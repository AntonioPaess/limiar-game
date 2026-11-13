## LIM-001 — Cena principal do protótipo cinza: monta mundo + jogador + UI e liga os sinais.
## Lógica de jogo fica nos componentes; aqui só composição.
class_name Main
extends Node3D

const WORLD_SCENE := preload("res://game/world/prototype_cathedral.tscn")
const PLAYER_SCENE := preload("res://game/player/first_person_player.tscn")
const VIGIA_SCENE := preload("res://game/enemies/vigia.tscn")
const RESPAWN_FADE_SEC := 0.8

var world: Node3D
var player: FirstPersonPlayer
var resonance: PlayerResonance
var combat: PlayerCombat
var vigia: Vigia
var checkpoint: Transform3D
var respawning := false
var _hit_stop_id := 0

@onready var hud: Hud = $Hud
@onready var pause_menu: PauseMenu = $PauseMenu
@onready var debug_overlay: DebugOverlay = $DebugOverlay


func _ready() -> void:
	world = WORLD_SCENE.instantiate()
	add_child(world)
	player = PLAYER_SCENE.instantiate()
	add_child(player)
	var spawn: Marker3D = world.get_node("Markers/PlayerSpawn")
	player.global_transform = spawn.global_transform

	var interaction: PlayerInteraction = player.get_node("PlayerInteraction")
	interaction.focus_changed.connect(hud.set_prompt)
	interaction.interacted.connect(func(_id: StringName, msg: String) -> void: hud.show_message(msg))
	var exit: ExitTrigger = world.get_node("Interactables/ExitTrigger")
	exit.reached.connect(hud.show_message)
	_wire_resonance()
	_wire_puzzle()
	checkpoint = spawn.global_transform
	_wire_combat()
	_spawn_vigia()
	var cp: Area3D = world.get_node("Interactables/CheckpointArea_Galeria")
	cp.body_entered.connect(func(b: Node3D) -> void:
		if b == player:
			_reach_checkpoint(world.get_node(String(cp.get_meta("checkpoint_marker")))))

	pause_menu.settings = player.settings
	pause_menu.paused.connect(func() -> void: player.input_enabled = false)
	pause_menu.resumed.connect(func() -> void: player.input_enabled = true)
	if debug_overlay:
		debug_overlay.player = player
		debug_overlay.interaction = interaction

	if _wants_mouse_capture():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


## Falso em headless e em capturas automáticas (`-- --no-mouse-capture`), para não prender o cursor de quem roda.
func _wants_mouse_capture() -> bool:
	return DisplayServer.get_name() != "headless" and not OS.get_cmdline_user_args().has("--no-mouse-capture")


func _wire_resonance() -> void:
	resonance = player.get_node("PlayerResonance")
	var res := resonance
	res.state_changed.connect(func(st: PlayerResonance.State) -> void:
		hud.set_resonance_veil(st == PlayerResonance.State.ACTIVE, player.settings.resonance_effect_intensity)
		if st == PlayerResonance.State.ACTIVE:
			_play_sfx(&"resonance_swell")
			hud.set_hint(""))
	res.caption.connect(hud.show_message)
	var hint: HintArea = world.get_node("Resonance/DicaRessonancia")
	hint.player_entered.connect(func(text: String) -> void:
		if res.reads_done == 0:
			hud.set_hint(text))
	hint.player_exited.connect(func() -> void: hud.set_hint(""))


func _wire_puzzle() -> void:
	var puzzle: CandlePatternPuzzle = world.get_node("Interactables/PuzzleVelas")
	var res := resonance
	puzzle.message.connect(hud.show_message)
	puzzle.resonance_hint_requested.connect(func() -> void:
		hud.set_hint(tr("ui.resonance.hint") % Hud._key_for(&"resonance")))
	res.state_changed.connect(func(st: PlayerResonance.State) -> void:
		if st == PlayerResonance.State.ACTIVE:
			hud.set_hint(""))


func _wire_combat() -> void:
	combat = player.get_node("PlayerCombat")
	var pulse: Pulse = player.get_node("Pulse")
	var health: Health = player.get_node("Health")
	health.damaged.connect(func(_e: DamageEvent, applied: float) -> void:
		hud.set_health(health.ratio())
		if applied > 0.0:
			hud.flash_damage(applied / health.max_health)
			_play_sfx(&"hurt"))
	health.healed.connect(func(_a: float) -> void: hud.set_health(health.ratio()))
	pulse.changed.connect(func(_c: float, _m: float) -> void: hud.set_pulse(pulse.ratio()))
	hud.set_pulse(pulse.ratio())
	combat.parried.connect(func(_e: DamageEvent) -> void:
		_play_sfx(&"parry")
		_hit_stop(0.08))
	combat.hit_landed.connect(func(_t: Node3D, applied: float) -> void:
		if applied > 0.0:
			_hit_stop(0.05))
	combat.died.connect(_on_player_died)
	resonance.intervened.connect(func(_o: Node) -> void:
		_play_sfx(&"intervention")
		_hit_stop(0.1))
	resonance.intervention_failed.connect(func(reason: StringName) -> void:
		if reason == &"cooldown":
			return
		_play_sfx(&"fizzle")
		hud.show_message(tr("ch1.proto.intervention.no_pulse" if reason == &"no_pulse" \
			else "ch1.proto.intervention.no_target")))


func _spawn_vigia() -> void:
	if get_node(^"/root/GameState").has_flag(&"ch1.proto.vigia_comum_defeated"):
		return  # derrotado nesta sessão: não volta
	if vigia and is_instance_valid(vigia):
		vigia.queue_free()
	var marker: Marker3D = world.get_node("Markers/VigiaSpawn")
	vigia = VIGIA_SCENE.instantiate()
	world.add_child(vigia)
	vigia.global_transform = marker.global_transform
	vigia.target = player


func _reach_checkpoint(marker: Node3D) -> void:
	if checkpoint.is_equal_approx(marker.global_transform):
		return
	checkpoint = marker.global_transform
	var pulse: Pulse = player.get_node("Pulse")
	if pulse.current < pulse.start_value:  # descanso: recupera o Pulso mínimo
		pulse.gain(pulse.start_value - pulse.current)
	hud.show_message(tr("ui.checkpoint"))


## Morte: escurece, volta ao checkpoint com vida cheia; memórias, flags e puzzles resolvidos ficam (GDD §8).
func _on_player_died() -> void:
	if respawning:
		return
	respawning = true
	player.input_enabled = false
	hud.show_message(tr("ui.death"))
	await hud.fade_to(1.0, RESPAWN_FADE_SEC).finished
	await get_tree().create_timer(0.4).timeout
	respawn_at_checkpoint()
	await hud.fade_to(0.0, RESPAWN_FADE_SEC).finished


func respawn_at_checkpoint() -> void:
	player.global_transform = checkpoint
	player.velocity = Vector3.ZERO
	player.head.rotation = Vector3.ZERO
	combat.revive()
	hud.set_health(1.0)
	_spawn_vigia()
	player.input_enabled = not pause_menu.is_open()
	respawning = false


## Hit-stop curto (game-feel, tier médio). Restaura em tempo real; só o mais novo restaura. Desligável.
func _hit_stop(duration: float) -> void:
	if not player.settings.hitstop_enabled:
		return
	_hit_stop_id += 1
	var my_id := _hit_stop_id
	Engine.time_scale = 0.05
	await get_tree().create_timer(duration, true, false, true).timeout
	if my_id == _hit_stop_id:
		Engine.time_scale = 1.0


func _process(_delta: float) -> void:
	hud.set_resonance_state(resonance.state, resonance.progress())


func _play_sfx(sound: StringName) -> void:
	var p := AudioStreamPlayer.new()
	p.stream = ProceduralSfx.get_stream(sound)
	p.volume_db = -6.0
	add_child(p)
	p.finished.connect(p.queue_free)
	p.play()


func _unhandled_input(event: InputEvent) -> void:
	# Depois de alt-tab o cursor pode ter sido liberado: um clique recaptura (fora da pausa).
	if event is InputEventMouseButton and event.pressed and not pause_menu.is_open() \
			and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT and _wants_mouse_capture() and is_inside_tree() \
			and not pause_menu.is_open():
		pause_menu.open()  # perder o foco pausa, em vez de deixar o jogador sem controle

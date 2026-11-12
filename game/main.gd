## LIM-001 — Cena principal do protótipo cinza: monta mundo + jogador + UI e liga os sinais.
## Lógica de jogo fica nos componentes; aqui só composição.
class_name Main
extends Node3D

const WORLD_SCENE := preload("res://game/world/prototype_cathedral.tscn")
const PLAYER_SCENE := preload("res://game/player/first_person_player.tscn")

var world: Node3D
var player: FirstPersonPlayer
var resonance: PlayerResonance

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

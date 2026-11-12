## LIM-001 — Cena principal do protótipo cinza: monta mundo + jogador + UI e liga os sinais.
## Lógica de jogo fica nos componentes; aqui só composição.
class_name Main
extends Node3D

const WORLD_SCENE := preload("res://game/world/prototype_cathedral.tscn")
const PLAYER_SCENE := preload("res://game/player/first_person_player.tscn")

var world: Node3D
var player: FirstPersonPlayer

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

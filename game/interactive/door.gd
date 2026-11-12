## Porta simples do protótipo: abre girando sobre a dobradiça quando o Interactable filho é usado.
## O estado aberto é persistido em sessão por uma flag estável (ex.: ch1.proto.door_exit_open).
class_name Door
extends Node3D

signal opened

@export var open_angle_deg := 100.0
@export var open_time := 0.8
@export var state_flag: StringName = &""

var is_open := false

@onready var _interactable: Interactable = $Interactable


func _ready() -> void:
	_interactable.once = true
	_interactable.used.connect(_on_used)
	if state_flag != &"" and _state().has_flag(state_flag):
		# já aberta nesta sessão (ex.: recarga de checkpoint): aplica o estado sem animar
		is_open = true
		_interactable.enabled = false
		rotation.y += deg_to_rad(open_angle_deg)


func _on_used(_actor: Node) -> void:
	open()


func open() -> void:
	if is_open:
		return
	is_open = true
	_interactable.enabled = false
	if state_flag != &"":
		_state().set_flag(state_flag, true)
	# A colisão vai junto com a folha da porta (filho deste nó), então a passagem libera ao girar.
	var tw := create_tween()
	tw.tween_property(self, "rotation:y", rotation.y + deg_to_rad(open_angle_deg), open_time)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	opened.emit()


## Autoload por caminho: o identificador global `GameState` não existe em scripts rodados com --script (testes).
func _state() -> Node:
	return get_node(^"/root/GameState")

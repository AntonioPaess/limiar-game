## Área de saída do trecho: marca a flag uma única vez quando o jogador entra.
class_name ExitTrigger
extends Area3D

signal reached(message: String)

@export var flag_id: StringName = &"ch1.proto.exit_reached"
@export var message_key := "ch1.proto.exit.reached"


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if body is FirstPersonPlayer and not _state().has_flag(flag_id):
		_state().set_flag(flag_id, true)
		reached.emit(tr(message_key))


## Autoload por caminho: o identificador global `GameState` não existe em scripts rodados com --script (testes).
func _state() -> Node:
	return get_node(^"/root/GameState")

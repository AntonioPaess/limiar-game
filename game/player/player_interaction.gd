## LIM-012 — Interação por raycast no centro da câmera. Emite sinais para a UI; não conhece a UI.
class_name PlayerInteraction
extends Node

## Prompt atual ("" quando nada interagível está em foco).
signal focus_changed(prompt: String)
## Texto a exibir depois de uma interação aceita ("" se o alvo não tem mensagem).
signal interacted(target_id: StringName, message: String)

@export var ray: RayCast3D

var current_target: Node = null

@onready var _player: FirstPersonPlayer = owner as FirstPersonPlayer


func _ready() -> void:
	if ray == null:
		ray = _player.get_node("Head/Camera3D/InteractionRay")
	ray.target_position = Vector3(0, 0, -_player.settings.interact_distance)
	_player.settings.changed.connect(func() -> void:
		ray.target_position = Vector3(0, 0, -_player.settings.interact_distance))


func _physics_process(_delta: float) -> void:
	_set_target(find_target())


## Primeiro nó (o colisor ou um ancestral) que segue a convenção e aceita interação agora.
func find_target() -> Node:
	if not ray.is_colliding():
		return null
	var n: Node = ray.get_collider()
	while n != null:
		if n.has_method("interact") and n.has_method("can_interact"):
			return n if n.can_interact(_player) else null
		n = n.get_parent()
	return null


func _set_target(t: Node) -> void:
	if t == current_target:
		return
	current_target = t
	focus_changed.emit(t.get_prompt(_player) if t != null else "")


func _unhandled_input(event: InputEvent) -> void:
	if _player.input_enabled and event.is_action_pressed("interact") and not event.is_echo():
		try_interact()
		get_viewport().set_input_as_handled()


## Interage com o alvo em foco. Uma chamada = no máximo uma interação.
func try_interact() -> bool:
	var t := find_target()
	if t == null:
		return false
	if not t.interact(_player):
		return false
	var id: StringName = t.get("interactable_id") if "interactable_id" in t else &""
	var msg: String = t.get_message() if t.has_method("get_message") else ""
	interacted.emit(id, msg)
	_set_target(find_target())  # alvo `once` deixa de ser válido → foco limpa e o prompt some
	return true

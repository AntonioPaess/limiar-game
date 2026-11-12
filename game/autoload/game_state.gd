## Estado da sessão: flags narrativas/de mundo por ID estável (07 §4). Sem referências a nós.
## Persistência em disco é etapa posterior (LIM-050); por ora vale só durante a sessão.
extends Node

signal narrative_flag_changed(flag_id: StringName, value: Variant)

var _flags: Dictionary[StringName, Variant] = {}


func set_flag(flag_id: StringName, value: Variant = true) -> void:
	if _flags.get(flag_id) == value:
		return  # evita disparar o mesmo evento várias vezes
	_flags[flag_id] = value
	narrative_flag_changed.emit(flag_id, value)


func get_flag(flag_id: StringName, default: Variant = false) -> Variant:
	return _flags.get(flag_id, default)


func has_flag(flag_id: StringName) -> bool:
	return _flags.has(flag_id) and _flags[flag_id] != false


func reset() -> void:
	_flags.clear()

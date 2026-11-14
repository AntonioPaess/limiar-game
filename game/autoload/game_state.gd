## Estado da sessão: flags narrativas/de mundo por ID estável (07 §4). Sem referências a nós.
## Persistência em disco é etapa posterior (LIM-050); por ora vale só durante a sessão.
extends Node

signal narrative_flag_changed(flag_id: StringName, value: Variant)
## Um Eco entrou no Diário pela primeira vez (arquitetura 07 §4: memory_discovered).
signal memory_discovered(entry: EcoEntry)

var _flags: Dictionary[StringName, Variant] = {}
var _journal: Array[EcoEntry] = []  ## ordem de descoberta


func set_flag(flag_id: StringName, value: Variant = true) -> void:
	if _flags.get(flag_id) == value:
		return  # evita disparar o mesmo evento várias vezes
	_flags[flag_id] = value
	narrative_flag_changed.emit(flag_id, value)


func get_flag(flag_id: StringName, default: Variant = false) -> Variant:
	return _flags.get(flag_id, default)


func has_flag(flag_id: StringName) -> bool:
	return _flags.has(flag_id) and _flags[flag_id] != false


## Registra o Eco no Diário uma única vez e grava a flag `entry.id`. Retorna true só na primeira vez (NAR-01).
func discover_memory(entry: EcoEntry) -> bool:
	if entry == null or has_memory(entry.id):
		return false
	_journal.append(entry)
	set_flag(entry.id, true)
	memory_discovered.emit(entry)
	return true


func has_memory(id: StringName) -> bool:
	for e in _journal:
		if e.id == id:
			return true
	return false


func journal() -> Array[EcoEntry]:
	return _journal.duplicate()


func reset() -> void:
	_flags.clear()
	_journal.clear()

## LIM-022 — Puzzle de protótipo [PROPOSTA, placeholder de mecânica — não é o P1/P2 do Level Design]:
## a porta da sala só cede quando as velas acesas correspondem aos monitores LIGADOS do Eco da sala.
## A pista só existe na Leitura de Ressonância (gratuita). Estados: repouso → (tentativas) → resolvido (persistido).
## Falha não punitiva: tentar a porta só mostra texto e um som; dicas graduais (GDD §6).
class_name CandlePatternPuzzle
extends Node

signal solved
## Mensagens para o HUD (o puzzle não conhece a UI).
signal message(text: String)
## Pedido de dica contextual de Ressonância (HUD decide como mostrar).
signal resonance_hint_requested

@export var candelabra: Array[NodePath] = []
@export var solution: Array[bool] = []  ## mesmo tamanho de `candelabra`
@export var door: NodePath
@export var solved_flag: StringName = &"ch1.puzzle.candles_solved"
@export var hint_after_attempts := 2  ## a partir da 2ª tentativa trancada, dica apontando para "algo que não está aqui"

var is_solved := false
var _candles: Array[Candelabrum] = []
var _door: Door


func _ready() -> void:
	for p in candelabra:
		var c := get_node(p) as Candelabrum
		_candles.append(c)
		c.toggled.connect(func(_lit: bool) -> void: _check())
	_door = get_node(door) as Door
	_door.locked_attempt.connect(_on_locked_attempt)
	if _state().has_flag(solved_flag):
		_mark_solved(false)
	else:
		_door.locked = true


func current_pattern() -> Array[bool]:
	var out: Array[bool] = []
	for c in _candles:
		out.append(c.lit)
	return out


func _check() -> void:
	if is_solved:
		return  # resolvido não volta a trancar (sem punição por mexer nas velas depois)
	if current_pattern() == solution:
		_mark_solved(true)


func _mark_solved(announce: bool) -> void:
	is_solved = true
	_state().set_flag(solved_flag, true)
	_door.unlock()
	if announce:
		var sfx := get_node_or_null(^"Sfx") as AudioStreamPlayer
		if sfx:
			sfx.stream = ProceduralSfx.get_stream(&"chime_solved")
			sfx.play()
		message.emit(tr("ch1.proto.puzzle.solved"))
		solved.emit()


func _on_locked_attempt(count: int) -> void:
	var sfx := get_node_or_null(^"Sfx") as AudioStreamPlayer
	if sfx:
		sfx.stream = ProceduralSfx.get_stream(&"dissonant")
		sfx.play()
	if count >= hint_after_attempts:
		message.emit(tr("ch1.proto.door.hint_candles"))
		resonance_hint_requested.emit()
	else:
		message.emit(tr("ch1.proto.door.locked"))


func _state() -> Node:
	return get_node(^"/root/GameState")

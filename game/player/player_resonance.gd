## LIM-020 — Controlador de Ressonância do jogador (modo Leitura, gratuito). Componente irmão do movimento.
## Toque em R: revela alvos no raio por tempo limitado. Sem custo de Pulso. Pressionar de novo durante a Leitura ou
## no cooldown não gera evento (invariante 3). Intervenção (segurar R, custa Pulso) é LIM-021.
class_name PlayerResonance
extends Node

enum State { READY, ACTIVE, COOLDOWN }

signal state_changed(state: State)
## Uma Leitura aconteceu; `revealed_ids` pode ser vazio (nada no raio): o feedback ainda acontece.
signal read_performed(revealed_ids: Array[StringName])
## Um alvo revelado tem legenda sonora (acessibilidade).
signal caption(text: String)

@export var settings: ResonanceSettings

var state := State.READY
var reads_done := 0
var _timer := 0.0

@onready var _player: FirstPersonPlayer = owner as FirstPersonPlayer


func _ready() -> void:
	if settings == null:
		settings = load("res://game/data/resonance/default_resonance_settings.tres")


func _unhandled_input(event: InputEvent) -> void:
	if _player.input_enabled and event.is_action_pressed("resonance") and not event.is_echo():
		try_read()
		get_viewport().set_input_as_handled()


## Executa uma Leitura se estiver pronta. Retorna true se executou.
func try_read() -> bool:
	if state != State.READY:
		return false
	var game_state := get_node_or_null(^"/root/GameState")
	var origin := _player.global_position
	var ids: Array[StringName] = []
	for n in get_tree().get_nodes_in_group(ResonanceTarget.GROUP):
		var t := n as ResonanceTarget
		if t == null:
			continue
		if origin.distance_to(t.global_position) > settings.read_radius + t.reach():
			continue
		if t.reveal(game_state):
			ids.append(t.data.id)
			if t.data.caption_key != "":
				caption.emit(tr(t.data.caption_key))
	reads_done += 1
	_set_state(State.ACTIVE, settings.read_active_sec)
	read_performed.emit(ids)
	return true


## 0..1 do tempo restante no estado atual (HUD).
func progress() -> float:
	match state:
		State.ACTIVE:
			return _timer / settings.read_active_sec
		State.COOLDOWN:
			return 1.0 - _timer / settings.read_cooldown_sec
	return 1.0


func _process(delta: float) -> void:
	if state == State.READY:
		return
	_timer -= delta
	if _timer > 0.0:
		return
	if state == State.ACTIVE:
		_set_state(State.COOLDOWN, settings.read_cooldown_sec)
	else:
		_set_state(State.READY, 0.0)


func _set_state(s: State, duration: float) -> void:
	state = s
	_timer = duration
	state_changed.emit(s)

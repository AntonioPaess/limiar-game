## LIM-020/021 — Controlador de Ressonância do jogador. Componente irmão do movimento e do combate.
## Toque em R = Leitura: revela alvos no raio por tempo limitado, sem custo. Pressionar de novo durante a Leitura ou no
## cooldown não gera evento (invariante 3). Segurar R = Intervenção: custa Pulso, só funciona num alvo AUTORIZADO
## (ENEMY_WEAKPOINT já revelado, na mira e no alcance) e nunca afeta outro alvo.
class_name PlayerResonance
extends Node

enum State { READY, ACTIVE, COOLDOWN }

signal state_changed(state: State)
## Uma Leitura aconteceu; `revealed_ids` pode ser vazio (nada no raio): o feedback ainda acontece.
signal read_performed(revealed_ids: Array[StringName])
## Um alvo revelado tem legenda sonora (acessibilidade).
signal caption(text: String)
## Intervenção aplicada em `target_owner` (ex.: Vigia).
signal intervened(target_owner: Node)
## Intervenção tentada sem efeito: "no_target" | "no_pulse" | "cooldown". Nada é gasto.
signal intervention_failed(reason: StringName)

@export var settings: ResonanceSettings

var state := State.READY
var reads_done := 0
var interventions_done := 0
var _timer := 0.0
var _hold := -1.0  ## tempo segurando R; -1 = solto ou já consumido
var _intervention_cooldown := 0.0

@onready var _player: FirstPersonPlayer = owner as FirstPersonPlayer


func _ready() -> void:
	if settings == null:
		settings = load("res://game/data/resonance/default_resonance_settings.tres")


func _unhandled_input(event: InputEvent) -> void:
	if not _player.input_enabled:
		return
	if event.is_action_pressed("resonance") and not event.is_echo():
		try_read()  # o toque já lê; continuar segurando vira Intervenção
		_hold = 0.0
		get_viewport().set_input_as_handled()
	elif event.is_action_released("resonance"):
		_hold = -1.0


## Intervenção: alvo ENEMY_WEAKPOINT revelado, na mira, no alcance; gasta Pulso uma vez. Retorna true se aplicou.
func try_intervene() -> bool:
	if _intervention_cooldown > 0.0:
		intervention_failed.emit(&"cooldown")
		return false
	var t := find_intervention_target()
	if t == null:
		intervention_failed.emit(&"no_target")
		return false
	var pulse: Pulse = _player.get_node_or_null("Pulse")
	if pulse == null or not pulse.spend(settings.intervention_cost):
		intervention_failed.emit(&"no_pulse")
		return false
	_intervention_cooldown = settings.intervention_cooldown_sec
	interventions_done += 1
	var owner_node := t.get_parent()
	if owner_node.has_method("on_intervened"):
		owner_node.on_intervened(_player)
	intervened.emit(owner_node)
	return true


## Corpo na mira (raio da câmera) que tem um ResonanceTarget ENEMY_WEAKPOINT revelado.
func find_intervention_target() -> ResonanceTarget:
	var cam := _player.camera
	var from := cam.global_position
	var to := from - cam.global_transform.basis.z * settings.intervention_range
	var q := PhysicsRayQueryParameters3D.create(from, to, 1 | 4)  # mundo bloqueia; inimigos são alvo
	q.exclude = [_player.get_rid()]
	var hit := _player.get_world_3d().direct_space_state.intersect_ray(q)
	if hit.is_empty():
		return null
	for c in (hit.collider as Node).get_children():
		var rt := c as ResonanceTarget
		if rt and rt.data and rt.data.target_type == ResonanceTargetData.TargetType.ENEMY_WEAKPOINT and rt.is_revealed:
			return rt
	return null


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
	_intervention_cooldown = maxf(0.0, _intervention_cooldown - delta)
	if _hold >= 0.0:
		if not Input.is_action_pressed("resonance"):
			_hold = -1.0
		else:
			_hold += delta
			if _hold >= settings.hold_to_intervene_sec:
				_hold = -1.0  # uma Intervenção por pressionamento
				try_intervene()
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

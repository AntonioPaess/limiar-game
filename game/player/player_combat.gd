## LIM-030/031 — Combate do jogador (GDD §4). Máquina de estados explícita; lógica separada de áudio/VFX (sinais).
## Estados: Idle, Windup, Active, Recovery, Guard, Dodge, Stagger, Dead. Dano 1× por golpe por alvo (COM-01).
class_name PlayerCombat
extends Node

enum State { IDLE, WINDUP, ACTIVE, RECOVERY, GUARD, DODGE, STAGGER, DEAD }

signal state_changed(state: State)
signal attack_started(attack: AttackData)
## Golpe do jogador acertou `target`; `applied` 0 = bloqueado pelo alvo.
signal hit_landed(target: Node3D, applied: float)
signal blocked_incoming(event: DamageEvent)
signal parried(event: DamageEvent)
signal dodged(event: DamageEvent)
signal took_damage(event: DamageEvent, applied: float)
signal died

const ENEMY_MASK := 4  ## camada 3: inimigos

@export var light_attack: AttackData
@export var settings: CombatSettings

var state := State.IDLE
var _timer := 0.0
var _attack: AttackData
var _attack_instance := 0
var _hit_list: Array[Node3D] = []
var _guard_time := 0.0  ## há quanto tempo a guarda está levantada (aparo)
var _dodge_cooldown := 0.0
var _iframes := 0.0
var _buffered_attack := 0.0

@onready var _player: FirstPersonPlayer = owner as FirstPersonPlayer
@onready var health: Health = _player.get_node("Health")
@onready var pulse: Pulse = _player.get_node("Pulse")


func _ready() -> void:
	if light_attack == null:
		light_attack = load("res://game/data/combat/player_light.tres")
	if settings == null:
		settings = load("res://game/data/combat/default_combat_settings.tres")
	health.damage_filter = _filter_damage
	health.died.connect(_on_died)


# --- entrada ---------------------------------------------------------------

func _unhandled_input(event: InputEvent) -> void:
	if not _player.input_enabled or state == State.DEAD:
		return
	if event.is_action_pressed("attack_light") and not event.is_echo():
		request_attack()
	elif event.is_action_pressed("dodge") and not event.is_echo():
		var dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		request_dodge(dir)
	elif event.is_action_pressed("guard"):
		request_guard(true)
	elif event.is_action_released("guard"):
		request_guard(false)


func request_attack() -> bool:
	if state in [State.IDLE, State.GUARD]:
		_start_attack(light_attack)
		return true
	if state == State.RECOVERY:
		_buffered_attack = settings.input_buffer_sec  # entra quando a recuperação acabar
	return false


func request_guard(on: bool) -> void:
	if on and state == State.IDLE:
		_guard_time = 0.0
		_set_state(State.GUARD, 0.0)
	elif not on and state == State.GUARD:
		_set_state(State.IDLE, 0.0)


## `dir`: vetor de movimento (x direita, y para trás). Sem direção: esquiva para trás.
func request_dodge(dir: Vector2) -> bool:
	if _dodge_cooldown > 0.0 or state not in [State.IDLE, State.GUARD, State.RECOVERY]:
		return false
	if dir == Vector2.ZERO:
		dir = Vector2(0, 1)
	var world := (_player.transform.basis * Vector3(dir.x, 0, dir.y))
	world.y = 0.0
	_player.start_dash(world.normalized() * (settings.dodge_distance / settings.dodge_time), settings.dodge_time)
	_iframes = settings.dodge_iframes
	_dodge_cooldown = settings.dodge_cooldown + settings.dodge_time + settings.dodge_recovery
	_set_state(State.DODGE, settings.dodge_time + settings.dodge_recovery)
	return true


# --- simulação ---------------------------------------------------------------

func _physics_process(delta: float) -> void:
	step(delta)


## Avança a máquina de estados (público para testes determinísticos).
func step(delta: float) -> void:
	_dodge_cooldown = maxf(0.0, _dodge_cooldown - delta)
	_iframes = maxf(0.0, _iframes - delta)
	_buffered_attack = maxf(0.0, _buffered_attack - delta)
	match state:
		State.GUARD:
			_guard_time += delta
		State.ACTIVE:
			_check_hits()
	if state in [State.IDLE, State.GUARD, State.DEAD]:
		_update_move_multiplier()
		return
	_timer -= delta
	if _timer > 0.0:
		_update_move_multiplier()
		return
	match state:
		State.WINDUP:
			_set_state(State.ACTIVE, _attack.active_sec)
			_check_hits()
		State.ACTIVE:
			_set_state(State.RECOVERY, _attack.recovery_sec)
		State.RECOVERY, State.DODGE, State.STAGGER:
			_set_state(State.IDLE, 0.0)
			if _buffered_attack > 0.0:
				_buffered_attack = 0.0
				_start_attack(light_attack)
			elif Input.is_action_pressed("guard") and _player.input_enabled:
				request_guard(true)
	_update_move_multiplier()


func _start_attack(attack: AttackData) -> void:
	_attack = attack
	_attack_instance = DamageEvent.new_instance_id()
	_hit_list.clear()
	_set_state(State.WINDUP, attack.windup_sec)
	attack_started.emit(attack)


func _check_hits() -> void:
	var origin := _player.camera.global_position
	var fwd := -_player.camera.global_transform.basis.z
	for body in Melee.find_targets(_player, origin, fwd, _attack, ENEMY_MASK):
		if _hit_list.has(body):
			continue
		_hit_list.append(body)  # 1 dano por alvo por golpe, mesmo que fique vários frames no cone
		var h := Health.of(body)
		if h == null:
			continue
		var applied := h.apply_damage(DamageEvent.make(_player, body, _attack, _attack_instance))
		hit_landed.emit(body, applied)


# --- receber dano --------------------------------------------------------------

func _filter_damage(e: DamageEvent) -> float:
	if state == State.DEAD:
		return 0.0
	if _iframes > 0.0:
		dodged.emit(e)
		return 0.0
	var from_front := e.source is Node3D and \
		Melee.incoming_angle(_player, (e.source as Node3D).global_position) <= settings.guard_arc_deg / 2.0
	if state == State.GUARD and from_front:
		if _guard_time <= settings.parry_window_sec:
			pulse.gain(settings.parry_pulse_gain)
			if e.source.has_method("on_parried"):
				e.source.on_parried(_player)
			parried.emit(e)
			return 0.0
		blocked_incoming.emit(e)
		took_damage.emit(e, e.amount * settings.guard_damage_taken)
		return e.amount * settings.guard_damage_taken
	# atingido: interrompe a ação atual por um instante (sem prender o jogador)
	if state != State.DODGE:
		_set_state(State.STAGGER, settings.hit_reaction_sec)
	took_damage.emit(e, e.amount)
	return e.amount


func _on_died() -> void:
	_set_state(State.DEAD, 0.0)
	_player.speed_multiplier = 0.0
	died.emit()


## Volta ao estado inicial (respawn no checkpoint).
func revive() -> void:
	health.reset()
	_iframes = 0.0
	_dodge_cooldown = 0.0
	_buffered_attack = 0.0
	_set_state(State.IDLE, 0.0)
	_update_move_multiplier()


func is_invulnerable() -> bool:
	return _iframes > 0.0


func _set_state(s: State, duration: float) -> void:
	state = s
	_timer = duration
	state_changed.emit(s)


func _update_move_multiplier() -> void:
	match state:
		State.GUARD:
			_player.speed_multiplier = settings.guard_move_multiplier
		State.WINDUP, State.ACTIVE, State.RECOVERY:
			_player.speed_multiplier = settings.attack_move_multiplier
		State.STAGGER:
			_player.speed_multiplier = 0.3
		State.DEAD:
			_player.speed_multiplier = 0.0
		_:
			_player.speed_multiplier = 1.0

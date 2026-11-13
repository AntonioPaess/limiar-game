## LIM-032 — Vigia comum (GDD §9, Art Bible §7). Ensina a diferença entre defesa e evasão.
## Estados: Idle → Approach → Windup (anúncio visual + sonoro) → Active → Recovery (aberto) → …; Stagger; Dead.
## Escudo bloqueia golpes de frente. Costas/lados, recuperação e atordoamento recebem dano. Vencível só com esquiva e
## observação (sem aparo perfeito). Aparo e Intervenção de Ressonância atordoam.
class_name Vigia
extends CharacterBody3D

enum State { IDLE, APPROACH, WINDUP, ACTIVE, RECOVERY, STAGGER, DEAD }

signal state_changed(state: State)
signal blocked_hit(attacker: Node3D)
signal hurt(applied: float)
signal defeated(enemy_id: StringName)

const PLAYER_MASK := 2

@export var enemy_id: StringName = &"ch1.proto.vigia_comum"
@export var attacks: Array[AttackData] = []
@export_group("Comportamento [VALIDAR]")
@export var detect_radius := 11.0
@export var attack_distance := 2.1
@export var move_speed := 2.3
@export var turn_speed_deg := 220.0  ## virando para o jogador ao se aproximar
@export var recovery_turn_speed_deg := 45.0  ## na recuperação vira devagar: janela para flanquear
@export var attack_cooldown := 0.5
@export var shield_arc_deg := 120.0  ## golpes dentro deste cone frontal batem no escudo
@export var parry_stagger_sec := 2.0
@export var intervention_stagger_sec := 3.0
@export var exposed_damage_multiplier := 1.5

var state := State.IDLE
var target: Node3D
var health: Health
var exposed := false  ## escudo rompido pela Intervenção enquanto atordoado
var _timer := 0.0
var _cooldown := 0.0
var _attack: AttackData
var _attack_index := 0
var _attack_instance := 0
var _hit_list: Array[Node3D] = []
var _lunge_velocity := Vector3.ZERO
var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)
var _tween: Tween
var _shield_rest: Vector3

@onready var _arm: Node3D = $Visual/ArmPivot
@onready var _shield: Node3D = $Visual/ShieldPivot
@onready var _visual: Node3D = $Visual
@onready var _sfx: AudioStreamPlayer3D = $Sfx
@onready var weak_point: ResonanceTarget = $Res_Fissura


func _ready() -> void:
	health = $Health
	health.damage_filter = _filter_damage
	health.died.connect(_on_died)
	_shield_rest = _shield.position
	_rest_pose()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= _gravity * delta
	step(delta)
	move_and_slide()


## Avança a IA (público para testes determinísticos).
func step(delta: float) -> void:
	_cooldown = maxf(0.0, _cooldown - delta)
	var hv := Vector3.ZERO
	match state:
		State.IDLE:
			if _sees_target():
				_set_state(State.APPROACH, 0.0)
		State.APPROACH:
			if not _target_alive():
				_set_state(State.IDLE, 0.0)
			else:
				_turn_toward(target.global_position, turn_speed_deg, delta)
				var d := _flat_distance(target.global_position)
				if d > attack_distance:
					hv = -global_transform.basis.z * move_speed
				elif _cooldown <= 0.0 and _facing(target.global_position) < 30.0:
					_start_attack()
		State.WINDUP:
			_turn_toward(target.global_position, turn_speed_deg * 0.5, delta)
			_timer -= delta
			if _timer <= 0.0:
				_lunge_velocity = -global_transform.basis.z * (_attack.lunge_distance / maxf(0.01, _attack.active_sec))
				_set_state(State.ACTIVE, _attack.active_sec)
				_swing_pose()
				_check_hits()
		State.ACTIVE:
			hv = _lunge_velocity
			_check_hits()
			_timer -= delta
			if _timer <= 0.0:
				_set_state(State.RECOVERY, _attack.recovery_sec)
		State.RECOVERY:
			if _target_alive():
				_turn_toward(target.global_position, recovery_turn_speed_deg, delta)
			_timer -= delta
			if _timer <= 0.0:
				_cooldown = attack_cooldown
				_rest_pose()
				_set_state(State.APPROACH, 0.0)
		State.STAGGER:
			_timer -= delta
			if _timer <= 0.0:
				exposed = false
				_rest_pose()
				_set_state(State.APPROACH, 0.0)
	velocity.x = hv.x
	velocity.z = hv.z


# --- ataques -------------------------------------------------------------------

func _start_attack() -> void:
	_attack = attacks[_attack_index % attacks.size()]
	_attack_index += 1  # alterna varrido / avanço: padrão aprendível
	_attack_instance = DamageEvent.new_instance_id()
	_hit_list.clear()
	_set_state(State.WINDUP, _attack.windup_sec)
	_telegraph_pose()
	_play(&"telegraph_lunge" if _attack.lunge_distance > 0.0 else &"telegraph_sweep")


func _check_hits() -> void:
	var origin := global_position + Vector3(0, 1.2, 0)
	for body in Melee.find_targets(self, origin, -global_transform.basis.z, _attack, PLAYER_MASK):
		if _hit_list.has(body):
			continue
		_hit_list.append(body)
		var h := Health.of(body)
		if h:
			h.apply_damage(DamageEvent.make(self, body, _attack, _attack_instance))


# --- receber dano ----------------------------------------------------------------

func _filter_damage(e: DamageEvent) -> float:
	if state == State.DEAD:
		return 0.0
	var vulnerable := state == State.STAGGER
	var from_front := e.source is Node3D and \
		Melee.incoming_angle(self, (e.source as Node3D).global_position) <= shield_arc_deg / 2.0
	if from_front and not vulnerable:
		blocked_hit.emit(e.source)
		_play(&"block")
		_flinch(0.04)
		return 0.0
	var amount := e.amount * (exposed_damage_multiplier if exposed else 1.0)
	_play(&"impact")
	_flinch(0.12)
	hurt.emit(amount)
	return amount


## Chamado pelo combate do jogador num aparo bem-sucedido.
func on_parried(_by: Node) -> void:
	if state in [State.WINDUP, State.ACTIVE, State.RECOVERY, State.APPROACH]:
		_stagger(parry_stagger_sec, false)


## Chamado pela Intervenção de Ressonância (LIM-021): rompe o escudo por um tempo.
func on_intervened(_by: Node) -> void:
	if state != State.DEAD:
		_stagger(intervention_stagger_sec, true)


func _stagger(sec: float, break_shield: bool) -> void:
	exposed = break_shield
	_lunge_velocity = Vector3.ZERO
	_set_state(State.STAGGER, sec)
	_kill_tween()
	_tween = create_tween().set_parallel()
	# escudo cai para o lado (gira no próprio plano e desce) e o tronco recua: aberto, legível sem depender de cor
	_tween.tween_property(_shield, "rotation", Vector3(0, 0, deg_to_rad(80)), 0.25)
	_tween.tween_property(_shield, "position", _shield_rest + Vector3(-0.45, -0.6, 0.25), 0.25)
	_tween.tween_property(_arm, "rotation", Vector3(deg_to_rad(40), 0, 0), 0.25)
	_tween.tween_property(_visual, "rotation:x", deg_to_rad(-12), 0.25)


func _on_died() -> void:
	_set_state(State.DEAD, 0.0)
	collision_layer = 0  # corpo deixa de bloquear e de ser alvo
	remove_from_group(&"damageable")
	var gs := get_node_or_null(^"/root/GameState")
	if gs:
		gs.set_flag(StringName(String(enemy_id) + "_defeated"), true)
	_kill_tween()
	_tween = create_tween()
	_tween.tween_property(_visual, "rotation:x", deg_to_rad(-85), 0.7).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	defeated.emit(enemy_id)


# --- percepção e movimento ---------------------------------------------------------

func _target_alive() -> bool:
	if target == null or not is_instance_valid(target):
		return false
	var h := Health.of(target)
	return h == null or not h.is_dead


func _sees_target() -> bool:
	if not _target_alive() or _flat_distance(target.global_position) > detect_radius:
		return false
	var q := PhysicsRayQueryParameters3D.create(global_position + Vector3(0, 1.6, 0),
		target.global_position + Vector3(0, 1.5, 0), 1)
	return get_world_3d().direct_space_state.intersect_ray(q).is_empty()


func _turn_toward(p: Vector3, deg_per_sec: float, delta: float) -> void:
	var to := p - global_position
	to.y = 0.0
	if to.length() < 0.01:
		return
	var desired := atan2(-to.x, -to.z)  # -Z é a frente
	rotation.y = rotate_toward(rotation.y, desired, deg_to_rad(deg_per_sec) * delta)


func _facing(p: Vector3) -> float:
	return Melee.incoming_angle(self, p)


func _flat_distance(p: Vector3) -> float:
	return Vector2(p.x - global_position.x, p.z - global_position.z).length()


func _set_state(s: State, t: float) -> void:
	state = s
	_timer = t
	state_changed.emit(s)


# --- poses (telegraph por forma, não só por cor) -------------------------------------

func _rest_pose() -> void:
	_kill_tween()
	_tween = create_tween().set_parallel()
	_tween.tween_property(_arm, "rotation", Vector3.ZERO, 0.3)
	_tween.tween_property(_shield, "rotation", Vector3.ZERO, 0.3)
	_tween.tween_property(_shield, "position", _shield_rest, 0.3)
	_tween.tween_property(_visual, "rotation:x", 0.0, 0.3)
	_tween.tween_property(_visual, "position:y", 0.0, 0.3)


func _telegraph_pose() -> void:
	_kill_tween()
	_tween = create_tween().set_parallel()
	if _attack.lunge_distance > 0.0:  # avanço: agacha fundo, inclina e abre o escudo para o lado (silhueta baixa)
		var t := _attack.windup_sec * 0.8
		_tween.tween_property(_visual, "position:y", -0.35, t)
		_tween.tween_property(_visual, "rotation:x", deg_to_rad(-22), t)
		_tween.tween_property(_shield, "position", _shield_rest + Vector3(-0.35, 0, 0.2), t)
		_tween.tween_property(_shield, "rotation", Vector3(0, deg_to_rad(35), 0), t)
		_tween.tween_property(_arm, "rotation", Vector3(deg_to_rad(-15), deg_to_rad(-25), 0), t)
	else:  # varrido: ergue o braço alto para o lado
		_tween.tween_property(_arm, "rotation", Vector3(deg_to_rad(70), deg_to_rad(-60), 0), _attack.windup_sec * 0.8)
		_tween.tween_property(_shield, "rotation", Vector3(0, deg_to_rad(-15), 0), _attack.windup_sec * 0.8)


func _swing_pose() -> void:
	_kill_tween()
	_tween = create_tween().set_parallel()
	if _attack.lunge_distance > 0.0:
		_tween.tween_property(_arm, "rotation", Vector3(deg_to_rad(-80), 0, 0), _attack.active_sec)
	else:
		_tween.tween_property(_arm, "rotation", Vector3(deg_to_rad(10), deg_to_rad(80), 0), _attack.active_sec)


func _flinch(amount: float) -> void:
	var base := _visual.position
	var tw := create_tween()
	tw.tween_property(_visual, "position", base + global_transform.basis.z * amount, 0.06)
	tw.tween_property(_visual, "position", Vector3.ZERO, 0.12)


func _kill_tween() -> void:
	if _tween:
		_tween.kill()


func _play(sound: StringName) -> void:
	if _sfx and is_inside_tree():
		_sfx.stream = ProceduralSfx.get_stream(sound)
		_sfx.play()

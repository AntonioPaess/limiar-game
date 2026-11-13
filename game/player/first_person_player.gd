## LIM-010 — Controlador em primeira pessoa (GDD §3, arquitetura 07 §3).
## Só movimento e câmera. Interação fica em PlayerInteraction; combate e Ressonância virão como componentes irmãos.
class_name FirstPersonPlayer
extends CharacterBody3D

@export var settings: PlayerSettings

## Quando falso o jogador ignora input (pausa, cutscene). Física/gravidade continuam.
var input_enabled := true
## Definido pelo combate (guarda/ataque deixam mais lento; morto = 0). Correr só vale com 1.0.
var speed_multiplier := 1.0

var _dash_velocity := Vector3.ZERO
var _dash_time := 0.0

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)
var _bob_phase := 0.0
var _head_base_y := 0.0

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D


func _ready() -> void:
	if settings == null:
		settings = load("res://game/data/player/default_player_settings.tres")
	_head_base_y = head.position.y
	camera.keep_aspect = Camera3D.KEEP_WIDTH  # fov passa a ser horizontal
	settings.changed.connect(_apply_settings)
	_apply_settings()


func _apply_settings() -> void:
	camera.fov = settings.fov_horizontal
	if not settings.head_bob_enabled:
		head.position.y = _head_base_y


func _unhandled_input(event: InputEvent) -> void:
	if not input_enabled:
		return
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var rel: Vector2 = event.screen_relative
		look(rel * settings.mouse_sensitivity)


## Aplica um delta de olhar em radianos (x = yaw, y = pitch positivo para baixo).
func look(delta_rad: Vector2) -> void:
	var pitch_sign := -1.0 if settings.invert_y else 1.0
	rotate_y(-delta_rad.x)
	head.rotation.x = clamp_pitch(head.rotation.x - delta_rad.y * pitch_sign, settings.max_pitch_deg)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= _gravity * delta

	if _dash_time > 0.0:  # esquiva: velocidade horizontal fixa, sem controle durante o impulso
		_dash_time -= delta
		velocity.x = _dash_velocity.x
		velocity.z = _dash_velocity.z
		move_and_slide()
		return

	var wish := Vector3.ZERO
	var target_speed := settings.walk_speed
	if input_enabled:
		var stick := Input.get_vector("look_left", "look_right", "look_up", "look_down")
		if stick != Vector2.ZERO:
			look(stick * settings.stick_sensitivity * delta)
		var move := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		wish = (transform.basis * Vector3(move.x, 0.0, move.y))
		wish.y = 0.0
		wish = wish.limit_length(1.0)
		if Input.is_action_pressed("sprint") and speed_multiplier >= 1.0:
			target_speed = settings.sprint_speed
		target_speed *= speed_multiplier

	var accel := settings.acceleration if wish != Vector3.ZERO else settings.deceleration
	if not is_on_floor():
		accel *= settings.air_control
	var horizontal := compute_horizontal_velocity(
		Vector3(velocity.x, 0.0, velocity.z), wish, target_speed, accel, delta)
	velocity.x = horizontal.x
	velocity.z = horizontal.z
	move_and_slide()
	_update_head_bob(delta)


func _update_head_bob(delta: float) -> void:
	if not settings.head_bob_enabled:
		return
	var speed := Vector2(velocity.x, velocity.z).length()
	if is_on_floor() and speed > 0.1:
		_bob_phase = fmod(_bob_phase + speed * delta * settings.head_bob_frequency * TAU / 2.0, TAU)
		head.position.y = _head_base_y + sin(_bob_phase) * settings.head_bob_amplitude
	else:
		head.position.y = move_toward(head.position.y, _head_base_y, delta * 0.25)


## Impulso de esquiva (chamado pelo PlayerCombat). Colisão continua valendo: não atravessa paredes (COM-02).
func start_dash(horizontal_velocity: Vector3, duration: float) -> void:
	_dash_velocity = Vector3(horizontal_velocity.x, 0.0, horizontal_velocity.z)
	_dash_time = duration


func is_dashing() -> bool:
	return _dash_time > 0.0


## Velocidade horizontal se aproximando de `wish_dir * target_speed` com aceleração limitada (lógica pura, testável).
static func compute_horizontal_velocity(current: Vector3, wish_dir: Vector3, target_speed: float,
		accel: float, delta: float) -> Vector3:
	var target := wish_dir * target_speed
	return current.move_toward(target, accel * delta)


## Limita o pitch para não virar a câmera de cabeça para baixo (lógica pura, testável).
static func clamp_pitch(pitch_rad: float, max_pitch_deg: float) -> float:
	var limit := deg_to_rad(max_pitch_deg)
	return clampf(pitch_rad, -limit, limit)

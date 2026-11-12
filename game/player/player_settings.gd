## Tuning e opções de conforto do jogador (GDD §3). Valores padrão são placeholders [VALIDAR] por playtest.
## Um único recurso compartilhado entre jogador e menu de pausa; mudanças emitem `changed`.
class_name PlayerSettings
extends Resource

const FOV_MIN := 70.0
const FOV_MAX := 100.0

@export_group("Movimento")
@export var walk_speed := 4.2  ## m/s [VALIDAR]
@export var sprint_speed := 6.0  ## m/s [VALIDAR]
@export var acceleration := 30.0  ## m/s² em direção à velocidade-alvo
@export var deceleration := 40.0  ## m/s² ao soltar o movimento
@export var air_control := 0.3  ## fração da aceleração no ar

@export_group("Câmera")
## FOV em graus HORIZONTAIS (Camera3D.keep_aspect = KEEP_WIDTH). GDD: alvo 80°, faixa 70–100°.
@export_range(FOV_MIN, FOV_MAX, 1.0) var fov_horizontal := 80.0:
	set(v):
		fov_horizontal = clampf(v, FOV_MIN, FOV_MAX)
		emit_changed()
@export var mouse_sensitivity := 0.0025:  ## rad por pixel
	set(v):
		mouse_sensitivity = clampf(v, 0.0005, 0.01)
		emit_changed()
@export var stick_sensitivity := 2.6:  ## rad/s no deslocamento máximo
	set(v):
		stick_sensitivity = clampf(v, 0.5, 6.0)
		emit_changed()
@export var invert_y := false:
	set(v):
		invert_y = v
		emit_changed()
@export var max_pitch_deg := 85.0

@export_group("Conforto")
@export var head_bob_enabled := true:
	set(v):
		head_bob_enabled = v
		emit_changed()
@export var head_bob_amplitude := 0.025  ## metros (mínimo, GDD §3)
@export var head_bob_frequency := 1.8  ## ciclos por metro percorrido
## Intensidade do véu violeta de tela durante a Ressonância (0 = desligado). O Eco no mundo continua visível.
@export_range(0.0, 1.0, 0.05) var resonance_effect_intensity := 1.0:
	set(v):
		resonance_effect_intensity = clampf(v, 0.0, 1.0)
		emit_changed()

@export_group("Interação")
@export var interact_distance := 2.5  ## metros

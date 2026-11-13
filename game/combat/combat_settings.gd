## Tuning do combate do jogador (GDD §4). Placeholders [VALIDAR] por playtest; janela de aparo começa generosa.
class_name CombatSettings
extends Resource

@export_group("Guarda e aparo")
@export var parry_window_sec := 0.25  ## desde o início da guarda; generosa no protótipo
@export_range(0.0, 1.0) var guard_damage_taken := 0.25  ## fração do dano que passa pela guarda frontal
@export var guard_arc_deg := 140.0  ## cone frontal coberto pela guarda
@export var parry_pulse_gain := 20.0
@export var guard_move_multiplier := 0.5

@export_group("Esquiva")
@export var dodge_distance := 3.6  ## metros
@export var dodge_time := 0.24
@export var dodge_iframes := 0.22  ## invulnerável dentro da esquiva
@export var dodge_recovery := 0.2
@export var dodge_cooldown := 0.35

@export_group("Ataque")
@export var attack_move_multiplier := 0.45
@export var hit_reaction_sec := 0.25  ## jogador atingido: interrompe a ação atual por este tempo
@export var input_buffer_sec := 0.15  ## ataque apertado no fim da recuperação entra em fila

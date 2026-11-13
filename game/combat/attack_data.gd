## Dados de um ataque (arquitetura 07 §5). Tempos e dano em Resource: nada hardcoded em cena. Valores [VALIDAR].
class_name AttackData
extends Resource

@export var id: StringName = &""
@export var windup_sec := 0.15  ## anúncio (telegraph): janela em que o alvo pode reagir
@export var active_sec := 0.12  ## golpe valendo: dano aplicado no máximo 1 vez por alvo
@export var recovery_sec := 0.3  ## depois do golpe: abertura para o adversário
@export var range := 2.2  ## metros
@export_range(10.0, 180.0) var arc_deg := 90.0  ## cone frontal
@export var damage := 10.0
@export var stun_sec := 0.0  ## atordoamento aplicado ao acertar (0 = só reação curta)
@export var lunge_distance := 0.0  ## avanço durante o golpe (golpe de avanço)
@export var can_interrupt := false  ## se sofrer dano no windup cancela este ataque
@export var visual_telegraph_id: StringName = &""
@export var audio_telegraph_id: StringName = &""


func total_sec() -> float:
	return windup_sec + active_sec + recovery_sec

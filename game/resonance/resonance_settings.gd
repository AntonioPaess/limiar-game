## Tuning da Leitura (GDD §5). Placeholders [VALIDAR] por playtest.
class_name ResonanceSettings
extends Resource

@export var read_radius := 9.0  ## metros a partir do jogador
@export var read_active_sec := 5.0  ## janela em que a Leitura está "ligada" (feedback de HUD)
@export var read_cooldown_sec := 1.5  ## cooldown curto, sem custo de Pulso

@export_group("Intervenção (custa Pulso)")
@export var hold_to_intervene_sec := 0.35  ## segurar R além disso = Intervenção
@export var intervention_cost := 30.0
@export var intervention_range := 7.0  ## metros, pela mira
@export var intervention_cooldown_sec := 3.0

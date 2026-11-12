## Tuning da Leitura (GDD §5). Placeholders [VALIDAR] por playtest.
class_name ResonanceSettings
extends Resource

@export var read_radius := 9.0  ## metros a partir do jogador
@export var read_active_sec := 5.0  ## janela em que a Leitura está "ligada" (feedback de HUD)
@export var read_cooldown_sec := 1.5  ## cooldown curto, sem custo de Pulso

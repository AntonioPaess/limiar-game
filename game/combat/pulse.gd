## Pulso: recurso da Intervenção de Ressonância (GDD §4–5). Máximo hipotético 100; regenera por aparo, descanso e
## interações específicas. NUNCA é necessário para pistas obrigatórias (Leitura é gratuita).
class_name Pulse
extends Node

signal changed(current: float, max_value: float)

@export var max_value := 100.0
@export var start_value := 40.0  ## [VALIDAR] dá para 1 Intervenção logo no primeiro encontro

var current: float


func _ready() -> void:
	current = start_value


func can_spend(amount: float) -> bool:
	return current >= amount


## Gasta se houver o suficiente. Retorna true se gastou (uma chamada = um gasto).
func spend(amount: float) -> bool:
	if not can_spend(amount):
		return false
	current -= amount
	changed.emit(current, max_value)
	return true


func gain(amount: float) -> void:
	current = minf(max_value, current + amount)
	changed.emit(current, max_value)


func ratio() -> float:
	return current / max_value

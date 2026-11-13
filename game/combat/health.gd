## Vida de qualquer combatente. Componente filho do corpo; o corpo entra no grupo "damageable".
## Quem decide bloqueio/aparo é o dono (via `damage_filter`); aqui só se aplica e se deduplica.
class_name Health
extends Node

signal damaged(event: DamageEvent, applied: float)
signal died
signal healed(amount: float)

@export var max_health := 100.0

var current: float
var is_dead := false
## Callable(event: DamageEvent) -> float: devolve o dano realmente aplicado (bloqueio, aparo, i-frames).
var damage_filter: Callable

var _seen_instances: Dictionary[int, bool] = {}


func _ready() -> void:
	current = max_health
	var body := get_parent()
	if body:
		body.add_to_group(&"damageable")


## Retorna o dano aplicado (0 se ignorado). O mesmo `attack_instance_id` só é processado uma vez.
func apply_damage(event: DamageEvent) -> float:
	if is_dead or _seen_instances.has(event.attack_instance_id):
		return 0.0
	_seen_instances[event.attack_instance_id] = true
	var amount := event.amount
	if damage_filter.is_valid():
		amount = damage_filter.call(event)
	amount = maxf(0.0, amount)
	current = maxf(0.0, current - amount)
	damaged.emit(event, amount)
	if current <= 0.0 and not is_dead:
		is_dead = true
		died.emit()
	return amount


func heal(amount: float) -> void:
	if is_dead:
		return
	var before := current
	current = minf(max_health, current + amount)
	if current > before:
		healed.emit(current - before)


func reset() -> void:
	current = max_health
	is_dead = false
	_seen_instances.clear()


func ratio() -> float:
	return current / max_health


static func of(body: Node) -> Health:
	if body == null:
		return null
	for c in body.get_children():
		if c is Health:
			return c
	return null

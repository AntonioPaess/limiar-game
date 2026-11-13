## Evento de dano (arquitetura 07 §5). `attack_instance_id` identifica UM golpe: o mesmo golpe nunca causa dano duas
## vezes no mesmo alvo (COM-01).
class_name DamageEvent
extends RefCounted

static var _next_instance := 1

var source: Node
var target: Node
var attack_id: StringName
var amount: float
var damage_type: StringName = &"physical"
var direction: Vector3  ## do atacante para o alvo, normalizado no plano XZ
var stun_sec := 0.0
var attack_instance_id: int


static func new_instance_id() -> int:
	_next_instance += 1
	return _next_instance


static func make(src: Node, tgt: Node, attack: AttackData, instance_id: int, amount_override := -1.0) -> DamageEvent:
	var e := DamageEvent.new()
	e.source = src
	e.target = tgt
	e.attack_id = attack.id
	e.amount = attack.damage if amount_override < 0.0 else amount_override
	e.stun_sec = attack.stun_sec
	e.attack_instance_id = instance_id
	if src is Node3D and tgt is Node3D:
		var d: Vector3 = (tgt as Node3D).global_position - (src as Node3D).global_position
		d.y = 0.0
		e.direction = d.normalized()
	return e

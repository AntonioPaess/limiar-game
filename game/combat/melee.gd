## Detecção de golpe corpo a corpo por cone (decisão em aberto no TDD: raycast/sweep x Area3D — aqui consulta de
## esfera + filtro de ângulo + linha de visão, determinística e testável). Aplica dano no máximo 1 vez por alvo por
## golpe: o chamador guarda `hit_list` durante toda a janela ativa.
class_name Melee
extends RefCounted


## Alvos (corpos no grupo "damageable", exceto `attacker`) dentro do alcance e do cone, com linha de visão livre.
static func find_targets(attacker: Node3D, origin: Vector3, forward: Vector3, attack: AttackData,
		mask: int) -> Array[Node3D]:
	var out: Array[Node3D] = []
	var space := attacker.get_world_3d().direct_space_state
	var shape := SphereShape3D.new()
	shape.radius = attack.range
	var q := PhysicsShapeQueryParameters3D.new()
	q.shape = shape
	q.transform = Transform3D(Basis(), origin)
	q.collision_mask = mask
	q.exclude = [attacker.get_rid()] if attacker is CollisionObject3D else []
	var fwd := Vector3(forward.x, 0, forward.z).normalized()
	for hit in space.intersect_shape(q, 16):
		var body := hit.collider as Node3D
		if body == null or body == attacker or not body.is_in_group(&"damageable") or out.has(body):
			continue
		var to := body.global_position - origin
		to.y = 0.0
		if to.length() > attack.range + 0.4:
			continue
		if to.length() > 0.05 and rad_to_deg(fwd.angle_to(to.normalized())) > attack.arc_deg / 2.0:
			continue
		if not _line_of_sight(space, attacker, origin, body):
			continue
		out.append(body)
	return out


static func _line_of_sight(space: PhysicsDirectSpaceState3D, attacker: Node3D, origin: Vector3, body: Node3D) -> bool:
	var target := body.global_position + Vector3(0, 1.0, 0)
	var q := PhysicsRayQueryParameters3D.create(origin, target, 1)  # só o mundo (camada 1) bloqueia
	var excl: Array[RID] = []
	if attacker is CollisionObject3D:
		excl.append(attacker.get_rid())
	q.exclude = excl
	var r := space.intersect_ray(q)
	return r.is_empty() or r.collider == body


## Ângulo (graus) entre a frente de `defender` e a direção de onde vem o golpe. 0 = de frente, 180 = pelas costas.
static func incoming_angle(defender: Node3D, attacker_pos: Vector3) -> float:
	var fwd := -defender.global_transform.basis.z
	fwd.y = 0.0
	var to := attacker_pos - defender.global_position
	to.y = 0.0
	if to.length() < 0.01:
		return 0.0
	return rad_to_deg(fwd.normalized().angle_to(to.normalized()))

## Espada FPP placeholder (Art Bible §9: "1 malha simples de braços/mãos FPP e espada"). Formas simples montadas em
## código; cada estado de combate tem uma pose legível. Será trocada pelo asset do art proof (G3).
class_name WeaponRig
extends Node3D

const REST_POS := Vector3(0.3, -0.3, -0.5)
const REST_ROT := Vector3(deg_to_rad(28), deg_to_rad(12), deg_to_rad(-14))  ## lâmina para cima e para frente

var _tween: Tween
var _pivot: Node3D


func _ready() -> void:
	_pivot = Node3D.new()
	_pivot.name = "Pivot"
	add_child(_pivot)
	var steel := _mat(Color("#8d939b"), 0.35, 0.6)
	var leather := _mat(Color("#3a2a22"), 0.9, 0.0)
	var brass := _mat(Color("#A16D47"), 0.5, 0.5)
	_part("Lamina", BoxMesh, Vector3(0.045, 0.012, 0.78), Vector3(0, 0, -0.52), steel)
	_part("Guarda", BoxMesh, Vector3(0.2, 0.03, 0.035), Vector3(0, 0, -0.12), brass)
	_part("Punho", BoxMesh, Vector3(0.035, 0.035, 0.16), Vector3(0, 0, -0.02), leather)
	_part("Mao", BoxMesh, Vector3(0.09, 0.08, 0.1), Vector3(0.0, -0.02, 0.0), _mat(Color("#6b4f43"), 0.9, 0.0))
	position = REST_POS
	rotation = REST_ROT
	var combat: PlayerCombat = owner.get_node_or_null("PlayerCombat") if owner else null
	if combat:
		combat.state_changed.connect(_on_state)


func _on_state(s: PlayerCombat.State) -> void:
	match s:
		PlayerCombat.State.WINDUP:  # recua para trás e para a direita: anúncio do golpe
			_pose(Vector3(0.42, -0.22, -0.45), Vector3(deg_to_rad(10), deg_to_rad(40), deg_to_rad(-40)), 0.1)
		PlayerCombat.State.ACTIVE:  # varre da direita para a esquerda
			_pose(Vector3(-0.2, -0.3, -0.62), Vector3(deg_to_rad(-15), deg_to_rad(-55), deg_to_rad(-70)), 0.11)
		PlayerCombat.State.GUARD:  # lâmina atravessada na frente, mais longe da câmera
			_pose(Vector3(0.18, -0.12, -0.62), Vector3(deg_to_rad(8), deg_to_rad(75), deg_to_rad(12)), 0.08)
		PlayerCombat.State.DODGE:
			_pose(REST_POS + Vector3(0, -0.08, 0.05), REST_ROT, 0.1)
		PlayerCombat.State.STAGGER:
			_pose(REST_POS + Vector3(0.05, -0.1, 0.08), REST_ROT + Vector3(0.3, 0, 0.2), 0.08)
		PlayerCombat.State.DEAD:
			_pose(REST_POS + Vector3(0, -0.6, 0), REST_ROT, 0.5)
		_:
			_pose(REST_POS, REST_ROT, 0.18)


func _pose(pos: Vector3, rot: Vector3, t: float) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel()
	_tween.tween_property(self, "position", pos, t).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "rotation", rot, t).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _part(n: String, mesh_type: Variant, size: Vector3, pos: Vector3, mat: Material) -> void:
	var m := MeshInstance3D.new()
	m.name = n
	var mesh: BoxMesh = mesh_type.new()
	mesh.size = size
	m.mesh = mesh
	m.material_override = mat
	m.position = pos
	m.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_pivot.add_child(m)


func _mat(c: Color, rough: float, metal: float) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = c
	m.roughness = rough
	m.metallic = metal
	return m

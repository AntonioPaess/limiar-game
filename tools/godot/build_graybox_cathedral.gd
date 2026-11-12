## LIM-011 — Gera o graybox da catedral em res://game/world/prototype_cathedral.tscn.
## Bootstrap: depois que a cena for editada à mão no editor, NÃO rodar de novo (ou portar a edição para cá).
##   godot --headless --path . --script "$PWD/tools/godot/build_graybox_cathedral.gd"
## Mapa lógico (04 §3, recorte do protótipo): Átrio → Corredor (parede de Eco placeholder) → Sala de combate →
## Porta → Saída. Eixo -Z é "para frente". Unidades em metros. Cores = alvos da Art Bible §3.
extends SceneTree

const OUT := "res://game/world/prototype_cathedral.tscn"
const C_FLOOR := Color("#3b4054")
const C_WALL := Color("#303447")
const C_COLUMN := Color("#262a38")
const C_CEIL := Color("#1a1d29")
const C_DOOR := Color("#A16D47")
const C_ECO := Color("#69465A")
const C_CANDLE := Color("#D5B879")
const C_CARPET := Color("#9E393E")

var scene_root: Node3D
var _mats := {}


func _initialize() -> void:
	scene_root = Node3D.new()
	scene_root.name = "PrototypeCathedral"
	var geo := _group("Geometry")
	_build_atrium(geo)
	_build_corridor(geo)
	_build_combat_room(geo)
	_build_exit(geo)
	_build_markers()
	_build_interactables()
	_build_lights()

	for n in scene_root.find_children("*", "", true, false):
		n.owner = scene_root
	var packed := PackedScene.new()
	var err := packed.pack(scene_root)
	if err == OK:
		err = ResourceSaver.save(packed, OUT)
	print("[graybox] %s (erro=%d, nós=%d)" % [OUT, err, scene_root.find_children("*", "", true, false).size()])
	scene_root.free()
	quit(0 if err == OK else 1)


# --- zonas ---------------------------------------------------------------

func _build_atrium(p: Node) -> void:  # [A] Átrio Quebrado: x -6..6, z 0..-12, altura 8
	var z := _group("A_Atrio", p)
	_box(z, "Floor", Vector3(0, -0.25, -6), Vector3(12, 0.5, 12), C_FLOOR)
	_box(z, "Carpet", Vector3(0, 0.01, -6.5), Vector3(1.6, 0.02, 11), C_CARPET, false)
	_box(z, "WallBack", Vector3(0, 4, 0.25), Vector3(12.5, 8, 0.5), C_WALL)
	_box(z, "WallLeft", Vector3(-6.25, 4, -6), Vector3(0.5, 8, 12), C_WALL)
	_box(z, "WallRight", Vector3(6.25, 4, -6), Vector3(0.5, 8, 12), C_WALL)
	_box(z, "WallFront_L", Vector3(-4, 4, -12.25), Vector3(5, 8, 0.5), C_WALL)
	_box(z, "WallFront_R", Vector3(4, 4, -12.25), Vector3(5, 8, 0.5), C_WALL)
	_box(z, "Lintel", Vector3(0, 6.5, -12.25), Vector3(3, 3, 0.5), C_WALL)
	_box(z, "Ceiling", Vector3(0, 8.25, -6), Vector3(13, 0.5, 13), C_CEIL)
	for x in [-3.5, 3.5]:
		for cz in [-3.0, -9.0]:
			_box(z, "Column_%d_%d" % [x, -cz], Vector3(x, 4, cz), Vector3(0.8, 8, 0.8), C_COLUMN)


func _build_corridor(p: Node) -> void:  # corredor: x -1.5..1.5, z -12.5..-26, altura 5
	var z := _group("B_Corredor", p)
	_box(z, "Floor", Vector3(0, -0.25, -19.25), Vector3(3, 0.5, 13.5), C_FLOOR)
	_box(z, "WallLeft", Vector3(-1.75, 2.5, -19.25), Vector3(0.5, 5, 13.5), C_WALL)
	_box(z, "WallRight_A", Vector3(1.75, 2.5, -14.75), Vector3(0.5, 5, 4.5), C_WALL)
	_box(z, "WallRight_B", Vector3(1.75, 2.5, -23.5), Vector3(0.5, 5, 5), C_WALL)
	# Parede de Eco: alvo futuro da Ressonância (LIM-020). Por enquanto só um marcador de cor + metadado.
	var eco := _box(z, "EcoWall_Placeholder", Vector3(1.75, 2.5, -19), Vector3(0.5, 5, 4), C_ECO)
	eco.set_meta("resonance_target_id", "ch1_wall_hospital_01")
	eco.set_meta("note", "Placeholder LIM-020: revelar corredor clínico por Leitura")
	_box(z, "Ceiling", Vector3(0, 5.25, -19.25), Vector3(4, 0.5, 13.5), C_CEIL)


func _build_combat_room(p: Node) -> void:  # [C] Galeria dos Vigias: x -8..8, z -26..-42, altura 7
	var z := _group("C_SalaCombate", p)
	_box(z, "Floor", Vector3(0, -0.25, -34), Vector3(16, 0.5, 16), C_FLOOR)
	_box(z, "WallBack_L", Vector3(-4.75, 3.5, -25.75), Vector3(6.5, 7, 0.5), C_WALL)
	_box(z, "WallBack_R", Vector3(4.75, 3.5, -25.75), Vector3(6.5, 7, 0.5), C_WALL)
	_box(z, "WallBack_Lintel", Vector3(0, 6, -25.75), Vector3(3, 2, 0.5), C_WALL)
	_box(z, "WallLeft", Vector3(-8.25, 3.5, -34), Vector3(0.5, 7, 16.5), C_WALL)
	_box(z, "WallRight", Vector3(8.25, 3.5, -34), Vector3(0.5, 7, 16.5), C_WALL)
	_box(z, "WallFar_L", Vector3(-4.5, 3.5, -42.25), Vector3(7, 7, 0.5), C_WALL)
	_box(z, "WallFar_R", Vector3(4.5, 3.5, -42.25), Vector3(7, 7, 0.5), C_WALL)
	_box(z, "WallFar_Lintel", Vector3(0, 5, -42.25), Vector3(2, 4, 0.5), C_WALL)
	_box(z, "Ceiling", Vector3(0, 7.25, -34), Vector3(17, 0.5, 17), C_CEIL)
	for x in [-4.0, 4.0]:
		for cz in [-30.0, -38.0]:
			_box(z, "Column_%d_%d" % [x, -cz], Vector3(x, 3.5, cz), Vector3(1, 7, 1), C_COLUMN)


func _build_exit(p: Node) -> void:  # saída: x -2..2, z -42.5..-48, altura 4
	var z := _group("H_Saida", p)
	_box(z, "Floor", Vector3(0, -0.25, -45.25), Vector3(4, 0.5, 5.5), C_FLOOR)
	_box(z, "WallLeft", Vector3(-2.25, 2, -45.25), Vector3(0.5, 4, 5.5), C_WALL)
	_box(z, "WallRight", Vector3(2.25, 2, -45.25), Vector3(0.5, 4, 5.5), C_WALL)
	_box(z, "WallBack", Vector3(0, 2, -48.25), Vector3(4.5, 4, 0.5), C_WALL)
	_box(z, "Ceiling", Vector3(0, 4.25, -45.25), Vector3(5, 0.5, 6), C_CEIL)


func _build_markers() -> void:
	var m := _group("Markers")
	var spawn := Marker3D.new()
	spawn.name = "PlayerSpawn"
	spawn.position = Vector3(0, 0.05, -2)  # olhando para -Z: a porta do átrio fica à vista
	m.add_child(spawn)
	var combat := Marker3D.new()
	combat.name = "VigiaSpawn_Placeholder"  # LIM-032
	combat.position = Vector3(0, 0, -36)
	m.add_child(combat)


func _build_interactables() -> void:
	var g := _group("Interactables")
	# Objeto examinável no átrio (teste de prompt + mensagem)
	var candle: StaticBody3D = _interactable(g, "Candle_Pedestal", Vector3(2.4, 0.5, -6),
		Vector3(0.5, 1.0, 0.5), C_WALL, &"ch1.proto.candle", "ch1.proto.candle.examine", "ch1.proto.candle.text")
	var wax := MeshInstance3D.new()
	wax.name = "Candle"
	var cyl := CylinderMesh.new()
	cyl.top_radius = 0.06
	cyl.bottom_radius = 0.07
	cyl.height = 0.25
	wax.mesh = cyl
	wax.material_override = _mat(C_CANDLE)
	wax.position = Vector3(0, 0.62, 0)
	candle.add_child(wax)

	# Porta da saída: dobradiça em x=-1; folha de 2 m gira para dentro da saída
	var door := Node3D.new()
	door.name = "ExitDoor"
	door.position = Vector3(-1, 0, -42.25)
	door.set_script(load("res://game/interactive/door.gd"))
	door.set("state_flag", &"ch1.proto.door_exit_open")
	g.add_child(door)
	_interactable(door, "Interactable", Vector3(1, 1.5, 0), Vector3(1.96, 3, 0.2), C_DOOR,
		&"ch1.proto.door_exit", "ch1.proto.door.open", "")

	var exit := Area3D.new()
	exit.name = "ExitTrigger"
	exit.position = Vector3(0, 1, -46)
	exit.collision_layer = 0
	exit.collision_mask = 2  # só o jogador
	exit.set_script(load("res://game/interactive/exit_trigger.gd"))
	var shape := CollisionShape3D.new()
	shape.name = "Shape"
	var box := BoxShape3D.new()
	box.size = Vector3(3, 2, 2)
	shape.shape = box
	exit.add_child(shape)
	g.add_child(exit)


func _build_lights() -> void:
	var g := _group("Lights")
	# âmbar = presença; frio = pedra; dourado na saída para guiar o olhar
	_omni(g, "Atrio_Vela_L", Vector3(-2.2, 1.6, -10.5), Color("#ffb060"), 2.5, 10.0)
	_omni(g, "Atrio_Vela_R", Vector3(2.4, 1.3, -6), Color("#ffb060"), 1.8, 7.0)
	_omni(g, "Atrio_Frio", Vector3(0, 6.5, -6), Color("#8fa3d9"), 1.4, 16.0)
	_omni(g, "Corredor", Vector3(-1, 3.5, -16), Color("#ffa050"), 1.6, 9.0)
	_omni(g, "Corredor_Fundo", Vector3(0, 3.5, -24), Color("#ffa050"), 1.2, 8.0)
	_omni(g, "Corredor_Eco", Vector3(1.0, 2.5, -19), Color("#9a6cff"), 0.8, 4.0)
	_omni(g, "Sala_A", Vector3(-5, 4, -30), Color("#ffa050"), 3.0, 14.0)
	_omni(g, "Sala_B", Vector3(5, 4, -38), Color("#ffa050"), 3.0, 14.0)
	_omni(g, "Sala_C", Vector3(5, 3, -29), Color("#ffb060"), 1.5, 9.0)
	_omni(g, "Sala_D", Vector3(-5, 3, -39.5), Color("#ffb060"), 1.5, 9.0)
	_omni(g, "Sala_Frio", Vector3(0, 6, -34), Color("#8fa3d9"), 1.6, 18.0)
	_omni(g, "Saida_Dourada", Vector3(0, 2.5, -46), Color("#ffd98a"), 3.5, 10.0)


# --- helpers -------------------------------------------------------------

func _group(n: String, parent: Node = null) -> Node3D:
	var g := Node3D.new()
	g.name = n
	(parent if parent != null else scene_root).add_child(g)
	return g


func _mat(c: Color) -> StandardMaterial3D:
	if not _mats.has(c):
		var m := StandardMaterial3D.new()
		m.albedo_color = c
		m.roughness = 0.9
		_mats[c] = m
	return _mats[c]


func _box(parent: Node, n: String, pos: Vector3, size: Vector3, c: Color, collide := true) -> CSGBox3D:
	var b := CSGBox3D.new()
	b.name = n
	b.position = pos
	b.size = size
	b.material = _mat(c)
	b.use_collision = collide
	b.collision_layer = 1
	b.collision_mask = 0
	parent.add_child(b)
	return b


func _interactable(parent: Node, n: String, pos: Vector3, size: Vector3, c: Color, id: StringName,
		prompt_key: String, message_key: String) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = n
	body.position = pos
	body.collision_layer = 1
	body.set_script(load("res://game/interactive/interactable.gd"))
	body.set("interactable_id", id)
	body.set("prompt_key", prompt_key)
	body.set("message_key", message_key)
	var shape := CollisionShape3D.new()
	shape.name = "Shape"
	var box := BoxShape3D.new()
	box.size = size
	shape.shape = box
	body.add_child(shape)
	var mesh := MeshInstance3D.new()
	mesh.name = "Mesh"
	var bm := BoxMesh.new()
	bm.size = size
	mesh.mesh = bm
	mesh.material_override = _mat(c)
	body.add_child(mesh)
	parent.add_child(body)
	return body


func _omni(parent: Node, n: String, pos: Vector3, c: Color, energy: float, rng: float) -> void:
	var l := OmniLight3D.new()
	l.name = n
	l.position = pos
	l.light_color = c
	l.light_energy = energy
	l.omni_range = rng
	l.shadow_enabled = energy >= 2.0  # sombras só nas luzes principais (custo)
	parent.add_child(l)

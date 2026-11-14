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
	_build_echo_layers()
	_build_resonance_targets()
	_build_puzzle()

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
	# Parede do Eco (LIM-020): pedra como as outras; a affordance é uma fissura fina e levemente luminosa (Beat 04).
	_box(z, "EcoWall", Vector3(1.75, 2.5, -19), Vector3(0.5, 5, 4), C_WALL)
	var crack := _box(z, "EcoWall_Fissura", Vector3(1.49, 2.0, -19.2), Vector3(0.03, 2.6, 0.07), C_ECO, false)
	crack.material = _emissive(C_ECO, Color("#9a6cff"), 0.6)
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
	combat.name = "VigiaSpawn"  # LIM-032: Vigia comum guarda a galeria, de frente para a entrada
	combat.position = Vector3(0, 0.05, -35)
	combat.rotation.y = PI
	m.add_child(combat)
	var cp := Marker3D.new()
	cp.name = "Checkpoint_Galeria"  # retorno antes do encontro (GDD §8: checkpoints curtos antes de lutas)
	cp.position = Vector3(0, 0.05, -23.5)
	m.add_child(cp)


func _build_interactables() -> void:
	var g := _group("Interactables")
	# Pedestal do átrio: porta-retratos do Eco "A cadeira guardada" (LIM-040). A vela fica como cenário.
	var pedestal: StaticBody3D = _interactable(g, "Photo_Pedestal", Vector3(2.4, 0.5, -6),
		Vector3(0.5, 1.0, 0.5), C_WALL, &"ch1.eco.foto", "ch1.eco.foto.examinar", "ch1.eco.foto.texto")
	var wax := MeshInstance3D.new()
	wax.name = "Candle"
	var cyl := CylinderMesh.new()
	cyl.top_radius = 0.05
	cyl.bottom_radius = 0.06
	cyl.height = 0.2
	wax.mesh = cyl
	wax.material_override = _mat(C_CANDLE)
	wax.position = Vector3(0.15, 0.6, 0.12)
	pedestal.add_child(wax)
	_photo_frame(pedestal)

	# Porta da saída: dobradiça em x=-1; folha de 2 m gira para dentro da saída
	var door := Node3D.new()
	door.name = "ExitDoor"
	door.position = Vector3(-1, 0, -42.25)
	door.set_script(load("res://game/interactive/door.gd"))
	door.set("state_flag", &"ch1.proto.door_exit_open")
	door.set("locked", true)
	door.set("locked_message_key", "")  # o puzzle fala pela porta (dicas graduais)
	g.add_child(door)
	_interactable(door, "Interactable", Vector3(1, 1.5, 0), Vector3(1.96, 3, 0.2), C_DOOR,
		&"ch1.proto.door_exit", "ch1.proto.door.open", "")

	var cpa := Area3D.new()
	cpa.name = "CheckpointArea_Galeria"
	cpa.position = Vector3(0, 1, -23.5)
	cpa.collision_layer = 0
	cpa.collision_mask = 2
	cpa.set_meta("checkpoint_marker", "Markers/Checkpoint_Galeria")
	var cps := CollisionShape3D.new()
	cps.name = "Shape"
	var cpb := BoxShape3D.new()
	cpb.size = Vector3(3, 2, 2)
	cps.shape = cpb
	cpa.add_child(cps)
	g.add_child(cpa)

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


const C_TILE := Color("#b9c2bf")
const C_CLINIC_WALL := Color("#8e9a97")
const C_SHEET := Color("#d9dcd6")
const C_METAL := Color("#6f7775")
const C_SCREEN := Color("#0d1412")
const C_TRACE := Color("#58d68d")
const CANDLE_POS := [Vector3(-7.2, 0, -31), Vector3(-7.2, 0, -37), Vector3(7.2, 0, -34)]
const CANDLE_SOLUTION := [true, false, true]  ## monitores LIGADOS no Eco = velas a acender [PROPOSTA]


# --- Eco (Ressonância) ---------------------------------------------------

func _build_echo_layers() -> void:
	var g := _group("EcoLayers")
	# Vislumbre clínico atrás da fissura: x 2..6, z -17..-21. Só visual (sem colisão): é um vislumbre, não passagem.
	var h := _group("Eco_Hospital", g)
	_box(h, "Floor", Vector3(4, -0.24, -19), Vector3(4, 0.5, 4), C_TILE, false)
	_box(h, "WallFar", Vector3(6.25, 2, -19), Vector3(0.5, 4, 4.5), C_CLINIC_WALL, false)
	_box(h, "WallA", Vector3(4, 2, -16.75), Vector3(4.5, 4, 0.5), C_CLINIC_WALL, false)
	_box(h, "WallB", Vector3(4, 2, -21.25), Vector3(4.5, 4, 0.5), C_CLINIC_WALL, false)
	_box(h, "Ceiling", Vector3(4, 4.25, -19), Vector3(4.5, 0.5, 4.5), C_CLINIC_WALL, false)
	var tube := _box(h, "Fluorescente", Vector3(4, 3.95, -19), Vector3(0.15, 0.06, 2.4), C_SHEET, false)
	tube.material = _emissive(C_SHEET, Color("#dfe9ff"), 2.0)
	_box(h, "Maca_Base", Vector3(4.6, 0.45, -19.6), Vector3(0.9, 0.12, 2.0), C_METAL, false)
	_box(h, "Maca_Lencol", Vector3(4.6, 0.6, -19.6), Vector3(0.85, 0.16, 1.9), C_SHEET, false)
	_box(h, "Maca_Cabeceira", Vector3(4.6, 0.85, -18.62), Vector3(0.9, 0.7, 0.06), C_METAL, false)
	_monitor(h, "Monitor", Vector3(5.6, 1.35, -18.4), -PI / 2.0, true)
	var lamp := OmniLight3D.new()
	lamp.name = "Luz_Clinica"
	lamp.position = Vector3(4, 3.6, -19)
	lamp.light_color = Color("#dfe9ff")
	lamp.light_energy = 1.6
	lamp.omni_range = 6.0
	h.add_child(lamp)

	# Mesa do Eco "A cadeira guardada": cinco lugares, quatro presenças âmbar (sem rosto, sem gênero) e uma cadeira
	# vazia, levemente afastada, mais perto de quem olha. Âmbar = presença/afeto (Art Bible §2).
	var mesa := _group("Eco_Mesa", g)
	var wood := Color("#6b4a35")
	_box(mesa, "Tampo", Vector3(4.6, 0.76, -6.0), Vector3(1.0, 0.06, 1.9), wood, false)
	for lx in [4.2, 5.0]:
		for lz in [-5.15, -6.85]:
			_box(mesa, "Perna_%d_%d" % [lx * 10, -lz * 100], Vector3(lx, 0.37, lz), Vector3(0.06, 0.74, 0.06), wood, false)
	var cloth := Color("#d8cbb0")
	_box(mesa, "Toalha", Vector3(4.6, 0.795, -6.0), Vector3(0.7, 0.01, 1.7), cloth, false)
	# lugares: (posição da cadeira, yaw voltado para a mesa, ocupado?)
	var seats := [
		[Vector3(3.75, 0, -5.55), PI / 2.0, true], [Vector3(3.75, 0, -6.45), PI / 2.0, true],
		[Vector3(5.45, 0, -5.55), -PI / 2.0, true], [Vector3(5.45, 0, -6.45), -PI / 2.0, true],
		[Vector3(4.65, 0, -4.55), 0.25, false],  # cabeceira vazia, voltada para o átrio e um pouco afastada
	]
	for i in seats.size():
		var seat: Array = seats[i]
		_chair(mesa, "Cadeira_%d" % i, seat[0], seat[1], wood)
		var pos: Vector3 = seat[0]
		var toward := Vector3(4.6, 0, -6.0) - pos
		toward.y = 0.0
		_box(mesa, "Prato_%d" % i, pos + toward.normalized() * 0.55 + Vector3(0, 0.81, 0), Vector3(0.22, 0.012, 0.22), cloth.lightened(0.3), false)
		if seat[2]:
			var p := MeshInstance3D.new()
			p.name = "Presenca_%d" % i
			var cap := CapsuleMesh.new()
			cap.radius = 0.2
			cap.height = 1.05
			p.mesh = cap
			var m := StandardMaterial3D.new()
			m.albedo_color = Color(0.84, 0.72, 0.47, 0.35)
			m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			m.emission_enabled = true
			m.emission = Color("#D5B879")
			m.emission_energy_multiplier = 0.8
			m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
			p.material_override = m
			p.position = pos + Vector3(0, 0.95, 0) - toward.normalized() * 0.05
			mesa.add_child(p)
	var warm := OmniLight3D.new()
	warm.name = "Luz_Mesa"
	warm.position = Vector3(4.6, 2.2, -6.0)
	warm.light_color = Color("#ffcf8a")
	warm.light_energy = 2.2
	warm.omni_range = 5.5
	mesa.add_child(warm)

	# Monitores do Eco na sala de combate, sobre os candelabros: ligado = traço em zigue-zague, desligado = linha reta.
	var m := _group("Eco_Monitores", g)
	for i in CANDLE_POS.size():
		var face := PI / 2.0 if CANDLE_POS[i].x < 0 else -PI / 2.0  # tela voltada para o centro da sala
		_monitor(m, "Monitor_%d" % i, CANDLE_POS[i] + Vector3(0, 1.9, 0), face, CANDLE_SOLUTION[i])


func _build_resonance_targets() -> void:
	var g := _group("Resonance")
	# Eco narrativo do átrio: mesa ganha vida ao lado do pedestal; a encenação e o Diário ficam no EcoSequence.
	_target(g, "Res_MesaGuardada", Vector3(4.2, 1.0, -6), &"ch1_atrio_mesa_guardada",
		ResonanceTargetData.TargetType.NARRATIVE_ECHO, [], "", 2.0, [], ["../../EcoLayers/Eco_Mesa"], &"")
	(g.get_node("Res_MesaGuardada").get("data") as ResonanceTargetData).read_duration_sec = 5.5
	var seq := Node.new()
	seq.name = "Seq_AssentoGuardado"
	seq.set_script(load("res://game/narrative/eco_sequence.gd"))
	seq.set("target", NodePath("../Res_MesaGuardada"))
	seq.set("entry", load("res://game/data/narrative/ch1_assento_guardado.tres"))
	g.add_child(seq)

	_target(g, "Res_ParedeHospital", Vector3(1.75, 2.0, -19), &"ch1_wall_hospital_01",
		ResonanceTargetData.TargetType.REVEAL, [&"ch1.echo.hospital_glimpse_seen"],
		"ch1.proto.echo.hospital.caption", 1.0,
		["../../Geometry/B_Corredor/EcoWall", "../../Geometry/B_Corredor/EcoWall_Fissura"],
		["../../EcoLayers/Eco_Hospital"], &"monitor_beep")
	_target(g, "Res_MonitoresSala", Vector3(0, 1.5, -34), &"ch1_room_monitors_01",
		ResonanceTargetData.TargetType.CLUE, [&"ch1.echo.room_monitors_seen"],
		"ch1.proto.echo.monitors.caption", 6.0, [], ["../../EcoLayers/Eco_Monitores"], &"monitor_beep")

	var hint := Area3D.new()
	hint.name = "DicaRessonancia"
	hint.position = Vector3(0, 1, -18.5)
	hint.collision_layer = 0
	hint.collision_mask = 2
	hint.set_script(load("res://game/interactive/hint_area.gd"))
	hint.set("hint_key", "ui.resonance.hint")
	hint.set("action", &"resonance")
	var shape := CollisionShape3D.new()
	shape.name = "Shape"
	var box := BoxShape3D.new()
	box.size = Vector3(3, 2, 5)
	shape.shape = box
	hint.add_child(shape)
	g.add_child(hint)


func _build_puzzle() -> void:
	var g: Node3D = scene_root.get_node("Interactables")
	var paths: Array[NodePath] = []
	for i in CANDLE_POS.size():
		var c := Node3D.new()
		c.name = "Candelabro_%d" % i
		c.position = CANDLE_POS[i]
		c.set_script(load("res://game/interactive/candelabrum.gd"))
		g.add_child(c)
		var body := _interactable(c, "Interactable", Vector3(0, 0.65, 0), Vector3(0.35, 1.3, 0.35), C_METAL,
			StringName("ch1.proto.candle_%d" % i), "ch1.proto.candle.light", "")
		body.set("once", false)
		var flame := Node3D.new()
		flame.name = "Flame"
		flame.position = Vector3(0, 1.42, 0)
		c.add_child(flame)
		var fm := MeshInstance3D.new()
		fm.name = "Chama"
		var sph := SphereMesh.new()
		sph.radius = 0.06
		sph.height = 0.16
		fm.mesh = sph
		fm.material_override = _emissive(C_CANDLE, Color("#ffb060"), 3.0)
		flame.add_child(fm)
		var light := OmniLight3D.new()
		light.name = "Light"
		light.light_color = Color("#ffb060")
		light.light_energy = 1.2
		light.omni_range = 5.0
		flame.add_child(light)
		var sfx := AudioStreamPlayer3D.new()
		sfx.name = "Sfx"
		c.add_child(sfx)
		paths.append(NodePath("../Candelabro_%d" % i))

	var puzzle := Node.new()
	puzzle.name = "PuzzleVelas"
	puzzle.set_script(load("res://game/puzzles/candle_pattern_puzzle.gd"))
	puzzle.set("candelabra", paths)
	var sol: Array[bool] = []
	sol.assign(CANDLE_SOLUTION)
	puzzle.set("solution", sol)
	puzzle.set("door", NodePath("../ExitDoor"))
	var psfx := AudioStreamPlayer.new()
	psfx.name = "Sfx"
	puzzle.add_child(psfx)
	g.add_child(puzzle)  # depois da porta e dos candelabros: _ready deles roda antes


func _chair(parent: Node, n: String, pos: Vector3, yaw: float, c: Color) -> void:
	var ch := Node3D.new()
	ch.name = n
	ch.position = pos
	ch.rotation.y = yaw
	parent.add_child(ch)
	_box(ch, "Assento", Vector3(0, 0.45, 0), Vector3(0.42, 0.05, 0.42), c, false)
	_box(ch, "Encosto", Vector3(0, 0.75, -0.19), Vector3(0.42, 0.55, 0.04), c, false)
	for px in [-0.18, 0.18]:
		for pz in [-0.18, 0.18]:
			_box(ch, "Pe_%d_%d" % [px * 100, pz * 100], Vector3(px, 0.22, pz), Vector3(0.04, 0.44, 0.04), c, false)


## Porta-retratos inclinado sobre o pedestal. A "foto" é um pictograma em cinzas: mesa, quatro cabeças, um lugar vazio.
func _photo_frame(pedestal: Node3D) -> void:
	var f := Node3D.new()
	f.name = "PortaRetrato"
	f.position = Vector3(-0.05, 0.66, 0.05)
	f.rotation = Vector3(deg_to_rad(-15), deg_to_rad(20), 0)
	pedestal.add_child(f)
	_box(f, "Moldura", Vector3(0, 0, 0), Vector3(0.3, 0.22, 0.02), Color("#3a2a22"), false)
	_box(f, "Foto", Vector3(0, 0, 0.011), Vector3(0.26, 0.18, 0.002), Color("#b9b3a8"), false)
	_box(f, "Mesa", Vector3(0, -0.035, 0.013), Vector3(0.17, 0.03, 0.002), Color("#55504a"), false)
	for i in 5:
		var x := -0.064 + i * 0.032
		if i == 3:  # o lugar vazio: só o encosto, sem cabeça
			_box(f, "Lugar_vazio", Vector3(x, -0.005, 0.013), Vector3(0.018, 0.035, 0.002), Color("#8a847b"), false)
		else:
			_box(f, "Pessoa_%d" % i, Vector3(x, 0.015, 0.013), Vector3(0.02, 0.02, 0.002), Color("#3f3b36"), false)


func _monitor(parent: Node, n: String, pos: Vector3, yaw: float, on: bool) -> void:
	var mon := Node3D.new()
	mon.name = n
	mon.position = pos
	mon.rotation.y = yaw
	parent.add_child(mon)
	_box(mon, "Corpo", Vector3(0, 0, 0), Vector3(0.62, 0.46, 0.18), C_METAL, false)
	_box(mon, "Tela", Vector3(0, 0.02, 0.095), Vector3(0.52, 0.34, 0.01), C_SCREEN, false)
	if on:  # zigue-zague: forma distingue "ligado", não só a cor
		var pts := [Vector2(-0.22, 0), Vector2(-0.08, 0), Vector2(-0.04, 0.1), Vector2(0.0, -0.09),
			Vector2(0.04, 0.05), Vector2(0.08, 0), Vector2(0.22, 0)]
		for k in pts.size() - 1:
			var a: Vector2 = pts[k]
			var b: Vector2 = pts[k + 1]
			var mid := (a + b) / 2.0
			var seg := _box(mon, "Traco_%d" % k, Vector3(mid.x, mid.y + 0.02, 0.102),
				Vector3((b - a).length(), 0.012, 0.004), C_TRACE, false)
			seg.rotation.z = atan2(b.y - a.y, b.x - a.x)
			seg.material = _emissive(C_TRACE, C_TRACE, 2.5)
	else:  # linha reta, apagada
		_box(mon, "Traco_Plano", Vector3(0, 0.02, 0.102), Vector3(0.44, 0.008, 0.004), C_METAL, false)


func _target(parent: Node, n: String, pos: Vector3, id: StringName, type: int, flags: Array,
		caption_key: String, reach: float, veil: Array, echo: Array, sound: StringName) -> void:
	var t := Node3D.new()
	t.name = n
	t.position = pos
	t.set_script(load("res://game/resonance/resonance_target.gd"))
	var d := ResonanceTargetData.new()
	d.id = id
	d.target_type = type
	var fl: Array[StringName] = []
	fl.assign(flags)
	d.on_resolved_flags = fl
	d.caption_key = caption_key
	d.reach = reach
	t.set("data", d)
	var vp: Array[NodePath] = []
	for v in veil:
		vp.append(NodePath(v))
	var ep: Array[NodePath] = []
	for e in echo:
		ep.append(NodePath(e))
	t.set("veil_nodes", vp)
	t.set("echo_nodes", ep)
	t.set("echo_sound", sound)
	var audio := AudioStreamPlayer3D.new()
	audio.name = "EchoAudio"
	t.add_child(audio)
	parent.add_child(t)


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


func _emissive(albedo: Color, glow: Color, energy: float) -> StandardMaterial3D:
	var key := "%s|%s|%s" % [albedo, glow, energy]
	if not _mats.has(key):
		var m := StandardMaterial3D.new()
		m.albedo_color = albedo
		m.emission_enabled = true
		m.emission = glow
		m.emission_energy_multiplier = energy
		_mats[key] = m
	return _mats[key]


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

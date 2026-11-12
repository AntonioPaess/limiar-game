## Runner headless do protótipo (09 QA: MOV-01, INP-01, INT-01, CAM-01 parcial). Sai com 1 se qualquer teste falhar.
## godot --headless --path . --import && godot --headless --path . --script res://tests/run_tests.gd
extends SceneTree

const MAIN := "res://game/main.tscn"

var passed := 0
var failed := 0
var _current := ""
var game_state: Node  # autoload GameState (o identificador global não existe em scripts --script)


func _initialize() -> void:
	game_state = root.get_node("GameState")
	# unitários (sem cena)
	for t: String in ["test_input_actions_exist", "test_no_key_conflicts", "test_velocity_accelerates_bounded",
			"test_velocity_decelerates_to_zero", "test_pitch_clamped", "test_fov_clamped",
			"test_interactable_once", "test_translations_loaded"]:
		_run(t)
	# integração (cena principal)
	for t: String in ["test_spawn_on_floor", "test_walk_forward", "test_interaction_range_and_door",
			"test_exit_trigger_sets_flag", "test_pause_blocks_input"]:
		await _run_async(t)
	print("\n[tests] %d ok, %d falha(s)" % [passed, failed])
	quit(1 if failed > 0 else 0)


# --- infraestrutura ------------------------------------------------------

func _run(t: String) -> void:
	_current = t
	if call(t) != true:
		_fail("não terminou (erro de execução?)")


func _run_async(t: String) -> void:
	_current = t
	game_state.reset()
	if await call(t) != true:
		_fail("não terminou (erro de execução?)")


func check(cond: bool, what: String) -> bool:
	if cond:
		passed += 1
		print("  ok   %s: %s" % [_current, what])
	else:
		_fail(what)
	return cond


func _fail(what: String) -> void:
	failed += 1
	push_error("FALHA %s: %s" % [_current, what])
	print("  FALHA %s: %s" % [_current, what])


func _load_main() -> Main:
	var main: Main = (load(MAIN) as PackedScene).instantiate()
	root.add_child(main)
	await physics_frame
	return main


func _frames(n: int) -> void:
	for i in n:
		await physics_frame


func _place(player: FirstPersonPlayer, pos: Vector3, yaw_deg: float) -> void:
	player.global_position = pos
	player.rotation = Vector3(0, deg_to_rad(yaw_deg), 0)
	player.velocity = Vector3.ZERO
	player.head.rotation = Vector3.ZERO


# --- unitários -----------------------------------------------------------

func test_input_actions_exist() -> bool:
	for a in ["move_forward", "move_back", "move_left", "move_right", "look_up", "look_down", "look_left",
			"look_right", "sprint", "interact", "attack_light", "guard", "dodge", "resonance", "pause", "debug_overlay"]:
		check(InputMap.has_action(a) and InputMap.action_get_events(a).size() > 0, "ação %s mapeada" % a)
	return true


func test_no_key_conflicts() -> bool:
	var seen := {}
	var conflicts: Array[String] = []
	for a in InputMap.get_actions():
		if String(a).begins_with("ui_"):
			continue
		for ev in InputMap.action_get_events(a):
			var k := ""
			if ev is InputEventKey:
				k = "key:%d" % ev.physical_keycode
			elif ev is InputEventMouseButton:
				k = "mouse:%d" % ev.button_index
			elif ev is InputEventJoypadButton:
				k = "joy:%d" % ev.button_index
			elif ev is InputEventJoypadMotion:
				k = "axis:%d:%d" % [ev.axis, signf(ev.axis_value)]
			if k == "":
				continue
			if seen.has(k):
				conflicts.append("%s em %s e %s" % [k, seen[k], a])
			seen[k] = a
	check(conflicts.is_empty(), "nenhuma tecla/botão em duas ações %s" % [conflicts])
	return true


func test_velocity_accelerates_bounded() -> bool:
	var v := FirstPersonPlayer.compute_horizontal_velocity(Vector3.ZERO, Vector3(0, 0, -1), 4.2, 30.0, 1.0 / 60.0)
	check(is_equal_approx(v.length(), 0.5), "1 tick acelera exatamente accel*dt (0.5 m/s)")
	for i in 60:
		v = FirstPersonPlayer.compute_horizontal_velocity(v, Vector3(0, 0, -1), 4.2, 30.0, 1.0 / 60.0)
	check(is_equal_approx(v.length(), 4.2), "converge para a velocidade-alvo sem ultrapassar")
	return true


func test_velocity_decelerates_to_zero() -> bool:
	var v := Vector3(6, 0, 0)
	for i in 20:
		v = FirstPersonPlayer.compute_horizontal_velocity(v, Vector3.ZERO, 4.2, 40.0, 1.0 / 60.0)
	check(v.is_zero_approx(), "solta o movimento → para em < 0,35 s")
	return true


func test_pitch_clamped() -> bool:
	check(is_equal_approx(FirstPersonPlayer.clamp_pitch(PI, 85.0), deg_to_rad(85.0)), "pitch máx 85°")
	check(is_equal_approx(FirstPersonPlayer.clamp_pitch(-PI, 85.0), -deg_to_rad(85.0)), "pitch mín -85°")
	return true


func test_fov_clamped() -> bool:
	var s: PlayerSettings = load("res://game/data/player/default_player_settings.tres").duplicate()
	check(is_equal_approx(s.fov_horizontal, 80.0), "FOV padrão 80° horizontal")
	s.fov_horizontal = 200.0
	check(is_equal_approx(s.fov_horizontal, 100.0), "FOV limitado a 100°")
	s.fov_horizontal = 10.0
	check(is_equal_approx(s.fov_horizontal, 70.0), "FOV limitado a 70°")
	return true


func test_interactable_once() -> bool:
	var i := Interactable.new()
	i.once = true
	var count := [0]
	i.used.connect(func(_a: Node) -> void: count[0] += 1)
	check(i.interact(null) == true, "primeira interação aceita")
	check(i.interact(null) == false, "segunda interação recusada (once)")
	check(count[0] == 1, "sinal `used` emitido 1 vez")
	i.free()
	return true


func test_translations_loaded() -> bool:
	check(TranslationServer.translate("ui.pause.resume") == "Continuar", "texto PT-BR vem da tabela, não do código")
	return true


# --- integração ----------------------------------------------------------

func test_spawn_on_floor() -> bool:
	var main := await _load_main()
	await _frames(30)
	check(main.player.is_on_floor(), "jogador no chão após o spawn")
	check(absf(main.player.global_position.y) < 0.2, "não afundou nem caiu (y=%.3f)" % main.player.global_position.y)
	check(is_equal_approx(main.player.camera.fov, 80.0), "câmera aplica FOV das opções")
	main.queue_free()
	await process_frame
	return true


func test_walk_forward() -> bool:
	var main := await _load_main()
	await _frames(10)
	var z0 := main.player.global_position.z
	Input.action_press("move_forward")
	await _frames(60)
	Input.action_release("move_forward")
	var dz := z0 - main.player.global_position.z
	check(dz > 3.0 and dz < 4.5, "anda ~4 m em 1 s para frente (%.2f m)" % dz)
	await _frames(30)
	check(Vector2(main.player.velocity.x, main.player.velocity.z).length() < 0.01, "para ao soltar")
	main.queue_free()
	await process_frame
	return true


func test_interaction_range_and_door() -> bool:
	var main := await _load_main()
	var interaction: PlayerInteraction = main.player.get_node("PlayerInteraction")
	var door: Door = main.world.get_node("Interactables/ExitDoor")
	# longe da porta (4 m): nada em foco
	_place(main.player, Vector3(0, 0.05, -38.0), 0.0)
	await _frames(5)
	check(interaction.current_target == null, "fora do alcance (4 m) não foca a porta")
	# perto (1,5 m), olhando para a porta
	_place(main.player, Vector3(0, 0.05, -40.6), 0.0)
	await _frames(5)
	check(interaction.current_target != null and interaction.current_target.get_parent() == door,
		"no alcance foca a porta")
	check(main.hud.current_prompt().contains("Abrir porta"), "HUD mostra o prompt '%s'" % main.hud.current_prompt())
	check(interaction.try_interact() == true, "interagir abre a porta")
	check(interaction.try_interact() == false, "segunda tentativa não faz nada (1 resposta por ação)")
	check(door.is_open, "porta marcada como aberta")
	check(game_state.has_flag(&"ch1.proto.door_exit_open"), "flag de sessão gravada")
	await _frames(5)
	check(main.hud.current_prompt() == "", "prompt some após abrir")
	main.queue_free()
	await process_frame
	return true


func test_exit_trigger_sets_flag() -> bool:
	var main := await _load_main()
	var door: Door = main.world.get_node("Interactables/ExitDoor")
	door.open()
	await _frames(60)  # animação da porta (0,8 s)
	_place(main.player, Vector3(0, 0.05, -41.0), 0.0)
	Input.action_press("move_forward")
	await _frames(90)
	Input.action_release("move_forward")
	check(main.player.global_position.z < -44.0, "passa pela porta aberta (z=%.2f)" % main.player.global_position.z)
	check(game_state.has_flag(&"ch1.proto.exit_reached"), "chegar à saída marca a flag")
	check(main.hud.current_message() != "", "HUD mostra a mensagem de fim do trecho")
	main.queue_free()
	await process_frame
	return true


func test_pause_blocks_input() -> bool:
	var main := await _load_main()
	await _frames(10)
	main.pause_menu.open()
	check(paused and not main.player.input_enabled, "pausa congela a árvore e desliga o input")
	main.pause_menu.close()
	check(not paused and main.player.input_enabled, "continuar devolve o controle")
	main.queue_free()
	await process_frame
	return true

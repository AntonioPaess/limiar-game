## Runner headless do protótipo (09 QA: MOV-01, INP-01, INT-01, CAM-01 parcial, RES-01, RES-02, PUZ-01, NAR-01). Sai com 1 se qualquer teste falhar.
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
			"test_puzzle_states", "test_resonance_reveals_in_range_for_free", "test_resonance_flag_and_event_once",
			"test_resonance_keeps_collision", "test_resonance_contextual_hint",
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
	var puzzle: CandlePatternPuzzle = main.world.get_node("Interactables/PuzzleVelas")
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
	# trancada: tentativa aceita, mas só informa; 2ª tentativa dá a dica (não punitivo)
	check(interaction.try_interact() == true and not door.is_open, "trancada: porta não abre")
	check(main.hud.current_message() == "A porta não cede.", "1ª tentativa: '%s'" % main.hud.current_message())
	interaction.try_interact()
	check(main.hud.current_message().contains("velas"), "2ª tentativa: dica gradual sobre as velas")
	check(main.hud.current_hint().contains("Ressonância"), "2ª tentativa: lembra a tecla da Ressonância")
	# resolve o puzzle e abre
	_solve_puzzle(main)
	check(puzzle.is_solved and not door.locked, "padrão correto destranca a porta")
	check(interaction.try_interact() == true, "interagir abre a porta")
	check(interaction.try_interact() == false, "segunda tentativa não faz nada (1 resposta por ação)")
	check(door.is_open, "porta marcada como aberta")
	check(game_state.has_flag(&"ch1.proto.door_exit_open"), "flag de sessão gravada")
	await _frames(5)
	check(main.hud.current_prompt() == "", "prompt some após abrir")
	main.queue_free()
	await process_frame
	return true


func _solve_puzzle(main: Main) -> void:
	var puzzle: CandlePatternPuzzle = main.world.get_node("Interactables/PuzzleVelas")
	for i in puzzle.candelabra.size():
		(puzzle.get_node(puzzle.candelabra[i]) as Candelabrum).set_lit(puzzle.solution[i])


func test_puzzle_states() -> bool:
	var main := await _load_main()
	var puzzle: CandlePatternPuzzle = main.world.get_node("Interactables/PuzzleVelas")
	var door: Door = main.world.get_node("Interactables/ExitDoor")
	var candles: Array[Candelabrum] = []
	for p in puzzle.candelabra:
		candles.append(puzzle.get_node(p))
	check(candles.size() == 3 and puzzle.solution.size() == 3, "3 candelabros, solução de 3 estados")
	check(door.locked and not puzzle.is_solved, "começa em repouso, porta trancada")
	for c in candles:
		c.set_lit(true)
	check(not puzzle.is_solved and door.locked, "padrão errado (todas acesas) não destranca")
	_solve_puzzle(main)
	check(puzzle.is_solved and game_state.has_flag(&"ch1.puzzle.candles_solved"), "padrão certo resolve e grava a flag")
	candles[0].set_lit(not candles[0].lit)
	check(puzzle.is_solved and not door.locked, "mexer nas velas depois não volta a trancar")
	main.queue_free()
	await process_frame
	# recarga da cena na mesma sessão: estado resolvido persiste
	var again := await _load_main()
	var p2: CandlePatternPuzzle = again.world.get_node("Interactables/PuzzleVelas")
	var d2: Door = again.world.get_node("Interactables/ExitDoor")
	check(p2.is_solved and not d2.locked, "resolvido persiste em sessão (recarga)")
	again.queue_free()
	await process_frame
	return true


func test_resonance_reveals_in_range_for_free() -> bool:
	var main := await _load_main()
	var res: PlayerResonance = main.player.get_node("PlayerResonance")
	var wall: ResonanceTarget = main.world.get_node("Resonance/Res_ParedeHospital")
	var echo: Node3D = main.world.get_node("EcoLayers/Eco_Hospital")
	check(wall.data.read_cost == 0, "pista crítica com custo 0 (RES-02)")
	check(not echo.visible, "Eco escondido no Véu")
	# longe (spawn, ~17 m): Leitura acontece mas não alcança a parede
	await _frames(5)
	check(res.try_read(), "Leitura executa no spawn")
	check(not wall.is_revealed, "fora do raio: parede não revela")
	res._process(10.0)
	res._process(10.0)
	check(res.state == PlayerResonance.State.READY, "volta a ficar pronta após ativa + cooldown")
	# perto da fissura
	_place(main.player, Vector3(0, 0.05, -18.5), -90.0)
	await _frames(3)
	check(res.try_read(), "Leitura executa perto da fissura")
	check(wall.is_revealed and echo.visible, "Eco do corredor clínico aparece (RES-01)")
	check(game_state.has_flag(&"ch1.echo.hospital_glimpse_seen"), "flag do vislumbre gravada")
	check(not res.try_read(), "apertar de novo durante a Leitura não gera nova Leitura")
	wall._process(wall.data.read_duration_sec + 0.1)
	check(not wall.is_revealed, "Eco some depois da duração")
	main.queue_free()
	await process_frame
	return true


func test_resonance_flag_and_event_once() -> bool:
	var main := await _load_main()
	var res: PlayerResonance = main.player.get_node("PlayerResonance")
	var count := [0]
	game_state.narrative_flag_changed.connect(func(id: StringName, _v: Variant) -> void:
		if id == &"ch1.echo.hospital_glimpse_seen":
			count[0] += 1)
	_place(main.player, Vector3(0, 0.05, -18.5), -90.0)
	await _frames(3)
	for i in 3:
		res.try_read()
		res._process(10.0)
		res._process(10.0)
	check(res.reads_done == 3, "3 Leituras feitas")
	check(count[0] == 1, "flag e evento do vislumbre disparam 1 vez (NAR-01), obtido %d" % count[0])
	main.queue_free()
	await process_frame
	return true


func test_resonance_keeps_collision() -> bool:
	var main := await _load_main()
	var res: PlayerResonance = main.player.get_node("PlayerResonance")
	var wall: CSGBox3D = main.world.get_node("Geometry/B_Corredor/EcoWall")
	_place(main.player, Vector3(0.6, 0.05, -19.0), 0.0)
	await _frames(3)
	res.try_read()
	check(wall.use_collision, "parede continua sólida durante o Eco")
	Input.action_press("move_right")
	await _frames(60)
	Input.action_release("move_right")
	check(main.player.global_position.x < 1.5, "jogador não atravessa a parede revelada (x=%.2f)" % main.player.global_position.x)
	main.queue_free()
	await process_frame
	return true


func test_resonance_contextual_hint() -> bool:
	var main := await _load_main()
	var res: PlayerResonance = main.player.get_node("PlayerResonance")
	_place(main.player, Vector3(0, 0.05, -18.5), 0.0)
	await _frames(10)
	check(main.hud.current_hint().contains("Ressonância"), "dica contextual perto da fissura: '%s'" % main.hud.current_hint())
	res.try_read()
	check(main.hud.current_hint() == "", "dica some ao usar a Ressonância")
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

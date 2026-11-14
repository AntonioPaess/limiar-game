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
			"test_interactable_once", "test_translations_loaded", "test_eco_texts_respect_canon"]:
		_run(t)
	# integração (cena principal)
	for t: String in ["test_spawn_on_floor", "test_walk_forward", "test_interaction_range_and_door",
			"test_puzzle_states", "test_resonance_reveals_in_range_for_free", "test_resonance_flag_and_event_once",
			"test_resonance_keeps_collision", "test_resonance_contextual_hint",
			"test_exit_trigger_sets_flag", "test_pause_blocks_input",
			"test_attack_damages_once_from_behind", "test_shield_blocks_front", "test_guard_parry_and_block",
			"test_dodge_iframes_and_walls", "test_vigia_telegraphs_then_hits", "test_vigia_beatable_without_parry",
			"test_intervention_rules", "test_death_respawn_keeps_progress", "test_hit_stop_restores_time",
			"test_eco_photo_examine_and_hint", "test_eco_reveal_sequence_and_journal", "test_journal_shows_entry"]:
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


## Sem Vigia por padrão (testes de exploração não devem ser interrompidos por combate).
func _load_main(with_vigia := false) -> Main:
	if not with_vigia:
		game_state.set_flag(&"ch1.proto.vigia_comum_defeated", true)
	var main: Main = (load(MAIN) as PackedScene).instantiate()
	root.add_child(main)
	await physics_frame
	main.player.settings.hitstop_enabled = false  # tempo determinístico nos testes
	return main


## Vigia parado (IA congelada) virado para +Z na posição dada.
func _freeze_vigia(main: Main, pos: Vector3) -> Vigia:
	var v := main.vigia
	v.set_physics_process(false)
	v.global_position = pos
	v.rotation = Vector3(0, PI, 0)  # frente (-Z local) aponta para +Z
	v.state = Vigia.State.IDLE
	return v


## Roda a máquina de estados do combate do jogador até voltar a IDLE (máx. `limit` frames).
func _finish_attack(main: Main, limit := 90) -> void:
	for i in limit:
		await physics_frame
		if main.combat.state == PlayerCombat.State.IDLE:
			return


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
			"look_right", "sprint", "interact", "attack_light", "guard", "dodge", "resonance", "pause", "journal", "debug_overlay"]:
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


# --- combate (COM-01..03, RES-03, SAV parcial) -------------------------------------

func test_attack_damages_once_from_behind() -> bool:
	var main := await _load_main(true)
	var v := _freeze_vigia(main, Vector3(0, 0.05, -34))
	_place(main.player, Vector3(0, 0.05, -35.6), 180.0)  # atrás do Vigia, olhando para ele
	await _frames(3)
	var hp := v.health.current
	check(main.combat.request_attack(), "ataque leve começa")
	check(main.combat.state == PlayerCombat.State.WINDUP, "ataque passa por windup (anúncio)")
	await _finish_attack(main)
	check(is_equal_approx(hp - v.health.current, 12.0), "1 golpe = 12 de dano exatamente 1 vez (COM-01): %.1f" % (hp - v.health.current))
	main.queue_free()
	await process_frame
	return true


func test_shield_blocks_front() -> bool:
	var main := await _load_main(true)
	var v := _freeze_vigia(main, Vector3(0, 0.05, -34))
	_place(main.player, Vector3(0, 0.05, -32.4), 0.0)  # de frente para o escudo
	await _frames(3)
	var blocked := [0]
	v.blocked_hit.connect(func(_a: Node3D) -> void: blocked[0] += 1)
	var hp := v.health.current
	main.combat.request_attack()
	await _finish_attack(main)
	check(v.health.current == hp, "golpe frontal não causa dano")
	check(blocked[0] == 1, "escudo bloqueia 1 vez e avisa (feedback de bloqueio)")
	main.queue_free()
	await process_frame
	return true


func test_guard_parry_and_block() -> bool:
	var main := await _load_main(true)
	var v := _freeze_vigia(main, Vector3(0, 0.05, -34))
	v.state = Vigia.State.WINDUP
	_place(main.player, Vector3(0, 0.05, -32.2), 0.0)
	await _frames(2)
	var pulse: Pulse = main.player.get_node("Pulse")
	var health: Health = main.player.get_node("Health")
	var sweep: AttackData = load("res://game/data/combat/vigia_sweep.tres")
	var p0 := pulse.current
	main.combat.request_guard(true)
	var applied := health.apply_damage(DamageEvent.make(v, main.player, sweep, DamageEvent.new_instance_id()))
	check(applied == 0.0, "aparo no início da guarda: 0 de dano")
	check(is_equal_approx(pulse.current, p0 + 20.0), "aparo rende 20 de Pulso")
	check(v.state == Vigia.State.STAGGER, "aparo atordoa o Vigia")
	main.combat.step(0.5)  # guarda levantada há muito tempo: fora da janela de aparo
	applied = health.apply_damage(DamageEvent.make(v, main.player, sweep, DamageEvent.new_instance_id()))
	check(is_equal_approx(applied, 5.0), "guarda frontal reduz 20 → 5 (%.1f)" % applied)
	main.combat.request_guard(false)
	var inst := DamageEvent.new_instance_id()
	applied = health.apply_damage(DamageEvent.make(v, main.player, sweep, inst))
	check(is_equal_approx(applied, 20.0), "sem guarda: dano cheio")
	check(health.apply_damage(DamageEvent.make(v, main.player, sweep, inst)) == 0.0, "mesmo golpe não acerta duas vezes")
	check(main.combat.state == PlayerCombat.State.STAGGER, "ser atingido interrompe por um instante (sem softlock)")
	main.combat.step(0.3)
	check(main.combat.state == PlayerCombat.State.IDLE, "volta ao controle depois da reação (COM-03)")
	main.queue_free()
	await process_frame
	return true


func test_dodge_iframes_and_walls() -> bool:
	var main := await _load_main(true)
	var v := _freeze_vigia(main, Vector3(0, 0.05, -34))
	_place(main.player, Vector3(6.8, 0.05, -34), -90.0)  # perto da parede direita (x=8), olhando para ela
	await _frames(3)
	var health: Health = main.player.get_node("Health")
	check(main.combat.request_dodge(Vector2(0, -1)), "esquiva para frente (rumo à parede)")
	var sweep: AttackData = load("res://game/data/combat/vigia_sweep.tres")
	check(health.apply_damage(DamageEvent.make(v, main.player, sweep, DamageEvent.new_instance_id())) == 0.0,
		"invulnerável durante a esquiva")
	await _frames(40)
	check(main.player.global_position.x < 7.8, "esquiva não atravessa a parede (COM-02): x=%.2f" % main.player.global_position.x)
	check(main.combat.state == PlayerCombat.State.IDLE, "esquiva termina e devolve o controle")
	main.queue_free()
	await process_frame
	return true


func test_vigia_telegraphs_then_hits() -> bool:
	var main := await _load_main(true)
	var v := main.vigia
	var health: Health = main.player.get_node("Health")
	var states: Array[int] = []
	v.state_changed.connect(func(s: Vigia.State) -> void: states.append(s))
	_place(main.player, Vector3(0, 0.05, -32.5), 0.0)  # parado na frente do Vigia
	await _frames(150)
	var w := states.find(Vigia.State.WINDUP)
	var a := states.find(Vigia.State.ACTIVE)
	check(w >= 0 and a > w, "anuncia (windup) antes de golpear: %s" % [states])
	check(health.current < health.max_health, "golpe acerta jogador parado (%.0f)" % health.current)
	check(is_equal_approx(health.max_health - health.current, 20.0) or is_equal_approx(health.max_health - health.current, 45.0),
		"dano 1× por golpe: 20 (varrido) ou 20+25 (%.0f)" % (health.max_health - health.current))
	main.queue_free()
	await process_frame
	return true


func test_vigia_beatable_without_parry() -> bool:
	var main := await _load_main(true)
	var v := _freeze_vigia(main, Vector3(0, 0.05, -34))
	_place(main.player, Vector3(0.6, 0.05, -35.5), 160.0)  # pelas costas/flanco
	await _frames(3)
	var swings := 0
	while not v.health.is_dead and swings < 10:
		main.combat.request_attack()
		await _finish_attack(main)
		swings += 1
	check(v.health.is_dead, "Vigia cai só com golpes pelas costas, sem aparo (%d golpes)" % swings)
	check(swings == 5, "60 de vida / 12 por golpe = 5 golpes")
	check(game_state.has_flag(&"ch1.proto.vigia_comum_defeated"), "derrota grava flag")
	check(v.collision_layer == 0, "corpo deixa de bloquear passagem")
	main.queue_free()
	await process_frame
	return true


func test_intervention_rules() -> bool:
	var main := await _load_main(true)
	var v := _freeze_vigia(main, Vector3(0, 0.05, -34))
	var res: PlayerResonance = main.player.get_node("PlayerResonance")
	var pulse: Pulse = main.player.get_node("Pulse")
	_place(main.player, Vector3(0, 0.05, -31), 0.0)  # 3 m à frente, mirando o Vigia
	main.player.head.rotation.x = deg_to_rad(-8)
	await _frames(3)
	check(is_equal_approx(pulse.current, 40.0), "Pulso inicial 40")
	check(not res.try_intervene() and is_equal_approx(pulse.current, 40.0), "sem Leitura, fissura oculta: nada é gasto")
	res.try_read()
	check(v.weak_point.is_revealed, "Leitura revela a fissura do escudo")
	check(res.try_intervene(), "Intervenção na fissura revelada funciona")
	check(is_equal_approx(pulse.current, 10.0), "custa 30 de Pulso uma vez (%.0f)" % pulse.current)
	check(v.state == Vigia.State.STAGGER and v.exposed, "Vigia atordoado e exposto")
	check(not res.try_intervene() and is_equal_approx(pulse.current, 10.0), "cooldown: segunda tentativa não gasta")
	res._process(5.0)
	v.weak_point.reveal(game_state)
	check(not res.try_intervene() and is_equal_approx(pulse.current, 10.0), "Pulso insuficiente: recusa sem gastar")
	# alvo errado: mirando a parede
	pulse.gain(60.0)
	main.player.rotation.y = deg_to_rad(90)
	await _frames(2)
	check(not res.try_intervene() and is_equal_approx(pulse.current, 70.0), "mira na parede: nada acontece (RES-03)")
	main.queue_free()
	await process_frame
	return true


func test_death_respawn_keeps_progress() -> bool:
	var main := await _load_main(true)
	_place(main.player, Vector3(0, 0.05, -23.5), 0.0)  # entra no checkpoint
	await _frames(5)
	game_state.set_flag(&"ch1.echo.hospital_glimpse_seen", true)
	var health: Health = main.player.get_node("Health")
	var huge := AttackData.new()
	huge.damage = 999.0
	health.apply_damage(DamageEvent.make(main.vigia, main.player, huge, DamageEvent.new_instance_id()))
	check(main.combat.state == PlayerCombat.State.DEAD and not main.player.input_enabled, "morte trava o controle")
	main.vigia.health.current = 10.0
	await create_timer(2.6).timeout  # escurece, retorna, clareia
	check(main.player.global_position.distance_to(Vector3(0, 0.05, -23.5)) < 0.3, "volta ao ponto de retorno da galeria")
	check(health.current == health.max_health and main.player.input_enabled, "vida cheia e controle de volta")
	check(game_state.has_flag(&"ch1.echo.hospital_glimpse_seen"), "memórias/flags preservadas após morrer")
	check(main.vigia.health.current == main.vigia.health.max_health, "Vigia não derrotado volta inteiro")
	main.queue_free()
	await process_frame
	return true


func test_hit_stop_restores_time() -> bool:
	var main := await _load_main(true)
	main.player.settings.hitstop_enabled = true
	main._hit_stop(0.08)
	await create_timer(0.03, true, false, true).timeout
	main._hit_stop(0.05)  # sobreposto
	check(Engine.time_scale < 1.0, "hit-stop desacelera o tempo")
	await create_timer(0.2, true, false, true).timeout
	check(is_equal_approx(Engine.time_scale, 1.0), "tempo volta a 1.0 depois de hit-stops sobrepostos")
	main.player.settings.hitstop_enabled = false
	Engine.time_scale = 1.0
	main.queue_free()
	await process_frame
	return true


# --- Eco narrativo e Diário (LIM-040, NAR-01) ------------------------------------

## Os textos do Eco não podem afirmar lore aberto (acidente, relações, motivo da ausência) nem soar como cobrança.
func test_eco_texts_respect_canon() -> bool:
	var entry: EcoEntry = load("res://game/data/narrative/ch1_assento_guardado.tres")
	var keys: Array[String] = []
	keys.append_array(entry.observation_keys)
	keys.append_array(entry.hypothesis_keys)
	keys.append_array(entry.transcript_keys)
	keys.append_array([entry.title_key, "ch1.eco.foto.texto", "ch1.eco.assento.voz"])
	var forbidden := ["acidente", "carro", "hospital", "coma", "morte", "morre", "morto", "mãe", "pai", "irmã",
		"irmão", "esposa", "marido", "filho", "filha", "namorad", "avó", "avô", "prometeu", "devia", "culpa",
		"atrasad", "abandon"]
	var hits: Array[String] = []
	for k in keys:
		var t := TranslationServer.translate(k).to_lower()
		check(t != k.to_lower(), "chave %s tem texto" % k)
		for w in forbidden:
			if t.contains(w):
				hits.append("%s → %s" % [k, w])
	check(hits.is_empty(), "nenhuma palavra proibida nos textos do Eco %s" % [hits])
	return true


func test_eco_photo_examine_and_hint() -> bool:
	var main := await _load_main()
	var interaction: PlayerInteraction = main.player.get_node("PlayerInteraction")
	_place(main.player, Vector3(2.4, 0.05, -4.6), 0.0)  # de frente para o pedestal
	main.player.head.rotation.x = deg_to_rad(-25)
	await _frames(5)
	check(interaction.current_target != null and interaction.current_target.name == "Photo_Pedestal",
		"mira no pedestal foca o porta-retratos")
	check(main.hud.current_prompt().contains("Examinar a foto"), "prompt: '%s'" % main.hud.current_prompt())
	check(interaction.try_interact(), "examinar a foto")
	check(main.hud.current_message() == "Uma foto de uma mesa cheia. Só uma cadeira está vazia.",
		"texto da foto no Véu: '%s'" % main.hud.current_message())
	check(main.hud.current_hint().contains("Ressonância"), "examinar sem nunca ter lido sugere a Ressonância")
	main.queue_free()
	await process_frame
	return true


func test_eco_reveal_sequence_and_journal() -> bool:
	var main := await _load_main()
	var res: PlayerResonance = main.player.get_node("PlayerResonance")
	var target: ResonanceTarget = main.world.get_node("Resonance/Res_MesaGuardada")
	var seq: EcoSequence = main.world.get_node("Resonance/Seq_AssentoGuardado")
	var mesa: Node3D = main.world.get_node("EcoLayers/Eco_Mesa")
	var captions: Array[String] = []
	var found := [0]
	seq.caption.connect(func(t: String) -> void: captions.append(t))
	seq.discovered.connect(func(_e: EcoEntry) -> void: found[0] += 1)
	check(not mesa.visible, "mesa do Eco escondida no Véu")
	check(main.world.get_node("EcoLayers/Eco_Mesa/Cadeira_4") != null and \
		not main.world.has_node("EcoLayers/Eco_Mesa/Presenca_4"), "a cadeira da cabeceira não tem presença")
	_place(main.player, Vector3(2.4, 0.05, -4.6), -60.0)
	await _frames(3)
	res.try_read()
	check(target.is_revealed and mesa.visible, "Leitura revela a mesa")
	await create_timer(3.8).timeout
	check(captions.size() == 2, "duas legendas (%d)" % captions.size())
	if captions.size() == 2:
		check(captions[0] == "[risos abafados ao redor de uma mesa]", "1ª legenda: riso")
		check(captions[1] == "Voz: «Guardei seu lugar.»", "2ª legenda: a voz")
	check(found[0] == 1 and game_state.has_memory(&"ch1.echo.assento_guardado"), "Eco entra no Diário")
	check(game_state.has_flag(&"ch1.echo.assento_guardado"), "flag do Eco gravada")
	check(main.hud.current_hint().contains("Diário"), "aviso de novo registro: '%s'" % main.hud.current_hint())
	# rever a cena: toca de novo, mas não registra outra vez
	res._process(10.0)
	res._process(10.0)
	target._process(10.0)
	res.try_read()
	await create_timer(3.8).timeout
	check(seq.plays == 2 and found[0] == 1 and game_state.journal().size() == 1,
		"rever o Eco não duplica registro nem evento (NAR-01)")
	main.queue_free()
	await process_frame
	return true


func test_journal_shows_entry() -> bool:
	var main := await _load_main()
	main.journal.open()
	check(main.journal.is_open() and paused, "Diário abre e pausa")
	check(main.journal.current_text().contains("Nada registrado"), "Diário vazio avisa")
	main.journal.close()
	game_state.discover_memory(load("res://game/data/narrative/ch1_assento_guardado.tres"))
	main.journal.open()
	var t := main.journal.current_text()
	check(main.journal.entry_count() == 1, "1 registro listado")
	check(t.contains("Observações") and t.contains("Alguém guardou um lugar para mim."), "seção de observações")
	check(t.contains("Hipóteses") and t.contains("Alguém esperava por mim?"), "seção de hipóteses, separada")
	check(t.contains("Guardei seu lugar."), "transcrição da voz revisável")
	check(t.contains("Átrio"), "área simbólica em vez de data")
	main.journal.close()
	check(not paused and main.player.input_enabled, "fechar devolve o jogo")
	main.queue_free()
	await process_frame
	return true

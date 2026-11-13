## Captura poses de combate para inspeção (precisa de janela).
## godot --path . --script res://tests/visual/capture_combat.gd -- --no-mouse-capture  → out/godot/combat/*.png
extends SceneTree


func _initialize() -> void:
	var out_dir := ProjectSettings.globalize_path("res://out/godot/combat")
	DirAccess.make_dir_recursive_absolute(out_dir)
	var main: Main = (load("res://game/main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	for i in 10:
		await process_frame
	main.player.settings.hitstop_enabled = false
	var p := main.player
	var v := main.vigia
	v.set_physics_process(false)
	v.global_position = Vector3(0, 0.05, -34.5)
	v.rotation = Vector3(0, PI, 0)
	p.global_position = Vector3(0.4, 0.05, -30.6)
	p.rotation = Vector3(0, deg_to_rad(5), 0)
	p.head.rotation = Vector3(deg_to_rad(-6), 0, 0)
	await _settle(40)
	await _shot(out_dir, "01_vigia_repouso")

	v._attack_index = 0
	v._start_attack()  # varrido
	await create_timer(0.6).timeout
	await _shot(out_dir, "02_anuncio_varrido")
	v._rest_pose()
	v.state = Vigia.State.IDLE
	await _settle(30)

	v._attack_index = 1
	v._start_attack()  # avanço
	await create_timer(0.75).timeout
	await _shot(out_dir, "03_anuncio_avanco")
	v._rest_pose()
	v.state = Vigia.State.IDLE
	await _settle(30)

	var res: PlayerResonance = p.get_node("PlayerResonance")
	res.try_read()
	await create_timer(0.8).timeout
	await _shot(out_dir, "04_fissura_revelada")
	v.on_intervened(p)
	await create_timer(0.4).timeout
	await _shot(out_dir, "05_intervencao_atordoado")

	main.combat.request_guard(true)
	await create_timer(0.3).timeout
	await _shot(out_dir, "06_guarda")
	quit(0)


func _settle(n: int) -> void:
	for i in n:
		await process_frame


func _shot(dir: String, name: String) -> void:
	await RenderingServer.frame_post_draw
	var img := root.get_viewport().get_texture().get_image()
	img.save_png("%s/%s.png" % [dir, name])
	print("[capture] %s" % name)

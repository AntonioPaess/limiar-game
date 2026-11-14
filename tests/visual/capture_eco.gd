## Captura o Eco "A cadeira guardada" e o Diário (precisa de janela).
## godot --path . --script res://tests/visual/capture_eco.gd -- --no-mouse-capture  → out/godot/eco/*.png
extends SceneTree


func _initialize() -> void:
	var out_dir := ProjectSettings.globalize_path("res://out/godot/eco")
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.get_node("GameState").set_flag(&"ch1.proto.vigia_comum_defeated", true)
	var main: Main = (load("res://game/main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	for i in 10:
		await process_frame
	var p := main.player
	p.global_position = Vector3(2.35, 0.05, -5.15)
	p.rotation = Vector3.ZERO
	p.head.rotation = Vector3(deg_to_rad(-38), 0, 0)
	await _settle(30)
	await _shot(out_dir, "01_porta_retrato_veu")

	p.global_position = Vector3(1.6, 0.05, -3.2)
	p.rotation = Vector3(0, deg_to_rad(-38), 0)
	p.head.rotation = Vector3(deg_to_rad(-10), 0, 0)
	await _settle(20)
	await _shot(out_dir, "02_atrio_veu")
	var res: PlayerResonance = p.get_node("PlayerResonance")
	res.try_read()
	await create_timer(1.0).timeout
	await _shot(out_dir, "03_mesa_eco_riso")
	await create_timer(1.9).timeout
	await _shot(out_dir, "04_mesa_eco_voz")
	await create_timer(1.2).timeout
	main.journal.open()
	await _settle(5)
	await _shot(out_dir, "05_diario")
	quit(0)


func _settle(n: int) -> void:
	for i in n:
		await process_frame


func _shot(dir: String, name: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_viewport().get_texture().get_image().save_png("%s/%s.png" % [dir, name])
	print("[capture] %s" % name)

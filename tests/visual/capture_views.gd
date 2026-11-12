## Captura vistas fixas do protótipo para inspeção visual (precisa de janela; não roda em --headless).
## godot --path . --script res://tests/visual/capture_views.gd -- --no-mouse-capture
## Saída: out/godot/views/<nome>.png
extends SceneTree

const VIEWS := [
	# nome, posição, yaw (graus), pitch (graus)
	["01_spawn", Vector3(0, 0.05, -2), 0.0, 0.0],
	["02_corredor_eco", Vector3(-0.6, 0.05, -14.5), -25.0, 0.0],
	["03_sala_combate", Vector3(0, 0.05, -27.5), 0.0, -4.0],
	["04_porta_saida", Vector3(1.2, 0.05, -36.0), 8.0, 2.0],
]


func _initialize() -> void:
	var out_dir := ProjectSettings.globalize_path("res://out/godot/views")
	DirAccess.make_dir_recursive_absolute(out_dir)
	var main: Main = (load("res://game/main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	for i in 10:
		await process_frame
	for v: Array in VIEWS:
		var p := main.player
		p.global_position = v[1]
		p.rotation = Vector3(0, deg_to_rad(v[2]), 0)
		p.head.rotation = Vector3(deg_to_rad(v[3]), 0, 0)
		p.velocity = Vector3.ZERO
		for i in 8:
			await process_frame
		await RenderingServer.frame_post_draw
		var img := root.get_viewport().get_texture().get_image()
		var path := "%s/%s.png" % [out_dir, v[0]]
		img.save_png(path)
		print("[capture] %s %dx%d" % [path, img.get_width(), img.get_height()])
	quit(0)

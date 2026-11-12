## Teste smoke headless do ambiente (não testa gameplay).
## Rodar: godot --headless --path . --script res://tests/smoke_headless.gd
## Sai com código 0 se a engine executa, a versão é 4.7.x e o plugin MCP está presente.
extends SceneTree


func _initialize() -> void:
	var failures: Array[String] = []
	var v := Engine.get_version_info()
	print("[smoke] Godot %s" % v.string)
	if v.major != 4 or v.minor != 7:
		failures.append("versão esperada 4.7.x, obtida %s" % v.string)
	if not FileAccess.file_exists("res://addons/godot_mcp_toolkit/plugin.cfg"):
		failures.append("addon godot_mcp_toolkit ausente")
	if ProjectSettings.get_setting("application/config/name") != "LIMIAR":
		failures.append("project.godot não carregado")
	# Uma cena 3D mínima instanciada em memória (nada é gravado em disco).
	var root3d := Node3D.new()
	var cam := Camera3D.new()
	root3d.add_child(cam)
	# A raiz ainda está montando os autoloads em _initialize: adiar e esperar um frame.
	get_root().add_child.call_deferred(root3d)
	await process_frame
	if not cam.is_inside_tree():
		failures.append("Camera3D não entrou na árvore")
	root3d.queue_free()
	if failures.is_empty():
		print("[smoke] OK")
		quit(0)
	else:
		for f in failures:
			push_error("[smoke] FALHA: " + f)
		quit(1)

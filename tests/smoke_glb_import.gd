## Verifica o pipeline Blender -> GLB -> Godot (rodar após tools/blender/smoke_export_column.py e --import).
## godot --headless --path . --script res://tests/smoke_glb_import.gd
extends SceneTree

const GLB := "res://out/blender/ENV_CATH_Column_Smoke.glb"


func _initialize() -> void:
	if not ResourceLoader.exists(GLB):
		push_error("[glb] FALHA: %s não importado (rode o export do Blender e --import)" % GLB)
		quit(1)
		return
	var scene := load(GLB) as PackedScene
	var inst := scene.instantiate()
	var meshes := inst.find_children("*", "MeshInstance3D", true, false)
	var ok := meshes.size() == 1
	var aabb := AABB()
	if ok:
		aabb = (meshes[0] as MeshInstance3D).get_aabb()
		# altura ~6 m, base no chão (pivô na base)
		ok = absf(aabb.size.y - 6.0) < 0.05 and absf(aabb.position.y) < 0.05
	print("[glb] meshes=%d aabb=%s" % [meshes.size(), aabb])
	inst.free()
	if ok:
		print("[glb] OK")
		quit(0)
	else:
		push_error("[glb] FALHA: geometria inesperada")
		quit(1)

"""LIMIAR — smoke test headless do pipeline Blender -> glTF (Art Bible §10).

Gera uma coluna low-poly placeholder (8 lados, em metros, pivô na base) e exporta GLB.
Não é asset final. Rodar:
    blender --background --factory-startup --python tools/blender/smoke_export_column.py -- out/blender/ENV_CATH_Column_Smoke.glb
"""
import sys
import bpy

out = sys.argv[sys.argv.index("--") + 1] if "--" in sys.argv else "out/blender/ENV_CATH_Column_Smoke.glb"

bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.ops.mesh.primitive_cylinder_add(vertices=8, radius=0.35, depth=6.0, location=(0, 0, 3.0))
col = bpy.context.active_object
col.name = "ENV_CATH_Column_Smoke"
# pivô na base: aplicar deslocamento à malha
bpy.context.scene.cursor.location = (0, 0, 0)
bpy.ops.object.origin_set(type="ORIGIN_CURSOR")

mat = bpy.data.materials.new("MAT_Pedra_Fria")
mat.diffuse_color = (0.188, 0.204, 0.278, 1.0)  # #303447
col.data.materials.append(mat)

tris = sum(len(p.vertices) - 2 for p in col.data.polygons)
bpy.ops.export_scene.gltf(filepath=out, export_format="GLB", use_selection=False)
print(f"[blender-smoke] OK {out} tris={tris}")

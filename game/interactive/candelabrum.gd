## Candelabro de dois estados (acesa/apagada) para o puzzle do protótipo. Forma muda junto com a luz: a chama
## aparece/some (não depende só de cor).
class_name Candelabrum
extends Node3D

signal toggled(lit: bool)

@export var lit := false:
	set(v):
		lit = v
		if is_node_ready():
			_apply()

@onready var _interactable: Interactable = $Interactable
@onready var _flame: Node3D = $Flame
@onready var _light: OmniLight3D = $Flame/Light


func _ready() -> void:
	_interactable.once = false
	_interactable.used.connect(func(_a: Node) -> void: set_lit(not lit))
	_apply()


func set_lit(v: bool) -> void:
	if v == lit:
		return
	lit = v
	var sfx := get_node_or_null(^"Sfx") as AudioStreamPlayer3D
	if sfx:
		sfx.stream = ProceduralSfx.get_stream(&"candle_toggle")
		sfx.play()
	toggled.emit(lit)


func _apply() -> void:
	_flame.visible = lit
	_light.visible = lit
	_interactable.prompt_key = "ch1.proto.candle.snuff" if lit else "ch1.proto.candle.light"

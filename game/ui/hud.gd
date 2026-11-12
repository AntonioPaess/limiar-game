## HUD mínimo (06 §4): retículo discreto que muda quando há algo interagível, prompt e mensagens curtas.
## Renderiza em resolução nativa, independente de qualquer pixelização futura do mundo.
class_name Hud
extends CanvasLayer

const MESSAGE_SECONDS := 3.5

var _crosshair: ColorRect
var _prompt: Label
var _message: Label
var _message_timer := 0.0


func _ready() -> void:
	layer = 10
	var root := Control.new()
	root.name = "Root"
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)

	_crosshair = ColorRect.new()
	_crosshair.name = "Crosshair"
	_crosshair.color = Color(1, 1, 1, 0.55)
	_crosshair.size = Vector2(4, 4)
	_crosshair.set_anchors_preset(Control.PRESET_CENTER)
	_crosshair.position = -_crosshair.size / 2.0
	_crosshair.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(_crosshair)

	_prompt = _label("Prompt", 20)
	_prompt.set_anchors_preset(Control.PRESET_CENTER)
	_prompt.position = Vector2(-300, 28)
	_prompt.size = Vector2(600, 30)
	root.add_child(_prompt)

	_message = _label("Message", 22)
	_message.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_message.position = Vector2(-450, -120)
	_message.size = Vector2(900, 60)
	_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(_message)
	set_prompt("")


func _label(n: String, font_size: int) -> Label:
	var l := Label.new()
	l.name = n
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_font_size_override("font_size", font_size)
	l.add_theme_color_override("font_color", Color("#e8e2d2"))
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	l.add_theme_constant_override("outline_size", 6)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l


## Texto vazio esconde o prompt. A tecla mostrada vem do mapa de input (remapeável).
func set_prompt(verb: String) -> void:
	if verb == "":
		_prompt.text = ""
		_crosshair.color = Color(1, 1, 1, 0.55)
		_crosshair.scale = Vector2.ONE
		return
	_prompt.text = tr("ui.prompt.format") % [_key_for("interact"), verb]
	_crosshair.color = Color("#D5B879")  # dourado: presença/afeto; forma muda junto (não só cor)
	_crosshair.scale = Vector2(1.75, 1.75)


func show_message(text: String) -> void:
	if text == "":
		return
	_message.text = text
	_message.modulate.a = 1.0
	_message_timer = MESSAGE_SECONDS


func current_prompt() -> String:
	return _prompt.text


func current_message() -> String:
	return _message.text if _message_timer > 0.0 else ""


func _process(delta: float) -> void:
	if _message_timer > 0.0:
		_message_timer -= delta
		_message.modulate.a = clampf(_message_timer / 0.6, 0.0, 1.0)
		if _message_timer <= 0.0:
			_message.text = ""


static func _key_for(action: StringName) -> String:
	for ev in InputMap.action_get_events(action):
		if ev is InputEventKey:
			return OS.get_keycode_string(DisplayServer.keyboard_get_keycode_from_physical(ev.physical_keycode))
	return "?"

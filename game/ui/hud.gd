## HUD mínimo (06 §4): retículo discreto que muda quando há algo interagível, prompt e mensagens curtas.
## Renderiza em resolução nativa, independente de qualquer pixelização futura do mundo.
class_name Hud
extends CanvasLayer

const MESSAGE_SECONDS := 3.5

var _crosshair: ColorRect
var _prompt: Label
var _message: Label
var _message_timer := 0.0
var _res_bar: ProgressBar
var _res_label: Label
var _veil: ColorRect
var _veil_tween: Tween
var _hint: Label


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

	# véu de tela da Ressonância: muito sutil, sem flash, intensidade ajustável (06 §5)
	_veil = ColorRect.new()
	_veil.name = "ResonanceVeil"
	_veil.color = Color("#69465A")
	_veil.modulate.a = 0.0
	_veil.set_anchors_preset(Control.PRESET_FULL_RECT)
	_veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(_veil)
	root.move_child(_veil, 0)

	# indicador: texto + barra (estado legível sem depender de cor)
	var res := VBoxContainer.new()
	res.name = "Resonance"
	res.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	res.position = Vector2(24, -70)
	res.custom_minimum_size = Vector2(180, 0)
	res.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(res)
	_res_label = _label("ResonanceLabel", 15)
	_res_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	res.add_child(_res_label)
	_res_bar = ProgressBar.new()
	_res_bar.custom_minimum_size = Vector2(180, 6)
	_res_bar.show_percentage = false
	_res_bar.max_value = 1.0
	_res_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var fill := StyleBoxFlat.new()
	fill.bg_color = Color("#9a6cff")
	_res_bar.add_theme_stylebox_override("fill", fill)
	res.add_child(_res_bar)

	_hint = _label("Hint", 18)
	_hint.set_anchors_preset(Control.PRESET_CENTER)
	_hint.position = Vector2(-300, 60)
	_hint.size = Vector2(600, 30)
	_hint.modulate = Color(1, 1, 1, 0.85)
	root.add_child(_hint)
	set_prompt("")
	set_resonance_state(0, 1.0)


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


## state: 0 pronta, 1 ativa, 2 recarregando (PlayerResonance.State). progress 0..1.
func set_resonance_state(state: int, progress: float) -> void:
	_res_bar.value = progress
	match state:
		0:
			_res_label.text = "%s · %s" % [tr("ui.resonance.ready"), _key_for("resonance")]
			_res_bar.modulate.a = 0.5
		1:
			_res_label.text = "%s ◆" % tr("ui.resonance.ready")
			_res_bar.modulate.a = 1.0
		2:
			_res_label.text = "%s …" % tr("ui.resonance.ready")
			_res_bar.modulate.a = 0.35


## Liga/desliga o véu de tela. `intensity` 0 desliga (opção de acessibilidade).
func set_resonance_veil(on: bool, intensity: float) -> void:
	if _veil_tween:
		_veil_tween.kill()
	_veil_tween = create_tween()
	var target := 0.14 * intensity if on else 0.0
	_veil_tween.tween_property(_veil, "modulate:a", target, 0.6)


func set_hint(text: String) -> void:
	_hint.text = text


func current_hint() -> String:
	return _hint.text


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
			if DisplayServer.get_name() == "headless":  # sem layout de teclado em headless: nome da tecla física
				return OS.get_keycode_string(ev.physical_keycode)
			return OS.get_keycode_string(DisplayServer.keyboard_get_keycode_from_physical(ev.physical_keycode))
	return "?"

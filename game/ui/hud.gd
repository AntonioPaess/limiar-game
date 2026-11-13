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
var _health_bar: ProgressBar
var _pulse_bar: ProgressBar
var _damage_edge: ColorRect
var _fade: ColorRect


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

	# vida e Pulso: compactos (06 §4), com rótulo de texto
	var stats := VBoxContainer.new()
	stats.name = "Stats"
	stats.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	stats.position = Vector2(24, -150)
	stats.custom_minimum_size = Vector2(180, 0)
	stats.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(stats)
	_health_bar = _bar(stats, tr("ui.hud.health"), Color("#9E393E"))
	_pulse_bar = _bar(stats, tr("ui.hud.pulse"), Color("#69465A").lightened(0.35))

	_damage_edge = ColorRect.new()
	_damage_edge.name = "DamageEdge"
	_damage_edge.color = Color("#4a0f14")
	_damage_edge.modulate.a = 0.0
	_damage_edge.set_anchors_preset(Control.PRESET_FULL_RECT)
	_damage_edge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(_damage_edge)
	root.move_child(_damage_edge, 1)

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
	_fade = ColorRect.new()
	_fade.name = "Fade"
	_fade.color = Color.BLACK
	_fade.modulate.a = 0.0
	_fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(_fade)
	set_prompt("")
	set_resonance_state(0, 1.0)


func _bar(parent: Control, label_text: String, color: Color) -> ProgressBar:
	var l := _label("Label", 13)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	l.text = label_text
	parent.add_child(l)
	var b := ProgressBar.new()
	b.custom_minimum_size = Vector2(180, 8)
	b.show_percentage = false
	b.max_value = 1.0
	b.value = 1.0
	b.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var fill := StyleBoxFlat.new()
	fill.bg_color = color
	b.add_theme_stylebox_override("fill", fill)
	parent.add_child(b)
	return b


func set_health(ratio: float) -> void:
	_health_bar.value = ratio


func set_pulse(ratio: float) -> void:
	_pulse_bar.value = ratio


func health_value() -> float:
	return _health_bar.value


## Borda escura avermelhada ao sofrer dano: escura e curta (sem flash de luminância, 06 §5).
func flash_damage(strength: float) -> void:
	var tw := create_tween()
	_damage_edge.modulate.a = clampf(0.12 + strength * 0.25, 0.0, 0.35)
	tw.tween_property(_damage_edge, "modulate:a", 0.0, 0.5)


## Escurece/clareia a tela (morte e retorno). Retorna o tween para quem quiser esperar.
func fade_to(alpha: float, sec: float) -> Tween:
	var tw := create_tween()
	tw.tween_property(_fade, "modulate:a", alpha, sec)
	return tw


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

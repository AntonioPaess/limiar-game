## Menu de pausa com opções de conforto desde o protótipo (06 §5): FOV, sensibilidades, inverter Y, head bob.
## Pausa a árvore e libera o cursor; ao voltar, recaptura. Edita o PlayerSettings compartilhado.
class_name PauseMenu
extends CanvasLayer

signal resumed
signal paused

var settings: PlayerSettings

var _panel: PanelContainer
var _first_focus: Control


func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build()
	visible = false


func is_open() -> bool:
	return visible


func toggle() -> void:
	if visible:
		close()
	else:
		open()


func open() -> void:
	visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if _first_focus:
		_first_focus.grab_focus()
	paused.emit()


func close() -> void:
	visible = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	resumed.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not event.is_echo():
		toggle()
		get_viewport().set_input_as_handled()


func _build() -> void:
	var dim := ColorRect.new()
	dim.color = Color(0.04, 0.05, 0.08, 0.72)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	_panel = PanelContainer.new()
	_panel.custom_minimum_size = Vector2(460, 0)
	center.add_child(_panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	_panel.add_child(box)

	var title := Label.new()
	title.text = tr("ui.pause.title")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 28)
	box.add_child(title)

	var resume := Button.new()
	resume.text = tr("ui.pause.resume")
	resume.pressed.connect(close)
	box.add_child(resume)
	_first_focus = resume

	box.add_child(_slider_row("ui.pause.fov", PlayerSettings.FOV_MIN, PlayerSettings.FOV_MAX, 1.0,
		func() -> float: return settings.fov_horizontal,
		func(v: float) -> void: settings.fov_horizontal = v))
	box.add_child(_slider_row("ui.pause.mouse_sensitivity", 0.0005, 0.01, 0.0001,
		func() -> float: return settings.mouse_sensitivity,
		func(v: float) -> void: settings.mouse_sensitivity = v))
	box.add_child(_slider_row("ui.pause.stick_sensitivity", 0.5, 6.0, 0.1,
		func() -> float: return settings.stick_sensitivity,
		func(v: float) -> void: settings.stick_sensitivity = v))
	box.add_child(_check("ui.pause.invert_y",
		func() -> bool: return settings.invert_y,
		func(v: bool) -> void: settings.invert_y = v))
	box.add_child(_slider_row("ui.pause.resonance_intensity", 0.0, 1.0, 0.05,
		func() -> float: return settings.resonance_effect_intensity,
		func(v: float) -> void: settings.resonance_effect_intensity = v))
	box.add_child(_check("ui.pause.hitstop",
		func() -> bool: return settings.hitstop_enabled,
		func(v: bool) -> void: settings.hitstop_enabled = v))
	box.add_child(_check("ui.pause.head_bob",
		func() -> bool: return settings.head_bob_enabled,
		func(v: bool) -> void: settings.head_bob_enabled = v))

	var quit_btn := Button.new()
	quit_btn.text = tr("ui.pause.quit")
	quit_btn.pressed.connect(func() -> void: get_tree().quit())
	box.add_child(quit_btn)

	var hint := Label.new()
	hint.text = tr("ui.pause.hint")
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.modulate = Color(1, 1, 1, 0.6)
	box.add_child(hint)


func _slider_row(key: String, min_v: float, max_v: float, step: float,
		getter: Callable, setter: Callable) -> Control:
	var row := VBoxContainer.new()
	var label := Label.new()
	row.add_child(label)
	var slider := HSlider.new()
	slider.min_value = min_v
	slider.max_value = max_v
	slider.step = step
	row.add_child(slider)
	var refresh := func() -> void:
		label.text = "%s: %s" % [tr(key), str(snappedf(getter.call(), step))]
	visibility_changed.connect(func() -> void:
		if visible and settings:
			slider.set_value_no_signal(getter.call())
			refresh.call())
	slider.value_changed.connect(func(v: float) -> void:
		setter.call(v)
		refresh.call())
	return row


func _check(key: String, getter: Callable, setter: Callable) -> Control:
	var cb := CheckBox.new()
	cb.text = tr(key)
	visibility_changed.connect(func() -> void:
		if visible and settings:
			cb.set_pressed_no_signal(getter.call()))
	cb.toggled.connect(func(v: bool) -> void: setter.call(v))
	return cb

## Diário de Ecos (06 §4): observações e hipóteses em seções distintas, área simbólica em vez de data, transcrição
## revisável (nenhuma informação crítica fica presa num áudio único). Abre com J / Tab / Back e pausa o jogo.
class_name Journal
extends CanvasLayer

signal opened
signal closed

var _list: ItemList
var _title: Label
var _body: RichTextLabel
var _entries: Array[EcoEntry] = []


func _ready() -> void:
	layer = 25
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build()
	visible = false


func is_open() -> bool:
	return visible


func open() -> void:
	if visible:
		return
	_refresh()
	visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	opened.emit()


func close() -> void:
	if not visible:
		return
	visible = false
	get_tree().paused = false
	if DisplayServer.get_name() != "headless" and not OS.get_cmdline_user_args().has("--no-mouse-capture"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	closed.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo():
		return
	if event.is_action_pressed("journal"):
		if visible:
			close()
		elif not get_tree().paused:  # não abre por cima da pausa
			open()
		get_viewport().set_input_as_handled()
	elif visible and event.is_action_pressed("pause"):
		close()
		get_viewport().set_input_as_handled()


## Texto mostrado para o registro selecionado (também usado pelos testes).
func current_text() -> String:
	return _body.get_parsed_text()


func entry_count() -> int:
	return _entries.size()


func select(index: int) -> void:
	if index < 0 or index >= _entries.size():
		return
	_list.select(index)
	_show(index)


func _refresh() -> void:
	var gs := get_node(^"/root/GameState")
	_entries = gs.journal()
	_list.clear()
	for e in _entries:
		_list.add_item(e.title())
	if _entries.is_empty():
		_title.text = tr("ui.journal.title")
		_body.text = tr("ui.journal.empty")
	else:
		select(_entries.size() - 1)  # o mais recente
		_list.grab_focus()


func _show(i: int) -> void:
	var e := _entries[i]
	_title.text = e.title()
	var t := ""
	if e.area_key != "":
		t += "[i]%s[/i]\n\n" % tr(e.area_key)
	t += "[b]%s[/b]\n" % tr("ui.journal.observations")
	for line in e.lines(e.observation_keys):
		t += "• %s\n" % line
	t += "\n[b]%s[/b]\n" % tr("ui.journal.hypotheses")
	for line in e.lines(e.hypothesis_keys):
		t += "? %s\n" % line
	if not e.transcript_keys.is_empty():
		t += "\n[b]%s[/b]\n" % tr("ui.journal.transcript")
		for line in e.lines(e.transcript_keys):
			t += "%s\n" % line
	_body.text = t


func _build() -> void:
	var dim := ColorRect.new()
	dim.color = Color(0.05, 0.05, 0.07, 0.86)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(dim)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(880, 580)
	var bg := StyleBoxFlat.new()  # opaco: nada do HUD transparece (legibilidade, 06 §5)
	bg.bg_color = Color("#141720")
	bg.border_color = Color("#3b3f52")
	bg.set_border_width_all(1)
	bg.set_content_margin_all(24)
	panel.add_theme_stylebox_override("panel", bg)
	center.add_child(panel)
	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 10)
	panel.add_child(root)

	var header := Label.new()
	header.text = tr("ui.journal.title")
	header.add_theme_font_size_override("font_size", 26)
	header.add_theme_color_override("font_color", Color("#D5B879"))
	root.add_child(header)

	var cols := HBoxContainer.new()
	cols.size_flags_vertical = Control.SIZE_EXPAND_FILL
	cols.add_theme_constant_override("separation", 16)
	root.add_child(cols)
	_list = ItemList.new()
	_list.custom_minimum_size = Vector2(240, 0)
	_list.item_selected.connect(_show)
	cols.add_child(_list)
	var right := VBoxContainer.new()
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cols.add_child(right)
	_title = Label.new()
	_title.add_theme_font_size_override("font_size", 22)
	right.add_child(_title)
	_body = RichTextLabel.new()
	_body.bbcode_enabled = true
	_body.fit_content = false
	_body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_body.add_theme_font_size_override("normal_font_size", 18)
	_body.add_theme_font_size_override("bold_font_size", 18)
	right.add_child(_body)

	var hint := Label.new()
	hint.text = tr("ui.journal.close") % Hud._key_for(&"journal")
	hint.modulate = Color(1, 1, 1, 0.6)
	root.add_child(hint)

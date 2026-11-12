## LIM-003 (parcial) — Overlay de debug (F3): FPS, posição, velocidade, chão, alvo de interação.
## Desligado por padrão e removido de builds de release.
class_name DebugOverlay
extends CanvasLayer

var player: FirstPersonPlayer
var interaction: PlayerInteraction

var _label: Label


func _ready() -> void:
	layer = 30
	process_mode = Node.PROCESS_MODE_ALWAYS
	if not OS.is_debug_build():
		queue_free()
		return
	_label = Label.new()
	_label.position = Vector2(12, 10)
	_label.add_theme_font_size_override("font_size", 14)
	_label.add_theme_color_override("font_outline_color", Color.BLACK)
	_label.add_theme_constant_override("outline_size", 4)
	add_child(_label)
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_overlay") and not event.is_echo():
		visible = not visible


func _process(_delta: float) -> void:
	if not visible or player == null:
		return
	var v := player.velocity
	var target: String = interaction.current_target.name if interaction and interaction.current_target else "-"
	_label.text = "FPS %d\npos %s\nvel %.2f m/s (y %.2f)\nno chão %s\nalvo %s\npausa %s" % [
		Engine.get_frames_per_second(), player.global_position.snappedf(0.01),
		Vector2(v.x, v.z).length(), v.y, player.is_on_floor(), target, get_tree().paused]

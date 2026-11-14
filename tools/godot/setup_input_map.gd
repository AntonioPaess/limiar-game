## LIM-002 — Gera o mapa de input do LIMIAR dentro do project.godot (fonte de verdade das ações).
## Rodar (caminho absoluto, pois tools/ é ignorado pelo Godot):
##   godot --headless --path . --script "$PWD/tools/godot/setup_input_map.gd"
## Esquema inicial do GDD §2. Pulo não aprovado; ataque pesado fica para depois do primeiro combate.
## Esquiva usa Espaço enquanto não houver pulo. Tudo será remapeável no produto.
extends SceneTree

const DEADZONE := 0.2

# action -> lista de eventos: ["key", KEY_*] | ["mouse", MOUSE_BUTTON_*] | ["joy_button", JOY_BUTTON_*] | ["joy_axis", JOY_AXIS_*, sinal]
const ACTIONS := {
	"move_forward": [["key", KEY_W], ["key", KEY_UP], ["joy_axis", JOY_AXIS_LEFT_Y, -1.0]],
	"move_back": [["key", KEY_S], ["key", KEY_DOWN], ["joy_axis", JOY_AXIS_LEFT_Y, 1.0]],
	"move_left": [["key", KEY_A], ["key", KEY_LEFT], ["joy_axis", JOY_AXIS_LEFT_X, -1.0]],
	"move_right": [["key", KEY_D], ["key", KEY_RIGHT], ["joy_axis", JOY_AXIS_LEFT_X, 1.0]],
	"look_up": [["joy_axis", JOY_AXIS_RIGHT_Y, -1.0]],
	"look_down": [["joy_axis", JOY_AXIS_RIGHT_Y, 1.0]],
	"look_left": [["joy_axis", JOY_AXIS_RIGHT_X, -1.0]],
	"look_right": [["joy_axis", JOY_AXIS_RIGHT_X, 1.0]],
	"sprint": [["key", KEY_SHIFT], ["joy_button", JOY_BUTTON_LEFT_STICK]],
	"interact": [["key", KEY_E], ["joy_button", JOY_BUTTON_X]],
	"attack_light": [["mouse", MOUSE_BUTTON_LEFT], ["joy_axis", JOY_AXIS_TRIGGER_RIGHT, 1.0]],
	"guard": [["mouse", MOUSE_BUTTON_RIGHT], ["joy_axis", JOY_AXIS_TRIGGER_LEFT, 1.0]],
	"dodge": [["key", KEY_SPACE], ["joy_button", JOY_BUTTON_B]],
	"resonance": [["key", KEY_R], ["joy_button", JOY_BUTTON_LEFT_SHOULDER]],
	"pause": [["key", KEY_ESCAPE], ["joy_button", JOY_BUTTON_START]],
	"journal": [["key", KEY_J], ["key", KEY_TAB], ["joy_button", JOY_BUTTON_BACK]],
	"debug_overlay": [["key", KEY_F3]],
}


func _initialize() -> void:
	for action: String in ACTIONS:
		var events: Array[InputEvent] = []
		for spec: Array in ACTIONS[action]:
			var ev := _make_event(spec)
			ev.device = -1  # todos os dispositivos (padrão do editor); sem isso o Godot fixa teclado/1º gamepad
			events.append(ev)
		ProjectSettings.set_setting("input/" + action, {"deadzone": DEADZONE, "events": events})
	var err := ProjectSettings.save()
	print("[input] %d ações gravadas em project.godot (erro=%d)" % [ACTIONS.size(), err])
	quit(0 if err == OK else 1)


func _make_event(spec: Array) -> InputEvent:
	match spec[0]:
		"key":
			var k := InputEventKey.new()
			k.physical_keycode = spec[1]  # layout-independente (WASD fica no lugar em AZERTY/ABNT)
			return k
		"mouse":
			var m := InputEventMouseButton.new()
			m.button_index = spec[1]
			return m
		"joy_button":
			var b := InputEventJoypadButton.new()
			b.button_index = spec[1]
			return b
		"joy_axis":
			var a := InputEventJoypadMotion.new()
			a.axis = spec[1]
			a.axis_value = spec[2]
			return a
	push_error("tipo de evento desconhecido: %s" % spec)
	return null

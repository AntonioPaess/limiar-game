## LIM-020 — Alvo de Ressonância: sobreposição LOCALIZADA Véu → Eco, sem duplicar mapa (GDD §5).
## Alterna só a visibilidade/transparência de nós escolhidos e a energia de luzes. NUNCA mexe em colisão: a Leitura
## não pode tirar piso ou parede de baixo/da frente do jogador (invariante 4 da skill limiar-resonance-system).
class_name ResonanceTarget
extends Node3D

signal revealed(target_id: StringName)
signal concealed(target_id: StringName)

const GROUP := &"resonance_target"
const TRANSITION_SEC := 0.6  ## dentro da faixa 0,4–0,8 s da Art Bible [VALIDAR]

@export var data: ResonanceTargetData
@export var veil_nodes: Array[NodePath] = []  ## Véu: fica translúcido durante o Eco (continua sólido)
@export var echo_nodes: Array[NodePath] = []  ## Eco: invisível no Véu, aparece na Leitura
@export_range(0.0, 1.0) var veil_reveal_transparency := 0.82
## Som do Eco tocado num AudioStreamPlayer3D filho "EchoAudio" (opcional). Nome de ProceduralSfx.
@export var echo_sound: StringName = &""

var is_revealed := false
var reveal_count := 0

var _time_left := 0.0
var _current_weight := 0.0
var _tween: Tween
var _light_energy := {}  # Light3D -> energia original


func _ready() -> void:
	add_to_group(GROUP)
	for l in _echo_lights():
		_light_energy[l] = l.light_energy
	_apply_echo_weight(0.0)
	_set_echo_visible(false)


## Raio efetivo a partir do qual a Leitura alcança este alvo.
func reach() -> float:
	return data.reach if data else 0.0


func can_read(state: Node) -> bool:
	if data == null or (data.once and reveal_count > 0):
		return false
	for f in data.required_flags:
		if state == null or not state.has_flag(f):
			return false
	return true


## Revela o Eco por `data.read_duration_sec`. Uma nova Leitura durante a revelação só renova o tempo.
## Retorna true se o alvo respondeu.
func reveal(state: Node) -> bool:
	if not can_read(state):
		return false
	_time_left = data.read_duration_sec
	if is_revealed:
		return true
	is_revealed = true
	reveal_count += 1
	if reveal_count == 1 and state != null:
		for f in data.on_resolved_flags:
			state.set_flag(f, true)  # GameState ignora repetição: flag e evento 1 vez (NAR-01)
	_fade_to(1.0)
	var audio := get_node_or_null(^"EchoAudio") as AudioStreamPlayer3D
	if audio and echo_sound != &"":
		audio.stream = ProceduralSfx.get_stream(echo_sound)
		audio.play()
	revealed.emit(data.id)
	return true


func conceal() -> void:
	if not is_revealed:
		return
	is_revealed = false
	_time_left = 0.0
	_fade_to(0.0)
	concealed.emit(data.id)


func _process(delta: float) -> void:
	if is_revealed:
		_time_left -= delta
		if _time_left <= 0.0:
			conceal()


func _fade_to(weight: float) -> void:
	if _tween:
		_tween.kill()
	if weight > 0.0:
		_set_echo_visible(true)
	_tween = create_tween()
	_tween.tween_method(_apply_echo_weight, _current_weight, weight, TRANSITION_SEC)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	if weight == 0.0:
		_tween.tween_callback(_set_echo_visible.bind(false))


## 0 = só Véu, 1 = Eco pleno. Transição por transparência por instância (sem duplicar materiais nem flashes).
func _apply_echo_weight(w: float) -> void:
	_current_weight = w
	for g in _geometry(veil_nodes):
		g.transparency = w * veil_reveal_transparency
	for g in _geometry(echo_nodes):
		g.transparency = 1.0 - w
	for l in _echo_lights():
		l.light_energy = _light_energy.get(l, 1.0) * w


func _set_echo_visible(v: bool) -> void:
	for p in echo_nodes:
		var n := get_node_or_null(p)
		if n is Node3D:
			n.visible = v


func _geometry(paths: Array[NodePath]) -> Array[GeometryInstance3D]:
	var out: Array[GeometryInstance3D] = []
	for p in paths:
		var n := get_node_or_null(p)
		if n == null:
			continue
		if n is GeometryInstance3D:
			out.append(n)
		for c in n.find_children("*", "GeometryInstance3D", true, false):
			out.append(c)
	return out


func _echo_lights() -> Array[Light3D]:
	var out: Array[Light3D] = []
	for p in echo_nodes:
		var n := get_node_or_null(p)
		if n == null:
			continue
		if n is Light3D:
			out.append(n)
		for c in n.find_children("*", "Light3D", true, false):
			out.append(c)
	return out

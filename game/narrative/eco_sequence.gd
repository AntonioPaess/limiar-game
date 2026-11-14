## Encenação temporizada de um Eco narrativo: quando o alvo de Ressonância revela, toca sons e legendas em ordem e
## registra o Eco no Diário. Reutilizável: tempos, sons e textos são dados. Só a 1ª revelação registra; as seguintes
## repetem som e legendas (o jogador pode rever a cena), sem novo evento (NAR-01).
class_name EcoSequence
extends Node

signal caption(text: String)
signal discovered(entry: EcoEntry)
signal finished

@export var target: NodePath
@export var entry: EcoEntry
## Passos: [tempo_s, chave_de_legenda ("" = nenhuma), som de ProceduralSfx (&"" = nenhum)]
@export var steps: Array = [
	[0.3, "ch1.eco.assento.legenda_riso", &"table_murmur"],
	[2.6, "ch1.eco.assento.legenda_voz", &"warm_chord"],
]
@export var discover_at := 3.4

var plays := 0
var _run_id := 0

@onready var _target: ResonanceTarget = get_node(target)


func _ready() -> void:
	_target.revealed.connect(func(_id: StringName) -> void: play())
	_target.concealed.connect(func(_id: StringName) -> void: _run_id += 1)  # interrompe se sumir antes


func play() -> void:
	plays += 1
	_run_id += 1
	var my_id := _run_id
	var t := 0.0
	var timeline := steps.duplicate()
	timeline.append([discover_at, "__discover__", &""])
	timeline.sort_custom(func(a: Array, b: Array) -> bool: return a[0] < b[0])
	for s: Array in timeline:
		var wait: float = s[0] - t
		if wait > 0.0:
			await get_tree().create_timer(wait, false).timeout
		t = s[0]
		if my_id != _run_id:
			return
		if s[1] == "__discover__":
			var gs := get_node(^"/root/GameState")
			if gs.discover_memory(entry):
				discovered.emit(entry)
			continue
		if s[2] != &"":
			_play_sound(s[2])
		if s[1] != "":
			caption.emit(tr(s[1]))
	finished.emit()


func _play_sound(sound: StringName) -> void:
	var p := AudioStreamPlayer3D.new()
	p.stream = ProceduralSfx.get_stream(sound)
	p.unit_size = 6.0
	_target.add_child(p)
	p.finished.connect(p.queue_free)
	p.play()

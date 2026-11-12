## Área de tutorial contextual (GDD §5, Beat 04: até 1–2 frases). Avisa entrada/saída do jogador; quem decide se a
## dica ainda é necessária (ex.: Ressonância nunca usada) é a cena principal.
class_name HintArea
extends Area3D

signal player_entered(text: String)
signal player_exited

@export var hint_key := ""  ## texto com %s para a tecla da ação
@export var action: StringName = &""


func _ready() -> void:
	body_entered.connect(func(b: Node3D) -> void:
		if b is FirstPersonPlayer:
			player_entered.emit(text()))
	body_exited.connect(func(b: Node3D) -> void:
		if b is FirstPersonPlayer:
			player_exited.emit())


func text() -> String:
	var t := tr(hint_key)
	return t % Hud._key_for(action) if t.contains("%s") else t

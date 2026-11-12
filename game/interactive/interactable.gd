## Corpo interagível (LIM-012). Implementa a convenção `IInteractable` da arquitetura (07 §4):
## `can_interact(actor)`, `get_prompt(actor)`, `interact(actor)`. O raycast do jogador ignora nós sem esse contrato.
## Textos são chaves de tradução (data/i18n/strings.csv), nunca texto literal.
class_name Interactable
extends StaticBody3D

## Emitido uma vez por interação aceita.
signal used(actor: Node)

@export var interactable_id: StringName = &""  ## ID estável (ex.: ch1.proto.door_exit)
@export var prompt_key: String = ""  ## chave do verbo exibido no prompt
@export var message_key: String = ""  ## chave de texto mostrado após interagir (opcional)
@export var once := false  ## se verdadeiro, só aceita a primeira interação
@export var enabled := true

var use_count := 0


func can_interact(_actor: Node) -> bool:
	return enabled and not (once and use_count > 0)


func get_prompt(_actor: Node) -> String:
	return tr(prompt_key) if prompt_key != "" else ""


func get_message() -> String:
	return tr(message_key) if message_key != "" else ""


## Retorna true se a interação foi aceita.
func interact(actor: Node) -> bool:
	if not can_interact(actor):
		return false
	use_count += 1
	used.emit(actor)
	return true

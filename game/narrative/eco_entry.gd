## Registro do Diário de Ecos (GDD §7, 06 §4): OBSERVAÇÕES e HIPÓTESES em seções separadas, transcrição revisável.
## Só chaves de tradução: nenhum texto de história no código. Hipóteses nunca afirmam lore ([LORE_TBD] fica aberto).
class_name EcoEntry
extends Resource

@export var id: StringName = &""  ## ex.: ch1.echo.assento_guardado (também é a flag gravada ao descobrir)
@export var title_key := ""
@export var observation_keys: Array[String] = []
@export var hypothesis_keys: Array[String] = []
@export var transcript_keys: Array[String] = []  ## legendas do Eco, na ordem, para rever depois
@export var area_key := ""  ## área simbólica, não data (06 §4)


func title() -> String:
	return TranslationServer.translate(title_key)


func lines(keys: Array[String]) -> PackedStringArray:
	var out := PackedStringArray()
	for k in keys:
		out.append(TranslationServer.translate(k))
	return out

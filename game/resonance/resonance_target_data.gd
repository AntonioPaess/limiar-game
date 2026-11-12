## Contrato de dados de um alvo de Ressonância (GDD §5 "Contratos", arquitetura 07 §4). Data-driven: nada de números
## mágicos na cena. Leitura é sempre gratuita (ADR-002 [PROPOSTA]); custo só existirá na Intervenção (LIM-021).
class_name ResonanceTargetData
extends Resource

enum TargetType { CLUE, REVEAL, BRIDGE, ENEMY_WEAKPOINT, NARRATIVE_ECHO }

@export var id: StringName = &""  ## ex.: ch1_wall_hospital_01
@export var target_type: TargetType = TargetType.REVEAL
@export var required_flags: Array[StringName] = []  ## todas precisam estar ligadas para o alvo responder
@export var read_duration_sec := 5.0  ## quanto tempo o Eco fica visível por Leitura [VALIDAR]
@export var read_cost := 0  ## pistas críticas: SEMPRE 0 (RES-02)
@export var once := false  ## se verdadeiro, responde só à primeira Leitura
@export var on_resolved_flags: Array[StringName] = []  ## gravadas na primeira revelação (1 vez)
@export var caption_key := ""  ## legenda do som do Eco (acessibilidade: pista sonora também em texto)
@export var reach := 0.0  ## metros somados ao raio da Leitura (alvos grandes)

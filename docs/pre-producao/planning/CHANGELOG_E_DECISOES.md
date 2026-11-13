# Changelog & Architectural/Creative Decision Records

## v0.1 — 12/11/2026

### Fixado a partir da direção do criador
- 3D em primeira pessoa.
- Dark fantasy low-poly com texturas pixeladas.
- Exploração psicológica, combate e puzzles.
- Ressonância como principal sistema diferencial.
- Quatro capítulos de 2–3 horas como objetivo, com memórias gradualmente recuperadas.
- Capítulo I com minichefe, chefe e revelação final.
- Foco temático em fazer o bem sem esperar retorno, viver o presente e buscar sonhos com equilíbrio.
- Não incluir animal companheiro pessoal por padrão.

### Proposto, aguardando validação
- Nome LIMIAR (de trabalho), protagonista Davi, nomes/temas dos capítulos, O Vigia/O Confessor, Godot 4.7.2 e estrutura de save.

### ADR-001 — Câmera em primeira pessoa

**Decisão:** FPS 3D (aprovado pelo criador). **Motivação:** imersão psicológica e observação de mudanças Véu/Eco. **Trade-offs:** nível, combate, movimento e animações FPP exigem mais trabalho; silhueta do protagonista visível menos frequentemente. **Revisar apenas se** o protótipo demonstrar falha grave incontornável.

### ADR-002 — Ressonância de dois modos

**Decisão:** leitura gratuita para pistas essenciais e intervenção limitada para efeitos fortes (proposta). **Motivação:** evitar softlock e ligar combate/investigação. **Trade-offs:** duas formas de uso exigem tutorial claro. **Revisar se** jogadores não distinguirem modos.

### ADR-003 — Implementação com Godot 4.7.2

**Decisão:** proposta técnica, não aprovada. **Motivação:** prototipagem ágil e distribuição desktop. **Trade-offs:** ferramentas e experiência da equipe podem favorecer Unity. **Revisar antes** de criar sistema permanente.

### ADR-004 — Input, FOV e geração do graybox no protótipo cinza

Data: 12/11/2026
Status: proposta (aplicada no protótipo; revisar no G1)
Contexto: LIM-002/010/011 precisavam de decisões pequenas e reversíveis para começar.
Opções consideradas: input no `project.godot` x registrado em runtime; FOV vertical (padrão Godot) x horizontal; graybox à mão x gerado.
Decisão: (1) ações no `project.godot`, geradas por `tools/godot/setup_input_map.gd`, teclas físicas (layout-independentes), todos os dispositivos; esquiva no Espaço enquanto pulo não for aprovado; ataque pesado adiado. (2) FOV em graus horizontais (`KEEP_WIDTH`), 80° padrão, 70–100°. (3) graybox CSG gerado por `tools/godot/build_graybox_cathedral.gd`.
Motivo: input editável no editor e testável; FOV horizontal bate com a especificação do GDD §3; geração reproduzível enquanto o layout muda rápido.
Consequências e riscos: editar a cena gerada à mão invalida o gerador; Espaço para esquiva conflita se pulo for aprovado.
Como validar: playtest G1 (conforto de câmera, ergonomia de esquiva).
Critério de revisão: pulo aprovado; reclamações de náusea/FOV; level designer assumir a cena no editor.

### ADR-005 — Leitura de Ressonância localizada e puzzle-placeholder das velas

Data: 12/11/2026
Status: proposta (aplicada no protótipo; revisar no G1/G2)
Contexto: LIM-020/022 exigem Leitura gratuita que revele pista obrigatória sem duplicar mapa, e um puzzle resolvível por observação + Ressonância.
Opções consideradas: trocar cenas/sub-mapas inteiros; shader global de pós-processo; alternar nós selecionados por alvo.
Decisão: `ResonanceTarget` (dados em `ResonanceTargetData`) alterna só nós escolhidos: Véu fica translúcido (`GeometryInstance3D.transparency`), Eco aparece com fade de 0,6 s, luzes do Eco sobem; **colisão nunca muda** na Leitura. Leitura = toque em R, raio 9 m, 5 s, cooldown 1,5 s, custo 0. Véu de tela violeta com intensidade ajustável (0 desliga). Puzzle-placeholder: 3 candelabros cujo padrão correto = monitores ligados no Eco da sala; dicas graduais na porta.
Motivo: barato (sem materiais duplicados, sem cena extra), seguro (sem prender o jogador em parede), testável; puzzle exercita observação + Ressonância + flag persistida.
Consequências e riscos: transparência por instância tem custo de ordenação em cenas grandes (medir no art proof); o puzzle das velas não é o P1/P2 do Level Design e pode ser descartado; a regra "monitor ligado = vela acesa" pode não ser óbvia sem playtest.
Como validar: playtest G2 (o jogador entende a Leitura sem texto? deduz o padrão?); profiler com 10+ alvos.
Critério de revisão: jogadores não ligarem monitor ↔ vela; queda de FPS na transição; Intervenção (LIM-021) exigir mudar colisão (só alvos `bridge` autorizados).

### ADR-006 — Combate do protótipo: detecção por cone, escudo frontal e Intervenção na fissura revelada

Data: 12/11/2026
Status: proposta (aplicada no protótipo; revisar no G1)
Contexto: LIM-021/030/031/032 pedem combate deliberado, legível em FPS, vencível sem aparo perfeito, e um uso da Ressonância em combate.
Opções consideradas: hitbox Area3D animada; raycast único; consulta de esfera + filtro de cone + linha de visão.
Decisão: consulta de esfera + cone + linha de visão (`Melee`), dano deduplicado por `attack_instance_id` no atacante e no `Health`. Vigia com escudo frontal (120°) que bloqueia; vulnerável pelas costas, na recuperação lenta e atordoado. Dois golpes alternados (varrido/avanço) com anúncio por forma + som. Intervenção = segurar R sobre a fissura do escudo já revelada pela Leitura (Toque lê, segurar intervém), 30 de Pulso. Pulso inicial 40, +20 por aparo, recarga mínima no checkpoint. Hit-stop curto desligável; sem tremor de câmera.
Motivo: determinístico e testável headless; ensina defesa × evasão; liga Leitura → Intervenção num gesto só (pilar 1: mecânica e tema inseparáveis).
Consequências e riscos: sem navmesh o Vigia pode enroscar em colunas; tempos e danos são palpite até playtest; espada/Vigia são formas placeholder.
Como validar: playtest G1 (mortes por encontro, motivo percebido, se alguém usa a Intervenção sem ser instruído).
Critério de revisão: jogadores morrerem sem entender por quê; ninguém descobrir a Intervenção; Vigia travado em geometria.

### Template de novas decisões

```
ADR-XXX — Título
Data:
Status: proposta | aprovada | substituída
Contexto:
Opções consideradas:
Decisão:
Motivo:
Consequências e riscos:
Como validar:
Critério de revisão:
```

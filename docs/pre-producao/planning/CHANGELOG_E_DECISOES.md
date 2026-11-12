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

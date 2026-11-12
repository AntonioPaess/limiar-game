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

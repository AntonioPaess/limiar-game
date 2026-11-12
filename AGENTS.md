# LIMIAR — Instruções para agentes (Claude Code e Codex)

Fonte única de instruções do projeto. `CLAUDE.md` apenas importa este arquivo. Inventário de ferramentas, versões
e comandos: `docs/AMBIENTE.md`.

## O projeto

Jogo narrativo de ação, exploração e terror psicológico, **3D em primeira pessoa**, dark fantasy low-poly com
texturas pixeladas, mecânica central **Ressonância** (Véu/Eco). Estado: **pré-produção**; nenhum gameplay foi
implementado. Idioma de trabalho e de UI: **PT-BR**.

**Documentação = fonte da verdade:** `docs/pre-producao/` (comece por `docs/00_DECISOES_E_STATUS.md`).
Prompt mestre de implementação: `docs/pre-producao/prompts/01_PROMPT_MESTRE_AGENTE.md`.

## Regras invioláveis

- Nunca converter para 2.5D, terceira pessoa ou top-down.
- Nunca promover `[PROPOSTA]`, `[ABERTO]` ou `[VALIDAR]` a cânone. Lore faltante → `[LORE_TBD]` + 2–3 opções.
- Não inventar acidente, identidade de pessoas, final nem detalhes íntimos do criador. Sem animal companheiro.
- Começar pelo **protótipo cinza de 10–15 min** (backlog `docs/pre-producao/planning/BACKLOG_MVP.md`, ordem
  `001 → 002 → 010 → 011 → 012 → 020 → 022 → 030 → 031 → 032 → 021 → 040 → 041 → 050 → 051`). Não pular para
  Capítulo II, chefe final, cinematics ou 4 capítulos.
- Nunca afirmar que algo foi criado, testado ou funciona sem ter executado e inspecionado. Relatar testes não rodados.
- Sem assets, trilha, código ou mapas de jogos de referência. Registrar fonte e licença de todo asset.
- Sem refactors massivos, sem sistemas fora do MVP, sem trocar tecnologia aprovada silenciosamente.
- Mudança estrutural/irreversível (engine, compra de assets, apagar dados) → parar e perguntar.

## Skills — carregue só as relevantes

Instaladas em `.agents/skills/` (Codex) com symlinks em `.claude/skills/` (Claude Code). Use o **`router`** para
escolher 2–3 skills por tarefa; não carregue todas. As skills do projeto têm prioridade sobre as genéricas:

| Tarefa | Skill do LIMIAR | Genéricas típicas |
|---|---|---|
| arte, shaders, luz, assets, renders | `limiar-art-director` | `godot-shaders`, `godot-3d-essentials`, `create-game-assets`, `raea` |
| história, diálogos, memórias, flags | `limiar-narrative-director` | `dialogue-systems`, `game-docs` |
| combate, inimigos, chefes | `limiar-combat-designer` | `game-feel`, `game-ai`, `godot-physics` |
| Ressonância, Véu/Eco, puzzles | `limiar-resonance-system` | `godot-resources`, `godot-signals-groups` |
| câmera FPS, input | — | `camera-systems`, `input-systems` |
| testes | — | `godot-gdscript-headless-testing` |

## Arquitetura (resumo de `07_ARQUITETURA_TECNICA.md`)

- Godot **4.7.2 stable + GDScript** (ADR-003 ainda `[PROPOSTA]`; confirmar com o criador antes de produção grande).
- Implementar verticalmente; tuning em `Resources` (`.tres`); sinais com fonte explícita; poucos autoloads.
- Separar movimento, combate, interação, Ressonância e flags narrativas. Flags por IDs estáveis
  (`ch1.echo.hospital_glimpse_seen`), nunca referências a nós.
- Strings por chave de localização; UI em resolução nativa, mundo pode ser pixelado.
- Grandes decisões → ADR em `docs/pre-producao/planning/CHANGELOG_E_DECISOES.md`.

## Ferramentas

- **Godot** é a engine. MCP `godot` (Godot MCP Toolkit) exige o editor aberto no projeto
  (`godot --editor --path .` ou `--headless --editor`).
- **Blender** para modelagem: headless `blender --background --python tools/blender/X.py -- args`;
  MCP `blender` exige a janela do Blender aberta (add-on inicia o servidor na porta 9876).
- **RAEA** é complementar (estudos visuais, luz, pixel look, transições, export experimental para Godot). Nada de
  RAEA vira asset final sem passar pelo pipeline `Blender → GLB → Godot`.

## Validação antes de dizer "pronto"

```bash
godot --headless --path . --import
godot --headless --path . --script res://tests/smoke_headless.gd
```

Tarefas visuais: render/screenshot inspecionado. Definition of Done: `08_PRODUCAO_ROADMAP.md` §5.
Commits pequenos; nenhum co-autor de IA nas mensagens de commit.

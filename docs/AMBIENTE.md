# LIMIAR — Ambiente de desenvolvimento (relatório de configuração)

**Data:** 12/11/2026 · **Máquina:** macOS 27.0.1, Apple Silicon (arm64) · **Projeto:** `~/Developer/limiar-game`
Este documento registra apenas o que foi instalado e executado de fato. Itens não verificados estão marcados.

---

## A. Skills

| Origem | Qtde | Local | Referência |
|---|---:|---|---|
| `gamedev-skills/awesome-gamedev-agent-skills` (Apache-2.0) | 79 + `router` = **80** | `.agents/skills/` (real) · `.claude/skills/` (symlinks) | v2.0.0, commit `c6ca6c4`, hashes em `skills-lock.json` |
| Skills do LIMIAR (criadas aqui) | **4** | `.agents/skills/limiar-*` · symlinks em `.claude/skills/` | este repositório |
| RAEA (`raea`) | 1 (com módulos) | `~/.claude/skills/raea` e `~/.agents/skills/raea` (escopo de usuário) | raea 0.1.1 |

- Instalação: `npx skills add gamedev-skills/awesome-gamedev-agent-skills --skill '*' -a claude-code -a codex -y`
  (escopo de **projeto**, não global, para não afetar outros projetos).
- As **30 skills prioritárias** do pedido existem e estão instaladas (verificado por nome): godot-3d-essentials,
  godot-gdscript, godot-nodes-scenes, godot-signals-groups, godot-physics, godot-animation, godot-shaders,
  godot-resources, godot-audio, godot-gdscript-headless-testing, godot-export, game-feel, game-ai,
  ai-behavior-trees-utility-ai, camera-systems, input-systems, physics-tuning, save-systems,
  performance-optimization, create-game-assets, level-design, dialogue-systems, audio-design, shader-programming,
  game-ui-ux, procedural-gen, game-docs, prototype-fast, steam-publish, itch-publish.
- Validação estática: 84/84 skills do projeto com `SKILL.md`, frontmatter válido, `name` = pasta, descrição ≤1024
  caracteres; nenhum symlink quebrado.
- **Orçamento de listagem:** com ~95 skills visíveis, o Claude Code pode cortar descrições. Configurado
  `skillListingBudgetFraction: 0.02` em `.claude/settings.json` (recomendação do próprio repositório).
- Atualizar: `npx skills update -p`. Restaurar em outra máquina: `npx skills experimental_install`.
- Módulos RAEA pedidos, todos presentes como arquivos da skill `raea` (não são pacotes separados):
  `3d/scenes.md, 3d/lights.md, 3d/materials.md, 3d/characters.md, 3d/animation.md, 3d/games.md, 3d/assets.md,
  3d/blender.md, 3d/godot.md, 3d/post.md, 3d/solari.md, 3d/limits.md, games.md, sound.md`.

## B. MCPs

Configurados em `.mcp.json` (Claude Code, escopo de projeto) e espelhados em `.codex/config.toml` (Codex).

| Servidor | Pacote | Pré-requisito em execução | Teste de comunicação real |
|---|---|---|---|
| `godot` | `@npgamedev/godot-mcp-server@1.1.2` + addon `addons/godot_mcp_toolkit` v1.1.2 (release assinada do GitHub) | editor Godot aberto no projeto | **APROVADO.** Editor headless escutando em 127.0.0.1:6550 com token de sessão; ponte respondeu `initialize` (protocolo 2025-06-18), `tools/list` = 36 ferramentas, `project_get_settings` devolveu 957 configurações reais; `script_check` respondeu com validação de schema (eu passei `path` em vez de `file_path`). |
| `blender` | `mcp-for-blender==2.2.8` (PyPI, autor Siddharth Ahuja) + add-on "MCP for Blender" v2.0 instalado via `raea setup blender` | janela do Blender aberta (servidor inicia sozinho na porta 9876) | **PARCIAL.** Socket do add-on respondeu `get_scene_info` com a cena real (Cube, Light, Camera). A execução da ponte `uvx mcp-for-blender` foi **bloqueada pelo classificador do modo automático**; não testada ponta a ponta. |

**Escolhas:**
- `scpli/blender-mcp` (pedido) tem 1 estrela e é uma cópia do `ahujasid/blender-mcp` (34k estrelas, MIT, ativo,
  hoje “mcp-for-blender”). Usado o original, que também é o que o RAEA instala: **um único Blender MCP**, sem redundância.
- `raea skills install` foi rodado com `--no-mcp --no-hooks`: o MCP do Blender foi registrado só no projeto (não
  global) e os hooks globais do RAEA (interceptar abertura de mídia no Preview, check após salvar composição) não
  foram adicionados ao Claude Code/Codex, para não alterar o comportamento de outros projetos. Para ativar:
  `raea skills install --agent claude` (sem flags).
- Segurança do Godot MCP: só localhost, token aleatório por sessão, sandbox em `res://`. Modo somente leitura
  disponível com `"env": {"GODOT_MCP_READ_ONLY": "1"}`. Verificação diária de update no GitHub pode ser desligada em
  Project Settings › Mcp Toolkit › Updates.
- O toolkit adiciona o autoload `MCPRuntimeServer` (porta 6570) em builds de debug; ele se desativa e é removido em exports.

## C. RAEA

- Instalado com o instalador oficial (inspecionado antes: baixa release do GitHub, confere SHA-256, instala em
  `~/.raea`, link em `~/.local/bin/raea`, copia a skill para `~/.claude/skills`). Versão **0.1.1**; `raea doctor`: OK.
- `raea skills install --agent claude|codex` é válido na 0.1.1 (verificado no `--help`).
- **Render 3D mínimo: APROVADO.** `tools/raea/smoke_cathedral.tsx` (nave gótica graybox, paleta da Art Bible,
  velas âmbar, fenda violeta do Eco, névoa, `<Look mode="pixel" pixelSize={4}>`) → `out/raea/smoke_cathedral.png`
  1280×720, inspecionado. A primeira versão ficou escura demais (−6,5 stops, 34% de pretos esmagados); ajustada para
  −4,2 stops sem pretos esmagados (low-key intencional).
- **Export para Godot: APROVADO com ressalva.** `raea godot export` gerou projeto (20 partes) que importa e roda no
  Godot 4.7.2 headless sem erro, mas **bloom, fog, pixel look e tonemapping não são levados**. O visual pixelado do
  jogo precisa de shader próprio no Godot; RAEA serve para estudo/referência.
- Também verificado: `raea setup blender` instalou os add-ons RAEA e MCP no Blender 5.3.0.
- Não verificado: áudio local (`raea setup-audio`), `raea godot run` (usa o build GodotJS 4.6.1 do RAEA, separado
  do Godot do projeto; não baixado).
- Usos possíveis no LIMIAR: estudos de luz/atmosfera e paleta por capítulo, comparação de pixelSize/resoluções
  (640×360, 960×540, 1280×720), estudos de transição Véu/Eco, cutscenes conceituais, renders de revisão
  (`raea render --review`) para inspeção automatizada.

## D. Skills do LIMIAR

| Skill | Responsabilidade | Ativa quando | Fonte da verdade |
|---|---|---|---|
| `limiar-art-director` | estética, paleta, materiais, luz, pós, naming, consistência | modelos, texturas, shaders, VFX, UI visual, renders | `05_ART_BIBLE.md` |
| `limiar-narrative-director` | cânone, status, privacidade, temas, diálogos, memórias, flags | lore, falas, Ecos, beats, chefes, final | `00_DECISOES…`, `02_BIBLIA_NARRATIVA.md` |
| `limiar-combat-designer` | estados, ações, contratos de dano, telegraphs, inimigos, chefes | combate, IA inimiga, hitboxes, balanço | `03_GDD_MECANICAS.md` §4, §9 |
| `limiar-resonance-system` | Leitura/Intervenção, `ResonanceTarget`, invariantes, linguagem Véu/Eco, puzzles | Ressonância, Pulso, puzzles de memória | `03_GDD…` §5–6, ADR-002 |

Todas referenciam os documentos em vez de duplicá-los e mantêm a marcação `[APROVADO]/[PROPOSTA]/[ABERTO]/[VALIDAR]`.

## E. Arquitetura de integração

```
                 AGENTS.md (fonte única)  ←  CLAUDE.md (@AGENTS.md)
                        │
     .agents/skills/ ───┴── .claude/skills/ (symlinks)      docs/pre-producao/ (fonte da verdade do jogo)
          │
 Claude Code / Codex ── MCP godot ──WS:6550──▶ Godot 4.7.2 editor ──▶ projeto (GDScript, .tres, cenas)
          │          └─ MCP blender ─TCP:9876─▶ Blender 5.3 (janela)       ▲
          │                                                                  │ GLB (metros, pivô, naming)
          ├── headless: blender --background --python tools/blender/*.py ───┘
          ├── headless: godot --headless --path . --script res://tests/*.gd
          └── RAEA (estudos): raea render tools/raea/*.tsx → out/raea/*.png (inspeção visual)
                              raea godot export → out/raea/godot_export (experimental, isolado com .gdignore)
```

- Godot é a engine; Blender é a ferramenta de assets; RAEA é laboratório visual. Nada de RAEA vira asset final sem
  passar por `Blender → GLB → Godot`.
- `docs/` e `tools/` têm `.gdignore` (Godot não importa a documentação); `out/` é saída regenerável e ignorada pelo git.
- Mudanças de MCP: editar `.mcp.json` **e** `.codex/config.toml`.

## F. Validação

| # | Verificação | Resultado |
|---|---|---|
| 1 | Skills pedidas instaladas | ✅ 80/80 + 4 do projeto; 30/30 prioritárias |
| 2 | Agentes encontram as skills | ⚠️ Estrutura e frontmatter validados; **descoberta numa sessão nova não testada** (o CLI `claude`/`codex` não está disponível neste shell). Confirmar com `/skills` numa nova sessão. |
| 3 | Carregamento automático via router | ⚠️ Não testável sem nova sessão; `router` instalado. |
| 4 | MCPs | ✅ Godot ponta a ponta · ⚠️ Blender só o lado do add-on (ponte bloqueada, ver B) |
| 5 | RAEA instalado e CLI | ✅ 0.1.1, `raea doctor` OK |
| 6 | Render 3D no RAEA | ✅ `out/raea/smoke_cathedral.png` inspecionado |
| 7 | Godot instalado e executando | ✅ 4.7.2.stable.official (o cask antigo 4.3 estava órfão: registro sem app; reinstalado) |
| 8 | Godot headless | ✅ `--import` exit 0; `tests/smoke_headless.gd` OK; `tests/smoke_glb_import.gd` OK |
| 9 | Blender | ✅ 5.3.0; export headless de GLB (28 tris, pivô na base) importado no Godot com AABB correto |
| 10 | Skills do LIMIAR | ✅ 4 criadas, frontmatter válido, symlinks OK |
| 11 | Falhas/pendências | ver abaixo |
| 12 | Nada destruído | ✅ `docs/pre-producao` idêntico ao pacote original (diff); projeto novo, nenhum arquivo de jogo pré-existente |

**Pendências**
1. Aprovar a execução de `uvx mcp-for-blender==2.2.8` (bloqueada pelo modo automático) e testar com o Blender aberto.
2. Abrir uma nova sessão do Claude Code em `~/Developer/limiar-game`, aprovar os MCPs do projeto e rodar `/skills` e `/mcp`.
3. Codex não está instalado nesta máquina; a configuração está pronta, mas não foi testada.
4. Git LFS 3.8.1 instalado, mas **desligado**: o GitHub recusou o push com "This repository exceeded its LFS
   budget" (orçamento de LFS da conta zerado). Binários seguem como arquivos normais. Para ligar: ajustar o
   orçamento em github.com/settings/billing/budgets e seguir as instruções no topo de `.gitattributes`.
   Fazer isso antes de versionar assets grandes (o GitHub recusa arquivos acima de 100 MB fora do LFS).
5. Disco: ~12 GB livres (98% usado). Blender + Godot + caches já ocupam espaço; recomendável liberar antes da produção de assets.
6. Engine (ADR-003) e renderer Forward+ vs Compatibility continuam `[PROPOSTA]`; `project.godot` usa Forward+ provisoriamente.

## Comandos de teste

```bash
godot --headless --path . --import
godot --headless --path . --script res://tests/smoke_headless.gd
blender --background --factory-startup --python tools/blender/smoke_export_column.py -- out/blender/ENV_CATH_Column_Smoke.glb
godot --headless --path . --import && godot --headless --path . --script res://tests/smoke_glb_import.gd
raea render tools/raea/smoke_cathedral.tsx --frame 0 -o out/raea/smoke_cathedral.png
godot --headless --editor --path .     # para o MCP godot
```

## G. Próximos passos — vertical slice

Seguir o backlog na ordem aprovada, um incremento testável por vez (detalhes em `BACKLOG_MVP.md`):

1. **LIM-001/002** — bootstrap formal (README de execução, cena `main`) e input centralizado (WASD/mouse, E, ataque,
   defesa/esquiva, R, Esc) com cursor capturado/liberado.
2. **LIM-010/011/012** — controlador FPS (`CharacterBody3D`, FOV 80° ajustável, head bob desligável), graybox da
   catedral (Átrio → corredor → sala de combate → parede de Eco → saída) e interação por raycast.
3. **LIM-020/022** — Ressonância de Leitura gratuita revelando o corredor clínico + puzzle de 2–3 estados com flag.
4. **LIM-030/031/032/021** — espada com dano 1× por swing, defesa/esquiva, Vigia comum, Intervenção expondo fissura.
5. **LIM-040/041/050/051** — um Eco narrativo `[LORE_TBD]`, HUD/menus PT-BR, checkpoint, testes smoke → revisão G1.

Em paralelo, decisão do criador: confirmar Godot (ADR-003) e escolher o renderer antes de qualquer shader de
pixelização definitivo (protótipo: comparar 640×360 / 960×540 / 1280×720).

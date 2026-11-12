# LIMIAR — Plano de implementação (protótipo cinza)

Complementa `docs/pre-producao/` (não substitui). Ordem do backlog:
`001 → 002 → 010 → 011 → 012 → 020 → 022 → 030 → 031 → 032 → 021 → 040 → 041 → 050 → 051` → revisão G1.
Engine: Godot 4.7.2 + GDScript (ADR-003 ainda `[PROPOSTA]`: o protótipo cinza serve justamente para validá-la).

## Incremento 1 — "andar e tocar" (esta branch: `feat/prototipo-fps-graybox`)

| Item | Entrega | Critério de aceite | Teste |
|---|---|---|---|
| LIM-001 | `game/main.tscn` como cena principal, estrutura `game/`, README de execução | editor abre sem erros; `main` executa | import headless + cena roda N frames sem `ERROR` |
| LIM-002 | Mapa de input no `project.godot` (teclado/mouse + gamepad básico), gerado por `tools/godot/setup_input_map.gd` | nenhuma tecla crítica em duas ações; cursor capturado/liberado | teste de conflitos de tecla; pausa libera cursor |
| LIM-010 | `FirstPersonPlayer` (`CharacterBody3D`): aceleração, gravidade, olhar mouse/analógico, FOV ajustável, head bob desligável, tuning em `PlayerSettings` (.tres) | percorre sala, olha em todas direções, sem clipping | testes de movimento/pitch; simulação de andar N frames |
| LIM-011 | Graybox da catedral: Átrio → corredor (com placeholder da parede de Eco) → sala de combate → porta → saída. CSG com colisão, luzes simples. Gerada por `tools/godot/build_graybox_cathedral.gd` | rota principal completa, saída visível nos primeiros segundos, sem quedas involuntárias | teste de rota: jogador spawna no chão e não cai |
| LIM-012 | Interação por raycast (convenção `can_interact/get_prompt/interact`), prompt no HUD, porta e objeto examinável | só alvo válido no alcance; 1 resposta por pressionamento | teste: fora do alcance não foca; porta abre 1 vez |
| extra | Menu de pausa PT-BR (FOV, sensibilidade, head bob), overlay de debug (F3) | opções aplicadas na hora | — (verificação manual) |

**Fora deste incremento:** combate, Ressonância, Vigia, puzzle, save em disco, áudio, arte final, pixelização.

## Incremento 2 — "ver o que não está lá" (branch `feat/ressonancia-leitura`, empilhada no incremento 1)

| Item | Entrega | Critério de aceite | Teste |
|---|---|---|---|
| LIM-020 | `ResonanceTarget` + `ResonanceTargetData`, `PlayerResonance` (toque em R), HUD (estado + véu ajustável), legendas, sons sintetizados, dica contextual | pista obrigatória revelada sem Pulso e sem duplicar mapa; spam de R não repete evento | alcance, custo 0, cooldown, flag 1×, colisão intacta, dica; capturas antes/depois |
| LIM-022 | Puzzle-placeholder das velas `[PROPOSTA]`: 3 candelabros, padrão nos monitores do Eco, porta trancada com dicas graduais | resolvível por observação + Ressonância; persiste em sessão; falha não punitiva | estados, padrão errado/certo, não retranca, persistência após recarga |

**Fora:** Intervenção/Pulso (LIM-021, junto com o Vigia), Diário de Ecos (LIM-040), save em disco.

## Arquitetura deste incremento

```
game/
  main.tscn                 cena principal: mundo + jogador + HUD + pausa + debug
  player/                   first_person_player.(tscn|gd), player_interaction.gd, player_settings.gd
  interactive/              interactable.gd (convenção), door.gd
  world/                    prototype_cathedral.tscn (gerada), world_environment
  ui/                       hud.(tscn|gd), pause_menu.(tscn|gd), debug_overlay.gd
  data/player/              default_player_settings.tres (tuning, placeholders [VALIDAR])
  data/i18n/strings.csv     textos PT-BR por chave (não hardcoded)
tests/run_tests.gd          runner headless com código de saída real
```

- Movimento, interação e UI separados; UI só reage a sinais do jogador.
- FOV medido em graus **horizontais** (`Camera3D.keep_aspect = KEEP_WIDTH`), alvo 80°, faixa 70–100° (GDD §3).
- Números de tuning (4,2 m/s caminhada, 6,0 m/s corrida) são placeholders `[VALIDAR]` em `.tres`.

## Riscos

- Cena gerada por script x edição manual: o gerador é bootstrap. Depois que alguém editar a cena no editor, não rodar
  o gerador de novo (ou portar a mudança para ele).
- Testes headless não renderizam: verificação visual via Movie Maker (`--write-movie`) com janela.
- Sensação de câmera (náusea, sensibilidade) só se valida com playtest real (G1/G2).

## Sequência de commits

1. Input map + estrutura + cena principal vazia.
2. Controlador FPS + settings.
3. Graybox + interação + HUD/pausa/debug.
4. Testes + docs/backlog.

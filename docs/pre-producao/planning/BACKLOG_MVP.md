# Backlog MVP — Prioridades e critérios de aceite

> **Objetivo:** demonstrar em cerca de 10–15 minutos o diferencial de LIMIAR: FPS 3D retro + ameaça legível + Ressonância que revela uma lembrança e afeta combate. Não produzir o Capítulo I completo nesta fase.

## Épico 0 — Fundação

**LIM-001 | Bootstrap do projeto [MUST]** — ✅ feito (branch `feat/prototipo-fps-graybox`): `game/main.tscn`, `README.md`, testes headless.
- Criar projeto Godot em versão estável escolhida, README de setup, estrutura mínima, `.gitignore`, import settings e mapa inicial vazio.
- Aceite: editor abre sem erros, cena `main` executa e há instruções reproduzíveis.

**LIM-002 | Input centralizado [MUST]** — ✅ feito: 16 ações em `project.godot` (teclado/mouse + gamepad), sem conflitos (teste). Cursor capturado/liberado pela pausa: verificado só por código/teste, falta teste manual.
- Mapear mover, olhar, interagir, atacar, defender/esquivar, Ressonância e pausar; gamepad em planejamento, com suporte básico se viável.
- Aceite: nenhuma tecla crítica colide com outra; cursor capturado e liberado corretamente.

**LIM-003 | Logging e diagnósticos [SHOULD]** — 🟡 parcial: overlay F3 (FPS, posição, velocidade, alvo); estados de combate/Ressonância quando existirem.
- Criar modo debug com estados do player, flag de Ressonância e framerate.
- Aceite: saída desativável em release sem console inundado.

## Épico 1 — Movimento e mundo

**LIM-010 | Controlador FPS [MUST]** — ✅ feito: movimento, olhar mouse/analógico, FOV 70–100° horizontal, head bob desligável. Sensação de câmera ainda **não validada por playtest humano**.
- CharacterBody3D, aceleração, gravidade, olhar, colisão, FOV ajustável e input pausable.
- Aceite: percorrer sala, olhar em todas direções, sem clipping e com opções de motion mínimas.

**LIM-011 | Graybox da catedral [MUST]** — ✅ feito: Átrio → corredor (placeholder da parede de Eco) → sala de combate → porta → saída; spawn no chão e rota até a saída testados.
- Átrio, corredor, sala de combate, parede de Eco e pequena saída; primitives e luzes simples.
- Aceite: rota principal completa, marcos visuais e sem áreas de queda involuntária.

**LIM-012 | Interação [MUST]** — ✅ feito: raycast 2,5 m, prompt no HUD, porta (1 vez, flag de sessão) e vela examinável; alcance e resposta única testados.
- Raycast, indicação de interação e objeto simples.
- Aceite: detectar somente alvo válido no alcance, responder uma vez por pressionamento.

## Épico 2 — Ressonância

**LIM-020 | Leitura básica [MUST]** — ✅ feito (branch `feat/ressonancia-leitura`): toque em R revela alvos num raio de 9 m por 5 s, custo 0, cooldown 1,5 s; fissura do corredor revela vislumbre clínico sem duplicar mapa (transparência por instância, colisão intacta); legenda do som; dica contextual. Testado headless + capturas antes/depois.
- Toque de tecla para revelar objeto/corredor hospitalar localizado por tempo limitado, com VFX/áudio placeholder.
- Aceite: pista obrigatória pode ser revelada independentemente de Pulso e sem duplicar mapa.

**LIM-021 | Intervenção [MUST]** — ✅ feito (branch `feat/combate-vigia`): segurar R (0,35 s) sobre a fissura do escudo **revelada** pela Leitura, na mira, ≤7 m; custa 30 de Pulso uma vez, cooldown 3 s; atordoa o Vigia 3 s e expõe (dano ×1,5). Sem alvo/Pulso: recusa sem gastar; mira na parede não afeta nada (testado).
- Alvo opcional de intervenção com custo e efeito (ex.: debuff temporário no Vigia).
- Aceite: consome Pulso uma vez, tem cooldown e nunca afeta alvo errado.

**LIM-022 | Puzzle com flag [MUST]** — ✅ feito como placeholder de mecânica `[PROPOSTA]`: 3 candelabros (acesa/apagada), padrão revelado pelos monitores do Eco; porta trancada com dicas graduais; `ch1.puzzle.candles_solved` persiste em sessão. Clareza do puzzle **não validada por playtest**.
- Dois ou três estados, pistas graduais e porta que abre.
- Aceite: resolver por observação+Ressonância; progressão persistida em sessão.

## Épico 3 — Combate

**LIM-030 | Espada e hit detection [MUST]** — ✅ feito: ataque leve (windup 0,12/ativo 0,12/recuperação 0,28 s, 12 de dano) por cone + linha de visão; `attack_instance_id` garante 1 dano por golpe por alvo (testado). Espada FPP placeholder com poses por estado.
- Ataque leve, janela de golpe, reação e cooldown parametrizados.
- Aceite: cada swing causa no máximo um dano por inimigo, sem hits fantasma.

**LIM-031 | Defesa/esquiva [MUST]** — ✅ feito: guarda frontal (25% do dano passa), aparo nos primeiros 0,25 s da guarda (0 dano, +20 Pulso, atordoa), esquiva 3,6 m com i-frames 0,22 s que não atravessa parede. Janelas `[VALIDAR]` por playtest.
- Mecânica alternativa de sobrevivência com telegraph legível.
- Aceite: jogador consegue evitar ataque do Vigia sem timing de parry perfeito.

**LIM-032 | Vigia comum [MUST]** — ✅ feito: idle → detectar (linha de visão, 11 m) → aproximar → anunciar (forma + som distintos) → varrido 20 / avanço 25 → recuperação lenta (abertura) → atordoado → morte (flag). Escudo bloqueia frente; vencível só pelas costas em 5 golpes, sem aparo (testado). Navegação é direta (sem navmesh): pode enroscar em colunas.
- Idle, detectar, aproximar, anunciar ataque, atacar, recuperar, reagir, morrer.
- Aceite: encontro 1v1 completável e não impede saída por bug.

**LIM-033 | Vigia minichefe simplificado [SHOULD]**
- 2 padrões, momento de Ressonância e vida balanceada.
- Aceite: diferença mecânica clara, duração curta, checkpoint próximo.

## Épico 4 — Narrativa e apresentação

**LIM-040 | Um Eco narrativo [MUST]**
- Registro com frase/áudio curto + objeto visual sem revelar lore não aprovado.
- Aceite: atualização de diário/flag, evidência recuperável, sem texto expositivo excessivo.

**LIM-041 | HUD e menus [MUST]** — 🟡 parcial: vida, Pulso, Ressonância, prompt, legendas, pausa com opções (FOV, sensibilidades, inverter Y, head bob, hit-stop, intensidade da Ressonância). Falta menu principal.
- Vida, Pulso, Ressonância, pausa, opções básicas, feedback de hit.
- Aceite: legível com pixelização do mundo desligada ou ligada.

**LIM-042 | Ambiente de respiro [SHOULD]**
- Pequena vista do jardim após encontro, sem ameaça.
- Aceite: transição de áudio/luz representa contraste emocional.

## Épico 5 — Qualidade

**LIM-050 | Checkpoint e retorno [MUST]** — ✅ feito em sessão: ponto de retorno antes da galeria; morrer escurece e volta com vida cheia, flags/puzzles preservados, Vigia não derrotado reinicia (testado). Save em disco: etapa seguinte.
- Recomeçar do checkpoint no protótipo; persistência em disco numa fase seguinte.
- Aceite: sem softlocks após morte ou puzzle.

**LIM-051 | Testes smoke [MUST]**
- Abre, move, interage, ataca, usa Ressonância, resolve puzzle, conclui.
- Aceite: registrar resultados reais e bugs.

**LIM-052 | Playtest independente [MUST para G2]**
- 5–8 jogadores quando possível, roteiro cego.
- Aceite: relatórios com observações, sem fabricar números.

## Ordem técnica sugerida

`001 → 002 → 010 → 011 → 012 → 020 → 022 → 030 → 031 → 032 → 021 → 040 → 041 → 050 → 051`.

Após esses itens, **não** adicionar mais sistemas automaticamente: fazer revisão G1, medir e avaliar se o minichefe/arte são os próximos investimentos.

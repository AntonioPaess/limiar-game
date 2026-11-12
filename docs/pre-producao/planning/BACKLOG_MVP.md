# Backlog MVP — Prioridades e critérios de aceite

> **Objetivo:** demonstrar em cerca de 10–15 minutos o diferencial de LIMIAR: FPS 3D retro + ameaça legível + Ressonância que revela uma lembrança e afeta combate. Não produzir o Capítulo I completo nesta fase.

## Épico 0 — Fundação

**LIM-001 | Bootstrap do projeto [MUST]**
- Criar projeto Godot em versão estável escolhida, README de setup, estrutura mínima, `.gitignore`, import settings e mapa inicial vazio.
- Aceite: editor abre sem erros, cena `main` executa e há instruções reproduzíveis.

**LIM-002 | Input centralizado [MUST]**
- Mapear mover, olhar, interagir, atacar, defender/esquivar, Ressonância e pausar; gamepad em planejamento, com suporte básico se viável.
- Aceite: nenhuma tecla crítica colide com outra; cursor capturado e liberado corretamente.

**LIM-003 | Logging e diagnósticos [SHOULD]**
- Criar modo debug com estados do player, flag de Ressonância e framerate.
- Aceite: saída desativável em release sem console inundado.

## Épico 1 — Movimento e mundo

**LIM-010 | Controlador FPS [MUST]**
- CharacterBody3D, aceleração, gravidade, olhar, colisão, FOV ajustável e input pausable.
- Aceite: percorrer sala, olhar em todas direções, sem clipping e com opções de motion mínimas.

**LIM-011 | Graybox da catedral [MUST]**
- Átrio, corredor, sala de combate, parede de Eco e pequena saída; primitives e luzes simples.
- Aceite: rota principal completa, marcos visuais e sem áreas de queda involuntária.

**LIM-012 | Interação [MUST]**
- Raycast, indicação de interação e objeto simples.
- Aceite: detectar somente alvo válido no alcance, responder uma vez por pressionamento.

## Épico 2 — Ressonância

**LIM-020 | Leitura básica [MUST]**
- Toque de tecla para revelar objeto/corredor hospitalar localizado por tempo limitado, com VFX/áudio placeholder.
- Aceite: pista obrigatória pode ser revelada independentemente de Pulso e sem duplicar mapa.

**LIM-021 | Intervenção [MUST]**
- Alvo opcional de intervenção com custo e efeito (ex.: debuff temporário no Vigia).
- Aceite: consome Pulso uma vez, tem cooldown e nunca afeta alvo errado.

**LIM-022 | Puzzle com flag [MUST]**
- Dois ou três estados, pistas graduais e porta que abre.
- Aceite: resolver por observação+Ressonância; progressão persistida em sessão.

## Épico 3 — Combate

**LIM-030 | Espada e hit detection [MUST]**
- Ataque leve, janela de golpe, reação e cooldown parametrizados.
- Aceite: cada swing causa no máximo um dano por inimigo, sem hits fantasma.

**LIM-031 | Defesa/esquiva [MUST]**
- Mecânica alternativa de sobrevivência com telegraph legível.
- Aceite: jogador consegue evitar ataque do Vigia sem timing de parry perfeito.

**LIM-032 | Vigia comum [MUST]**
- Idle, detectar, aproximar, anunciar ataque, atacar, recuperar, reagir, morrer.
- Aceite: encontro 1v1 completável e não impede saída por bug.

**LIM-033 | Vigia minichefe simplificado [SHOULD]**
- 2 padrões, momento de Ressonância e vida balanceada.
- Aceite: diferença mecânica clara, duração curta, checkpoint próximo.

## Épico 4 — Narrativa e apresentação

**LIM-040 | Um Eco narrativo [MUST]**
- Registro com frase/áudio curto + objeto visual sem revelar lore não aprovado.
- Aceite: atualização de diário/flag, evidência recuperável, sem texto expositivo excessivo.

**LIM-041 | HUD e menus [MUST]**
- Vida, Pulso, Ressonância, pausa, opções básicas, feedback de hit.
- Aceite: legível com pixelização do mundo desligada ou ligada.

**LIM-042 | Ambiente de respiro [SHOULD]**
- Pequena vista do jardim após encontro, sem ameaça.
- Aceite: transição de áudio/luz representa contraste emocional.

## Épico 5 — Qualidade

**LIM-050 | Checkpoint e retorno [MUST]**
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

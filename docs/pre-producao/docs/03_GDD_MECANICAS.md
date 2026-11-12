# 03 — Game Design Document (GDD) v0.1

**Perspectiva aprovada:** 3D em primeira pessoa. **Duração-alvo:** 2–3h por capítulo, somente após validação. **Estado:** regras detalhadas abaixo são configurações iniciais de protótipo, sujeitas a playtests.

## 1. Mecânicas centrais e dependências

1. Explorar com liberdade em pequenos ambientes conectados.
2. Observar indícios ambientais e interagir com objetos.
3. Sobreviver ou evitar encontros de combate.
4. Usar Ressonância para revelar o Eco de uma memória, pista, rota ou fraqueza.
5. Resolver um puzzle ou confronto que dependa da informação encontrada.
6. Atualizar memória/estado do mundo, abrindo um atalho, cena ou habilidade.
7. Voltar à exploração com nova interpretação do espaço.

A mecânica central precisa ter ao menos **dois usos reais diferentes no protótipo**: revelar uma passagem necessária e expor a fraqueza do Vigia.

## 2. Inputs (sugestão inicial)

| Ação | Teclado/mouse | Gamepad | Notas |
|---|---|---|---|
| Mover | WASD | Analógico esquerdo | Relativo à câmera |
| Olhar | Mouse | Analógico direito | Sensibilidade configurável |
| Caminhar/correr | Shift | L3 ou botão dedicado | Correr não deve limitar investigação |
| Pular (se aprovado) | Espaço | A/X | Avaliar necessidade; não criar parkour sem razão |
| Interagir | E | X/Quadrado | Raio curto, com foco visual |
| Ataque leve | Mouse esquerdo | RT/R2 | Velocidade deliberada |
| Ataque pesado | Segurar mouse esquerdo ou Q | RB/R1 | Escolher após teste ergonômico |
| Defender/aparar | Mouse direito | LT/L2 | Aparo por janela curta |
| Esquiva | Espaço + direção ou Alt | B/Círculo | Evitar conflito com pulo |
| Ressonância | R | LB/L1 | Toque: leitura; segurar: intervenção, se habilitada |
| Pausa | Esc | Start | Mouse liberado, salva opções |

**Nota:** esquema de pulo/esquiva e ataque pesado não está fechado. No protótipo priorizar movimentação, ataque leve, defesa, esquiva, Ressonância e interação. Controles sempre remapeáveis no produto.

## 3. Controlador de primeira pessoa

- `CharacterBody3D` com gravidade, aceleração/desaceleração, colisões e degraus testados.
- Câmera na altura dos olhos; FOV inicial **80° horizontal ou equivalente medido na engine**, ajustável de ~70–100° sem distorção excessiva. Documentar unidade efetiva do FOV da engine.
- Movimento inicial aproximado: caminhada 4.2 m/s; corrida 6.0 m/s; testado contra escala de portas e salas. Esses números são **placeholder de tuning**.
- Head bob mínimo e desligável; sem balanço forçado após dano; opção para desligar tremor e motion blur.
- Interação com raycast no centro e área de tolerância. Destaques sem exagero; HUD discreta.
- Em primeira pessoa o personagem deve ter mãos visíveis e feedback de respiração. Corpo completo somente se espelhos/flashbacks exigirem.

## 4. Combate deliberado

**Objetivo:** ameaça compreensível, encontros memoráveis e leitura clara. Não prometer Soulslike ou spam de inimigos.

### Estado do jogador

- `Idle`, `Move`, `Windup`, `Attack`, `Recovery`, `Guard`, `Parry`, `Dodge`, `Stagger`, `Interact`, `Resonance`, `Dead`.
- Transições explícitas e testáveis; animações governam janelas de acerto apenas onde necessário, com hitboxes verificáveis.
- Dano é aplicado uma vez por ataque por alvo, salvo ataques explicitamente multi-hit.
- Feedback: impacto sonoro, reação curta, VFX contido e indicador legível; sem câmera sacudindo sem opção de desligar.

### Ações

| Ação | Uso | Risco | Primeiro protótipo |
|---|---|---|---|
| Leve | golpe rápido, abertura curta | baixo dano | SIM |
| Pesado | rompe guarda e postura | preparação lenta | DEPOIS DO PRIMEIRO COMBATE |
| Guarda | mitiga dano frontal | gasta postura/tempo | SIM |
| Aparo | timing curto e Pulso | falhar expõe jogador | SIM, janela generosa inicial |
| Esquiva | reposiciona e evita golpe | recuperação breve | SIM |
| Ressonância ofensiva | revela fissura/ilusão | consome Pulso | SIM |

### Recursos de combate

- **Vida:** esgotar = reaparecer no último checkpoint, com objetos de progresso preservados conforme política de save.
- **Postura:** opcional na vertical slice. Inimigo pode ter apenas flag `vulnerable` sem barra numérica visível.
- **Pulso:** recurso de intervenção de Ressonância; máximo hipotético 100; regeneração por aparo, descanso e interações específicas. Não necessário para pistas indispensáveis.
- **Cura:** uso limitado e legível; no protótipo até 3 cargas por checkpoint, parametrizável.

### Balanço inicial [VALIDAR]

- 1 Vigia comum em arena de ensino + 1 minichefe com 2 padrões; combate total de 2–4 minutos no protótipo.
- Dano de ataques, vida, i-frames, janela de aparo e cadência são definidos em `Resources` externos, com métricas de playtest. Evitar valores hardcoded por cena.
- Evitar exigir aparo perfeito para vencer: esquiva e observação devem oferecer alternativa.
- Reduzir tempo de retorno após morte; preservar conhecimento e evitar longos percursos repetidos.

## 5. Ressonância — sistema assinatura

### Conceito

O ambiente contém o **Véu** (fantasia gótica jogável) e o **Eco** (fragmentos de uma lembrança). Ressonância não é um botão que teletransporta para outro universo inteiro: é uma ferramenta de sobreposição localizada, investigação e intervenção.

### Dois modos

**A. Leitura [gratuita / acessibilidade]:** toque em R. Revela por ~5 segundos contornos, sons, objetos e fissuras do Eco num raio/área definidos. Pode ser reativada após cooldown curto, sem consumir Pulso. Toda pista essencial deve ser acessível por aqui. Áudio e geometria complementam cor.

**B. Intervenção [custa Pulso]:** quando o jogador encontra um alvo autorizado, segurando R ou usando uma interação contextual é possível estabilizar uma ponte/objeto por tempo limitado ou tornar um inimigo vulnerável. Condições e duração devem ser data-driven. Não funcionar em todo objeto; marcadores ambientais ensinam a linguagem.

### Contratos

- `ResonanceTarget`: `id`, `target_type` (clue, reveal, bridge, enemy_weakpoint, narrative_echo), `required_flags`, `visual_state`, `audio_cue`, `duration`, `cost`, `cooldown`, `once`, `on_resolved_flags`.
- Pistas críticas: custo 0 e sem condição de recurso; alternativa de leitura por inspeção e legendas.
- Não criar duas versões inteiras de cada mapa: alternar materiais, malhas selecionadas, colisores e visibilidade de props e áudio.
- Ativar/desativar transição sem frame hitch e sem modificar estado global indevidamente.
- Eventos não devem disparar várias vezes por pressionar a tecla repetidamente.

### Exemplos

1. **Puzzle** — parede medieval revela porta clínica; puzzle exige reordenar três objetos para reconstruir um Eco; ao resolver, destrava uma passagem.
2. **Combate** — após um golpe bloqueado do Vigia, ativar Leitura mostra uma fissura no escudo; Intervenção por 30 Pulso atordoa por tempo curto. O jogador também pode vencer com esquiva e golpes por trás.
3. **Narrativa** — foto de um grupo se revela incompleta; jogador encontra Eco sonoro com uma frase antes ausente. O Eco registra nova dúvida, não entrega exposição longa.

## 6. Investigação e puzzles

- Puzzles partem de affordances claras: símbolo repetido, objeto deslocado, ruído, arquitetura inconsistente.
- Cada puzzle tem estado de repouso, pistas gradativas, solução, falha não punitiva e resolução persistida.
- Puzzles centrais não devem ser bloqueados por gasto de Pulso, inventário raro ou perda de item.
- Hints opcionais após exploração suficiente; nunca usar só pixel minúsculo em sala escura.
- Investigações oferecem observação e decisão, não apenas coletar 4 itens arbitrários.

## 7. Memórias, escolhas e sistema de bondade

- **Fragmentos de memória:** colecionáveis narrativos em sua maioria contextuais, com 1–2 memórias obrigatórias por sequência e algumas opcionais.
- **Diário de Ecos:** fatos observados, hipóteses separadas, sem narrador onisciente. Após a primeira descoberta registrar “Uma voz que não reconheço”, não “Quem dirigia o carro”.
- **Bondade:** ações opcionais de ajudar NPCs ou aliviar situações que não oferecem loot ou vantagem desproporcional. Reações humanas e pequenas mudanças no ambiente podem ocorrer; nenhuma barra de karma ou “moralidade”.
- **Escolhas:** pequenas consequências relacionais e de leitura; não prometer 30 finais ramificados. Só criar ramificação que caiba no orçamento de conteúdo.
- **Pós-chefe:** uma memória/revelação importante deve surgir a partir de participação ativa do jogador (investigar, recompor, interpretar), não só cutscene.

## 8. Morte, checkpoints e saves

- Checkpoints curtos antes de chefes e após puzzles grandes; morrer não apaga memórias essenciais já descobertas.
- Persistir: cena/checkpoint, status de encontros, puzzles resolvidos, flags narrativas, inventário, upgrades, controles, áudio, recursos apropriados.
- Suporte a múltiplos slots posteriormente; `schema_version` para migrações. Escrita atômica e backup de segurança.
- Não salvar no meio de cutscene irrecuperável; lidar com fechar durante transições.

## 9. Inimigos e encontro do protótipo

**Vigia comum:** silhueta robusta, escudo, golpe horizontal, golpe de avanço, estado vulnerável; ensina diferença entre defesa e evasão. Ataques anunciados por animação e som consistentes.

**O Vigia minichefe [proposta]:** versão de 2 estágios com variação de cobertura; sem simplesmente multiplicar HP. Fase 1 ensina leitura; fase 2 revela uma fissura com Ressonância.

**O Confessor chefe do Capítulo I [proposta]:** 2–3 fases narrativas, sino e ondas de som, Ecos contraditórios, arena com cover e espaços seguros. Não implementar na primeira sprint. Regras de combate específicas precisam de prototipagem separada.

## 10. Progressão

Proposta de habilidades associadas a compreensão de memórias:

| Habilidade | Exploração | Combate | Status |
|---|---|---|---|
| Leitura básica | detectar Eco | revelar fraqueza | MVP |
| Ruptura | dissipar obstáculo seletivo | interromper defesa | Protótipo avançado |
| Eco Persistente | manter estrutura ativa | janela prolongada | Pós-capítulo I |
| Reflexo | identificar acontecimentos repetidos | telegraph de padrão | Capítulo II candidato |
| Âncora | estabilizar área | criar refúgio limitado | Capítulo III candidato |

Não fazer árvore de 50 upgrades. Cada habilidade deve alterar pelo menos um puzzle e um confronto; se não consegue justificar ambos, rever.

## 11. Indicadores de playtest

- Tempo para entender interação e Ressonância.
- Mortes por encontro e motivo percebido.
- Taxa de descoberta de pistas sem hint.
- Quantidade de pessoas com náusea/desconforto na câmera.
- Conclusão correta/errada sobre o mistério ao fim do trecho.
- Se o jogador quer continuar e **por quê**.

## 12. Fora do MVP

Múltiplas armas, magia extensa, árvore de talentos, crafting, veículos, multiplayer, procedural generation, física avançada global, mundo aberto, finais múltiplos, NPCs sistêmicos e port mobile.

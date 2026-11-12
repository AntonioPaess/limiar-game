# 09 — QA, Playtests e critérios de aceitação

## 1. Matriz de testes de funcionalidade

| ID | Área | Teste | Resultado esperado |
|---|---|---|---|
| MOV-01 | Movimento | andar, girar, sprintar, voltar a andar | sem teleporte, jitter ou aceleração errática |
| CAM-01 | Câmera | girar 360°, olhar chão/teto, trocar FOV | sem clipping e sem UI distorcida |
| INP-01 | Input | teclado/mouse e gamepad | ações equivalentes e sem conflito grave |
| INT-01 | Interação | mirar, interagir longe/perto | prompt correto e sem interação à distância indevida |
| COM-01 | Combate | ataque leve em Vigia | dano 1x por swing, com telegraph |
| COM-02 | Combate | esquivar de golpe | sucesso legível, sem atravessar paredes |
| COM-03 | Combate | aparar e errar | feedback correto e sem softlock |
| RES-01 | Ressonância | ler parede do Eco | aparece e some de forma consistente |
| RES-02 | Ressonância | usar sem Pulso em pista obrigatória | pista continua acessível |
| RES-03 | Ressonância | intervenção em Vigia | apenas alvo válido muda estado |
| PUZ-01 | Puzzle | solução correta e incorreta | feedback, sem bloquear progressão permanentemente |
| NAR-01 | Narrativa | descobrir Eco | flag e diário atualizados 1 vez |
| SAV-01 | Save | fechar depois de checkpoint | progresso restaurado, sem corrupção |
| ACC-01 | Acessibilidade | reduzir efeito de pixel/shake | HUD/pistas permanecem legíveis |

## 2. Playtest de primeira experiência

**Amostra inicial:** 5–8 pessoas que não acompanharam a criação; testar perfis com experiências diferentes em jogos FPS, de terror e puzzle. Não induzir respostas enquanto jogam.

**Roteiro do observador:** marcar quando compreenderam o objetivo, quando sentiram medo, quando ficaram confusos, quantas tentativas no Vigia, se notaram o Eco, se entraram no caminho opcional, se pediram ajuda e o que lembram do personagem.

**Perguntas de saída:**

1. Em suas palavras, onde você acha que estava?
2. Para que serve a Ressonância?
3. Que parte foi mais interessante? E mais frustrante?
4. Você gostaria de continuar? Que pergunta espera responder?
5. Você percebeu alguma situação humana além do combate?
6. A câmera ou os efeitos causaram desconforto?

Não perguntar “você gostou da mensagem sobre viver o presente?”; isso sugere uma interpretação que deveria emergir naturalmente.

## 3. Critérios de aprovação por etapa

### Protótipo cinza

- [ ] 10–15 min de interação sem travar.
- [ ] Um encontro resolvível por ataque/esquiva sem obrigar aparo perfeito.
- [ ] Uma pista aparece por Ressonância e pode ser interpretada.
- [ ] Uma mudança de estado do mundo é persistida em sessão.
- [ ] Pelo menos uma pessoa do teste enuncia espontaneamente um mistério.

### Vertical slice

- [ ] Menu → gameplay → exploração → puzzle → minichefe → revelação → saída funciona.
- [ ] Cenário, armas, áudio e UI usam identidade artística coerente.
- [ ] 60 FPS alvo aferido em máquina de referência documentada; sem alegar meta cumprida sem medição.
- [ ] Controles e legendas suportam usuário que não enxerga cor violeta claramente.
- [ ] Nenhum blocker crítico na rota principal após ciclos de playtest.
- [ ] Análise de custo de conteúdo escrita com base na produção real.

## 4. Severidade

- **P0 Blocker:** crash, save corrupto, não progride, agressão visual perigosa, cena impossível de sair.
- **P1 Alta:** mecânica central falha ou informação obrigatória inacessível.
- **P2 Média:** inconsistência perceptível, performance em trecho específico, comportamento de inimigo confuso.
- **P3 Baixa:** polimento ou detalhe cosmético.

Usar issue com passos de reprodução, build/commit, esperado/obtido, gravação ou logs e responsável.

## 5. Métricas honestas

Registrar tempo real para completar a vertical slice, mortes, tentativas, uso de Ressonância, dificuldade percebida, problemas de acessibilidade e intenção de continuar. Não fabricar percentuais de satisfação nem afirmar validação por IA que não jogou.

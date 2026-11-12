# 04 — Level Design: Capítulo I, A Catedral dos Arrependimentos

**Status:** proposta de escopo e ritmo. Duração-alvo do capítulo completo **2–3h**, que deve ser conquistada com descoberta e variedade, não com tarefas repetitivas. **Primeira vertical slice:** 15–25 minutos em um recorte contido do capítulo.

## 1. Objetivo do jogador

- **Externo:** escapar da catedral.
- **Imediato:** alcançar o altar e obter a chave para abrir o Arquivo das Promessas.
- **Investigativo:** entender por que a catedral conhece detalhes que ele não recorda.
- **Emocional:** perceber que a própria imagem de culpa é parcial.

## 2. Objetivo dramático

Não contar ao jogador que está em coma nos primeiros segundos por narração expositiva. O mundo começa com regras de fantasia e indícios de anacronismo (som de monitor, metal de maca, vidro clínico). A primeira revelação deve ser vivenciada por Ressonância e não por texto.

## 3. Arquitetura de zonas

```
[A] Átrio Quebrado — despertar e câmera
    |
[B] Claustro das Velas — interação + primeira pista
    |---------- [B1] Jardim Silencioso (opcional: bondade + respiro)
    |
[C] Galeria dos Vigias — combate-base + checkpoint
    |
[D] Arquivo das Promessas — puzzle de Ressonância
    |----------- atalho -> [B]
    |
[E] Salão do Sino — minichefe O Vigia + primeiro grande Eco
    |
[F] Nave Principal — exploração, cena humana, preparação
    |
[G] Tribunal do Confessor — chefe final de capítulo
    |
[H] Porta do Eco — memória reconstruída, conclusão e pista nova
```

Esta topologia é um **mapa lógico**, não planta arquitetônica final. Jogador deve visualizar principais marcos e caminhos alternativos.

## 4. Distribuição hipotética das 2–3 horas

| Conteúdo | Meta aproximada |
|---|---:|
| Despertar, Átrio, Claustro | 15–25 min |
| Galeria de combate e exploração | 20–30 min |
| Arquivo das Promessas e segredo | 25–35 min |
| Minichefe, consequências e retorno | 20–30 min |
| Nave e investigação opcional | 25–35 min |
| Confessor, memória, desfecho | 20–30 min |

A soma pode variar conforme exploração; não acrescentar espera artificial. Replanejar depois de playtests.

## 5. Beat sheet do capítulo

**Beat 01 — Impossibilidade:** protagonista desperta numa catedral, escuta respiração e uma batida distante; não há explicação. Encontra um objeto moderno que desaparece quando olha novamente.

**Beat 02 — Primeira escolha sem recompensa:** no Claustro, uma figura pede ajuda para recuperar um pequeno objeto. Jogador pode ajudar ou seguir; ajudar não dá espada/XP, mas produz um momento de humanidade. Nenhuma punição moral secreta.

**Beat 03 — Primeiro combate:** um Vigia simples torna evidente o custo de atacar indiscriminadamente. Observação e esquiva funcionam.

**Beat 04 — Primeira Ressonância:** fissura numa parede revela breve corredor hospitalar; camadas do Véu e Eco são introduzidas por ação. Tutorial contextual com até 1–2 frases.

**Beat 05 — Arquivo:** três registros aparentemente provam que o protagonista faltou a promessas. A investigação revela um contexto omitido em ao menos um caso. O puzzle abre rota e mostra a mentira da catedral.

**Beat 06 — Minichefe:** O Vigia protege uma memória fragmentada. Derrotá-lo libera pista de que o Confessor edita o contexto, não necessariamente inventa fatos.

**Beat 07 — Respiro:** janela para um jardim iluminado; um Eco feliz comum, não um susto, mostra pessoa anônima rindo. Sem transformar toda ternura em anúncio de morte.

**Beat 08 — Preparação:** Nave Principal contém atalhos, registro, áudio da catedral e local seguro. O jogador pode ler informações opcionais antes do chefe.

**Beat 09 — Chefe final:** O Confessor alterna padrões físicos e projeções de julgamentos. Resolver seus efeitos exige aplicar Ressonância sob pressão, mas sempre com opção de defesa/esquiva legível.

**Beat 10 — Revelação:** o jogador reconstrói fragmento que prova que ao menos uma das acusações era incompleta; descobre anomalia [LORE_TBD] do acidente.

**Beat 11 — Encerramento satisfatório:** a catedral interrompe o ciclo de julgamento, abre caminho para além de suas muralhas, protagonista consegue sair. Último Eco mostra pista nova, iniciando pergunta do Capítulo II. Sem cliffhanger por corte abrupto durante uma luta.

## 6. Puzzles candidatos

### P1 — Vitrais Incompletos

- **Premissa:** quatro painéis descrevem sequência de acontecimentos, mas um deles não aparece na superfície do Véu.
- **Ações:** explorar, revelar o Eco com Ressonância, descobrir símbolo no reverso do vitral, reposicionar dois fragmentos.
- **Resultado:** abre porta do Arquivo e registra a hipótese “uma lembrança foi omitida”.
- **Falha:** posições erradas apenas tocam nota dissonante e recolocam peças; nunca tranca jogo.
- **Hint:** luz de vitral, som localizado, nota opcional na mesa.

### P2 — O Peso da Promessa

- **Premissa:** pedestal com três objetos cotidianos, cada um associado a uma promessa.
- **Ações:** leitura de Ecos de contexto; jogador escolhe quais objetos fazem parte da mesma memória, não quais são “culpados”.
- **Resultado:** revela que uma cena muda quando se acrescenta informação externa.
- **Falha:** pode revisar escolha; sem “resposta moral” binária.

## 7. Encontros

| Zona | Objetivo | Inimigos | Pista ou respiro |
|---|---|---|---|
| C | Aprender leitura de ataque | 1 Vigia comum | porta de hospital sem contexto |
| D | Puzzle com tensão | 0–1 Silenciado (após tutorial) | foto incompleta |
| E | Minichefe | Vigia | Eco do Arquivo |
| F | Exploração serena e preparação | encontro opcional | janela/jardim/lembrança humana |
| G | Chefe final | Confessor | interpretação das acusações |

No protótipo inicial, implementar só encontro comum + versão simplificada do Vigia como minichefe. Silenciado e Confessor são escopo futuro.

## 8. Vertical slice de 15–25 minutos

1. Átrio de introdução (~2 min).
2. Claustro compacto com interação (~3 min).
3. Vigia comum, básico de ataque e esquiva (~3 min).
4. Ressonância revela corredor clínico em parede (~3 min).
5. Puzzle de dois estados com uma pista e um retorno (~5 min).
6. Minichefe Vigia simplificado (~3–5 min).
7. Uma revelação curta e pergunta final (~1–2 min).

**Não construir chefe final do capítulo ainda.** A vertical slice demonstra o loop; o capítulo completo é etapa posterior.

## 9. Checklist de qualidade do nível

- Primeira saída visível em 3 segundos após o jogador ganhar controle.
- Pontos de interesse distinguíveis por silhueta, som e iluminação.
- Pelo menos 2 caminhos curtos de retorno, sem labirintos repetitivos.
- Distância entre checkpoints e chefes não cria repetição longa.
- Nenhuma pista obrigatória escondida em pixel indecifrável.
- Sem sobreposição de stingers/vozes durante combate crítico.
- Ressonância altera geometria/estado de forma que o jogador compreende.
- Cena de revelação deixa pergunta explícita na mente do jogador, mas resolve tensão local.

## 10. Critérios de saída do Capítulo I

A pessoa que joga deve ser capaz de dizer: (a) o que era O Confessor e por que combatê-lo; (b) qual acusação estava incompleta; (c) o que foi descoberto, mas ainda está em aberto sobre o acidente; (d) como Ressonância muda o mundo. Se responder apenas “derrotei um chefe”, a narrativa falhou.

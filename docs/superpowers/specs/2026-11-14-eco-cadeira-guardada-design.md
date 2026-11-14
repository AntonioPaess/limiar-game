# Eco narrativo "A cadeira guardada" (LIM-040) — design curto

**Status:** `[PROPOSTA]` escolhida por delegação do criador ("quero que você decida", 13/11/2026), com base no
veredito do council em `docs/decisions/council-eco-lim040/session.md`. Não é cânone de história: não afirma nada sobre
o acidente, quem estava presente, relações reais ou o final (todos seguem `[ABERTO]`).

## Intenção

O primeiro Eco narrativo precisa deixar no jogador **um detalhe humano** e **uma pergunta**, sem inventar lore. Também
é o contrapeso quente do quarto clínico frio do corredor: alegria/ternura antes da primeira imagem de hospital.

## Abordagens consideradas (council)

- (A) Foto incompleta — mistério forte, mas toca o reveal candidato "segunda presença". Descartada.
- (B) Gesto sem recompensa — tema central, mistério fraco. Descartada como principal.
- (C) Promessa interrompida — culpa pura sobre relações em aberto. Descartada.
- **(D) A cadeira guardada — escolhida.** Detalhe humano + presença + pergunta ("de quem é a voz?"), sem acidente.

## O que se constrói

- **Objeto (Véu):** no pedestal do átrio, um porta-retratos com uma foto em tons de cinza: mesa cheia, uma cadeira vazia.
  Interagir (E) mostra: *"Uma foto de uma mesa cheia. Só uma cadeira está vazia."* e, se a Ressonância nunca foi
  usada, a dica `[R] Ressonância`. A vela do pedestal fica só como cenário.
- **Eco (Leitura):** ao lado do pedestal, uma mesa em tamanho real aparece: pratos, copos, cinco cadeiras; quatro
  presenças âmbar translúcidas (sem rosto, sem gênero) e **uma cadeira vazia, levemente afastada**, que continua vazia.
  Luz âmbar quente sobe (Art Bible: âmbar = presença/afeto).
- **Encenação (~5 s):** 0,0 s Eco aparece (fade 0,6 s) → 0,3 s murmúrio de mesa + legenda
  *"[risos abafados ao redor de uma mesa]"* → 2,6 s acorde quente + legenda *"Voz: «Guardei seu lugar.»"* →
  3,4 s registro no Diário + aviso *"Novo registro no Diário [J]"* → 5,0 s Eco se desfaz.
- **Fala:** *"Guardei seu lugar."* — **minha decisão**: é o fallback neutro do council; "teu" marca região/intimidade
  que ninguém aprovou. Fica numa chave de tradução (`ch1.eco.assento.voz`), trocável sem código.
- **Voz gravada:** ainda não existe. O protótipo usa murmúrio + acorde sintetizados e **legenda** como portadora da
  fala `[VALIDAR]`. Risco do council: voz placeholder ruim mataria o efeito — por isso não há voz falsa.
- **Diário de Ecos (novo, tecla J / Tab / Back):** pausa o jogo e lista registros. Entrada:
  - Título: *A cadeira guardada*
  - Observações: *"Uma mesa cheia. Uma cadeira vazia. Alguém riu."* / *"Alguém guardou um lugar para mim."*
  - Hipóteses: *"Alguém esperava por mim?"* / *"Por que a Catedral guarda este momento, e não uma dor?"*
  - Transcrição revisável: as duas legendas.
- **Flag:** `ch1.echo.assento_guardado` (convenção `chN.echo.*`; o council chamou de `eco_assento_guardado`).

## Não dizer

Nome, gênero, parentesco, idade, data, de quem é a voz, por que ele faltou; carro, acidente, hospital, coma, morte;
qualquer tom de cobrança. Um teste automático varre os textos do Eco por essas palavras.

## Fora do escopo

Voz gravada, arte final da foto, Eco do hospital no Diário, save em disco do Diário.

## Validação

- Automática: flag e registro 1 vez; registro revisável no Diário; legendas na ordem; sem palavras proibidas; sem
  conflito de tecla.
- Playtest (council): passa se ≥3 de 5 jogadores citarem a cadeira ou a voz e perguntarem sozinhos de quem era a voz.

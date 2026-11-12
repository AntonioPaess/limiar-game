# LIMIAR — Documento Mestre de Pré-Produção v0.1
> Este arquivo reúne a documentação textual do pacote para facilitar a importação em uma IA que não leia ZIPs. Visuais estão no ZIP. A prioridade de decisão é `00_DECISOES_E_STATUS.md`.

---



---

<!-- SOURCE: README.md -->

# LIMIAR — Pacote de Pré-Produção v0.1

**Data:** 12/11/2026 · **Idioma de trabalho:** português brasileiro · **Status:** design de pré-produção, não produto jogável

> **Logline:** Após um acidente, um homem acorda num mundo de fantasia sombria formado por lembranças fragmentadas. Ao atravessar provações, recuperar memórias e ajudar desconhecidos, ele descobre que viver não é esperar que tudo esteja resolvido.

## Comece aqui

1. Leia `docs/00_DECISOES_E_STATUS.md`: separa decisões fechadas, hipóteses e pontos pendentes.
2. Leia `docs/01_GAME_VISION.md` e `docs/02_BIBLIA_NARRATIVA.md` para compreender a identidade e o sentido da experiência.
3. Leia `docs/03_GDD_MECANICAS.md`, `docs/04_CAPITULO_01_LEVEL_DESIGN.md`, `docs/05_ART_BIBLE.md` e `docs/06_AUDIO_UI_ACESSIBILIDADE.md`.
4. Leia `docs/07_ARQUITETURA_TECNICA.md`, `docs/08_PRODUCAO_ROADMAP.md`, `docs/09_QA_CRITERIOS.md` e `docs/10_COMERCIAL_LEGAL.md`.
5. Para uma IA encarregada de codificar, forneça **todo o pacote** e a instrução `prompts/01_PROMPT_MESTRE_AGENTE.md`. Para uma IA encarregada de escrever/documentar, use `prompts/02_PROMPT_NARRATIVA_E_ARTE.md`.
6. Se a IA não puder ler arquivos anexados, envie `LIMIAR_MASTER_DOCUMENT.md` e, em seguida, o prompt escolhido.

## Escopo aprovado

- Jogo narrativo de **ação, exploração e terror psicológico**.
- **3D em primeira pessoa**, não terceira pessoa e não 2.5D.
- Estética **dark fantasy 3D low-poly com texturas pixeladas**, sombreamento e iluminação atmosférica; inspiração estética de referência, sem copiar assets ou identidade de jogos existentes.
- Quatro capítulos planejados, **2–3 horas por capítulo** como alvo, total hipotético de **8–12 horas**. O escopo depende de uma vertical slice aprovada.
- Mecânica central: **Ressonância** (o Véu de fantasia e o Eco de memórias), usada em investigação, puzzles e combate.
- Capítulo I começa na **Catedral dos Arrependimentos**, apresenta combate, mistérios, **um minichefe e um chefe final**, encerra resolvendo um conflito e revelando uma pista maior.
- História de um homem que tenta retornar à vida depois de um acidente e recupera a memória ao longo dos capítulos.
- Temas: bondade sem recompensa, liberdade, presença, sonhos, vínculos, arrependimento e limites do controle.

## Aviso editorial e privacidade

A obra utiliza sentimentos universais inspirados por experiências humanas, **não relata autobiografia**. Não incluir nomes verdadeiros, eventos íntimos identificáveis, diagnósticos, condições médicas familiares, detalhes de relacionamentos, endereços ou histórias de animais/pessoas reais. Os personagens, o acidente e as relações são ficcionais até aprovação explícita do criador. O coma é um recurso ficcional; não representar despertar clínico como consequência literal de força de vontade ou superação emocional.

## Regras de trabalho para IA

- Não declarar como cânone fatos marcados `[PROPOSTA]`, `[ABERTO]` ou `[VALIDAR]`.
- Implementar **primeiro um protótipo cinza de 10–15 minutos**, não tentar construir 8–12h de jogo de imediato.
- Nunca inventar que um asset, cena, build, teste ou arquivo foi criado. Relatar o que foi efetivamente executado e inspecionado.
- Usar ferramentas locais, licença válida e assets originais ou de procedência documentada; não extrair materiais de jogos de referência.
- Manter documentação sincronizada com o código; cada grande decisão precisa de uma ADR ou atualização do changelog.

## Estrutura

```
LIMIAR_Pre_Producao_v0.1/
├── README.md
├── LIMIAR_MASTER_DOCUMENT.md
├── docs/
│   ├── 00_DECISOES_E_STATUS.md
│   ├── 01_GAME_VISION.md
│   ├── 02_BIBLIA_NARRATIVA.md
│   ├── 03_GDD_MECANICAS.md
│   ├── 04_CAPITULO_01_LEVEL_DESIGN.md
│   ├── 05_ART_BIBLE.md
│   ├── 06_AUDIO_UI_ACESSIBILIDADE.md
│   ├── 07_ARQUITETURA_TECNICA.md
│   ├── 08_PRODUCAO_ROADMAP.md
│   ├── 09_QA_CRITERIOS.md
│   └── 10_COMERCIAL_LEGAL.md
├── planning/
│   ├── BACKLOG_MVP.md
│   └── CHANGELOG_E_DECISOES.md
└── prompts/
    ├── 01_PROMPT_MESTRE_AGENTE.md
    └── 02_PROMPT_NARRATIVA_E_ARTE.md
```

**Observação:** este pacote **não contém um jogo executável**, arte final, modelos 3D ou assets liberados para comércio. É um conjunto de especificações e instruções para iniciar o trabalho de maneira controlada.


---

<!-- SOURCE: docs/00_DECISOES_E_STATUS.md -->

# 00 — Registro de decisões e status

## Interpretação de status

- `[APROVADO]`: foi combinado explicitamente e só deve ser alterado com aprovação.
- `[PROPOSTA]`: direção recomendada, ainda não aprovada como conteúdo final.
- `[ABERTO]`: não há informação suficiente para fechar.
- `[VALIDAR]`: hipótese a testar em protótipo/playtest, mesmo que seja a direção atual.

## Decisões aprovadas

| Item | Estado | Especificação |
|---|---|---|
| Identidade narrativa | APROVADO | Bondade sem recompensa, liberdade, aproveitar o presente e valorizar quem amamos sem abrir mão dos sonhos |
| Premissa | APROVADO | Homem sofre acidente, entra em coma; universo aparentemente fantástico formado por memórias, provas e conflitos |
| Progressão da trama | APROVADO | Memórias recuperadas gradualmente; jogador descobre o que aconteceu e quem era o protagonista |
| Episódios | APROVADO | Quatro capítulos narrativos planejados, cada um com aproximadamente 2–3 horas; ritmo inspirado em episódios com mistério e resolução local |
| Capítulo I | APROVADO | Ensina mecânicas gradualmente, contém minichefe e chefe final, resolve questão local e termina com revelação intrigante |
| Câmera | APROVADO | 3D livre em **primeira pessoa** |
| Arte | APROVADO | Dark fantasy, low-poly, pixelização/texturas retro, gótico e surrealismo |
| Sistemas fundamentais | APROVADO | Exploração psicológica + combate + puzzles + Ressonância |
| Tom | APROVADO | Melancolia e tensão com intervalos genuínos de beleza, humanidade e esperança |
| Uso das vivências | APROVADO | Abstração temática sem reproduzir diretamente pessoas/acontecimentos reais |
| Animal companheiro | APROVADO | **Não** adicionar um companheiro canino inspirado em experiências pessoais apenas porque foi mencionado; não faz parte do escopo aprovado |

## Propostas de trabalho, não cânone

- `[PROPOSTA]` Título de trabalho **LIMIAR**. Alternativas: Entre Ecos, Véspera, Os Dias que Não Vivemos, Ainda Há Amanhã. Exigem busca de marca e pesquisa comercial antes de anúncio.
- `[PROPOSTA]` Protagonista provisoriamente chamado **Davi**, 27–30 anos, reservado e autoexigente, com gestos de generosidade e falhas de presença afetiva.
- `[PROPOSTA]` Capítulos: I Catedral dos Arrependimentos (culpa); II Floresta dos Amanhãs (liberdade/futuro); III Cidade dos Ausentes (vínculos/perda); IV O Limiar/O Quarto (verdade/presença).
- `[PROPOSTA]` Minichefe O Vigia e chefe final O Confessor no Capítulo I.
- `[PROPOSTA]` Uma espada principal, esquiva, defesa, aparo, ataque leve/pesado e habilidade de Ressonância com camada gratuita para investigação e camada avançada alimentada por Pulso.
- `[PROPOSTA]` Engine-base **Godot 4.7.2 estável com GDScript**; confirmar com o criador antes de iniciar uma implementação definitiva. Para benchmark de produtividade é possível comparar com Unity, mas não iniciar dois projetos completos.
- `[PROPOSTA]` Lançamento inicial para Windows/Steam; macOS considerado depois de testes de exportação e performance; iPhone fora do MVP.
- `[PROPOSTA]` Um produto com quatro capítulos internos; estratégia de lançamento episódico como aplicativos separados permanece em aberto.

## Pontos abertos que NÃO podem ser inventados como definitivos

1. Nome comercial e identidade visual/logomarca final.
2. Nome, idade, voz, profissão, relações e história exata do protagonista.
3. O que realmente ocorreu no acidente, quem estava presente, motivo da viagem, consequências e resultado clínico.
4. Quem é a pessoa mais importante para o protagonista no mundo real e como ela será ficcionalizada.
5. O desfecho definitivo e eventual ambiguidade sobrenatural.
6. Quantidade real de inimigos, duração efetiva dos níveis e orçamento de conteúdo.
7. Modelo de distribuição dos quatro capítulos e preço.
8. Localização (PT-BR obrigatório no planejamento; EN possível), vozes e fornecedores.

## Protocolo de proteção narrativa

Quando a IA precisar de detalhes sobre passado ou acidente, deve: (a) usar `[LORE_TBD]`; (b) oferecer 2–3 opções claramente sinalizadas; (c) não alterar plot twist ou final sem validação; (d) continuar trabalho técnico independente do lore. A narrativa não pode ser tratada como um prontuário, autobiografia ou terapia. Nada de chamar sentimentos de transtornos no texto ficcional sem pesquisa e revisão.

## Gates de projeto

- **G0 | Pré-produção:** documentos coerentes e protótipo definido.
- **G1 | Fun:** movimentar, atacar, esquivar e usar Ressonância é compreensível e divertido com geometria cinza.
- **G2 | Suspense:** playtest de 10–15 minutos gera curiosidade sem exposição exagerada.
- **G3 | Visual:** uma sala com assets originais demonstra pipeline de pixelização, luz e performance.
- **G4 | Vertical slice:** 15–25 minutos com qualidade representativa de um capítulo.
- **G5 | Escopo:** extrapolação da vertical slice sustenta ou reduz a ambição de 4 × 2–3h.

Nenhum compromisso de lançamento, contratação ou custo deve ser anunciado antes de G4/G5.


---

<!-- SOURCE: docs/01_GAME_VISION.md -->

# 01 — Game Vision / Creative Pillars

## High concept

**LIMIAR** é um jogo narrativo de ação e exploração em primeira pessoa, com estética dark fantasy 3D pixelada. Um homem que sofreu um acidente desperta em um mundo gótico aparentemente impossível. Para encontrar a saída, enfrenta criaturas, investiga ambientes e ativa a **Ressonância**, habilidade que revela fragmentos do passado escondidos no cenário. Cada descoberta altera sua interpretação dos fatos e de si mesmo.

## O que o jogo deseja dizer

**“A vida não começa quando tudo estiver resolvido.”**

Duas máximas interagem: **“Faça o bem sem olhar a quem”** e **“Não deixe para viver quando chegar ao destino.”** Gentileza não é moeda de troca; perseguir sonhos não deveria anular o presente. O personagem precisa aprender a distinguir responsabilidade real de culpa impossível, presença de controle, ambição de adiamento da vida.

Não reduzir o projeto a uma mensagem moral simplista. Boas ações não garantem recompensas, renúncia nem sempre é nobre, viajar e crescer não implicam abandonar pessoas, e não há culpa por não controlar o tempo ou a vida alheia.

## Fantasia do jogador

“Sou alguém preso num pesadelo medieval que se comporta como uma memória falha. Investigo a verdade, enfrento criaturas com espada e recursos limitados, ajudo algumas pessoas sem garantia de recompensa e descubro pequenas razões para querer continuar vivendo.”

## Experiência desejada

- **Curiosidade:** cada sala contém algo estranho que implica história.
- **Tensão controlada:** alguns combates são perigosos; não há inimigos em todas as salas.
- **Espanto:** a Ressonância faz um mundo medieval revelar lugares cotidianos impossíveis.
- **Empatia:** o protagonista tem falhas concretas e gestos de bondade reconhecíveis.
- **Respiro:** paisagens bonitas, silêncio, música e memórias felizes impedem monotonia emocional.
- **Reflexão:** o jogador interpreta dilemas antes de ouvir uma tese explícita.

## Quatro pilares não negociáveis

1. **Mecânica e tema inseparáveis:** Ressonância aparece em exploração, combate e narrativa. Evitar três minijogos que não conversam.
2. **Sofrimento sem espetáculo:** criaturas e eventos possuem significado, mas não representamos doenças mentais como monstros que basta matar.
3. **Beleza contrastando com terror:** ao menos uma pausa emocional significativa em cada capítulo.
4. **Contenção de escopo:** cada sistema deve funcionar no protótipo e ter justificativa para permanecer.

## Público-alvo hipotético

Adultos e jovens adultos interessados em mistério de exploração, horror psicológico atmosférico, fantasia sombria e combate deliberado, com tolerância a leitura ambiental e puzzles. Não presumir público fiel de jogos de ação difíceis: conduzir playtests com perfis diversos.

## Referências e limites

- *Ignite the Depths*: linguagem 3D retrô/pixelada e fantasia sombria; **não** copiar mapas, conceitos, assets ou identidade.
- Jogos narrativos de memórias e terror: referência apenas de ritmo e uso de símbolos.
- Estrutura episódica no estilo de aventuras com capítulos de 2–3 horas: resolução local + pista maior; **não** importar personagens ou trama de *Poppy Playtime*.

## Meta de duração (não uma garantia)

4 capítulos × 2–3 horas = **8–12 horas**. Inclui exploração principal, encontros, puzzles e narrativa, sem esticar artificialmente puzzles para bater tempo. O tempo deve ser medido em playtests, não escrito como requisito que force repetição.

## Core loop

`Explorar → Observar e sobreviver → Revelar memória com Ressonância → Resolver conflito/puzzle → Transformar o mundo → Receber nova capacidade ou informação → Reexplorar/avançar`

O loop precisa funcionar antes de qualquer cinematic ou exposição.

## Não objetivos

- Mundo aberto com centenas de NPCs.
- RPG de loot, raridades e estatísticas extensas.
- Multiplayer/co-op e live service.
- Combate punitivo como identidade principal.
- Recriar fielmente vivências pessoais ou rostos de pessoas reais.
- Monetização por capítulos definida antes de validar custo e aderência.
- Final em que o coma termina literalmente por “vencer seus traumas”.

## Critérios de sucesso do protótipo

- Jogador consegue navegar em primeira pessoa sem desconforto indevido.
- Em 5 minutos compreende movimentação, interação e ameaça básica.
- Reconhece ao menos um uso de Ressonância na exploração e um em combate.
- Consegue dizer qual mistério quer investigar depois do trecho.
- Termina o trecho lembrando de um detalhe humano, não só de um efeito visual.


---

<!-- SOURCE: docs/02_BIBLIA_NARRATIVA.md -->

# 02 — Bíblia Narrativa v0.1

> **Estado:** premissa e temas aprovados; identidade específica do protagonista, passado, acidente, final, falas e revelações são **propostas** a validar. Esta versão serve para dirigir gameplay e arte sem determinar acontecimentos íntimos.

## 1. Logline

Depois de um acidente, um homem desperta num mundo onde uma catedral o julga, uma floresta promete futuros impossíveis e uma cidade preserva vozes de quem deixou para trás. Ao recuperar suas memórias, descobre que viver não é ganhar controle sobre tudo, mas continuar amando, escolhendo e fazendo o bem enquanto há tempo.

## 2. Tema, antítese e dilema

- **Tese:** fazer o bem sem esperar prêmio; estar presente; viver agora; sonhar sem adiar a vida.
- **Antítese encarnada no mundo:** só serei digno quando tiver sucesso, satisfizer todos e impedir toda perda.
- **Pergunta dramática:** alguém pode aspirar a uma vida maior sem transformar o presente em dívida permanente?
- **Transformação:** da necessidade de ser suficiente para todos → à capacidade de reconhecer limites, reparar falhas reais e escolher a presença sem abandonar sonhos.

## 3. Protagonista — ficha de ficção

**Codinome de escrita: Davi [PROPOSTA].** Adulto, aproximadamente 28 anos; reservado em público, impaciente quando teme falhar, generoso em gestos não anunciados, curioso e fascinado pelo mundo. Deseja viajar, compreender outras pessoas e construir um futuro seguro para quem ama. Às vezes esquece de viver o presente. Diz “não preciso de ninguém” quando na verdade teme depender e perder.

**Mentira interna:** “Se eu não conseguir proteger e prover para todos, sou um fracasso.”

**Verdade a descobrir:** “Tenho responsabilidades, mas não posso controlar o destino de todos; minha existência também é feita das presenças e dos gestos de hoje.”

**Falhas reais:** interromper pessoas, não pedir desculpas, adiar conversas importantes, interpretar afeto como cobrança, transformar amor em plano financeiro. **Forças reais:** curiosidade, sensibilidade à natureza, capacidade de ajudar desconhecidos, lealdade, abertura para rever escolhas.

**Não copiar fatos íntimos diretamente.** O jogador deve reconhecer emoções, não detalhes biográficos de uma pessoa real.

## 4. Três níveis de verdade

1. **Mundo real [ABERTO]:** cronologia causal do acidente e das relações. Deve ser escrita e aprovada numa folha separada, com respostas fechadas para o roteirista.
2. **Véu [PROPOSTA]:** interpretação fantasiosa de conflitos e memórias, com regras físicas consistentes no gameplay.
3. **Eco [PROPOSTA]:** impressões sensoriais de lugares, vozes, fotografias, clima, objetos e pessoas do mundo real, reveladas com Ressonância. São lembranças, não gravações objetivas.

A ambiguidade pode se manter até o final, mas o autor precisa conhecer os fatos reais antes de espalhar pistas. Nenhum Eco deve contradizer sem propósito a cronologia canônica.

## 5. Regras de narrativa

- Uma área importante = um conflito, um elemento afetivo concreto, uma ação do jogador e uma transformação.
- Toda acusação monstruosa mistura uma parte de verdade e uma conclusão injusta. O jogador encontra evidências suficientes para distinguir as duas.
- Pelo menos 25% dos grandes beats emocionais tratam de alegria, ternura, beleza, humor ou esperança; não fazer fila de traumas.
- Evitar diálogos que recitem autores famosos como professores. Filosofia por dilemas e escolhas; personagens originais inspirados por questões éticas.
- Não afirmar que “ser uma pessoa boa impede perdas”. Bondade importa, mas não garante resultados.
- Não exigir salvar todos para alcançar o “bom final”. Ausência de recompensa material não deve virar punição moral oculta.
- Não fazer a recuperação do coma depender biologicamente de resolução psicológica.

## 6. Capítulo I — A Catedral dos Arrependimentos [PROPOSTA]

**Pergunta:** “O que, de fato, é minha responsabilidade?”

**Mentira do local:** uma pessoa só merece partir quando tiver cumprido todas as promessas.

**Conflito local:** figuras encapuzadas e inscrições acusam o protagonista de abandonar pessoas e de nunca ter sido suficiente. Algumas lembranças corroboram pequenas falhas de presença; outras provam que ele também esteve disponível, tentou ajudar e fez escolhas generosas.

**NPC conceitual — A Zeladora [PROPOSTA]:** figura ambígua que conserta vitrais e se recusa a julgar alguém por uma lembrança isolada. Não conhece toda a verdade. Serve como primeiro contraponto do Confessor e dá orientação sem palestrar.

**Minichefe — O Vigia [PROPOSTA]:** guardião do Arquivo das Promessas. Silhueta pesada, escudo grande, ataque previsível. Mecanicamente ensina aparo/Ressonância. Narrativamente representa o hábito de vigiar cada erro próprio.

**Chefe — O Confessor [PROPOSTA]:** juiz cuja voz mistura frases de várias lembranças. Ele acusa o protagonista com fatos parciais, exigindo uma culpa totalizante. O jogador vence o combate físico e o puzzle de identificar o que o Confessor omite.

**Resolução local:** jogador encontra uma lembrança concreta de uma ajuda feita sem esperar retorno e percebe que uma pessoa não cabe numa lista de dívidas. A catedral deixa de repetir algumas acusações.

**Pista de encerramento [CANDIDATA, NÃO CÂNONE]:** um Eco do acidente mostra que havia uma segunda presença cuja identidade foi removida das lembranças. Uma frase anteriormente atribuída ao Confessor é reconhecida no Eco, mas não sabemos de quem é. O jogador entende algo sobre como as memórias falham, sem saber ainda o que causou o acidente.

**Outras opções de revelação para aprovação:** (A) o protagonista confundiu uma promessa com uma ordem; (B) um objeto do hospital aparece onde não poderia estar; (C) uma voz demonstra que uma discussão ocorreu depois do momento que ele lembrava.

## 7. Capítulo II — A Floresta dos Amanhãs [PROPOSTA]

**Pergunta:** “Se posso imaginar mil futuros, por que não consigo estar neste momento?”

Paisagem impossível de trilhas bifurcadas, árvores que sustentam casas inacabadas e mirantes que mostram vidas desejadas. Cada trilha promete uma versão idealizada da vida, mas exige abandonar a cena real diante do jogador.

**Mecânica própria:** Ecos de Possibilidade — o jogador materializa temporariamente um caminho alternativo, mas só pode manter um conjunto limitado de alterações para que a navegação permaneça clara.

**Antagonista conceitual — O Peregrino Imóvel [PROPOSTA]:** arrasta relógios e mapas; não dá um passo porque exige ter certeza de que escolheu a direção perfeita.

**Resolução local:** escolher um percurso imperfeito e ajudar alguém que não pode oferecer vantagem futura.

**Revelação maior [ABERTA]:** recuperar decisão anterior ao acidente, sem ainda conhecer seu significado causal.

## 8. Capítulo III — A Cidade dos Ausentes [PROPOSTA]

**Pergunta:** “Como continuar amando sem controlar o tempo de quem amamos?”

Cidade gótica em águas escuras, pontes interrompidas, casas transformadas em ilhas. A ausência modifica a acústica: vozes são audíveis mas as pessoas não estão mais nos cômodos. A água não representa apenas morte; também acolhe reflexos de festas, refeições e risadas.

**Mecânica própria:** Âncoras de presença — estabilizar memórias para acessar rotas, mas não congelar tudo; algumas passagens só abrem quando o jogador permite que uma memória desapareça do cenário.

**Antagonista conceitual — O Faroleiro [PROPOSTA]:** tenta manter eternamente todas as luzes acesas e aprisiona a cidade num crepúsculo interminável.

**Resolução local:** proteger o valor do que existiu sem exigir que continue intacto.

**Revelação maior [ABERTA]:** contexto verdadeiro das relações e da linha do tempo do acidente.

## 9. Capítulo IV — O Quarto / O Limiar [PROPOSTA]

**Pergunta:** “Uma vida imperfeita pode ser uma vida que vale a pena viver?”

O Véu se fragmenta. Elementos da catedral, da floresta e da cidade surgem fundidos com espaços cotidianos. A última investigação reconstrói a cronologia do acidente e o que o protagonista pode — e não pode — saber sobre as pessoas ao redor.

**Conflito final:** confrontar a fantasia de que existe uma escolha capaz de prevenir toda dor. Não concluir que ser bom é ser invulnerável. O confronto pode ter combate, mas sua resolução deve depender do que o jogador aprendeu a fazer, não de selecionar um slogan moral.

**Final [ABERTO]:** resultado clínico não deve ser prometido por uma vitória simbólica. Opções autorais incluem (A) retorno com perdas e vínculos ainda reais; (B) final aberto com sinal de consciência; (C) desfecho com duas perspectivas, clínica e simbólica. Exigem decisão do criador e revisão de sensibilidade.

## 10. Matriz de revelações (rascunho)

| Fase | Crença do jogador | Descoberta local | Pergunta seguinte |
|---|---|---|---|
| Entrada do I | O mundo é uma punição | Objetos lembram lugares contemporâneos | Quem construiu esse mundo? |
| Fim do I | Ele é culpado por tudo | Acusações omitem contexto; Eco do acidente contém anomalia | O que falta na lembrança? |
| Fim do II | Uma escolha perfeita evitaria perda | As alternativas projetam futuros, não verdades | Que relação realmente motivou a viagem? |
| Fim do III | Ausência equivale a abandono | Presença e distância não se anulam | O que aconteceu de fato? |
| Fim do IV | Só posso viver quando resolver tudo | A vida exige escolha sob incerteza | Como carregar isso adiante? |

## 11. Vozes e diálogos

- Protagonista: poucas falas, naturais, curiosas, às vezes defensivas; sem narração filosófica constante.
- Zeladora: concreta e observadora. Ex.: “Essa vidraça só mostra o que sobrou. Não o que estava ao redor.”
- Confessor: preciso e sedutor; usa falhas reais para extrapolar culpa. Ex.: “Você se lembra do que não fez. Que conveniente esquecer o que fez.”
- Memórias felizes: cenas curtas, sensoriais; pessoas com humor e vontade própria, não apenas instrumentos para emocionar o protagonista.

Diálogos anteriores são **exemplos originais**, não texto definitivo de jogo.

## 12. Tratamento responsável

- Coma, hospital, lesões e recuperação: validação médica na versão final; não vender ideia de que o coma é um “sonho controlável” ou o acordar é merecimento moral.
- Luto, doenças e sofrimento psíquico: evitar exploração gráfica gratuita, diagnósticos como monstros e culpabilização. Buscar consultoria quando possível.
- Uso de filosofia e literatura: inspirar-se em obras e correntes, jamais colar traduções contemporâneas ou citações sem verificar domínio público, autorização e contexto.
- Referências pessoais do criador: guardar privadamente, fora de repositórios compartilhados; abstrair antes de documentar.

## 13. Perguntas para a próxima rodada autoral

1. Quem ele era antes do acidente (sem usar diretamente a identidade de ninguém)?
2. Qual acontecimento positivo merece ser lembrado com mais força do que qualquer trauma?
3. Qual falha concreta ele precisa reparar, em vez de só perdoar a si mesmo?
4. Qual é o fato objetivo do acidente? Quem sabe disso fora do Véu?
5. Que escolha emocional final faz sentido, mesmo se o estado clínico for incerto?

**As respostas nunca devem ser inventadas silenciosamente por um agente de implementação.**


---

<!-- SOURCE: docs/03_GDD_MECANICAS.md -->

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


---

<!-- SOURCE: docs/04_CAPITULO_01_LEVEL_DESIGN.md -->

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


---

<!-- SOURCE: docs/05_ART_BIBLE.md -->

# 05 — Art Bible / Direção de Arte v0.1

## 1. Declaração estética

**Dark fantasy psicológico em 3D de primeira pessoa** com geometrias simples, texturas pixeladas, silhuetas fortes, iluminação dramática contida e rupturas visuais entre uma arquitetura gótica imaginada e objetos cotidianos clínicos ou afetivos. A estética precisa parecer um jogo jogável, não uma pintura hiper-detalhada impossível de reproduzir.

**Palavras-chave:** solidão, pedra molhada, velas, ruínas, memória falha, madeira, vento, água, natureza, calor humano, presença.

**Anti-referências:** excesso de vinheta, aberração cromática permanente, escuridão sem leitura, imagens hiper-realistas, fotobash de assets terceiros, shader retro que dificulta reconhecer inimigos e UI ornamental ilegível.

## 2. Identidade visual e regras consistentes

- **Silhueta antes do detalhe:** cada inimigo deve ser distinguível por volume e postura em 1–2 segundos, inclusive sob névoa.
- **Pixelização intencional:** texturas majoritariamente low-res, sampling nearest com filtragem seletiva para legibilidade; respeitar densidade de texel consistente por classe de asset.
- **Modelos low-poly críveis:** planos e volumes angulares, não objetos todos cúbicos. Não criar uma “voxelização” rígida em que tudo vira cubo.
- **Cores com função:** bordô/cobre = cobranças/culpa; azul profundo = ausência e Eco; violeta = Ressonância; âmbar/dourado = presença, afeto e lembranças vívidas; cinzas clínicos = realidade.
- **Beleza controlada:** usar luz natural e vistas largas ocasionalmente para tornar o mundo desejável, não apenas assustador.
- **Objetos reais anacrônicos:** raros e significativos; um monitor ou cama no meio de uma catedral precisa causar estranheza, não virar decoração genérica.
- **Primeira pessoa:** mãos, espada, tecido, reflexo, postura e áudio substituem gestos faciais constantes. Modelar corpo inteiro apenas onde justificado.

## 3. Paleta-base sugerida

| Função | Cor | Hex |
|---|---|---|
| Abismo / sombra | Azul-noite | `#11131B` |
| Pedra fria | Cinza-azulado | `#303447` |
| Eco/visão | Roxo desaturado | `#69465A` |
| Materialidade | Cobre antigo | `#A16D47` |
| Presença/esperança | Dourado morno | `#D5B879` |
| Culpa/ameaça | Vinho ferrugem | `#9E393E` |

Os hex são **alvos de direção**, não cores absolutas do renderer. Em HDR/tonemapping validar em monitor padrão e com modos de acessibilidade.

## 4. Estilo de câmera e pós-processo

- Câmera 3D real, FPP, animações discretas. Sem câmera livre cinematográfica durante controle.
- Prototipar render de baixa resolução como **640×360** em viewport 16:9 para teste, comparar também 960×540 e 1280×720 com filtro retro; não impor resolução baixa a UI ou legendas.
- Dithering e banding sutis, de preferência ajustáveis; evitar jitter de vértices excessivo em puzzles pequenos.
- Fog volumétrico somente onde custo permitir; fallback fog simples para compatibilidade.
- Usar bloom contido em luzes e fragmentos; color grade por capítulo; opção “reduzir efeitos visuais”.
- Evitar flashes com luminância intensa; transições de Ressonância usam dissolve/mascara localizada, duração ~0,4–0,8s [VALIDAR].

## 5. Protagonista [PROPOSTA]

**Visual geral:** adulto comum, exausto, com roupas medievais práticas que parecem montadas de restos de lembranças; manga com faixa, capa bordô puída, couro escuro e metal gasto. Não precisa parecer nobre ou predestinado.

**Marcas reconhecíveis:** uma costura interrompida na manga, luva ou faixa no pulso, espada antiga simples com geometria assimétrica. Nada de símbolo sagrado específico tratado como verdade metafísica.

**Para produção:** model sheet com vista frontal, lateral, traseira, mãos FPP, arma, materiais e silhueta em três distâncias; 3 poses de emoção/corpo; não usar imagens conceituais como texturas finais sem adaptação.

**Progressão:** o vestuário não vira armadura dourada. Pequenas reparações, transparências do Eco e maior presença de luz humana sugerem mudança sem apagar suas cicatrizes.

## 6. Mundos e arquitetura

### I. Catedral dos Arrependimentos

Pedra úmida, velas baixas, confessionários, sinos quebrados, vitrais com cenas contraditórias, corredores aparentemente repetidos, objetos clínicos que se insinuam entre nichos. Silhuetas verticais opressivas. Paleta vinho, cinza, azul e violeta.

### II. Floresta dos Amanhãs

Árvores tortas, caminhos para paisagens e versões impossíveis de casas, mirantes, musgo, flores raras e construções interrompidas. Contraste entre lusco-fusco e amanhecer dourado. A natureza não é só ameaça; é território de liberdade.

### III. Cidade dos Ausentes

Gótico costeiro, água escura, ruas submersas, janelas iluminadas, pontes quebradas, objetos cotidianos presos na maré. Reflexos e sons trabalham memória e ausência. Azul petróleo, verde frio, pontos quentes nas casas.

### IV. O Quarto / O Limiar

Geometrias de fantasia dobradas sobre hospital, quarto, cozinha, jardim e outras cenas ainda abertas. A realidade deve aparecer em fragmentos com significado, não como um “plot twist de hospital” óbvio em todas as salas.

## 7. Inimigos e chefes

| Personagem | Silhueta | Materiais | Significado | Game readability |
|---|---|---|---|---|
| Vigia | escudo largo e tronco inclinado | ferro gasto e couro | autovigilância e proteção excessiva | braço do escudo anuncia defesa; fissura ao ativar Eco |
| Silenciado | corpo fino, capuz/tiras | pano sem brilho | recusa de expressar algo | áudio e distorção local denunciam deslocamento |
| Imitador | anatomia espelhada irregular | vidro fosco/metal | repetição de padrões | animação copia gesto com atraso legível |
| Confessor | figura alta, sino/correntes | tecido púrpura e ferro | julgamento sem contexto | golpes de sino telegráficos, contraste claro na arena |

Criaturas não devem ser cópias de pessoas reais ou metáforas simplistas para diagnósticos.

## 8. Linguagem de Ressonância

**Véu:** materiais sólidos, luz física e espaço gótico.

**Eco:** arestas violetas discretas, ruído sonoro específico, fragmentos anacrônicos, mudança temporária de collision/visibility em objetos autorizados.

Em combate, o ponto fraco pode ter reforço por forma, vibração leve e som, **não apenas roxo**. Em puzzle, transições não devem mover o jogador inadvertidamente ou ocultar piso enquanto atravessa.

## 9. Kit mínimo de assets do protótipo

- 1 malha simples de braços/mãos FPP e espada.
- 1 kit modular de catedral: parede, coluna, arco, piso, porta, escada, vitral, pedestal, altar, grade, cerca, vela.
- 1 Vigia simples com telegraph claro e 4 animações (idle, ataque, reação, morte) + defesa.
- 3 objetos de memória: fotografia abstrata, maca/cama, monitor estilizado.
- 1 VFX localizado de Ressonância, 1 material de Eco, 1 dissolve simples.
- 1 conjunto de ícones UI: vida, Pulso, espada, Ressonância, interação.
- Light rigs: catedral fria, vela, revelação violeta, janela quente.

## 10. Pipeline e naming

`Blender → glTF/GLB → Godot import → Material/Shader → Prefab/Scene → QA`.

Exemplo: `ENV_CATH_Wall_A_01.glb`, `CHR_Vigia_Base.glb`, `PRP_Memory_Photo_01.glb`, `VFX_Resonance_Reveal.tres`.

Para cada asset: owner, fonte/licença, tri count aproximado, resolução/texel density, materiais, LOD se necessário, colisão, pivô, escala em metros e screenshot in-engine.

## 11. Prompts para concept art (não assets finais)

**Personagem:** “Original dark-fantasy first-person adventure protagonist, weary adult traveler, tattered burgundy mantle, practical medieval layers, angular low-poly form with pixelated textures; turnaround front side back plus first-person hands, neutral lighting, production character sheet, no copyrighted logos or recognizable character likeness.”

**Catedral:** “Game environment art for an original 1990s-inspired low-poly 3D first-person psychological fantasy game: ruined gothic cathedral, wet stone, broken bell, candles and one impossible clinical corridor revealed through a localized violet rift. Readable paths, modular geometry, restrained postprocess, 16:9, in-engine screenshot aesthetic.”

**Ressonância:** “Side-by-side design study of the SAME low-poly gothic room before and during a violet-memory overlay; exact architectural alignment, a small hospital bed visible beyond one wall, clear player traversal, restrained effect, no UI text.”

**Aviso:** concept art criada por IA é referência de intenção, não comprovação de fidelidade a assets, geometria, gameplay, direitos ou performance.


---

<!-- SOURCE: docs/06_AUDIO_UI_ACESSIBILIDADE.md -->

# 06 — Audio Bible, UI/UX e acessibilidade

## 1. Direção sonora

Som como indício de memória, não apenas susto. Priorizar design de som espacial, silêncio e pequenas continuidades entre o Véu e o Eco: gotejamento de água se torna ruído de soro; sino se transforma em pulso eletrônico; vento entre árvores revela uma conversa distante. Esses efeitos precisam ser elegantes e não literalmente repetidos a cada sala.

### Identidade por capítulo

- **Catedral:** pedra, vento nos arcos, madeira, respiração, ferro e sino quebrado; drones graves espaçados, canto humano abstrato não litúrgico e sem citações religiosas diretas.
- **Floresta:** folhas, água, aves, distância, texturas orgânicas; poucos instrumentos melódicos, calor quando o jogador observa.
- **Cidade:** água sobre pedra, vozes abafadas, ecos de portas; música rarefeita, lampejos de encontros cotidianos.
- **Quarto:** eletricidade, respiração, cama, ruídos de memória; transição para sons próximos e humanos.

## 2. Eventos dinâmicos

- `player_enter_zone`, `threat_detected`, `combat_started`, `combat_finished`, `resonance_read`, `resonance_intervene`, `memory_fragment_found`, `puzzle_solved`, `checkpoint_saved`, `death`, `chapter_revelation`.
- Ambiência deve fazer crossfade para não reiniciar agressivamente.
- Sons essenciais da Ressonância e inimigos precisam ser distinguíveis sem estarem sempre altos.
- Legendar fala, voz distante e informações sonoras críticas quando necessário.

## 3. Música

A trilha deve sustentar a história, não sugerir tristeza constante. Referência de instrumentação: cordas de câmara, piano esparso, ressonâncias metálicas, texturas de madeira, drones sintéticos discretos. Criar um motivo curto (3–5 notas ou gesto sonoro **original**) que pode assumir harmonia angustiada na Catedral e versão luminosa no final. Não pedir à IA que replique melodia de jogo/filme existente.

**Protótipo:** 1 loop ambiente, 1 camada de ameaça, 1 impacto de revelação, 1 passagem de respiro; usar assets licenciados ou originais.

## 4. UI/UX

### HUD durante gameplay

- Vida e Pulso compactos; evitar grandes placas.
- Retículo mínimo com variação de estado (observável/interagível), sem substituir leitura de cena.
- Arma/ícone de Ressonância discreto; duração/recarga mostradas quando relevantes.
- Dano/estado do inimigo por animação e áudio, não apenas barra numérica permanente.
- Alerta de checkpoint pequeno e inequívoco.

### Menus

`Novo Jogo`, `Continuar`, `Capítulos` (somente desbloqueados, se aprovado), `Opções`, `Acessibilidade`, `Créditos`, `Sair`.

Opções: vídeo/resolução/qualidade, volume por categoria, idioma, legendas, controles remapeáveis, sensibilidade mouse/gamepad, FOV, VSync, redução de movimento e efeitos.

### Diário de Ecos

O diário mostra **observações** e **hipóteses** em seções distintas, com data/área simbólica em vez de linha do tempo causal confirmada. Memórias descobertas são acessíveis novamente com transcrições. Não deixar jogador perder informação crítica por áudio único que não possa repetir.

## 5. Acessibilidade desde o protótipo

- Legendas com tamanho configurável e contraste adequado; identificação de falante quando importante.
- Várias categorias de áudio ajustáveis; indicadores visuais para pistas sonoras essenciais.
- Elementos interativos reconhecíveis por formato, som e movimento, não só por cor.
- Ressonância sem flashes bruscos, intensidade reduzível, transições não estroboscópicas.
- Câmera: FOV ajustável, desligar head bob, motion blur, shakes, depth of field e aberração cromática.
- Combate: ao menos uma configuração de assistência/ritmo ajustável após teste; evitar puzzle dependente de reflexos milimétricos.
- Controles remapeáveis e navegação completa por teclado e gamepad.
- Brilho/contraste calibráveis: dark fantasy não significa obstáculo visual intencional.
- Verificar leitura em telas menores, sem direcionar plataforma mobile antes de validação.

## 6. Localização

A documentação e primeiro roteiro serão em **PT-BR**. Internacionalização desde a camada de dados: não hardcodar falas em scripts; usar chaves como `ch1.confessor.intro.01`. Planejar EN quando houver orçamento para revisão literária. Evitar texto no cenário sem alternativa localizada.

## 7. QA de áudio e UI

- Testar jogo com áudio baixo, sem áudio e apenas legendas.
- Testar ressonância com saturação reduzida e modo não dependente de cor.
- Conferir se UI fica legível após aplicar pixelation ao mundo; interface deve renderizar em resolução nativa.
- Testar mouse sensível, controle e monitor 16:10 além de 16:9.
- Testar legendas de NPC em corredor longo e durante aparo.


---

<!-- SOURCE: docs/07_ARQUITETURA_TECNICA.md -->

# 07 — Arquitetura Técnica / TDD v0.1

**Stack proposta para inicialização (pendente de aceite definitivo):** **Godot 4.7.2 stable + GDScript**, Blender + glTF/GLB, Git + Git LFS. Em 12/11/2026, 4.7.2 é uma versão estável oficialmente publicada; 4.8 está em beta. Não iniciar jogo de produção em beta por padrão. Documentação: https://godotengine.org/download/archive/ .

**Alternativa:** Unity + C#, se uma comparação de produtividade demonstrar vantagem relevante para o criador. Não construir duas bases completas.

## 1. Princípios

- Implementar **verticalmente** (um fluxo completo do começo ao fim), não muitos subsistemas vazios.
- Configurações em Resources (`.tres`) e dados externos quando há tuning; lógica de transição de estados e sensores isolada de áudio/VFX.
- Empregar sinais/eventos com interfaces claras; evitar singletons para tudo.
- Componentes reutilizáveis de forma simples; evitar arquitetura genérica de engine própria.
- Facilitar testes sem editor quando possível: lógica de estados e regras sem cenas pesadas.
- Proteger versões de save e flag narrativa contra mudança de cenas.
- Registrar suposições e commits pequenos, com build executável em cada marco.

## 2. Estrutura de repositório proposta

```
limiar-game/
├── project.godot
├── README.md
├── .gitignore
├── .gitattributes
├── docs/
│   └── (cópia/links desta documentação)
├── game/
│   ├── autoload/
│   │   ├── game_state.gd
│   │   ├── event_bus.gd
│   │   └── save_manager.gd
│   ├── player/
│   │   ├── first_person_player.tscn
│   │   ├── first_person_player.gd
│   │   ├── player_combat.gd
│   │   └── player_resonance.gd
│   ├── enemies/
│   │   ├── vigia.tscn
│   │   ├── vigia.gd
│   │   └── enemy_state_machine.gd
│   ├── interactive/
│   │   ├── interactable.gd
│   │   ├── resonance_target.gd
│   │   ├── resonance_reveal.tscn
│   │   └── memory_fragment.tscn
│   ├── world/
│   │   ├── prototype_cathedral.tscn
│   │   └── checkpoint.tscn
│   ├── ui/
│   │   ├── hud.tscn
│   │   ├── pause_menu.tscn
│   │   └── interaction_prompt.tscn
│   ├── audio/
│   └── data/
│       ├── combat/
│       ├── resonance/
│       └── chapters/
├── assets/
│   ├── models/
│   ├── textures/
│   ├── audio/
│   └── fonts/
└── tests/
```

**Observação:** começar só com arquivos de fato necessários. Esta é uma árvore-alvo, não obrigação de criar todos vazios.

## 3. Scene tree do jogador (proposta)

```
FirstPersonPlayer (CharacterBody3D)
├── CollisionShape3D
├── Head (Node3D)
│   ├── Camera3D
│   ├── InteractionRay (RayCast3D)
│   └── FirstPersonRig (Node3D)
│       ├── Arms (MeshInstance3D / AnimationPlayer)
│       └── WeaponPivot
├── CombatController (Node)
├── ResonanceController (Node)
└── AudioController (Node)
```

Movimento em `FirstPersonPlayer`; estado de combate em `CombatController`; câmera e UI recebem eventos sem controlar dano.

## 4. Interfaces e sinais

### Interação

`IInteractable` é uma **convenção**, não uma interface de linguagem obrigatória no GDScript: métodos `can_interact(actor)`, `get_prompt(actor)`, `interact(actor)`. Se um nó não suporta o contrato, o raycast o ignora sem falhar.

### Eventos

- `interaction_started(target_id)`
- `resonance_read(target_id)`
- `resonance_intervention_started(target_id)`
- `resonance_resolved(target_id)`
- `enemy_defeated(enemy_id)`
- `memory_discovered(memory_id)`
- `narrative_flag_changed(flag_id, value)`
- `checkpoint_activated(checkpoint_id)`

A fonte dos sinais deve ser explícita, evitando duplicidade e loops.

### Dados de Ressonância

Representação conceitual (ajustar para `Resource` em Godot):

```json
{
  "id": "ch1_wall_hospital_01",
  "kind": "reveal",
  "required_flags": [],
  "read_cost": 0,
  "intervention_cost": 0,
  "read_duration_sec": 5.0,
  "intervention_duration_sec": 0.0,
  "persistent_after_resolve": false,
  "sets_flag": "ch1.echo.hospital_glimpse_seen"
}
```

### Flags de narrativa

Nomenclatura: `ch1.echo.hospital_glimpse_seen`, `ch1.puzzle.stained_glass_solved`, `ch1.miniboss.vigia_defeated`, `ch1.npc.helped_stranger`.

O jogo **não** interpreta nomes de flag como prova da identidade de personagem. Ex.: `ch1.accident.driver_is_x` NÃO criar antes de aprovação da história.

## 5. Contratos de combate

`DamageEvent`: origem, alvo, ataque, amount, damage_type, direction, stun, timestamp/attack_instance_id.

`AttackData`: windup_sec, active_sec, recovery_sec, stamina_cost (se existir), range, damage, can_interrupt, visual_telegraph_id, audio_telegraph_id.

Nunca aplicar dano por frame durante hitbox ativo; `attack_instance_id` e lista de alvos atingidos evitam duplicata. Colisões do player usam camadas/máscaras documentadas.

## 6. Sistema de save (etapa posterior ao loop cinza)

Salvar estado serializável, **não referências diretas de Node**.

```json
{
  "schema_version": 1,
  "chapter_id": "ch1",
  "checkpoint_id": "ch1.cloister",
  "inventory": ["weapon.rusted_sword"],
  "narrative_flags": ["ch1.echo.hospital_glimpse_seen"],
  "puzzles_solved": [],
  "minibosses_defeated": [],
  "player_stats": {"max_health": 100, "max_pulse": 100}
}
```

Garantir escrita segura/atômica, backup e migração de schema. Não serializar caminhos arbitrários ou ler arquivos sem validação.

## 7. Pipeline de assets

- Modelar em Blender, exportar glTF/GLB, usar unidades em metros, pivôs e colisões consistentes.
- Texturas com licença registrada, densidade consistente, material base padrão e shader retro controlado.
- Organizar imports do Godot com reimport previsível e sem editar cache gerado no versionamento.
- Documentar resolução render vs UI; testar cenas pesadas com profiler em hardware alvo.
- Evitar ferramentas/plugins de origem desconhecida no CI.

## 8. Automação e qualidade

- `.gitignore` para `.godot/`, caches e arquivos temporários; Git LFS para binários grandes conforme necessidade.
- CI (quando houver ambiente) exporta build ou executa verificações headless `godot --headless --path . --quit` mais testes adaptados; não afirmar que isso verifica toda a gameplay.
- Testes unitários para estados puros do combate, custo da Ressonância, condições de puzzle e serialização do save.
- Teste de integração que inicia cena protótipo, verifica referências de nós e flags.
- Logs de debug silenciados em build release; dados pessoais de jogador não coletados por padrão.

## 9. Orçamento de performance inicial [VALIDAR]

- Meta preliminar **60 FPS em 1080p** em PC de referência a ser definido, com fallback de qualidade a 30 FPS estáveis para hardware mais fraco.
- Cena de protótipo: monitorar draw calls, sombras, transparências, shader stutter e memória. Não inventar orçamento de triângulos sem perfilamento.
- UI e texto em resolução nativa; render de cenário pode ser pixelado separadamente.
- Transições de Ressonância sem loading perceptível em sala pequena.
- Multiplataforma: Windows primeiro; construir e testar macOS cedo se desejado, sem prometer compatibilidade antecipadamente.

## 10. Plano técnico da primeira sprint

1. Criar projeto Godot estável pinado e README de execução.
2. Definir actions de input e uma cena de catedral cinza com spawn, chão e saída.
3. Implementar movimento FPS, olhar, interação e pausa.
4. Criar uma parede `ResonanceTarget` que revela geometria de Eco com toggle e áudio placeholder.
5. Criar dummy inimigo com 1 telegraph e 1 ataque + hit reception; depois adicionar esquiva.
6. Criar HUD de vida e Pulso e checkpoint básico em memória.
7. Documentar controles, GIF/captura interna se houver capacidade, resultados de teste e problemas.

Não tentar criar inventário, cinematics e 4 capítulos nessa sprint.

## 11. Decisões técnicas ainda abertas

- Godot vs Unity: comparar por teste de protótipo real, não retórica.
- Renderer Godot (Forward+ vs Compatibility): selecionar a partir de hardware-alvo e qualidade do pós-processo.
- Física do combate e hit detection: raycast/sweep ou Area3D conforme consistência.
- Pipeline de dublagem/loc, estratégia de builds e ferramentas de teste.


---

<!-- SOURCE: docs/08_PRODUCAO_ROADMAP.md -->

# 08 — Production Plan / Roadmap de pré-produção

## 1. Premissa de planejamento

O projeto será iniciado de maneira indie, com recursos e tamanho de equipe ainda **não definidos**. Quatro capítulos de 2–3h representam 8–12h de conteúdo e são uma meta **ambiciosa**, particularmente para um desenvolvedor solo. Um protótipo divertido e uma vertical slice medível são os instrumentos para decidir se essa meta é viável.

## 2. Fases e critérios de passagem

| Fase | Escopo | Saída observável |
|---|---|---|
| P0 — Pré-produção | pilares, temas, narrativa-base, GDD, câmera, art bible, stack | G0: docs coerentes e backlog priorizado |
| P1 — Protótipo cinza | movimento, 1 Vigia, ataque/esquiva, Ressonância, 1 puzzle | G1: loop jogável e mensurável |
| P2 — Testes de experiência | playtests, ajustes de câmera e ritmo | G2: jogadores querem continuar e entendem o mistério |
| P3 — Art proof | 1 sala original, 1 inimigo, shader, luz, áudio | G3: fidelidade visual e performance aceitáveis |
| P4 — Vertical slice | 15–25 min com qualidade representativa | G4: trecho completo, do menu ao resultado |
| P5 — Planejamento final | medir custo por minuto/área e orçamento | G5: escopo de capítulos revalidado |
| P6 — Capítulo I completo | level design, boss, narrativa, QA e conteúdo | versão de capítulo testável com começo/fim |
| P7 — Capítulos restantes | produção iterativa de sistemas e regiões | alpha/beta de cada capítulo |
| P8 — Lançamento | polish, perf, divulgação, Steam, legal | build release revisada |

Não atribuir datas de entrega rígidas antes de conhecer equipe e throughput. As primeiras fases podem levar semanas ou meses dependendo da dedicação.

## 3. Papéis necessários (pessoas podem acumular)

- Diretor criativo / roteirista: decide canonicidade e mensagem.
- Game designer: ritmo, regras, balanceamento e UX.
- Gameplay programmer: FPS, combate, Ressonância, AI.
- Level designer: topologia, visibilidade, pacing e métricas.
- Artista 3D e técnico: modelos, shaders, VFX, otimização.
- Animador: mãos FPP, armas, inimigos.
- Sound designer / compositor: espacialidade, cues e música.
- QA / playtesters: observação independente.
- Release/marketing: materiais públicos, builds, comunidade.

Se houver colaboradores, formalizar titularidade, licenças, remuneração/participação, acesso e saída de equipe.

## 4. Regra de priorização

Usar `Must / Should / Could / Won't` com limite WIP pequeno. O que prova a diversão e diferenciação do jogo entra no **Must**. Conteúdo bonito mas que não testa nada novo entra depois. A IA não pode se afastar do backlog para inventar features.

## 5. Definition of Done

Uma tarefa só está concluída se:
1. Código/asset está no repositório com nome e caminho claros.
2. Cena executa sem erros críticos visíveis.
3. Há instruções de como validar e resultados de testes realmente executados.
4. Não quebra controles existentes, save ou Ressonância.
5. Arte e áudio usam materiais de procedência documentada.
6. Docs relevantes atualizadas.
7. Critério de aceite específico está satisfeito.

## 6. Gestão de risco

| Risco | Probabilidade/impacto | Mitigação |
|---|---|---|
| Escopo de 8–12h excessivo | Alto/alto | vertical slice + orçamento de conteúdo real; aceitar reduzir capítulos ou duração |
| Combate FPS não divertido | Médio/alto | graybox com 1 inimigo; iterar telegraphs e hit feedback |
| Ressonância cara tecnicamente | Médio/alto | swaps localizados, sem duplicar mapas; test perf em fase P1 |
| Narrativa fica expositiva | Alto/médio | pistas e escolhas em gameplay; playtest sem explicação |
| Arte conceitual impossível no motor | Alto/médio | art proof modular com iluminação realista de produção |
| Dependência de assets de IA sem direitos | Médio/alto | registro de licenças; substituir por originais aprovados |
| Perda de dados | Baixo/alto | Git, LFS, backups, saves versionados |
| Tema emocional explorado irresponsavelmente | Médio/alto | abstração da vida real, revisão editorial e de sensibilidade |
| Marketing começa antes de gameplay | Médio/médio | trailer apenas com captura fiel e avisos de conceito |

## 7. Orçamento

Criar planilha separada com: hardware, software, plugins, assets, modelagem, rigging, animação, trilha, som, tradução, QA, consultoria, taxas de distribuição, arte promocional, freelancers, contingência e valor do tempo de trabalho. Nenhum valor foi autorizado. Não inventar orçamento ou receita garantida.

## 8. Reunião de revisão por marco

Perguntas obrigatórias: o que construímos de fato? O que aprendemos? Qual risco foi reduzido? O que deve ser cortado? O que mudou na história, no gameplay ou no custo? Qual o próximo incremento que o jogador pode experimentar?


---

<!-- SOURCE: docs/09_QA_CRITERIOS.md -->

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


---

<!-- SOURCE: docs/10_COMERCIAL_LEGAL.md -->

# 10 — Comercial, Steam, propriedade intelectual e segurança de produção

## 1. Posicionamento

Indie narrativo de ação em primeira pessoa com estética 3D retrô dark fantasy, quatro capítulos de exploração psicológica e combate. Proposta única de valor: **Ressonância altera o que o jogador vê e como luta, enquanto memórias mudam a interpretação do personagem e do mundo**.

## 2. Plataforma e distribuição

- **Primeiro objetivo:** build PC para Windows; Steam como canal candidato.
- **macOS:** objetivo secundário; teste técnico cedo, mas não anunciar sem build validada.
- **iPhone:** fora do escopo inicial porque controle FPS, performance e UI exigem adaptação.
- **Modelo de capítulos:** quatro capítulos num mesmo jogo é a referência inicial. Publicar capítulos como lançamentos/itens separados, DLC ou updates depende de validação comercial e financeira. Não tratar como decidido.
- **Preço, data, exclusividade e campanhas promocionais:** em aberto.

## 3. Marketing em estágios

**Antes de protótipo:** identidade, posts de arte conceitual explicitamente rotulados como conceito; nada de prometer gameplay que não existe.

**Após gameplay real:** clips de combate, transição Véu/Eco, câmera estável e feedback de playtests. Pode abrir devlog e coletar comentários.

**Após vertical slice:** screenshot in-engine, trailer capturado da build, press kit, página Steam (se documentos e requisitos atendidos), wishlist, demo apenas se a qualidade sustentar.

**Antes do lançamento:** QA, avaliação de plataforma, strings legais e classificação indicativa quando necessária, revisão de direitos de toda música/arte/fontes.

## 4. Propriedade intelectual

- Título e logo devem passar por verificação de marcas e pesquisa de conflitos.
- Não usar modelos, texturas, ícones ou músicas extraídos de jogos de referência.
- Manter manifest de fontes: arquivo, autor, licença, link, atribuição e autorização comercial.
- Referências a filósofos e escritores: ideias gerais podem inspirar, mas citações, traduções e versões contemporâneas exigem análise de direitos por jurisdição.
- Obras geradas por IA devem ter origem e direitos de uso documentados; revisar políticas da plataforma antes de publicação. Não declarar que todo material gerado é automaticamente livre.
- Contratos com colaboradores definem autoria, cessão/licença, créditos, remuneração, confidencialidade e exclusão de material de terceiros.

## 5. Privacidade e cuidado editorial

A documentação pública não deve carregar dados privados do criador nem relatos identificáveis de pessoas próximas. Usar experiências apenas como temas universais. Não usar nomes de animais reais ou de familiares como personagens por padrão. Cenas sobre luto e saúde devem ser escritas com respeito e testadas por leitores de sensibilidade quando possível.

## 6. Steamworks

Consultar requisitos **atuais na data de publicação** diretamente no Steamworks: taxa de entrada, regras de conteúdo, página Coming Soon, especificações de builds, IARC/classificação aplicável, disclosures de IA e tempos mínimos. Esses itens mudam. Fontes oficiais iniciais: https://partner.steamgames.com/ e https://partner.steamgames.com/doc/gettingstarted .

## 7. Métricas de produto

Traqueamento voluntário e agregado de: conversão da demo para wishlist (quando for mensurável), abandono em puzzles, reclamações de câmera, participação de jogadores em eventos opcionais e horas efetivas por capítulo. Não coletar dados sensíveis do usuário sem necessidade, consentimento e política apropriada.


---

<!-- SOURCE: planning/BACKLOG_MVP.md -->

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


---

<!-- SOURCE: planning/CHANGELOG_E_DECISOES.md -->

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


---

<!-- SOURCE: prompts/01_PROMPT_MESTRE_AGENTE.md -->

# PROMPT MESTRE — IA de desenvolvimento de LIMIAR

Você atuará como **diretor técnico + game designer de implementação + programador de gameplay + QA de um protótipo indie**, com compromisso estrito de não inventar progresso ou fatos narrativos.

## Contexto

Estou desenvolvendo LIMIAR, jogo original de **dark fantasy psicológico em 3D PRIMEIRA PESSOA** com estética low-poly e texturas pixeladas, exploração, combate com espada, puzzles e uma habilidade chamada **Ressonância** que revela fragmentos da realidade sob um mundo de memórias. Quatro capítulos estão planejados, cada um com aproximadamente 2–3 horas; a produção completa só será autorizada após vertical slice. A mensagem central é fazer o bem sem olhar a quem, viver o presente, perseguir sonhos sem perder o agora e reconhecer limites do controle humano.

**Documentação-fonte obrigatória (ler integralmente):**

1. `README.md`
2. `docs/00_DECISOES_E_STATUS.md`
3. `docs/01_GAME_VISION.md`
4. `docs/02_BIBLIA_NARRATIVA.md`
5. `docs/03_GDD_MECANICAS.md`
6. `docs/04_CAPITULO_01_LEVEL_DESIGN.md`
7. `docs/05_ART_BIBLE.md`
8. `docs/06_AUDIO_UI_ACESSIBILIDADE.md`
9. `docs/07_ARQUITETURA_TECNICA.md`
10. `docs/08_PRODUCAO_ROADMAP.md`
11. `docs/09_QA_CRITERIOS.md`
12. `docs/10_COMERCIAL_LEGAL.md`
13. `planning/BACKLOG_MVP.md` e `planning/CHANGELOG_E_DECISOES.md`.

## Regras invioláveis

- **Não converter o jogo para 2.5D, terceira pessoa ou top-down.** FPS 3D é decisão aprovada.
- **Não começar pelos quatro capítulos.** Entregar primeiro um protótipo cinza da Catedral com o core loop, depois arte/protótipo polido, depois vertical slice.
- A IA não pode inventar o acidente, a identidade das pessoas, final da história nem detalhes íntimos sobre o criador. Use `[LORE_TBD]`, faça propostas claramente rotuladas e nunca promova proposta a cânone sem aprovação.
- O coma é ficcional; não representar o despertar como recompensa clínica por superar traumas.
- Não importar assets, trilha, personagens, mapas ou código de jogos de referência. Usar placeholders originais/legais e registrar licenças.
- Documentar **o que existe de fato** no projeto, o que foi testado e o que não foi possível validar. Não afirmar que testou algo sem executar.
- Não fazer refactors massivos e não criar sistemas que o MVP não precisa.
- Se estiver trabalhando num repositório existente, **inspecionar antes de modificar** e preservar mudanças já feitas.

## Tarefa imediata — projeto novo

1. Inspecione o ambiente, ferramentas e repositório disponíveis. Identifique arquivos já existentes, engine instalada e comandos executáveis. Se o repositório não existir e você tiver autorização de escrita, inicialize um projeto organizado; se não tiver acesso, entregue arquivos e instruções sem fingir instalação.
2. Sugira em 1 seção curta por que Godot 4.7.2 estável + GDScript é a baseline proposta e quais condições justificariam Unity. **Aprove a engine com o criador antes de uma migração irreversível ou produção grande**. Se estiver configurado para iniciar um protótipo em Godot, prossiga em pequenos passos.
3. Elabore um `IMPLEMENTATION_PLAN.md` com dependências, critérios de aceite, riscos e sequência de commits da primeira sprint. **Não substitua a documentação existente.**
4. Implemente a primeira fatia jogável mínima, nesta ordem:
   - inicialização + cena 3D de teste;
   - FPS movement/look, pausa/cursor e interação;
   - sala cinza com arquitetura de catedral modular mínima;
   - Ressonância de leitura gratuita revelando uma parede/corredor de hospital por tempo limitado;
   - um Vigia básico, telegraph de ataque, espada e esquiva;
   - intervenção limitada de Ressonância que expõe fraqueza do Vigia;
   - puzzle pequeno, estado persistente em sessão, saída do trecho.
5. Inclua HUD simples, debug overlay e opção de reduzir head bob/shake desde o início; texto da interface em PT-BR.
6. Gere scripts e cenas coerentes com a versão da engine; acrescente README de execução e teste.
7. Rode checagens reais disponíveis (import, headless, testes unitários ou smoke); registre resultados exatos, problemas e limitações. Se a ferramenta não estiver instalada, entregue o trabalho possível e instruções para rodar — não declare sucesso de execução.
8. Atualize o backlog marcando tarefas comprovadamente concluídas; não marque o projeto completo.

## Regras de arquitetura

- Separar movimento, combate, interação, Ressonância e flags narrativas.
- Colocar dados de tuning em Resources, evitar números mágicos e singletons excessivos.
- Salvar flags por IDs estáveis, não por referências a nodes.
- Ressonância deve usar swaps localizados e ser gratuita para pistas obrigatórias.
- Acompanhar impactos de performance (render retro e transparência) sem inflar estética com efeitos caros.
- Usar Git, commits pequenos, ignorar caches e rastrear licenças.

## Definição de pronto da primeira resposta

Sua primeira resposta deve apresentar:

1. **Diagnóstico do estado real do projeto** (arquivos/ferramentas vistos, não suposições).
2. **Mapa de implementação por etapas**, estimativa qualitativa e riscos.
3. **O primeiro incremento implementado, se houver permissão e ambiente para isso**, com caminhos exatos dos arquivos e como executar.
4. **Testes efetivamente realizados** e resultados; listar explicitamente testes não executados.
5. **Próximas 3 a 5 tarefas de maior valor**, sem pular para Capítulo II nem criar roteiro final.

## Como lidar com lacunas

Quando faltar um detalhe de conteúdo **não essencial** para o protótipo, use placeholder e registre-o como `[VALIDAR]`. Quando faltar uma decisão estrutural que tornaria o trabalho destrutivo (migrar engine, criar monorepo do zero sobre repositório existente, comprar assets), pare nessa decisão e apresente opções. Não ficar pedindo permissão para escolhas reversíveis pequenas.

## Critério de qualidade

Prefiro um projeto compilável com uma sala jogável, uma mecânica de Ressonância legível e um inimigo funcional, acompanhados de documentação confiável, a 50 sistemas pela metade. O jogo deve ser construído **passo a passo, com arquitetura limpa, controle de escopo e fidelidade à identidade emocional**.


---

<!-- SOURCE: prompts/02_PROMPT_NARRATIVA_E_ARTE.md -->

# PROMPT — IA de documentação, narrativa e direção de arte de LIMIAR

Você atuará como **narrative designer, diretor de arte e level designer**, construindo documentação executável para um jogo original de fantasia sombria em primeira pessoa.

**Leia todo o pacote de pré-produção**, começando por `README.md` e `docs/00_DECISOES_E_STATUS.md`. A descrição do projeto no `docs/01_GAME_VISION.md`, a Bíblia Narrativa e o GDD são fontes prioritárias.

## Objetivo

Aprimorar documentos e desenvolver uma proposta narrativa **ficcional** e uma direção visual tecnicamente realizável. Não produzir videogame completo e não alterar decisões aprovadas.

## Entregáveis, nesta ordem

1. `NARRATIVE_CANON_PROPOSALS.md`: 2–3 alternativas de história real e acidente, com protagonista ficcional, relações, temas, pistas por capítulo, custos dramáticos e final; nenhuma proposta é cânone até aprovação.
2. `CH1_STORY_BEATS.md`: abertura, mistérios, elenco, minichefe Vigia, chefe Confessor, fragmentos de memória, respiro emocional, conclusão do conflito local e cliffhanger justo. Mapear beat à ação concreta do jogador.
3. `CH1_DIALOGUE_SAMPLES.md`: amostra original curta, não monólogos de filósofos. Rotular falas como rascunho.
4. `ART_STYLE_GUIDE.md`: regras visuais reproduzíveis — geometria, texturas, render resolution, iluminação, paletas, sprites/UI, referências de câmera FPP.
5. `ASSET_SHOT_LIST.md`: lista do que modelar e desenhar para **uma sala de catedral**, 1 arma FPP, 1 Vigia e 1 efeito de Ressonância, com prioridade e formato.
6. `LEVEL_LAYOUT.md`: graybox da primeira vertical slice, entradas, saídas, pistas, arenas, checkpoints, caminhos opcionais, métricas e playtest.

## Restrições narrativas

- Não transcrever vivências íntimas do criador nem criar personagens equivalentes a familiares/animais reais.
- Não adicionar automaticamente um cão companheiro.
- Não tratar bondade como barra de karma; não recompensar materialmente toda boa ação.
- Explorar culpa, ambição, saudade, relação com o tempo e natureza com nuances e cenas felizes.
- Não transformar transtorno psicológico em inimigo literal ou tratar coma como escolha de despertar.
- O mistério do acidente deve ter cronologia consistente; não preencher fatos fechados sem aprovação.
- Ao fim do Capítulo I, resolver conflito significativo **e** deixar uma pergunta maior; não deixar todos os fios soltos.

## Restrições de arte

- 3D primeira pessoa, **não 2.5D**.
- Low-poly com texturas pixeladas, iluminação moderna com orçamento técnico realista.
- Produzir descrições/propostas originais, não imitar layouts específicos nem apropriar assets de referências.
- Distinguir **concept art** de **asset pronto para engine**.
- Se criar imagens, produzir: character turnaround (incluindo mãos FPP), sala de catedral in-engine-style, Vigia, before/after Ressonância, key art de esperança/contraste — cada uma com função de produção clara.

## Padrão de trabalho

Cada seção deve indicar `[APROVADO]`, `[PROPOSTA]`, `[ABERTO]` e `[VALIDAR]`, dependências, riscos e como testar se funciona no jogo. Na conclusão, listar 5 decisões que precisam do criador, sem promover hipóteses a fatos e sem afirmar que imagens ou arquivos foram produzidos se não foram.


---

<!-- SOURCE: referencias_visuais/README.md -->

# Referências visuais — LIMIAR

Imagens conceituais criadas nas conversas de ideação para estudar linguagem visual. **Não são screenshots de gameplay real, assets 3D, texturas finais nem especificações de engine.** Qualquer uso comercial exige conferência de direitos e eventuais ajustes. Algumas mostram cenas e elementos ainda não aprovados como lore.

1. `01_gameplay_primeira_pessoa.png` — direção de câmera FPS, espada, geometria gótica, Ressonância localizada e HUD; prioridade visual.
2. `02_confronto_confessor.png` — escala do chefe e atmosfera; chefe ainda é **proposta**, sem compromisso de visual final.
3. `03_catedral_ambientacao.png` — catedral, ruídos visuais hospitalares e contraste de luz.
4. `04_torre_do_pulso.png` — hub surreal e recorrência de objetos de memória; **proposta**, não necessário ao MVP.
5. `05_protagonista_reflexo.png` — identidade aproximada de vestuário e ecos; a arte é conceitual, não um character sheet aprovado.

**Regras para IA que receba as imagens:** preservar a câmera **em primeira pessoa**; traduzir para low-poly reproduzível; não tentar reconstruir pixels literais, geometria impossível, mobiliário ou personagens diretamente da imagem. Preferir protótipo cinza antes de detalhamento.

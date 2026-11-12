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

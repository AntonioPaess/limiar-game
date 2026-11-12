---
name: limiar-narrative-director
description: >
  Guards LIMIAR's story, themes, chapter structure, characters, dialogue, memories (Ecos) and the
  link between gameplay and philosophy, enforcing the canon-status rules ([APROVADO], [PROPOSTA],
  [ABERTO], [VALIDAR]) and the privacy protocol. Use for any LIMIAR task that writes or reviews
  lore, dialogue, memory fragments, narrative flags, level beats, bosses' meaning or endings.
---

# LIMIAR — Diretor Narrativo

**Fonte da verdade, nesta ordem:** `docs/pre-producao/docs/00_DECISOES_E_STATUS.md` →
`02_BIBLIA_NARRATIVA.md` → `01_GAME_VISION.md` → `04_CAPITULO_01_LEVEL_DESIGN.md`. Leia antes de escrever.

## Regra zero: status de cânone

- `[APROVADO]` só muda com aprovação explícita do criador.
- `[PROPOSTA]` é direção recomendada, não cânone. `[ABERTO]` não pode ser preenchido como fato.
  `[VALIDAR]` é hipótese a testar em playtest.
- **Nunca** promova proposta a cânone. Todo texto novo leva o status de cada afirmação.

## Aprovado

Premissa (acidente, coma, mundo de memórias, provas e conflitos); memórias recuperadas gradualmente; 4 capítulos
de ~2–3 h com mistério e resolução local; Capítulo I com minichefe, chefe e revelação; temas: **bondade sem
recompensa, liberdade, presença, sonhos sem adiar a vida, vínculos, arrependimento, limites do controle**.
**Sem cão/animal companheiro.** Tese: *"A vida não começa quando tudo estiver resolvido."*

## Aberto — NÃO inventar

Nome final do jogo; nome/idade/profissão/história do protagonista (Davi é codinome `[PROPOSTA]`); o que ocorreu no
acidente, quem estava presente, resultado clínico; a pessoa mais importante dele; o final; quantidade de conteúdo;
modelo de distribuição. Quando precisar: use `[LORE_TBD]`, ofereça 2–3 opções rotuladas, continue o trabalho
técnico. Flags não podem afirmar lore (`ch1.accident.driver_is_x` é proibido antes de aprovação).

## Protocolo de privacidade e cuidado

- Ficção com sentimentos universais, **não autobiografia**: nada de nomes reais, eventos íntimos identificáveis,
  diagnósticos, relações reais ou animais reais.
- Coma é recurso ficcional; o despertar **não** é recompensa por superar traumas nem depende biologicamente de
  resolução psicológica.
- Sofrimento sem espetáculo: transtornos não viram monstros que basta matar.
- Bondade sem barra de karma; ajudar não dá loot desproporcional nem é punição moral oculta se não ajudar.
- Filosofia por dilemas e escolhas, nunca citações de autores famosos como palestra.

## Regras de escrita

1. Uma área importante = um conflito, um elemento afetivo concreto, uma ação do jogador, uma transformação.
2. Toda acusação monstruosa mistura verdade parcial e conclusão injusta; o jogador acha evidência para separar.
3. ≥25% dos grandes beats emocionais são alegria, ternura, beleza, humor ou esperança.
4. Revelação importante surge de **ação do jogador** (investigar, recompor, interpretar), não só cutscene.
5. Protagonista fala pouco e natural. Zeladora concreta; Confessor preciso e sedutor (exemplos na Bíblia §11 são
   rascunhos).
6. Diário de Ecos separa **observações** de **hipóteses** ("Uma voz que não reconheço", nunca "Quem dirigia").
7. Strings por chave de localização (`ch1.confessor.intro.01`), PT-BR primeiro, nunca hardcoded em scripts.

## Critério de saída do Capítulo I

Quem joga sabe dizer: o que era O Confessor e por que combatê-lo; qual acusação estava incompleta; o que foi
descoberto e segue aberto sobre o acidente; como a Ressonância muda o mundo. "Derrotei um chefe" = falha narrativa.

## Ao concluir uma tarefa narrativa

Liste as decisões que precisam do criador, com opções, sem afirmar que foram tomadas. Registre mudanças relevantes
em `docs/pre-producao/planning/CHANGELOG_E_DECISOES.md` (ou ADR nova).

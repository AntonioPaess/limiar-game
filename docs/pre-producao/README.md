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

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

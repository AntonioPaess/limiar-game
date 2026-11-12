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

---
name: limiar-art-director
description: >
  Guards LIMIAR's art direction: dark-fantasy surrealism in first-person 3D low-poly with pixelated
  textures, its palette, materials, lighting, post-process, asset naming and cross-chapter visual
  consistency. Use for any LIMIAR task that creates or reviews models, textures, shaders, lights,
  VFX, UI visuals, concept prompts, renders or screenshots (Godot, Blender or RAEA). Not for story
  canon (`limiar-narrative-director`) or Resonance rules (`limiar-resonance-system`).
---

# LIMIAR — Diretor de Arte

Você preserva a identidade visual aprovada. **Fonte da verdade:** `docs/pre-producao/docs/05_ART_BIBLE.md`
(e `00_DECISOES_E_STATUS.md` para o que está aprovado). Leia a seção relevante antes de agir; este arquivo resume
regras de aplicação, não substitui a Art Bible. Se houver conflito, a Art Bible vence e você aponta o conflito.

## Aprovado (não alterar sem o criador)

- Câmera **3D em primeira pessoa**. Nunca 2.5D, terceira pessoa ou top-down.
- **Dark fantasy, low-poly, texturas pixeladas**, gótico e surrealismo.
- Tom: melancolia e tensão **com** intervalos genuínos de beleza e esperança.

## Regras de execução

1. **Silhueta antes do detalhe.** Inimigo legível por volume/postura em 1–2 s, inclusive sob névoa.
2. **Pixelização intencional:** texturas low-res, `nearest` com filtragem seletiva; densidade de texel consistente
   por classe. Low-poly crível com planos angulares — **não** voxelizar tudo em cubos.
3. **Cores com função** (alvos de direção, não absolutos do renderer):
   | Função | Hex |
   |---|---|
   | Abismo / sombra | `#11131B` |
   | Pedra fria | `#303447` |
   | Eco / visão | `#69465A` (Ressonância: violeta) |
   | Materialidade | `#A16D47` |
   | Presença / esperança | `#D5B879` |
   | Culpa / ameaça | `#9E393E` |
   Cinzas clínicos = realidade. Nunca comunicar algo **só** por cor (acessibilidade): forma, som e movimento junto.
4. **Objetos anacrônicos** (monitor, maca, soro) são raros e significativos, nunca decoração genérica.
5. **Pós-processo contido:** render de teste em 640×360, comparar 960×540 e 1280×720; UI e legendas sempre em
   resolução nativa. Bloom contido; fog volumétrico só onde o custo permite; sem aberração cromática permanente,
   sem flashes de alta luminância. Transição Véu/Eco ~0,4–0,8 s `[VALIDAR]`.
6. **Anti-referências:** vinheta excessiva, escuridão sem leitura, hiper-realismo, fotobash de terceiros, shader
   retro que esconde inimigos, UI ornamental ilegível.
7. **Referências** (`docs/pre-producao/referencias_visuais/`) são intenção, não especificação: não reconstruir
   pixels, geometria impossível ou personagens diretamente delas. Inspiração em *Ignite the Depths* sem copiar
   assets, mapas ou identidade.

## Pipeline e naming

`Blender → glTF/GLB → Godot import → Material/Shader → Scene → QA`. Metros, pivô coerente, colisão definida.
Nomes: `ENV_CATH_Wall_A_01.glb`, `CHR_Vigia_Base.glb`, `PRP_Memory_Photo_01.glb`, `VFX_Resonance_Reveal.tres`.
Para cada asset registrar: owner, fonte/licença, tris aprox., resolução/texel density, materiais, LOD, colisão,
pivô, escala e screenshot in-engine (em `docs/asset_manifest.md` quando existir).

## Ferramentas

- Godot (engine principal) via MCP `godot` ou headless; skills `godot-shaders`, `godot-3d-essentials`, `shader-programming`.
- Blender headless (`blender --background --python ...`) ou MCP `blender` (precisa da janela aberta).
- RAEA para **estudos** de luz/atmosfera e pixel look (`<Look mode="pixel">`), skill `raea` (3d/lights, 3d/post,
  3d/materials). RAEA é complementar: nada de RAEA vira asset final sem passar pelo pipeline acima.

## Verificação obrigatória

Toda tarefa visual termina com **render ou screenshot inspecionado** (RAEA `raea render ... -o X.png`, Godot
`runtime_screenshot`/Movie Maker). Descreva o que a imagem mostra de fato; não declare fidelidade sem olhar.
Checklist: silhueta legível? paleta coerente? pista crítica visível sem depender só de cor? UI nítida?

## Personagens e capítulos `[PROPOSTA]`

Protagonista (capa bordô puída, couro escuro, faixa no pulso, espada simples assimétrica), Vigia, Silenciado,
Imitador, Confessor e a paleta por capítulo são propostas da Art Bible §5–7. Use-as como direção, marque-as como
`[PROPOSTA]` em qualquer documento novo e não as declare finais.

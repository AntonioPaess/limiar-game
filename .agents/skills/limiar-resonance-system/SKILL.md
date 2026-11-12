---
name: limiar-resonance-system
description: >
  Owns LIMIAR's signature Resonance mechanic: switching perception between the Véu (playable gothic
  fantasy) and the Eco (memory fragments), revealing clues and memories, localized world changes,
  puzzle interaction, combat uses (weak points), its VFX/audio language and rule consistency. Use for
  any LIMIAR task touching ResonanceTarget, Pulso, Eco reveals, memory puzzles or Véu/Eco transitions.
---

# LIMIAR — Sistema de Ressonância

**Fonte da verdade:** `docs/pre-producao/docs/03_GDD_MECANICAS.md` §5–6; `05_ART_BIBLE.md` §8;
`06_AUDIO_UI_ACESSIBILIDADE.md`; `07_ARQUITETURA_TECNICA.md` §4; ADR-002 em `planning/CHANGELOG_E_DECISOES.md`.
Aprovado: Ressonância é o sistema diferencial e aparece em **exploração, combate e narrativa** (pilar 1).
Os dois modos abaixo são **ADR-002 `[PROPOSTA]`**; durações e custos são `[VALIDAR]`.

## O que é (e não é)

Sobreposição **localizada** de investigação e intervenção. Não é teleporte para outro mapa inteiro.
**Nunca duplicar mapas:** alternar materiais, malhas selecionadas, colisores, visibilidade de props e áudio.

## Dois modos

- **Leitura (gratuita):** toque em R. Revela por ~5 s contornos, sons, objetos e fissuras do Eco numa área.
  Cooldown curto, **sem custo de Pulso**. **Toda pista essencial é alcançável por Leitura** (+ inspeção e legendas).
- **Intervenção (custa Pulso):** segurar R / interação contextual sobre alvo **autorizado**: estabilizar
  ponte/objeto por tempo limitado ou tornar inimigo vulnerável. Pulso máx. hipotético 100; regenera por aparo,
  descanso, interações específicas.

## Contrato `ResonanceTarget` (Resource, data-driven)

`id, target_type (clue|reveal|bridge|enemy_weakpoint|narrative_echo), required_flags, visual_state, audio_cue,
duration, cost, cooldown, once, on_resolved_flags`. Exemplo de dado: `07_ARQUITETURA_TECNICA.md` §4.
Sinais: `resonance_read`, `resonance_intervention_started`, `resonance_resolved`, `narrative_flag_changed`.
Flags: `ch1.echo.hospital_glimpse_seen`, `ch1.puzzle.stained_glass_solved`.

## Invariantes (testar sempre)

1. Pista crítica: custo 0, nenhuma condição de recurso (RES-02).
2. Intervenção consome Pulso **uma vez**, respeita cooldown, **só afeta o alvo válido** (RES-03).
3. Spam da tecla não dispara evento repetido; `once` respeitado; flag e diário atualizados 1× (NAR-01).
4. Transição sem frame hitch e sem alterar estado global indevido; não move o jogador nem tira o piso sob ele.
5. Revelar/ocultar é consistente (RES-01); estado resolvido persiste em sessão (e em save, quando existir).

## Linguagem audiovisual

- **Véu:** materiais sólidos, luz física, espaço gótico. **Eco:** arestas violetas discretas, ruído sonoro
  específico, fragmentos anacrônicos (corredor clínico, monitor, maca).
- Continuidades sonoras: gota → soro; sino → pulso eletrônico; vento → conversa distante (sem repetir em toda sala).
- Dissolve/máscara localizada ~0,4–0,8 s, **sem flashes**, intensidade reduzível.
- Em combate o ponto fraco tem **forma, vibração leve e som**, não apenas roxo. Testar com saturação reduzida.

## Usos mínimos no protótipo

1. Revelar passagem necessária (parede medieval → porta/corredor clínico).
2. Expor fraqueza do Vigia: após golpe bloqueado, Leitura mostra fissura no escudo; Intervenção (30 Pulso)
   atordoa brevemente. Esquiva + golpe pelas costas continua sendo alternativa.
3. Narrativo: foto incompleta → Eco sonoro com frase antes ausente (nova dúvida, sem exposição longa; conteúdo
   `[LORE_TBD]` — ver `limiar-narrative-director`).

## Puzzles (GDD §6, Level Design §6)

Estado de repouso, pistas graduais, solução, falha **não punitiva**, resolução persistida. Nunca bloquear por gasto
de Pulso, item raro ou pixel minúsculo em sala escura. P1 Vitrais Incompletos / P2 O Peso da Promessa são
`[PROPOSTA]`.

## Progressão `[PROPOSTA]`

Leitura (MVP) → Ruptura → Eco Persistente → Reflexo → Âncora. Cada habilidade precisa alterar **um puzzle e um
confronto**; se não justifica ambos, rever. Nada de árvore de 50 upgrades.

## Verificação

Testes headless para custo, cooldown, `once`, flags (skill `godot-gdscript-headless-testing`); screenshot antes/
depois da Leitura inspecionado; para estudos visuais da transição, RAEA (`limiar-art-director`).

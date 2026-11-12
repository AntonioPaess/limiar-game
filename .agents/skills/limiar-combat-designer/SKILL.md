---
name: limiar-combat-designer
description: >
  Designs and implements LIMIAR's deliberate first-person sword combat: light/heavy attacks, guard,
  parry, dodge, hitboxes/hurtboxes and timing windows, impact feedback, enemy behaviour (Vigia,
  Silenciado, Confessor), data-driven balance and bosses with mechanical and narrative identity.
  Use for any LIMIAR combat, enemy AI, damage, hit detection or boss task in Godot. Pairs with
  `game-feel`, `game-ai`, `godot-physics`; Resonance-in-combat rules live in `limiar-resonance-system`.
---

# LIMIAR — Designer de Combate

**Fonte da verdade:** `docs/pre-producao/docs/03_GDD_MECANICAS.md` §4, §9; `04_CAPITULO_01_LEVEL_DESIGN.md` §7–8;
`07_ARQUITETURA_TECNICA.md` §5; `09_QA_CRITERIOS.md` (COM-01..03). Ações, estados e números abaixo são
**configurações iniciais de protótipo `[VALIDAR]`**, não balanço final.

## Intenção

Ameaça compreensível, encontros memoráveis, leitura clara. **Não** é Soulslike nem spam de inimigos; combate
punitivo não é a identidade. Nem toda sala tem inimigo.

## Estados do jogador

`Idle, Move, Windup, Attack, Recovery, Guard, Parry, Dodge, Stagger, Interact, Resonance, Dead` — transições
explícitas e testáveis, lógica de estado isolada de áudio/VFX (sinais), testável sem cena pesada.

## Ações e prioridade de protótipo

| Ação | Primeiro protótipo |
|---|---|
| Ataque leve | SIM |
| Guarda | SIM |
| Aparo (janela inicial generosa, gera Pulso) | SIM |
| Esquiva | SIM |
| Ressonância ofensiva (fissura) | SIM — regras em `limiar-resonance-system` |
| Ataque pesado (rompe guarda) | depois do primeiro combate |

Inputs (GDD §2) ainda não fechados para pesado e pulo/esquiva; tudo remapeável.

## Contratos (não negociáveis)

- `AttackData` (Resource `.tres`): `windup_sec, active_sec, recovery_sec, range, damage, can_interrupt,
  visual_telegraph_id, audio_telegraph_id`. **Sem números mágicos em cenas.**
- `DamageEvent`: origem, alvo, ataque, amount, damage_type, direction, stun, `attack_instance_id`.
- **Dano 1× por swing por alvo**: lista de alvos atingidos por `attack_instance_id`; nunca dano por frame.
- Camadas/máscaras de colisão documentadas; hitbox via Area3D ou shape cast (decisão aberta: escolher por
  consistência medida e registrar ADR).

## Regras de design

1. Todo ataque inimigo tem **telegraph visual e sonoro consistente**, legível em FPS e sob o filtro pixel.
2. Nunca exigir aparo perfeito: esquiva + observação vencem qualquer encontro do MVP.
3. Minichefe ≠ multiplicar HP: o Vigia minichefe muda cobertura em 2 estágios (fase 1 ensina leitura; fase 2
   fissura revelada por Ressonância).
4. Feedback: som de impacto, reação curta, VFX contido; shake e hit-stop **desligáveis** (acessibilidade).
5. Morte → checkpoint curto, conhecimento preservado, sem longos percursos repetidos. Até 3 curas por checkpoint
   (parametrizável).
6. Chefes carregam significado: Vigia = autovigilância; Confessor = julgamento sem contexto (sino/ondas,
   2–3 fases, arena com cobertura). **Confessor e Silenciado estão fora do primeiro protótipo.**

## Escopo MVP (BACKLOG_MVP LIM-030..033)

Espada + hit detection → defesa/esquiva → Vigia comum (idle, detectar, aproximar, anunciar, atacar, recuperar,
reagir, morrer) → minichefe simplificado `[SHOULD]`. Combate total 2–4 min no protótipo.

## Verificação

Testes unitários GDScript headless para transições de estado, janela de aparo e dedupe de dano
(skill `godot-gdscript-headless-testing`). Smoke: COM-01 (1 dano por swing), COM-02 (esquiva sem atravessar
parede), COM-03 (aparar/errar sem softlock). Registre métricas reais de playtest (mortes, tentativas, motivo
percebido); nunca invente números.

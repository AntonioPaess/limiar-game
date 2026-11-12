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

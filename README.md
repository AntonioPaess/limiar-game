# LIMIAR

Jogo narrativo de ação, exploração e terror psicológico em **primeira pessoa**, dark fantasy low-poly com texturas
pixeladas. **Estado: protótipo cinza em construção** (pré-produção). Nada aqui é arte, narrativa ou balanço final.

- Documentação de design (fonte da verdade): [`docs/pre-producao/`](docs/pre-producao/README.md)
- Instruções para agentes de IA: [`AGENTS.md`](AGENTS.md) · Ambiente e ferramentas: [`docs/AMBIENTE.md`](docs/AMBIENTE.md)
- Plano do incremento atual: [`IMPLEMENTATION_PLAN.md`](IMPLEMENTATION_PLAN.md)

## Rodar

Requer **Godot 4.7.2 stable** (`brew install --cask godot`).

```bash
godot --path . --import      # primeira vez num checkout novo
godot --path .               # joga a cena principal (game/main.tscn)
godot --editor --path .      # abre no editor
```

## Controles (protótipo)

| Ação | Teclado/mouse | Gamepad |
|---|---|---|
| Mover | WASD / setas | analógico esquerdo |
| Olhar | mouse | analógico direito |
| Correr | Shift | L3 |
| Interagir | E | X / Quadrado |
| Ressonância: Leitura (toque) / Intervenção (segurar) | R | LB |
| Ataque leve | botão esquerdo | RT |
| Guarda / aparo (no início da guarda) | botão direito (segurar) | LT |
| Esquiva (com direção) | Espaço | B |
| Pausa e opções | Esc | Start |
| Overlay de debug | F3 | — |

A Intervenção custa 30 de Pulso e só funciona na fissura do escudo do Vigia **depois** de revelada pela Leitura.
Pulso sobe com aparos e é recarregado no ponto de retorno.

A pausa tem FOV (70–100°, horizontal), sensibilidade de mouse e analógico, inverter eixo Y, balanço de câmera,
pausa de impacto (hit-stop) e intensidade do efeito de Ressonância.

## O trecho cinza

Átrio → corredor (uma fissura na parede: aperte **R** perto dela para ver o primeiro Eco) → ponto de retorno →
galeria com o **Vigia** (escudo bloqueia golpes de frente: esquive e ataque pelas costas, apare no início da guarda, ou
leia a fissura do escudo e segure R) e três candelabros → porta de cobre trancada → saída.

**Spoiler do puzzle-placeholder:** a Leitura na sala mostra monitores sobre os candelabros; acenda as velas onde o
monitor está ligado (traço em zigue-zague) e deixe apagada onde a linha é reta.

## Testes

```bash
tests/run.sh                                                     # import + suíte headless + smoke + 300 frames da cena
godot --path . --script res://tests/visual/capture_views.gd -- --no-mouse-capture   # vistas em out/godot/views/
godot --path . --script res://tests/visual/capture_combat.gd -- --no-mouse-capture  # poses de combate em out/godot/combat/
```

`tests/run.sh` falha se o runner não imprimir o resumo (o Godot sai com 0 mesmo em erro de compilação).

## Regerar conteúdo gerado

```bash
godot --headless --path . --script "$PWD/tools/godot/setup_input_map.gd"        # mapa de input → project.godot
godot --headless --path . --script "$PWD/tools/godot/build_graybox_cathedral.gd" # graybox → game/world/
```

O gerador do graybox é bootstrap: depois de editar a cena à mão no editor, não rode de novo sem portar a edição.

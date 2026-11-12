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
| Pausa e opções | Esc | Start |
| Overlay de debug | F3 | — |

Já mapeados para os próximos incrementos (ainda sem efeito): ataque leve (botão esquerdo / RT), defesa (botão
direito / LT), esquiva (Espaço / B), Ressonância (R / LB).

A pausa tem FOV (70–100°, horizontal), sensibilidade de mouse e analógico, inverter eixo Y e balanço de câmera.

## O trecho cinza

Átrio → corredor (a parede violeta é o lugar onde a Ressonância vai revelar o primeiro Eco) → sala de combate
(colunas como cobertura, ainda sem inimigo) → porta de cobre (interagir) → saída.

## Testes

```bash
tests/run.sh                                                     # import + suíte headless + smoke + 300 frames da cena
godot --path . --script res://tests/visual/capture_views.gd -- --no-mouse-capture   # vistas em out/godot/views/
```

`tests/run.sh` falha se o runner não imprimir o resumo (o Godot sai com 0 mesmo em erro de compilação).

## Regerar conteúdo gerado

```bash
godot --headless --path . --script "$PWD/tools/godot/setup_input_map.gd"        # mapa de input → project.godot
godot --headless --path . --script "$PWD/tools/godot/build_graybox_cathedral.gd" # graybox → game/world/
```

O gerador do graybox é bootstrap: depois de editar a cena à mão no editor, não rode de novo sem portar a edição.

# 06 — Audio Bible, UI/UX e acessibilidade

## 1. Direção sonora

Som como indício de memória, não apenas susto. Priorizar design de som espacial, silêncio e pequenas continuidades entre o Véu e o Eco: gotejamento de água se torna ruído de soro; sino se transforma em pulso eletrônico; vento entre árvores revela uma conversa distante. Esses efeitos precisam ser elegantes e não literalmente repetidos a cada sala.

### Identidade por capítulo

- **Catedral:** pedra, vento nos arcos, madeira, respiração, ferro e sino quebrado; drones graves espaçados, canto humano abstrato não litúrgico e sem citações religiosas diretas.
- **Floresta:** folhas, água, aves, distância, texturas orgânicas; poucos instrumentos melódicos, calor quando o jogador observa.
- **Cidade:** água sobre pedra, vozes abafadas, ecos de portas; música rarefeita, lampejos de encontros cotidianos.
- **Quarto:** eletricidade, respiração, cama, ruídos de memória; transição para sons próximos e humanos.

## 2. Eventos dinâmicos

- `player_enter_zone`, `threat_detected`, `combat_started`, `combat_finished`, `resonance_read`, `resonance_intervene`, `memory_fragment_found`, `puzzle_solved`, `checkpoint_saved`, `death`, `chapter_revelation`.
- Ambiência deve fazer crossfade para não reiniciar agressivamente.
- Sons essenciais da Ressonância e inimigos precisam ser distinguíveis sem estarem sempre altos.
- Legendar fala, voz distante e informações sonoras críticas quando necessário.

## 3. Música

A trilha deve sustentar a história, não sugerir tristeza constante. Referência de instrumentação: cordas de câmara, piano esparso, ressonâncias metálicas, texturas de madeira, drones sintéticos discretos. Criar um motivo curto (3–5 notas ou gesto sonoro **original**) que pode assumir harmonia angustiada na Catedral e versão luminosa no final. Não pedir à IA que replique melodia de jogo/filme existente.

**Protótipo:** 1 loop ambiente, 1 camada de ameaça, 1 impacto de revelação, 1 passagem de respiro; usar assets licenciados ou originais.

## 4. UI/UX

### HUD durante gameplay

- Vida e Pulso compactos; evitar grandes placas.
- Retículo mínimo com variação de estado (observável/interagível), sem substituir leitura de cena.
- Arma/ícone de Ressonância discreto; duração/recarga mostradas quando relevantes.
- Dano/estado do inimigo por animação e áudio, não apenas barra numérica permanente.
- Alerta de checkpoint pequeno e inequívoco.

### Menus

`Novo Jogo`, `Continuar`, `Capítulos` (somente desbloqueados, se aprovado), `Opções`, `Acessibilidade`, `Créditos`, `Sair`.

Opções: vídeo/resolução/qualidade, volume por categoria, idioma, legendas, controles remapeáveis, sensibilidade mouse/gamepad, FOV, VSync, redução de movimento e efeitos.

### Diário de Ecos

O diário mostra **observações** e **hipóteses** em seções distintas, com data/área simbólica em vez de linha do tempo causal confirmada. Memórias descobertas são acessíveis novamente com transcrições. Não deixar jogador perder informação crítica por áudio único que não possa repetir.

## 5. Acessibilidade desde o protótipo

- Legendas com tamanho configurável e contraste adequado; identificação de falante quando importante.
- Várias categorias de áudio ajustáveis; indicadores visuais para pistas sonoras essenciais.
- Elementos interativos reconhecíveis por formato, som e movimento, não só por cor.
- Ressonância sem flashes bruscos, intensidade reduzível, transições não estroboscópicas.
- Câmera: FOV ajustável, desligar head bob, motion blur, shakes, depth of field e aberração cromática.
- Combate: ao menos uma configuração de assistência/ritmo ajustável após teste; evitar puzzle dependente de reflexos milimétricos.
- Controles remapeáveis e navegação completa por teclado e gamepad.
- Brilho/contraste calibráveis: dark fantasy não significa obstáculo visual intencional.
- Verificar leitura em telas menores, sem direcionar plataforma mobile antes de validação.

## 6. Localização

A documentação e primeiro roteiro serão em **PT-BR**. Internacionalização desde a camada de dados: não hardcodar falas em scripts; usar chaves como `ch1.confessor.intro.01`. Planejar EN quando houver orçamento para revisão literária. Evitar texto no cenário sem alternativa localizada.

## 7. QA de áudio e UI

- Testar jogo com áudio baixo, sem áudio e apenas legendas.
- Testar ressonância com saturação reduzida e modo não dependente de cor.
- Conferir se UI fica legível após aplicar pixelation ao mundo; interface deve renderizar em resolução nativa.
- Testar mouse sensível, controle e monitor 16:10 além de 16:9.
- Testar legendas de NPC em corredor longo e durante aparo.

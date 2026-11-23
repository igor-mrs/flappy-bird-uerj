# Flappy Bird - Oficina Godot 4 (GameLab UERJ)

Clone funcional completo do clássico **Flappy Bird**, construído passo a passo para a oficina presencial na **XII Semana de Engenharia UERJ** (**Igor Amaral · GameLab UERJ**), seguindo o tutorial de Kaan Alpar (*"Let's Create Flappy Bird in Godot 4.6!"*).

---

## Requisitos

- **Godot Engine 4.7** ([godotengine.org/download](https://godotengine.org/download))
- Nenhuma dependência externa. Todos os sprites, fontes e efeitos sonoros já estão em `res://assets/`.

---

## Roteiro da Aula & Branches Git

O repositório foi estruturado de forma **linear e cumulativa**: cada branch representa o estado exato do projeto ao final daquele módulo da aula.

Se alguém se atrasar durante a oficina, basta rodar `git checkout <branch>` para alcançar a turma imediatamente — ou usar `git diff` para revisar exatamente o que mudou de uma etapa para a outra!

| Módulo | Branch | Conteúdo Construído | Comparar Mudanças |
| :---: | :--- | :--- | :--- |
| **01** | `00-projeto-base` | Estrutura inicial (`scenes/`, `scripts/`, `assets/`) pronta para começar do zero. | — |
| **02** | `02-configuracao` | Viewport `480×854` (janela `720×1280` com `canvas_items`), filtro `Nearest`, ação `flap` no Input Map e `Background`. | `git diff 00-projeto-base..02-configuracao` |
| **03** | `03-jogador` | Cena `Player` (`RigidBody2D`), `gravity_scale` desligada no início, impulso no clique (`flap`), animação e inclinação do sprite. | `git diff 02-configuracao..03-jogador` |
| **04** | `04-mundo-obstaculos` | `Ground` em loop (`AnimationPlayer`), `PipePair` (`Area2D` letal + `ScoreArea` separado) e `ObstacleSpawner` com `Timer`. | `git diff 03-jogador..04-mundo-obstaculos` |
| **05** | `05-ui-recorde` | `HUD` (`StartMenu`, placar ao vivo e `Game Over`), máquina de estados da partida, reinício e recorde salvo em `user://highscore.save`. | `git diff 04-mundo-obstaculos..05-ui-recorde` |
| **06** | `06-polimento-final` | Três efeitos sonoros com `AudioStreamPlayer` (pulo, ponto e morte) + preset de exportação **Windows Desktop**. | `git diff 05-ui-recorde..06-polimento-final` |
| **07** | `07-extras-hall-transicao` | **Contribuição autoral:** plugin **EasyTransition** (`CIRCLE_CENTER_COLLAPSE` com dithering + `swoosh.wav`) e **Hall da Fama Top 5** em JSON (`user://hall_of_fame.json`). | `git diff 06-polimento-final..07-extras-hall-transicao` |
| **Final** | `main` | Jogo finalizado com os extras (idêntico à `07-extras-hall-transicao`). | — |

---

## Arquitetura de Cenas e Scripts

```text
res://
├── project.godot                # Viewport 480x854 (janela 720x1280), filtro Nearest, input "flap"
├── export_presets.cfg           # Preset Windows Desktop (x86_64, .pck embutido)
├── scenes/
│   ├── main.tscn                # Mundo principal (Background, Spawner, Ground, Player, HUD e Sons)
│   ├── player.tscn              # RigidBody2D + Sprite2D (3 frames) + CircleShape2D + AnimationPlayer
│   ├── ground.tscn              # StaticBody2D + 2x Sprite2D + DeathZone (Area2D) + AnimationPlayer
│   ├── pipe_pair.tscn           # TopPipe (Area2D) + BottomPipe (Area2D) + ScoreArea (Area2D)
│   ├── obstacle_spawner.tscn    # Node2D + SpawnTimer (1.7s)
│   └── hud.tscn                 # CanvasLayer (ScoreLabel, StartMenu e GameOverMenu)
├── scripts/
│   ├── main.gd                  # Estados (WAITING, PLAYING, GAME_OVER), áudio e FileAccess do recorde
│   ├── player.gd                # Gravidade, impulso vertical, limite de tela e rotação do sprite
│   ├── ground.gd                # Detecção de queda no solo e pausa da rolagem
│   ├── pipe_pair.gd             # Movimento para a esquerda, remoção fora da tela e sinais
│   ├── obstacle_spawner.gd      # Instanciação periódica com altura Y sorteada
│   └── hud.gd                   # Atualização visual do placar e telas de início / fim de partida
└── assets/
    ├── audio/                   # wing.wav, point.wav, hit.wav, die.wav, swoosh.wav
    ├── fonts/                   # flappyfont.TTF
    └── textures/                # background.png, bird.png, ground.png, pipe.png, message.png, gameover.png
```

---

## Exportando para Windows (Módulo 06)

1. No editor do Godot, acesse **Editor → Manage Export Templates...** e clique em **Download and Install** para instalar os templates da sua versão (4.7).
2. Acesse **Project → Export...** — o preset **Windows Desktop** já está configurado (`builds/windows/FlappyBird.exe` com `Embed PCK` ativado).
3. Clique em **Export Project...**.

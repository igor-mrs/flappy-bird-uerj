# Flappy Bird — Oficina Godot 4 (GameLab UERJ)

Projeto desenvolvido para o minicurso **"Um clone funcional do famoso Flappy Bird"** na **XII Semana de Engenharia UERJ** (Igor Morais do Amaral · GameLab UERJ), baseado no tutorial de Kaan Alpar para Godot 4.6+.

---

## Como começar (Projeto Base)

1. Baixe ou clone este repositório.
2. Abra o **Godot 4.6+** (ou **Godot 4.7**), clique em **Import** e selecione o arquivo `project.godot`.
3. Se você está acompanhando a aula do zero, mude para a branch inicial:
   ```bash
   git checkout 00-projeto-base
   ```

---

## Mapa de Branches da Aula

Se você perder algum passo durante a oficina presencial, basta alternar para a branch correspondente ao módulo atual do roteiro:

| Branch | Etapa da Aula | O que está pronto nesta branch |
| :--- | :--- | :--- |
| `00-projeto-base` | **01. Projeto Base** | Pastas `scenes/`, `scripts/` e `assets/` (sprites, sons e fonte) prontas para começar. |
| `02-configuracao` | **02. Configuração e Preparação** | Janela vertical (`480x854` com override `720x1280`), pixel art nítida (`Nearest`), ação `flap` no Input Map e `Background`. |
| `03-jogador` | **03. O Jogador: Física e Controle** | Cena `Player` (`RigidBody2D`), gravidade controlada, impulso de pulo (`flap`), animação de bater asas e rotação conforme velocidade vertical. |
| `04-mundo-obstaculos` | **04. Mundo e Obstáculos** | Solo com rolagem em loop (`AnimationPlayer`), par de canos (`Area2D` letal + `ScoreArea` separado) e `ObstacleSpawner` com `Timer`. |
| `05-ui-recorde` | **05. Sistemas de Jogo e Interface** | `HUD` (`StartMenu`, placar ao vivo e tela de `Game Over`), estados da partida, reinício e recorde persistido em `user://highscore.save`. |
| `06-polimento-final` | **06. Polimento e Exportação** | Efeitos sonoros com `AudioStreamPlayer` (pulo, ponto e morte) e preset de exportação Windows Desktop. |
| `main` | **Versão Completa** | Jogo finalizado com todos os sistemas, áudio e documentação. |

---

## Estrutura de Pastas

```text
res://
├── assets/
│   ├── audio/      # Efeitos sonoros (.wav)
│   ├── fonts/      # Fonte pixelada (flappyfont.TTF)
│   └── textures/   # Sprites do pássaro, canos, cenário, solo e UI (.png)
├── scenes/         # Cenas do Godot (.tscn)
└── scripts/        # Códigos GDScript (.gd)
```

# Roteiro Completo da Oficina — Flappy Bird em Godot 4 (3h)

**Evento:** XII Semana de Engenharia UERJ  
**Instrutor:** Igor Morais do Amaral · GameLab UERJ  
**Meta:** Sair do zero e construir um clone funcional do Flappy Bird com áudio, recorde, transição de tela e Hall da Fama Top 5.

---

## Checklist Pré-Aula (15 min antes de começar)

### No seu PC Pessoal (Bancada — sua "Cola")
- [ ] Abra o projeto na branch **`main`** (`git checkout main`).
- [ ] Deixe este roteiro aberto em tela cheia ou dividido com os scripts prontos.
- [ ] Teste dar **F5** uma vez para garantir que o jogo roda liso.

### No PC do Laboratório (Projetor — "PC do Aluno")
- [ ] Abra o projeto e confira se está na branch **`00-projeto-base`** (se for fazer o demo inicial na `main`, rode primeiro na `main`, feche e volte para `00-projeto-base` antes de começar a codar).
- [ ] Aumente a fonte do Godot para quem senta no fundo conseguir ler:
  - **Editor → Editor Settings → Interface → Editor → Main Font Size:** `16` ou `18`
  - **Editor → Editor Settings → Interface → Editor → Code Font Size:** `20` ou `22`
- [ ] Deixe um terminal aberto na pasta do projeto (`flappy/`).

---

## Parte 0 · Abertura e Setup (`00:00 – 00:20`)
**Branch:** `00-projeto-base`

### O que falar
> *"Hoje vamos construir um Flappy Bird completo do zero no Godot 4. Antes de abrir qualquer código, deixa eu mostrar o que a gente vai ter rodando daqui a 3 horas."*

1. *(Opcional, se estiver na `main`)* Aperte **F5**, dê 2 ou 3 pulos, passe por 1 cano, morra e mostre o Hall da Fama. Feche o jogo e volte o projetor para `00-projeto-base`:
   ```bash
   git checkout 00-projeto-base
   ```
2. Peça para os alunos clonarem/baixarem o repositório e importarem no Godot:
   - **Project Manager → Import →** selecionar `project.godot`.
3. Explique a **Regra do Checkpoint**:
   > *"Se alguém se perder, der um erro estranho ou o código não funcionar, não precisa travar: cada parte da aula tem uma branch no Git (`02-configuracao`, `03-jogador`, etc.). É só rodar `git checkout <nome-da-branch>` que vocês caem exatamente onde eu estou."*

---

## Parte 1 · Configuração e Preparação (`00:20 – 00:40`)
**Branch alvo:** `02-configuracao`

### 1.1 Configurações do Projeto (`Project → Project Settings`)
Faça devagar no projetor e peça para acompanharem:

1. **Janela vertical (`Display → Window`):**
   - `Viewport Width`: `480`
   - `Viewport Height`: `854`
   - Ative **Advanced Settings** (canto superior direito) e preencha:
     - `Window Width Override`: `720`
     - `Window Height Override`: `1280`
   - Em **Stretch**:
     - `Mode`: `canvas_items`
     - `Aspect`: `keep`
   - *O que falar:* *"Nosso fundo tem 480×854 px. Configurando assim, desenhamos tudo no tamanho exato da imagem e o Godot escala automaticamente para uma janela confortável de 720×1280 sem distorcer."*

2. **Pixel Art sem borrão (`Rendering → Textures → Canvas Textures`):**
   - `Default Texture Filter`: `Nearest`
   - *O que falar:* *"Por padrão o Godot suaviza imagens (Linear), deixando pixel art borrada. Mudando para Nearest, cada pixel fica nítido."*

3. **Controle de pulo (`Input Map`):**
   - Crie uma nova ação chamada `flap` → clique no `+` → **Mouse Button → Left Mouse Button**.

### 1.2 Conceitos Rápidos (Slides 7–9 · max 3 min)
- **Game Loop:** O jogo redesenha a tela ~60 vezes por segundo. Cada volta é um *frame*.
- **Nó (Node):** Peça de LEGO com uma função (ex: `Sprite2D` desenha imagem, `Timer` conta tempo).
- **Cena (Scene):** Árvore de nós salva num arquivo `.tscn` que podemos reutilizar (ex: o pássaro, o cano).

### 1.3 Criando a Cena Principal (`scenes/main.tscn`)
1. Clique em **+ (Other Node)** ou **2D Scene** → renomeie o nó raiz para `Main` (`Node2D`).
2. Salve como `res://scenes/main.tscn`.
3. Adicione um filho `Sprite2D` → renomeie para `Background`.
4. Arraste `res://assets/textures/background.png` para a propriedade **Texture**.
5. No Inspector, em **Offset**, desmarque **Centered** (`centered = false`).
6. Aperte **F5** → **Select Current** para definir `main.tscn` como cena principal.

> **Checkpoint:** Janela vertical 720×1280 aberta mostrando o céu e a cidade nítidos.  
> *(Se alguém travou: `git checkout 02-configuracao`)*

---

## Parte 2 · O Jogador: Física e Controle (`00:40 – 01:15`)
**Branch alvo:** `03-jogador`

### 2.1 Montando a Cena (`scenes/player.tscn`)
1. Crie uma **New Scene** → raiz `RigidBody2D` → renomeie para `Player`.
2. No Inspector do `Player`:
   - `Gravity Scale`: `0.0` *(começa parado na tela inicial!)*
   - `Lock Rotation`: **On** *(quem vai girar é só o sprite, não o corpo físico)*.
3. Adicione os filhos do `Player`:
   - `Sprite2D`: Texture = `res://assets/textures/bird.png` → em **Animation**, coloque `Hframes = 3`.
   - `CollisionShape2D`: Shape = `CircleShape2D` (`radius = 17`).
   - `AnimationPlayer`:
     - Crie a animação `flap` (`length = 0.3`, ative o ícone de **Loop** e **Autoplay on Load**).
     - Insira keyframes na propriedade `Sprite2D:frame`: `0` em `0.0s`, `1` em `0.1s`, `2` em `0.2s`.
4. Salve em `res://scenes/player.tscn`.

### 2.2 Escrevendo `scripts/player.gd` (em 3 blocos + F5)
Anexe um script em `Player` salvo em `res://scripts/player.gd`.

**Bloco A — Sinais, variáveis e estado inicial:**
```gdscript
class_name Player
extends RigidBody2D

signal game_started
signal flapped

@export var flap_force: float = 350.0
@export var max_fall_speed: float = 600.0
@export var min_tilt_deg: float = -30.0
@export var max_tilt_deg: float = 90.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_started: bool = false
var is_alive: bool = true


func _ready() -> void:
	gravity_scale = 0.0
	linear_velocity = Vector2.ZERO
```
*O que falar:* *"Reparem no aviso importante: `gravity_scale = 0` só desliga a aceleração da gravidade, não zera a velocidade. Então garantimos `linear_velocity = Vector2.ZERO` no `_ready()`."*

**Bloco B — Pulo, teto e rotação (`_physics_process`):**
```gdscript
func _physics_process(_delta: float) -> void:
	if is_alive and Input.is_action_just_pressed("flap"):
		if not is_started:
			start()
		flap()

	if linear_velocity.y > max_fall_speed:
		linear_velocity.y = max_fall_speed

	if global_position.y < 18.0 and linear_velocity.y < 0.0:
		global_position.y = 18.0
		linear_velocity.y = 0.0

	if is_started:
		sprite.rotation_degrees = clamp(linear_velocity.y * 0.15, min_tilt_deg, max_tilt_deg)
```

**Bloco C — Funções `start()`, `flap()` e `die()`:**
```gdscript
func start() -> void:
	is_started = true
	gravity_scale = 1.0
	game_started.emit()


func flap() -> void:
	linear_velocity = Vector2.ZERO
	apply_central_impulse(Vector2.UP * flap_force)
	flapped.emit()


func die() -> void:
	if not is_alive:
		return
	is_alive = false
	animation_player.stop()
	if linear_velocity.y < 0.0:
		linear_velocity.y = 0.0
```
*O que falar:* *"Por que zeramos `linear_velocity` dentro do `flap()`? Porque se o pássaro estiver caindo muito rápido, aplicar um impulso fixo para cima mal cancelaria a queda. Zerando antes, todo clique dá exatamente a mesma altura de pulo!"*

### 2.3 Instanciando na Cena Principal
1. Abra `main.tscn`, clique no ícone de corrente (**Instantiate Child Scene**) e escolha `player.tscn`.
2. Posicione o `Player` em `(120, 415)`.
3. Aperte **F5**!

> **Checkpoint:** Pássaro flutuando batendo as asas; no primeiro clique, cai pela gravidade, pula com impulso consistente e inclina o bico para cima/baixo.

---

## ☕ Intervalo (`01:15 – 01:30` · 15 min)
- Passe nas mesas para ajudar quem teve erro de digitação ou nó com nome diferente.
- Quem ficou para trás roda: `git checkout 03-jogador`.

---

## Parte 3 · Mundo e Obstáculos (`01:30 – 02:10`)
**Branch alvo:** `04-mundo-obstaculos`

### 3.1 Solo em Loop (`scenes/ground.tscn` + `scripts/ground.gd`)
1. Nova cena → raiz `StaticBody2D` → renomeie para `Ground`.
2. Adicione 2 filhos `Sprite2D` (`Sprite2D` e `Sprite2D2`), ambos com `ground.png` e **Centered = false**.
   - Posição do `Sprite2D`: `(0, 0)`
   - Posição do `Sprite2D2`: `(504, 0)` *(largura exata do sprite!)*
3. Adicione `CollisionShape2D` (`RectangleShape2D` `1008 × 168`) na posição `(504, 84)`.
4. Adicione `Area2D` chamado `DeathZone` com `CollisionShape2D` (`1008 × 168`) em `(504, 82)`.
5. Adicione `AnimationPlayer` → crie animação `scroll` (`length = 3.0`, **Loop** + **Autoplay**):
   - `Sprite2D:position`: `(0, 0)` em `0s` → `(-504, 0)` em `3.0s`.
   - `Sprite2D2:position`: `(504, 0)` em `0s` → `(0, 0)` em `3.0s`.
6. Crie `scripts/ground.gd`:
```gdscript
extends StaticBody2D

signal player_crashed

@onready var death_zone: Area2D = $DeathZone
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	death_zone.body_entered.connect(_on_death_zone_body_entered)


func stop() -> void:
	animation_player.pause()


func _on_death_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		player_crashed.emit()
```
7. Instancie `ground.tscn` em `main.tscn` na posição `(0, 686)` e dê **F5** para ver o chão correndo!

### 3.2 Par de Canos (`scenes/pipe_pair.tscn` + `scripts/pipe_pair.gd`)
1. Nova cena → raiz `Node2D` → renomeie para `PipePair`.
2. Adicione:
   - `TopPipe` (`Area2D`) em `(0, -318)` → filho `Sprite2D` (`pipe.png`, **Flip V = On**) + `CollisionShape2D` (`74 × 480`).
   - `BottomPipe` (`Area2D`) em `(0, 318)` → filho `Sprite2D` (`pipe.png`) + `CollisionShape2D` (`74 × 480`).
   - `ScoreArea` (`Area2D`) em `(20, 0)` → filho `CollisionShape2D` (`16 × 156`).
   - *O que falar:* *"O sensor de ponto é um `Area2D` separado no vão entre os canos, deslocado um pouco para a direita para o ponto contar exatamente quando o pássaro atravessa."*
3. Crie `scripts/pipe_pair.gd`:
```gdscript
class_name PipePair
extends Node2D

signal player_entered_pipe
signal point_scored

@export var speed: float = 168.0

@onready var top_pipe: Area2D = $TopPipe
@onready var bottom_pipe: Area2D = $BottomPipe
@onready var score_area: Area2D = $ScoreArea

var is_moving: bool = true


func _ready() -> void:
	top_pipe.body_entered.connect(_on_pipe_body_entered)
	bottom_pipe.body_entered.connect(_on_pipe_body_entered)
	score_area.body_entered.connect(_on_score_area_body_entered)


func _process(delta: float) -> void:
	if not is_moving:
		return
	position.x -= speed * delta
	if position.x < -100.0:
		queue_free()


func stop() -> void:
	is_moving = false


func _on_pipe_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered_pipe.emit()


func _on_score_area_body_entered(body: Node2D) -> void:
	if body is Player:
		score_area.set_deferred("monitoring", false)
		point_scored.emit()
```

### 3.3 Gerador de Obstáculos (`scenes/obstacle_spawner.tscn` + `scripts/obstacle_spawner.gd`)
1. Nova cena → raiz `Node2D` (`ObstacleSpawner`) + filho `Timer` (`SpawnTimer`, `Wait Time = 1.7`).
2. Crie `scripts/obstacle_spawner.gd`:
```gdscript
extends Node2D

signal pipe_hit
signal point_scored

@export var pipe_pair_scene: PackedScene = preload("res://scenes/pipe_pair.tscn")
@export var spawn_x: float = 540.0
@export var min_y: float = 180.0
@export var max_y: float = 500.0

@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)


func start() -> void:
	spawn_pipe()
	spawn_timer.start()


func stop() -> void:
	spawn_timer.stop()
	for child in get_children():
		if child is PipePair:
			child.stop()


func spawn_pipe() -> void:
	var pipe_pair: PipePair = pipe_pair_scene.instantiate()
	pipe_pair.position = Vector2(spawn_x, randf_range(min_y, max_y))
	pipe_pair.player_entered_pipe.connect(func(): pipe_hit.emit())
	pipe_pair.point_scored.connect(func(): point_scored.emit())
	add_child(pipe_pair)


func _on_spawn_timer_timeout() -> void:
	spawn_pipe()
```
3. Instancie `obstacle_spawner.tscn` em `main.tscn` **acima do `Ground`** na árvore (assim os canos passam por trás do chão!).
4. Conecte no `scripts/main.gd` (`game_started`, `player_crashed`, `pipe_hit`, `point_scored` com `print(score)`) e dê **F5**!

> **Checkpoint:** Jogo já 100% jogável! Canos nascem, pontuam no Output e travam tudo na colisão.

---

## Parte 4 · Interface, Recorde, Sons e Export (`02:10 – 02:40`)
**Branches:** `05-ui-recorde` → `06-polimento-final`

> **Dica de ritmo:** Montar `StyleBoxFlat` de botão e painel manualmente no editor leva tempo. Se estiver apertado no relógio, monte só o `ScoreLabel` + `StartMenu` + `GameOverMenu` simples, ou dê `git checkout 05-ui-recorde` para mostrar o visual completo da paleta e foque em explicar o código!

### Pontos-chave para explicar no `hud.gd` e `main.gd`
1. **Separação Estado vs Interface:** `main.gd` guarda `enum GameState { WAITING, PLAYING, GAME_OVER }` e `score`. A `HUD` só exibe o que o `Main` mandar e emite `restart_requested` quando clicam no botão.
2. **Sem ponto depois da morte:**
   ```gdscript
   if state != GameState.PLAYING:
       return
   ```
3. **Recorde persistido com `FileAccess`:**
   - Salva em `"user://highscore.save"` (pasta segura do sistema operacional que funciona mesmo no `.exe` exportado).
   - Usa `file.store_32(high_score)` e `file.get_32()`.
4. **3 Sons com `AudioStreamPlayer` (`06-polimento-final`):**
   - `FlapSound` (`wing.wav`) → conectado a `player.flapped`.
   - `PointSound` (`point.wav`) → dentro de `_on_point_scored()`.
   - `HitSound` (`hit.wav`) → dentro de `_on_player_crashed()` (toca uma única vez por causa do `if state == GameState.GAME_OVER: return`).
5. **Exportação Windows (`Project → Export...`):**
   - Mostre onde baixar os *Export Templates* e onde fica o preset `Windows Desktop` (`Embed PCK` ligado para gerar um único `.exe` fácil de compartilhar).

---

## Parte 5 · Extras Autorais & Campeonato ao Vivo (`02:40 – 03:00`)
**Branch:** `07-extras-hall-transicao` (`main`)

> **Regra de ouro:** Nos últimos 20 minutos, **não code esta parte do zero**. Use o Git a seu favor para fechar a oficina com chave de ouro!

1. No PC do projetor, rode:
   ```bash
   git checkout main
   ```
2. **Explique em 5 minutos a contribuição autoral:**
   - *"Quando você usa um tutorial ou projeto de outra pessoa, uma ótima prática é adicionar algo seu. Aqui trouxemos duas contribuições:"*
   - **Plugin `EasyTransition`** (`res://addons/easytransition/`): mostra como habilitar um plugin de terceiros + tocar `swoosh.wav` nas trocas de cena.
   - **Hall da Fama Top 5 (`HallOfFame` Autoload):** mostra uma cena separada (`hall_of_fame.tscn`) salvando uma lista ordenada de `{ "name": ..., "score": ... }` em JSON (`user://hall_of_fame.json`).
3. **Dinâmica Final (15 min):**
   - Clique em **LIMPAR TOP 5** no projetor.
   - Chame **5 alunos** na frente, um de cada vez, para jogar 1 partida no projetor e gravar as iniciais deles no **Hall da Fama** ao vivo!

---

## Cola Rápida de Emergência (Para o seu PC Pessoal)

| Sintoma na sala | Causa provável | Solução em 10 segundos |
| :--- | :--- | :--- |
| Pássaro já cai antes do primeiro clique | `gravity_scale` não está `0.0` | Conferir `gravity_scale = 0.0` no Inspector e no `_ready()` |
| Chão dá "pulinho" ao reiniciar o loop | Largura do `ground.png` é `504`, não `480` | `Sprite2D2.position.x = 504` e animação vai até `-504` |
| Canos passam na frente do chão | Ordem na árvore do `Main` | Arrastar `ObstacleSpawner` para **cima** do `Ground` |
| Pontua 2 vezes no mesmo cano | `ScoreArea` não desativou | `score_area.set_deferred("monitoring", false)` |
| Som de morte toca em loop | Faltou travar após a primeira colisão | `if state == GameState.GAME_OVER: return` |
| Clique no botão da HUD faz o pássaro pular | `Player` não ignorou botão da UI | Verificar `gui_get_hovered_control() is Button` em `player.gd` |

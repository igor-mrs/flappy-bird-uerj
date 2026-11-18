extends Node2D

const SAVE_FILE_PATH: String = "user://highscore.save"

# Estados da partida separados da interface (HUD)
enum GameState { WAITING, PLAYING, GAME_OVER }

@onready var obstacle_spawner: Node2D = $ObstacleSpawner
@onready var ground: StaticBody2D = $Ground
@onready var player: Player = $Player
@onready var hud: HUD = $HUD

@onready var flap_sound: AudioStreamPlayer = $FlapSound
@onready var point_sound: AudioStreamPlayer = $PointSound
@onready var hit_sound: AudioStreamPlayer = $HitSound

var state: GameState = GameState.WAITING
var score: int = 0
var high_score: int = 0


func _ready() -> void:
	load_high_score()

	player.game_started.connect(_on_game_started)
	player.flapped.connect(_on_player_flapped)
	ground.player_crashed.connect(_on_player_crashed)
	obstacle_spawner.pipe_hit.connect(_on_player_crashed)
	obstacle_spawner.point_scored.connect(_on_point_scored)
	hud.restart_requested.connect(_on_restart_requested)


func _on_game_started() -> void:
	state = GameState.PLAYING
	hud.show_gameplay()
	obstacle_spawner.start()


func _on_player_flapped() -> void:
	flap_sound.play()


func _on_point_scored() -> void:
	# Garante que nunca haja pontuação nem som de ponto depois da morte
	if state != GameState.PLAYING:
		return

	score += 1
	point_sound.play()
	hud.update_score(score)


func _on_player_crashed() -> void:
	if state == GameState.GAME_OVER:
		return

	state = GameState.GAME_OVER
	# Toca o som de morte apenas uma vez, no encerramento da partida
	hit_sound.play()

	player.die()
	ground.stop()
	obstacle_spawner.stop()

	if score > high_score:
		high_score = score
		save_high_score()

	hud.show_game_over(score, high_score)


func _on_restart_requested() -> void:
	get_tree().reload_current_scene()


func save_high_score() -> void:
	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_32(high_score)


func load_high_score() -> void:
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		high_score = 0
		return

	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file:
		high_score = file.get_32()

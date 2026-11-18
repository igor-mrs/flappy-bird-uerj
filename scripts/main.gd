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
@onready var swoosh_sound: AudioStreamPlayer = $SwooshSound

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
	hud.hall_of_fame_requested.connect(_on_hall_of_fame_requested)
	hud.save_record_requested.connect(_on_save_record_requested)


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

	hud.show_game_over(score, high_score, HallOfFame.qualifies(score))


func _on_save_record_requested(player_name: String) -> void:
	var rank: int = HallOfFame.add_entry(player_name, score)
	hud.mark_record_saved(rank)


func _on_restart_requested() -> void:
	_transition_with_swoosh("res://scenes/main.tscn")


func _on_hall_of_fame_requested() -> void:
	_transition_with_swoosh("res://scenes/hall_of_fame.tscn")


func _transition_with_swoosh(scene_path: String) -> void:
	if EasyTransition.is_transitioning:
		return
	swoosh_sound.play()
	EasyTransition.transition_to(
		scene_path,
		0.6,
		EasyTransition.TransitionAnim.CIRCLE_CENTER_COLLAPSE,
		HallOfFame.TRANSITION_COLOR,
		null,
		true,
		0.5,
		3.0
	)


func save_high_score() -> void:
	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_32(high_score)


func load_high_score() -> void:
	var hall_best: int = HallOfFame.get_best_score()
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		high_score = hall_best
		return

	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file:
		high_score = maxi(file.get_32(), hall_best)
	else:
		high_score = hall_best

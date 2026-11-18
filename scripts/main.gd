extends Node2D

@onready var obstacle_spawner: Node2D = $ObstacleSpawner
@onready var ground: StaticBody2D = $Ground
@onready var player: Player = $Player

var score: int = 0
var is_game_over: bool = false


func _ready() -> void:
	player.game_started.connect(_on_game_started)
	ground.player_crashed.connect(_on_player_crashed)
	obstacle_spawner.pipe_hit.connect(_on_player_crashed)
	obstacle_spawner.point_scored.connect(_on_point_scored)


func _on_game_started() -> void:
	obstacle_spawner.start()


func _on_point_scored() -> void:
	if is_game_over:
		return
	score += 1
	print("Pontuação: ", score)


func _on_player_crashed() -> void:
	if is_game_over:
		return
	is_game_over = true
	player.die()
	ground.stop()
	obstacle_spawner.stop()

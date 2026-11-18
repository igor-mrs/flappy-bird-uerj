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
	# Sorteia a posição vertical mantendo o tamanho fixo da abertura
	var random_y: float = randf_range(min_y, max_y)
	pipe_pair.position = Vector2(spawn_x, random_y)

	pipe_pair.player_entered_pipe.connect(_on_pipe_player_entered)
	pipe_pair.point_scored.connect(_on_pipe_point_scored)

	add_child(pipe_pair)


func _on_spawn_timer_timeout() -> void:
	spawn_pipe()


func _on_pipe_player_entered() -> void:
	pipe_hit.emit()


func _on_pipe_point_scored() -> void:
	point_scored.emit()

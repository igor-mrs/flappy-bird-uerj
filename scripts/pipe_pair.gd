class_name PipePair
extends Node2D

# Sinais separados: colisão letal nos canos vs passagem válida na abertura
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

	# Move o par de canos para a esquerda e remove quando sair da tela
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
		# Desativa o sensor após pontuar para garantir apenas 1 ponto por par
		score_area.set_deferred("monitoring", false)
		point_scored.emit()

extends StaticBody2D

# Sinal emitido quando o pássaro toca a zona letal do solo
signal player_crashed

@onready var death_zone: Area2D = $DeathZone
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	death_zone.body_entered.connect(_on_death_zone_body_entered)


func stop() -> void:
	# Pausa o deslocamento exatamente na posição atual dos sprites
	animation_player.pause()


func _on_death_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		player_crashed.emit()

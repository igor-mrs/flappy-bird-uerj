class_name Player
extends RigidBody2D

# Sinais para comunicar eventos do jogador ao mundo sem acoplamento direto
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
	# Atenção: gravity_scale = 0 desliga a gravidade na tela inicial,
	# mas garantimos também velocidade inicial zero.
	gravity_scale = 0.0
	linear_velocity = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	if is_alive and Input.is_action_just_pressed("flap"):
		if not is_started:
			start()
		flap()

	# Limita a velocidade máxima de queda e evita sair pelo topo da tela
	if linear_velocity.y > max_fall_speed:
		linear_velocity.y = max_fall_speed

	if global_position.y < 18.0 and linear_velocity.y < 0.0:
		global_position.y = 18.0
		linear_velocity.y = 0.0

	# Inclina o sprite conforme a velocidade vertical:
	# subindo (vy < 0) aponta para cima; caindo (vy > 0) aponta para baixo.
	if is_started:
		sprite.rotation_degrees = clamp(linear_velocity.y * 0.15, min_tilt_deg, max_tilt_deg)


func start() -> void:
	is_started = true
	gravity_scale = 1.0
	game_started.emit()


func flap() -> void:
	# Zera a velocidade atual antes do impulso para que todo clique tenha a mesma altura
	linear_velocity = Vector2.ZERO
	apply_central_impulse(Vector2.UP * flap_force)
	flapped.emit()


func die() -> void:
	if not is_alive:
		return
	is_alive = false
	animation_player.stop()
	# Se bateu subindo, interrompe a subida para cair imediatamente
	if linear_velocity.y < 0.0:
		linear_velocity.y = 0.0

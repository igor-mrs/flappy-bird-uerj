class_name HUD
extends CanvasLayer

# A interface apenas emite intenção de reinício; quem controla o estado é o Main
signal restart_requested

@onready var score_label: Label = $ScoreLabel
@onready var start_menu: Control = $StartMenu
@onready var game_over_menu: Control = $GameOverMenu
@onready var final_score_value: Label = %FinalScoreValue
@onready var best_score_value: Label = %BestScoreValue
@onready var restart_button: Button = %RestartButton


func _ready() -> void:
	restart_button.pressed.connect(_on_restart_button_pressed)
	show_start_menu()


func show_start_menu() -> void:
	start_menu.visible = true
	score_label.visible = false
	game_over_menu.visible = false


func show_gameplay() -> void:
	start_menu.visible = false
	score_label.text = "0"
	score_label.visible = true
	game_over_menu.visible = false


func update_score(current_score: int) -> void:
	score_label.text = str(current_score)


func show_game_over(final_score: int, high_score: int) -> void:
	score_label.visible = false
	final_score_value.text = str(final_score)
	best_score_value.text = str(high_score)
	game_over_menu.visible = true


func _on_restart_button_pressed() -> void:
	restart_requested.emit()

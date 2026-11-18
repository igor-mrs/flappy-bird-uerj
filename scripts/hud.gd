class_name HUD
extends CanvasLayer

# A interface apenas emite intenção de ações; quem controla o fluxo é o Main
signal restart_requested
signal hall_of_fame_requested
signal save_record_requested(player_name: String)

@onready var score_label: Label = $ScoreLabel
@onready var start_menu: Control = $StartMenu
@onready var start_hall_button: Button = %StartHallButton
@onready var game_over_menu: Control = $GameOverMenu
@onready var final_score_value: Label = %FinalScoreValue
@onready var best_score_value: Label = %BestScoreValue
@onready var record_box: VBoxContainer = %RecordBox
@onready var name_input: LineEdit = %NameInput
@onready var save_record_button: Button = %SaveRecordButton
@onready var saved_feedback_label: Label = %SavedFeedbackLabel
@onready var restart_button: Button = %RestartButton
@onready var hall_button: Button = %HallButton


func _ready() -> void:
	start_hall_button.pressed.connect(_on_hall_button_pressed)
	hall_button.pressed.connect(_on_hall_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	save_record_button.pressed.connect(_on_save_record_pressed)
	name_input.text_submitted.connect(_on_name_submitted)
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


func show_game_over(final_score: int, high_score: int, qualified: bool) -> void:
	score_label.visible = false
	final_score_value.text = str(final_score)
	best_score_value.text = str(high_score)
	record_box.visible = qualified
	saved_feedback_label.visible = false
	name_input.text = ""
	if qualified:
		name_input.editable = true
		save_record_button.disabled = false
	game_over_menu.visible = true


func mark_record_saved(rank: int) -> void:
	record_box.visible = false
	saved_feedback_label.text = "SALVO NO TOP %d!" % rank
	saved_feedback_label.visible = true


func _on_restart_button_pressed() -> void:
	restart_requested.emit()


func _on_hall_button_pressed() -> void:
	hall_of_fame_requested.emit()


func _on_save_record_pressed() -> void:
	save_record_requested.emit(name_input.text)


func _on_name_submitted(submitted_text: String) -> void:
	save_record_requested.emit(submitted_text)

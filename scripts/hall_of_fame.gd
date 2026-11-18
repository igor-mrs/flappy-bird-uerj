extends Node2D

@onready var entries_list: VBoxContainer = %EntriesList
@onready var empty_label: Label = %EmptyLabel
@onready var back_button: Button = %BackButton
@onready var clear_button: Button = %ClearButton
@onready var swoosh_sound: AudioStreamPlayer = $SwooshSound
@onready var font_res: Font = preload("res://assets/fonts/flappyfont.TTF")


func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	clear_button.pressed.connect(_on_clear_pressed)
	_render_entries()


func _render_entries() -> void:
	for child in entries_list.get_children():
		child.queue_free()

	var list := HallOfFame.entries
	empty_label.visible = list.is_empty()

	for i in range(list.size()):
		var item: Dictionary = list[i]
		var row := HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var rank_label := Label.new()
		rank_label.text = "%d. %s" % [i + 1, item["name"]]
		rank_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		rank_label.label_settings = _make_row_settings(_rank_color(i))

		var score_label := Label.new()
		score_label.text = str(item["score"])
		score_label.label_settings = _make_row_settings(Color.WHITE)

		row.add_child(rank_label)
		row.add_child(score_label)
		entries_list.add_child(row)


func _rank_color(index: int) -> Color:
	match index:
		0:
			return Color(1.0, 0.843137, 0.0, 1.0) # Ouro
		1:
			return Color(0.86, 0.88, 0.92, 1.0)    # Prata
		2:
			return Color(0.88, 0.56, 0.30, 1.0)    # Bronze
		_:
			return Color(0.909804, 0.415686, 0.090196, 1.0)


func _make_row_settings(text_color: Color) -> LabelSettings:
	var settings := LabelSettings.new()
	settings.font = font_res
	settings.font_size = 24
	settings.font_color = text_color
	settings.outline_size = 5
	settings.outline_color = Color(0.329412, 0.219608, 0.278431, 1.0)
	return settings


func _on_back_pressed() -> void:
	if EasyTransition.is_transitioning:
		return
	swoosh_sound.play()
	EasyTransition.transition_to(
		"res://scenes/main.tscn",
		0.6,
		EasyTransition.TransitionAnim.CIRCLE_CENTER_COLLAPSE,
		HallOfFame.TRANSITION_COLOR,
		null,
		true,
		0.5,
		3.0
	)


func _on_clear_pressed() -> void:
	HallOfFame.clear_entries()
	_render_entries()

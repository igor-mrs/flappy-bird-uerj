extends Node

# Autoload global para gerenciar o ranking Top 5 em JSON (user://hall_of_fame.json)
const SAVE_PATH: String = "user://hall_of_fame.json"
const MAX_ENTRIES: int = 5
const TRANSITION_COLOR: Color = Color(0.329412, 0.219608, 0.278431, 1.0)

var entries: Array[Dictionary] = []


func _ready() -> void:
	load_entries()


func load_entries() -> void:
	entries.clear()
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var text := FileAccess.get_file_as_string(SAVE_PATH)
	var parsed: Variant = JSON.parse_string(text)
	if parsed is Array:
		for item in parsed:
			if item is Dictionary and item.has("name") and item.has("score"):
				entries.append({
					"name": str(item["name"]),
					"score": int(item["score"]),
				})
		_sort_and_trim()


func save_entries() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(entries, "\t"))


func get_best_score() -> int:
	if entries.is_empty():
		return 0
	return int(entries[0]["score"])


func qualifies(score: int) -> bool:
	if score <= 0:
		return false
	if entries.size() < MAX_ENTRIES:
		return true
	return score > int(entries[-1]["score"])


func add_entry(player_name: String, score: int) -> int:
	var clean_name := player_name.strip_edges().to_upper()
	if clean_name.is_empty():
		clean_name = "AAA"
	if clean_name.length() > 6:
		clean_name = clean_name.substr(0, 6)

	var new_entry := {
		"name": clean_name,
		"score": score,
	}
	entries.append(new_entry)
	_sort_and_trim()
	save_entries()

	return entries.find(new_entry) + 1


func clear_entries() -> void:
	entries.clear()
	save_entries()


func _sort_and_trim() -> void:
	entries.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return int(a["score"]) > int(b["score"])
	)
	if entries.size() > MAX_ENTRIES:
		entries.resize(MAX_ENTRIES)

extends RefCounted

const GameState := preload("res://scripts/game_state.gd")
const SAVE_PATH := "user://guzhen_save.json"

static func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

static func save_game(state) -> bool:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(state.to_dict(), "\t"))
	return true

static func load_game():
	if not has_save():
		return GameState.new()
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return GameState.new()
	var text := file.get_as_text()
	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		return GameState.new()
	return GameState.from_dict(parsed)

static func reset_save() -> void:
	if has_save():
		var dir := DirAccess.open("user://")
		if dir != null:
			dir.remove("guzhen_save.json")

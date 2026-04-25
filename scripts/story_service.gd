extends RefCounted

const DungeonDefs := preload("res://scripts/data/dungeon_defs.gd")

const CHAPTER_ID := "three_kings_mountain"

static func ensure_story_state(state) -> void:
	if typeof(state.story_progress) != TYPE_DICTIONARY:
		state.story_progress = {}
	if typeof(state.dungeon_progress) != TYPE_DICTIONARY:
		state.dungeon_progress = {}
	if not state.story_progress.has(CHAPTER_ID):
		state.story_progress[CHAPTER_ID] = {
			"unlocked": true,
			"intro_seen": false,
			"rumor_month": int(state.world_month),
			"branches": {}
		}
	for branch_id in DungeonDefs.branch_ids():
		if not state.dungeon_progress.has(branch_id):
			state.dungeon_progress[branch_id] = {"attempts": 0, "victories": 0, "best_difficulty": "", "cleared": false}

static func mark_intro_seen(state) -> void:
	ensure_story_state(state)
	var chapter: Dictionary = state.story_progress[CHAPTER_ID]
	chapter["intro_seen"] = true
	state.story_progress[CHAPTER_ID] = chapter

static func mark_attempt(state, branch_id: String, difficulty_id: String) -> void:
	ensure_story_state(state)
	var progress: Dictionary = state.dungeon_progress.get(branch_id, {})
	progress["attempts"] = int(progress.get("attempts", 0)) + 1
	progress["last_difficulty"] = difficulty_id
	state.dungeon_progress[branch_id] = progress

static func mark_victory(state, branch_id: String, difficulty_id: String) -> void:
	ensure_story_state(state)
	var progress: Dictionary = state.dungeon_progress.get(branch_id, {})
	progress["victories"] = int(progress.get("victories", 0)) + 1
	progress["cleared"] = true
	if _difficulty_rank(difficulty_id) >= _difficulty_rank(String(progress.get("best_difficulty", ""))):
		progress["best_difficulty"] = difficulty_id
	state.dungeon_progress[branch_id] = progress
	var chapter: Dictionary = state.story_progress[CHAPTER_ID]
	var branches: Dictionary = chapter.get("branches", {})
	branches[branch_id] = true
	chapter["branches"] = branches
	state.story_progress[CHAPTER_ID] = chapter

static func chapter_completion(state) -> int:
	ensure_story_state(state)
	var completed: int = 0
	for branch_id in DungeonDefs.branch_ids():
		var progress: Dictionary = state.dungeon_progress.get(branch_id, {})
		if bool(progress.get("cleared", false)):
			completed += 1
	return completed

static func apply_story_morality(state, amount: int, reason: String) -> void:
	if state.has_method("adjust_morality"):
		state.adjust_morality(amount, reason)

static func _difficulty_rank(difficulty_id: String) -> int:
	match difficulty_id:
		"normal":
			return 1
		"danger":
			return 2
		"desperate":
			return 3
	return 0

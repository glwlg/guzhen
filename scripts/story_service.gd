extends RefCounted

const DungeonDefs := preload("res://scripts/data/dungeon_defs.gd")
const StoryChapterDefs := preload("res://scripts/data/story_chapter_defs.gd")
const CultivationService := preload("res://scripts/cultivation_service.gd")

const CHAPTER_ID := "three_kings_mountain"

static func ensure_story_state(state) -> void:
	if typeof(state.story_progress) != TYPE_DICTIONARY:
		state.story_progress = {}
	if typeof(state.dungeon_progress) != TYPE_DICTIONARY:
		state.dungeon_progress = {}
	for chapter_id_value in StoryChapterDefs.chapter_ids():
		var chapter_id := String(chapter_id_value)
		var chapter_def: Dictionary = StoryChapterDefs.chapter(chapter_id)
		var progress: Dictionary = state.story_progress.get(chapter_id, {})
		if progress.is_empty():
			progress = {
				"unlocked": bool(chapter_def.get("default_unlocked", false)),
				"intro_seen": false,
				"resolved": false,
				"choice_id": "",
				"resolved_month": -1
			}
		else:
			if not progress.has("unlocked"):
				progress["unlocked"] = bool(chapter_def.get("default_unlocked", false))
			if not progress.has("intro_seen"):
				progress["intro_seen"] = false
			if not progress.has("resolved"):
				progress["resolved"] = false
			if not progress.has("choice_id"):
				progress["choice_id"] = ""
			if not progress.has("resolved_month"):
				progress["resolved_month"] = -1
		if chapter_id == CHAPTER_ID and not progress.has("branches"):
			progress["branches"] = {}
		state.story_progress[chapter_id] = progress
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
	_apply_story_unlock_rules(state)
	if _visible_chapter_count(state) == 0:
		var start_id := StoryChapterDefs.start_chapter_for_origin(String(state.character.get("origin", "寒门子弟")))
		var start_progress: Dictionary = state.story_progress.get(start_id, {})
		start_progress["unlocked"] = true
		state.story_progress[start_id] = start_progress

static func configure_initial_story(state) -> void:
	ensure_story_state(state)
	for chapter_id_value in StoryChapterDefs.chapter_ids():
		var chapter_id := String(chapter_id_value)
		var chapter_def: Dictionary = StoryChapterDefs.chapter(chapter_id)
		var progress: Dictionary = state.story_progress.get(chapter_id, {})
		progress["unlocked"] = false
		progress["intro_seen"] = false
		progress["resolved"] = false
		progress["choice_id"] = ""
		progress["resolved_month"] = -1
		if String(chapter_def.get("kind", "")) == "dungeon":
			progress["branches"] = {}
		state.story_progress[chapter_id] = progress
	for branch_id in DungeonDefs.branch_ids():
		state.dungeon_progress[String(branch_id)] = {"attempts": 0, "victories": 0, "best_difficulty": "", "cleared": false}
	for i in range(state.npcs.size()):
		var npc: Dictionary = state.npcs[i]
		npc["met"] = false
		npc["alive"] = true
		state.npcs[i] = npc
	var start_id := StoryChapterDefs.start_chapter_for_origin(String(state.character.get("origin", "寒门子弟")))
	var start_progress: Dictionary = state.story_progress.get(start_id, {})
	start_progress["unlocked"] = true
	state.story_progress[start_id] = start_progress
	state.add_log("剧情线索根据出身展开：%s。" % String(StoryChapterDefs.chapter(start_id).get("name", "开局")))

static func chapter_ids() -> Array:
	return StoryChapterDefs.chapter_ids()

static func visible_chapter_ids(state) -> Array:
	ensure_story_state(state)
	var visible: Array = []
	for chapter_id_value in StoryChapterDefs.chapter_ids():
		var chapter_id := String(chapter_id_value)
		var progress: Dictionary = state.story_progress.get(chapter_id, {})
		if bool(progress.get("unlocked", false)) or bool(progress.get("resolved", false)) or _chapter_has_history(state, chapter_id):
			visible.append(chapter_id)
	return visible

static func chapter(chapter_id: String) -> Dictionary:
	return StoryChapterDefs.chapter(chapter_id)

static func chapter_progress(state, chapter_id: String) -> Dictionary:
	ensure_story_state(state)
	return state.story_progress.get(chapter_id, {})

static func is_chapter_unlocked(state, chapter_id: String) -> bool:
	return bool(chapter_progress(state, chapter_id).get("unlocked", false))

static func is_chapter_resolved(state, chapter_id: String) -> bool:
	return bool(chapter_progress(state, chapter_id).get("resolved", false))

static func can_start_branch(state, branch_id: String) -> bool:
	ensure_story_state(state)
	return not branch_attempted(state, branch_id)

static func branch_attempted(state, branch_id: String) -> bool:
	var progress: Dictionary = state.dungeon_progress.get(branch_id, {})
	return int(progress.get("attempts", 0)) > 0 or bool(progress.get("cleared", false))

static func choices(chapter_id: String) -> Array:
	return StoryChapterDefs.choices(chapter_id)

static func first_choice_id(chapter_id: String) -> String:
	var items := choices(chapter_id)
	if items.is_empty():
		return ""
	var first: Dictionary = items[0]
	return String(first.get("id", ""))

static func choice(chapter_id: String, choice_id: String) -> Dictionary:
	return StoryChapterDefs.choice(chapter_id, choice_id)

static func resolve_choice(state, chapter_id: String, choice_id: String) -> Dictionary:
	ensure_story_state(state)
	var chapter_def: Dictionary = chapter(chapter_id)
	var progress: Dictionary = state.story_progress.get(chapter_id, {})
	if not bool(progress.get("unlocked", false)):
		return {"ok": false, "message": "剧情尚未解锁。"}
	if bool(progress.get("resolved", false)):
		return {"ok": false, "message": "该剧情节点已经触发过，不能重复改写。"}
	var choice_def: Dictionary = choice(chapter_id, choice_id)
	if choice_def.is_empty():
		return {"ok": false, "message": "请选择一个有效抉择。"}
	var costs: Dictionary = choice_def.get("costs", {})
	if not state.can_pay(costs):
		return {"ok": false, "message": "抉择失败：资源不足。"}
	state.pay(costs)
	var rewards: Dictionary = choice_def.get("rewards", {})
	for id in rewards.keys():
		state.add_resource(String(id), int(rewards[id]))
	for gu_id_value in choice_def.get("gu_rewards", []):
		state.add_gu(String(gu_id_value), 1)
	for npc_id_value in choice_def.get("meet_npcs", []):
		_set_npc_met(state, String(npc_id_value), true)
	for npc_id_value in choice_def.get("kill_npcs", []):
		_set_npc_alive(state, String(npc_id_value), false)
	var cultivation_gain: int = int(choice_def.get("cultivation_exp", 0))
	if cultivation_gain > 0:
		CultivationService.add_exp(state, cultivation_gain, "剧情感悟")
	var morality_delta: int = int(choice_def.get("morality_delta", 0))
	if morality_delta != 0:
		apply_story_morality(state, morality_delta, "剧情抉择")
	progress["resolved"] = true
	progress["choice_id"] = choice_id
	progress["resolved_month"] = int(state.world_month)
	progress["intro_seen"] = true
	state.story_progress[chapter_id] = progress
	for unlock_id_value in chapter_def.get("unlocks", []):
		var unlock_id := String(unlock_id_value)
		var unlock_progress: Dictionary = state.story_progress.get(unlock_id, {})
		if _prerequisites_met(state, unlock_id):
			unlock_progress["unlocked"] = true
		state.story_progress[unlock_id] = unlock_progress
	_apply_story_unlock_rules(state)
	var log_text: String = String(choice_def.get("log", "%s：剧情已推进。" % String(chapter_def.get("name", "剧情"))))
	state.add_log(log_text)
	var message := "%s：%s" % [String(chapter_def.get("name", "剧情")), String(choice_def.get("title", "抉择"))]
	var result := {"ok": true, "message": message, "encounter": {}}
	if typeof(choice_def.get("encounter", null)) == TYPE_DICTIONARY:
		result["encounter"] = choice_def["encounter"].duplicate(true)
	return result

static func mark_story_combat_victory(state, chapter_id: String) -> void:
	ensure_story_state(state)
	var progress: Dictionary = state.story_progress.get(chapter_id, {})
	progress["combat_cleared"] = true
	state.story_progress[chapter_id] = progress

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

static func _apply_story_unlock_rules(state) -> void:
	for chapter_id_value in StoryChapterDefs.chapter_ids():
		var chapter_id := String(chapter_id_value)
		var chapter_def: Dictionary = StoryChapterDefs.chapter(chapter_id)
		var progress: Dictionary = state.story_progress.get(chapter_id, {})
		if not _prerequisites_met(state, chapter_id) and not _chapter_has_history(state, chapter_id):
			progress["unlocked"] = false
		state.story_progress[chapter_id] = progress

static func _prerequisites_met(state, chapter_id: String) -> bool:
	var chapter_def: Dictionary = StoryChapterDefs.chapter(chapter_id)
	for prereq_value in chapter_def.get("prerequisites", []):
		var prereq_id := String(prereq_value)
		var prereq_progress: Dictionary = state.story_progress.get(prereq_id, {})
		if not bool(prereq_progress.get("resolved", false)) and not _chapter_has_history(state, prereq_id):
			return false
	return true

static func _chapter_has_history(state, chapter_id: String) -> bool:
	if chapter_id == CHAPTER_ID:
		for branch_id in DungeonDefs.branch_ids():
			if branch_attempted(state, String(branch_id)):
				return true
	var progress: Dictionary = state.story_progress.get(chapter_id, {})
	return bool(progress.get("resolved", false)) or String(progress.get("choice_id", "")) != ""

static func _visible_chapter_count(state) -> int:
	var count := 0
	for chapter_id_value in StoryChapterDefs.chapter_ids():
		var chapter_id := String(chapter_id_value)
		var progress: Dictionary = state.story_progress.get(chapter_id, {})
		if bool(progress.get("unlocked", false)) or bool(progress.get("resolved", false)) or _chapter_has_history(state, chapter_id):
			count += 1
	return count

static func _set_npc_met(state, npc_id: String, value: bool) -> void:
	for i in range(state.npcs.size()):
		var npc: Dictionary = state.npcs[i]
		if String(npc.get("id", "")) == npc_id:
			npc["met"] = value
			if not npc.has("alive"):
				npc["alive"] = true
			state.npcs[i] = npc
			return

static func _set_npc_alive(state, npc_id: String, value: bool) -> void:
	for i in range(state.npcs.size()):
		var npc: Dictionary = state.npcs[i]
		if String(npc.get("id", "")) == npc_id:
			npc["alive"] = value
			npc["met"] = true
			npc["last_action"] = "剧情中身死" if not value else String(npc.get("last_action", "重新现身"))
			state.npcs[i] = npc
			return

extends RefCounted

const DungeonDefs := preload("res://scripts/data/dungeon_defs.gd")
const StoryService := preload("res://scripts/story_service.gd")
const GameState := preload("res://scripts/game_state.gd")
const CultivationService := preload("res://scripts/cultivation_service.gd")

static func start_branch(state, branch_id: String, difficulty_id: String) -> Dictionary:
	StoryService.ensure_story_state(state)
	StoryService.mark_attempt(state, branch_id, difficulty_id)
	var encounter: Dictionary = DungeonDefs.build_branch_encounter(branch_id, difficulty_id)
	state.add_log("踏入%s：%s。" % [String(encounter.get("name", "副本")), String(encounter.get("objective", "完成试炼"))])
	return encounter

static func wild_encounter(state) -> Dictionary:
	var encounter: Dictionary = DungeonDefs.build_wild_encounter()
	state.add_log("你被卷入野外遭遇。")
	return encounter

static func apply_result(state, encounter: Dictionary, victory: bool) -> String:
	if victory:
		_apply_rewards(state, encounter.get("rewards", {}))
		var cultivation_gain: int = _cultivation_reward(encounter)
		CultivationService.add_exp(state, cultivation_gain, "战斗感悟")
		var gu_reward: String = String(encounter.get("gu_reward", ""))
		if gu_reward != "" and not bool(GameState.GU_DEFINITIONS.get(gu_reward, {}).get("unique", false)):
			state.add_gu(gu_reward, 1)
		if String(encounter.get("branch_id", "")) != "wild":
			StoryService.mark_victory(state, String(encounter.get("branch_id", "")), String(encounter.get("difficulty_id", "normal")))
		if state.has_method("adjust_morality"):
			state.adjust_morality(int(encounter.get("morality_delta", 0)), "副本结算")
		return _reward_text(encounter.get("rewards", {}), gu_reward, cultivation_gain)

	var failure: Dictionary = encounter.get("failure", {})
	state.character["hp"] = int(state.character.get("max_hp", 100))
	state.character["lifespan_days"] = max(0, int(state.character.get("lifespan_days", 0)) - int(failure.get("lifespan_loss", 240)))
	if state.has_method("adjust_morality"):
		state.adjust_morality(-1, "败退求生")
	return "重伤遁逃，寿元折损 %d 天" % int(failure.get("lifespan_loss", 240))

static func _apply_rewards(state, rewards: Dictionary) -> void:
	for id in rewards.keys():
		state.add_resource(String(id), int(rewards[id]))

static func _cultivation_reward(encounter: Dictionary) -> int:
	var difficulty_id: String = String(encounter.get("difficulty_id", "normal"))
	var branch_id: String = String(encounter.get("branch_id", "wild"))
	var base: int = 90 if branch_id == "wild" else 150
	match difficulty_id:
		"danger":
			base = int(round(float(base) * 1.55))
		"desperate":
			base = int(round(float(base) * 2.35))
	return base + int(encounter.get("risk", 20)) * 2

static func _reward_text(rewards: Dictionary, gu_reward: String, cultivation_gain: int) -> String:
	var parts: Array = []
	for id in rewards.keys():
		parts.append("%s +%d" % [_resource_name(String(id)), int(rewards[id])])
	if gu_reward != "":
		parts.append("蛊虫 +1")
	if cultivation_gain > 0:
		parts.append("修为 +%d" % cultivation_gain)
	return "获得%s" % _join_strings(parts, " / ")

static func _join_strings(parts: Array, separator: String) -> String:
	var text := ""
	for part in parts:
		if text != "":
			text += separator
		text += String(part)
	return text

static func _resource_name(id: String) -> String:
	match id:
		"immortal_stone":
			return "仙元石"
		"spirit_qi":
			return "灵气"
		"intel":
			return "情报"
		"materials":
			return "材料"
	return id

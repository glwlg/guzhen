extends RefCounted

const RANK_NAMES := ["一转", "二转", "三转", "四转", "五转", "六转", "七转", "八转", "九转"]
const RANK_STAGES := ["初阶", "中阶", "高阶", "巅峰"]

static func migrate_character(character: Dictionary) -> Dictionary:
	var rank: int = int(character.get("rank", 0))
	if rank <= 0:
		rank = _legacy_realm_to_rank(int(character.get("realm_index", 1)))
	character["rank"] = clampi(rank, 1, 9)
	if not character.has("rank_stage"):
		character["rank_stage"] = 0
	character["rank_stage"] = clampi(int(character.get("rank_stage", 0)), 0, RANK_STAGES.size() - 1)
	if not character.has("morality_score"):
		character["morality_score"] = 0
	return character

static func display_realm(character: Dictionary) -> String:
	var rank: int = clampi(int(character.get("rank", character.get("realm_index", 1))), 1, 9)
	var stage: int = clampi(int(character.get("rank_stage", 0)), 0, RANK_STAGES.size() - 1)
	if rank >= 9:
		return "%s%s" % [rank_name(rank), cultivation_title(character)]
	return "%s%s %s" % [rank_name(rank), stage_name(stage), cultivation_title(character)]

static func npc_realm_name(npc: Dictionary) -> String:
	var character_like := {
		"rank": int(npc.get("rank", npc.get("realm_index", 1))),
		"rank_stage": int(npc.get("rank_stage", 0)),
		"morality_score": int(npc.get("morality_score", 0))
	}
	return display_realm(character_like)

static func cultivation_title(character: Dictionary) -> String:
	var rank: int = clampi(int(character.get("rank", character.get("realm_index", 1))), 1, 9)
	if rank >= 9:
		return "仙尊" if int(character.get("morality_score", 0)) >= 0 else "魔尊"
	if rank >= 6:
		return "蛊仙"
	return "蛊师"

static func rank_name(rank: int) -> String:
	var index: int = clampi(rank - 1, 0, RANK_NAMES.size() - 1)
	return String(RANK_NAMES[index])

static func stage_name(stage: int) -> String:
	return String(RANK_STAGES[clampi(stage, 0, RANK_STAGES.size() - 1)])

static func progress_stage(character: Dictionary, amount: int = 1) -> Dictionary:
	var rank: int = clampi(int(character.get("rank", 1)), 1, 9)
	var stage: int = clampi(int(character.get("rank_stage", 0)), 0, RANK_STAGES.size() - 1)
	stage += amount
	while stage >= RANK_STAGES.size() and rank < 9:
		stage -= RANK_STAGES.size()
		rank += 1
	character["rank"] = clampi(rank, 1, 9)
	character["rank_stage"] = clampi(stage, 0, RANK_STAGES.size() - 1)
	return character

static func _legacy_realm_to_rank(legacy_index: int) -> int:
	return clampi(legacy_index, 1, 9)

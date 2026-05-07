extends RefCounted

const GuService := preload("res://scripts/gu_service.gd")
const RefineChainDefs := preload("res://scripts/data/refine_chain_defs.gd")

static func upgrade_preview(state, gu_id: String) -> Dictionary:
	GuService.ensure_instance_state(state)
	var instance: Dictionary = GuService.best_instance(state, gu_id)
	if instance.is_empty():
		return {"ok": false, "reason": "未拥有该蛊虫"}
	var rank: int = clampi(int(instance.get("rank", 1)), 1, 9)
	if rank >= 5:
		return {"ok": false, "reason": "凡蛊已至五转，继续提升需要仙蛊合炼链"}
	var def: Dictionary = state.GU_DEFINITIONS.get(gu_id, {})
	var school: String = String(def.get("school", ""))
	var school_focus: bool = int(state.character.get("dao_marks", {}).get(school, 0)) >= 72
	var costs: Dictionary = RefineChainDefs.upgrade_cost(rank, school_focus)
	var duplicate_need: int = RefineChainDefs.duplicate_required(rank)
	var success: float = RefineChainDefs.upgrade_success_base(rank, school_focus)
	success += float(state.character.get("dao_marks", {}).get(school, 35)) / 520.0
	success -= float(state.aperture.get("conflict_rate", 30)) / 650.0
	success += float(int(instance.get("health", 100)) - 70) / 900.0
	success = clampf(success, 0.12, 0.94)
	return {
		"ok": true,
		"gu_id": gu_id,
		"rank": rank,
		"next_rank": rank + 1,
		"costs": costs,
		"duplicate_need": duplicate_need,
		"success_rate": success,
		"school_focus": school_focus
	}

static func try_upgrade(state, gu_id: String, rng: RandomNumberGenerator) -> Dictionary:
	var preview: Dictionary = upgrade_preview(state, gu_id)
	if not bool(preview.get("ok", false)):
		return {"ok": false, "message": String(preview.get("reason", "无法升转")), "feedback": "blocked"}
	var costs: Dictionary = preview.get("costs", {})
	if not state.can_pay(costs):
		return {"ok": false, "message": "升转失败：仙元石、灵气、情报或材料不足。", "feedback": "blocked"}
	var duplicate_need: int = int(preview.get("duplicate_need", 0))
	if duplicate_need > 0 and GuService.count_gu(state, gu_id) < duplicate_need + 1:
		return {"ok": false, "message": "升转失败：二转以上升转需要同类凡蛊作为合炼引子。", "feedback": "blocked"}
	state.pay(costs)
	if duplicate_need > 0:
		GuService.remove_gu(state, gu_id, duplicate_need)
	var months: int = int(preview.get("rank", 1))
	var gu_name: String = state.get_gu_name(gu_id)
	var success_rate: float = float(preview.get("success_rate", 0.5))
	var roll: float = rng.randf()
	var result: Dictionary = {"ok": false, "months": months, "feedback": "backlash", "message": ""}
	if roll <= success_rate and GuService.upgrade_best_mortal(state, gu_id):
		result["ok"] = true
		result["feedback"] = "success"
		result["message"] = "升转成功：%s 晋升为 %s凡蛊。" % [gu_name, state.RANK_NAMES[int(preview.get("next_rank", 2)) - 1]]
	else:
		GuService.degrade_gu_instance(state, gu_id, 22 + int(preview.get("rank", 1)) * 5)
		state.character["hp"] = max(1, int(state.character.get("hp", 100)) - 8 - int(preview.get("rank", 1)) * 2)
		state.character["lifespan_days"] = max(0, int(state.character.get("lifespan_days", 0)) - 18 * int(preview.get("rank", 1)))
		result["message"] = "升转失败：%s 合炼链不稳，蛊虫受损并折寿。" % gu_name
	return result

static func immortal_refine_preview(state, recipe: Dictionary) -> Dictionary:
	var result_id: String = String(recipe.get("result", ""))
	var result_def: Dictionary = state.GU_DEFINITIONS.get(result_id, {})
	var requires: Dictionary = recipe.get("requires_gu", {})
	var missing: Array = []
	var min_rank_needed: int = 1
	if int(result_def.get("rank", 1)) >= 6:
		min_rank_needed = 2
	for gu_id_value in requires.keys():
		var gu_id: String = String(gu_id_value)
		var amount: int = int(requires[gu_id])
		if not GuService.has_gu(state, gu_id, amount):
			missing.append("%s x%d" % [state.get_gu_name(gu_id), amount])
			continue
		if min_rank_needed > 1 and GuService.best_rank(state, gu_id) < min_rank_needed:
			missing.append("%s 至少需二转骨架" % state.get_gu_name(gu_id))
	var school: String = String(result_def.get("school", ""))
	var dao_bonus: float = float(state.character.get("dao_marks", {}).get(school, 35)) / 430.0
	var aperture_penalty: float = float(state.aperture.get("conflict_rate", 30)) / 540.0
	var condition_bonus: float = 0.0
	for gu_id_value in requires.keys():
		var modifier: Dictionary = GuService.move_component_modifier(state, String(gu_id_value))
		condition_bonus += float(int(modifier.get("health", 100)) - 70) / 1400.0
	var success_rate: float = clampf(float(recipe.get("base_success", 0.5)) + dao_bonus + condition_bonus - aperture_penalty, 0.05, 0.95)
	return {
		"missing": missing,
		"success_rate": success_rate,
		"chain_hint": RefineChainDefs.immortal_chain_hint(result_id),
		"min_rank_needed": min_rank_needed
	}

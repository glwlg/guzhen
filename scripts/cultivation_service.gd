extends RefCounted

const RealmService := preload("res://scripts/realm_service.gd")
const AscensionDefs := preload("res://scripts/data/ascension_defs.gd")

static func ensure_cultivation_state(state) -> void:
	state.character = RealmService.migrate_character(state.character)
	state.cultivation_exp = max(0, int(state.cultivation_exp))
	state.bottleneck = clampi(int(state.bottleneck), 0, 100)
	state.breakthrough_progress = current_progress_percent(state)
	if typeof(state.breakthrough_history) != TYPE_ARRAY:
		state.breakthrough_history = []
	if typeof(state.ascension_state) != TYPE_DICTIONARY:
		state.ascension_state = {}
	if state.ascension_state.is_empty():
		state.ascension_state = _default_ascension_state()
	else:
		if not state.ascension_state.has("status"):
			state.ascension_state["status"] = "idle"
		if not state.ascension_state.has("phases") or typeof(state.ascension_state.get("phases", null)) != TYPE_ARRAY:
			state.ascension_state["phases"] = _default_phase_states()
		if not state.ascension_state.has("last_result"):
			state.ascension_state["last_result"] = ""
		if not state.ascension_state.has("attempts"):
			state.ascension_state["attempts"] = 0

static func current_threshold(state) -> int:
	ensure_cultivation_state(state)
	var rank: int = int(state.character.get("rank", 1))
	var stage: int = int(state.character.get("rank_stage", 0))
	return AscensionDefs.breakthrough_threshold(rank, stage)

static func current_progress_percent(state) -> int:
	var rank: int = clampi(int(state.character.get("rank", 1)), 1, 9)
	var stage: int = clampi(int(state.character.get("rank_stage", 0)), 0, 3)
	if rank == 5 and stage == 3:
		return 100
	var threshold: int = AscensionDefs.breakthrough_threshold(rank, stage)
	if threshold <= 0:
		return 100
	return clampi(int(round(float(state.cultivation_exp) / float(threshold) * 100.0)), 0, 100)

static func add_exp(state, amount: int, reason: String = "") -> int:
	ensure_cultivation_state(state)
	amount = max(0, amount)
	if amount <= 0:
		return 0
	state.cultivation_exp += amount
	state.breakthrough_progress = current_progress_percent(state)
	if reason != "":
		state.add_log("%s：修为 +%d。" % [reason, amount])
	return amount

static func passive_monthly_gain(state, months: int) -> int:
	ensure_cultivation_state(state)
	var rank: int = int(state.character.get("rank", 1))
	var stability: int = int(state.aperture.get("stability", 50))
	var qi_balance: int = int(state.aperture.get("qi_balance", 50))
	var food: int = int(state.aperture.get("food_saturation", 50))
	return AscensionDefs.passive_gain(rank, stability, qi_balance, food, months)

static func retreat(state, months: int) -> Dictionary:
	ensure_cultivation_state(state)
	months = max(1, months)
	var costs: Dictionary = AscensionDefs.retreat_cost(months)
	if not state.can_pay(costs):
		state.add_log("闭关失败：灵气或仙元石不足。")
		return {"ok": false, "text": "资源不足"}
	state.pay(costs)
	var rank: int = int(state.character.get("rank", 1))
	var gain: int = AscensionDefs.retreat_gain(rank, months)
	var stability_bonus: int = max(0, int(state.aperture.get("stability", 50)) - 50) * months / 4
	var bottleneck_penalty: int = int(state.bottleneck) * months / 8
	gain = max(20 * months, gain + stability_bonus - bottleneck_penalty)
	add_exp(state, gain, "闭关修行")
	state.bottleneck = max(0, int(state.bottleneck) - months * 2)
	return {"ok": true, "text": "闭关 %d 月，修为 +%d" % [months, gain], "gain": gain}

static func try_breakthrough(state) -> Dictionary:
	ensure_cultivation_state(state)
	var rank: int = int(state.character.get("rank", 1))
	var stage: int = int(state.character.get("rank_stage", 0))
	if rank >= 6:
		state.add_log("高转突破框架已记录，七转以上内容将在后续阶段展开。")
		return {"ok": false, "text": "高转突破暂未开放"}
	if rank == 5 and stage == 3:
		state.add_log("五转巅峰已至，需准备升仙试炼。")
		return {"ok": false, "text": "请准备升仙"}
	var threshold: int = AscensionDefs.breakthrough_threshold(rank, stage)
	if int(state.cultivation_exp) < threshold:
		state.add_log("冲击小阶失败：修为积累不足。")
		return {"ok": false, "text": "修为不足"}
	var costs: Dictionary = AscensionDefs.breakthrough_cost(rank, stage)
	if not state.can_pay(costs):
		state.add_log("冲击小阶失败：突破材料不足。")
		return {"ok": false, "text": "材料不足"}
	state.pay(costs)
	var chance: int = _breakthrough_chance(state, rank, stage)
	var roll: int = randi_range(1, 100)
	if roll <= chance:
		state.cultivation_exp = max(0, int(state.cultivation_exp) - threshold)
		state.character = RealmService.progress_stage(state.character, 1)
		state.bottleneck = max(0, int(state.bottleneck) - 12)
		var primary_school: String = String(state.character.get("primary_school", "剑道"))
		var dao_marks: Dictionary = state.character.get("dao_marks", {}).duplicate(true)
		dao_marks[primary_school] = int(dao_marks.get(primary_school, 0)) + 5 + rank
		state.character["dao_marks"] = dao_marks
		var result_text: String = "突破成功：晋升%s。" % RealmService.display_realm(state.character)
		_push_history(state, result_text, true)
		state.add_log(result_text)
	else:
		var damage: int = randi_range(8, 18) + rank * 2
		state.character["hp"] = max(1, int(state.character.get("hp", 100)) - damage)
		state.cultivation_exp = max(0, int(state.cultivation_exp) - threshold / 4)
		state.bottleneck = clampi(int(state.bottleneck) + 9 + stage, 0, 100)
		if typeof(state.tribulation_state) == TYPE_DICTIONARY:
			state.tribulation_state["pressure"] = clampi(int(state.tribulation_state.get("pressure", 20)) + 6 + rank, 0, 100)
		var result_text: String = "突破失败：瓶颈加深，生命受损 %d。" % damage
		_push_history(state, result_text, false)
		state.add_log(result_text)
	state.breakthrough_progress = current_progress_percent(state)
	return {"ok": true, "success": roll <= chance, "chance": chance, "roll": roll}

static func can_prepare_ascension(state) -> bool:
	ensure_cultivation_state(state)
	return int(state.character.get("rank", 1)) == 5 and int(state.character.get("rank_stage", 0)) == 3

static func prepare_ascension(state) -> Dictionary:
	ensure_cultivation_state(state)
	if not can_prepare_ascension(state):
		state.add_log("升仙准备失败：须先抵达五转巅峰。")
		return {"ok": false, "text": "境界不足"}
	var costs: Dictionary = AscensionDefs.ascension_cost()
	if not state.can_pay(costs):
		state.add_log("升仙准备失败：灵气、仙元石、情报或材料不足。")
		return {"ok": false, "text": "资源不足"}
	state.pay(costs)
	state.ascension_state = _default_ascension_state()
	state.ascension_state["status"] = "active"
	state.ascension_state["attempts"] = int(state.ascension_state.get("attempts", 0)) + 1
	state.add_log("升仙试炼已开启：天地二气开始倒灌。")
	return {"ok": true, "text": "升仙试炼已开启"}

static func resolve_next_ascension_phase(state) -> Dictionary:
	ensure_cultivation_state(state)
	if String(state.ascension_state.get("status", "idle")) != "active":
		state.add_log("升仙试炼尚未开启。")
		return {"ok": false, "text": "试炼未开启"}
	var phase_index: int = _next_pending_phase_index(state)
	if phase_index < 0:
		return _complete_ascension(state)
	var phases: Array = state.ascension_state.get("phases", [])
	var phase: Dictionary = phases[phase_index]
	var score: int = _phase_score(state, String(phase.get("id", "")))
	var difficulty: int = int(phase.get("difficulty", 100))
	var roll: int = randi_range(-10, 16)
	var success: bool = score + roll >= difficulty
	phase["score"] = score + roll
	phase["success"] = success
	phase["status"] = "success" if success else "failed"
	phases[phase_index] = phase
	state.ascension_state["phases"] = phases
	if success:
		var text: String = "升仙试炼：%s通过。" % String(phase.get("name", "阶段"))
		state.ascension_state["last_result"] = text
		state.add_log(text)
		if _next_pending_phase_index(state) < 0:
			return _complete_ascension(state)
		return {"ok": true, "success": true, "text": text}
	var damage: int = clampi(difficulty - score + 18, 18, 90)
	state.character["hp"] = max(1, int(state.character.get("hp", 100)) - damage)
	state.character["lifespan_days"] = max(0, int(state.character.get("lifespan_days", 0)) - damage * 5)
	state.aperture["stability"] = clampi(int(state.aperture.get("stability", 50)) - damage / 4, 0, 100)
	state.bottleneck = clampi(int(state.bottleneck) + 18, 0, 100)
	state.ascension_state["status"] = "failed"
	var text: String = "升仙试炼失败：%s反噬，寿元与仙窍受损。" % String(phase.get("name", "阶段"))
	state.ascension_state["last_result"] = text
	_push_history(state, text, false)
	state.add_log(text)
	return {"ok": true, "success": false, "text": text}

static func cultivation_status(state) -> Dictionary:
	ensure_cultivation_state(state)
	var threshold: int = current_threshold(state)
	var rank: int = int(state.character.get("rank", 1))
	var stage: int = int(state.character.get("rank_stage", 0))
	return {
		"realm": RealmService.display_realm(state.character),
		"rank": rank,
		"stage": stage,
		"stage_name": AscensionDefs.stage_name(stage),
		"stage_id": AscensionDefs.stage_id(stage),
		"exp": int(state.cultivation_exp),
		"threshold": threshold,
		"progress": current_progress_percent(state),
		"bottleneck": int(state.bottleneck),
		"breakthrough_chance": _breakthrough_chance(state, rank, stage),
		"can_ascend": can_prepare_ascension(state),
		"ascension": state.ascension_state.duplicate(true),
		"history": state.breakthrough_history.duplicate(true)
	}

static func _breakthrough_chance(state, rank: int, stage: int) -> int:
	var base: int = AscensionDefs.breakthrough_base_chance(rank, stage)
	var stability_bonus: int = int(state.aperture.get("stability", 50)) / 5 - 10
	var qi_bonus: int = int(state.aperture.get("qi_balance", 50)) / 6 - 8
	var primary_school: String = String(state.character.get("primary_school", "剑道"))
	var dao_marks: Dictionary = state.character.get("dao_marks", {})
	var dao_bonus: int = int(dao_marks.get(primary_school, 50)) / 12
	var bottleneck_penalty: int = int(state.bottleneck) / 2
	return clampi(base + stability_bonus + qi_bonus + dao_bonus - bottleneck_penalty, 8, 92)

static func _phase_score(state, phase_id: String) -> int:
	var stability: int = int(state.aperture.get("stability", 50))
	var qi_balance: int = int(state.aperture.get("qi_balance", 50))
	var conflict: int = int(state.aperture.get("conflict_rate", 30))
	var primary_school: String = String(state.character.get("primary_school", "剑道"))
	var dao_marks: Dictionary = state.character.get("dao_marks", {})
	var dao_score: int = int(dao_marks.get(primary_school, 50))
	match phase_id:
		"qi_balance":
			return qi_balance + stability / 2 + int(state.cultivation_exp) / 80 - int(state.bottleneck) / 3
		"dao_pressure":
			return dao_score + stability / 2 - conflict / 2 + int(state.cultivation_exp) / 120
		"inner_demon":
			var lifespan_years: int = int(state.character.get("lifespan_days", 0)) / 360
			return 58 + min(30, lifespan_years) + int(state.resources.get("intel", 0)) / 90 - int(state.bottleneck) / 2
	return 60

static func _complete_ascension(state) -> Dictionary:
	state.character["rank"] = 6
	state.character["rank_stage"] = 0
	state.character["realm_index"] = 6
	state.cultivation_exp = 0
	state.breakthrough_progress = 0
	state.bottleneck = max(0, int(state.bottleneck) - 24)
	var primary_school: String = String(state.character.get("primary_school", "剑道"))
	var dao_marks: Dictionary = state.character.get("dao_marks", {}).duplicate(true)
	for school in dao_marks.keys():
		dao_marks[school] = int(dao_marks[school]) + 10
	dao_marks[primary_school] = int(dao_marks.get(primary_school, 0)) + 36
	state.character["dao_marks"] = dao_marks
	state.aperture["stability"] = clampi(int(state.aperture.get("stability", 50)) + 15, 0, 100)
	state.aperture["stone_delta"] = int(state.aperture.get("stone_delta", 20)) + 12
	state.add_resource("materials", 3)
	_upgrade_aperture_nodes(state)
	if state.has_method("adjust_morality"):
		state.adjust_morality(2, "升仙抉择")
	state.ascension_state["status"] = "complete"
	state.ascension_state["last_result"] = "升仙成功：六转蛊仙"
	var text: String = "升仙成功：晋升六转初阶蛊仙，仙窍完成第一次扩容。"
	_push_history(state, text, true)
	state.add_log(text)
	return {"ok": true, "success": true, "completed": true, "text": text}

static func _upgrade_aperture_nodes(state) -> void:
	var nodes: Array = state.aperture.get("nodes", [])
	for i in range(nodes.size()):
		var node: Dictionary = nodes[i]
		node["level"] = int(node.get("level", 1)) + 1
		node["pressure"] = max(0, int(node.get("pressure", 40)) - 12)
		node["status"] = "稳定"
		nodes[i] = node
	state.aperture["nodes"] = nodes

static func _default_ascension_state() -> Dictionary:
	return {
		"status": "idle",
		"attempts": 0,
		"phases": _default_phase_states(),
		"last_result": ""
	}

static func _default_phase_states() -> Array:
	var phases: Array = []
	for raw_phase in AscensionDefs.ascension_phases():
		var phase: Dictionary = raw_phase
		phase["status"] = "pending"
		phase["score"] = 0
		phase["success"] = false
		phases.append(phase)
	return phases

static func _next_pending_phase_index(state) -> int:
	var phases: Array = state.ascension_state.get("phases", [])
	for i in range(phases.size()):
		var phase: Dictionary = phases[i]
		if String(phase.get("status", "pending")) == "pending":
			return i
	return -1

static func _push_history(state, text: String, success: bool) -> void:
	if typeof(state.breakthrough_history) != TYPE_ARRAY:
		state.breakthrough_history = []
	state.breakthrough_history.push_front({
		"month": int(state.world_month),
		"realm": RealmService.display_realm(state.character),
		"success": success,
		"text": text
	})
	while state.breakthrough_history.size() > 16:
		state.breakthrough_history.pop_back()

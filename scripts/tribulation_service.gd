extends RefCounted

const TribulationDefs := preload("res://scripts/data/tribulation_defs.gd")
const ApertureService := preload("res://scripts/aperture_service.gd")

static func ensure_tribulation_state(state) -> void:
	if typeof(state.tribulation_state) != TYPE_DICTIONARY:
		state.tribulation_state = {}
	var data: Dictionary = state.tribulation_state
	if not data.has("next_month"):
		data["next_month"] = max(8, int(state.world_month) + 12)
	if not data.has("pressure"):
		data["pressure"] = clampi(20 + int(state.aperture.get("conflict_rate", 30)) / 3, 0, 100)
	if not data.has("active"):
		data["active"] = false
	if not data.has("current") or typeof(data.get("current", null)) != TYPE_DICTIONARY:
		data["current"] = {}
	if not data.has("history") or typeof(data.get("history", null)) != TYPE_ARRAY:
		data["history"] = []
	if not data.has("prepared_script_index"):
		data["prepared_script_index"] = -1
	state.tribulation_state = data

static func advance_months(state, months: int) -> Array:
	ensure_tribulation_state(state)
	months = max(1, months)
	var data: Dictionary = state.tribulation_state
	var pressure_gain := months * 3 + int(ceil(float(state.aperture.get("conflict_rate", 30)) / 35.0))
	if int(state.aperture.get("stability", 50)) < 45:
		pressure_gain += months
	data["pressure"] = clampi(int(data.get("pressure", 0)) + pressure_gain, 0, 100)
	var warnings: Array = []
	if not bool(data.get("active", false)) and int(state.world_month) >= int(data.get("next_month", 12)):
		var current := TribulationDefs.pick_for_state(state)
		current["spawn_month"] = int(state.world_month)
		current["severity"] = clampi(int(current.get("severity", current.get("base_severity", 50))) + int(data.get("pressure", 0)) / 5, 30, 100)
		data["active"] = true
		data["current"] = current
		warnings.append("%s 已锁定仙窍，建议准备防御脚本。" % String(current.get("name", "灾劫")))
		state.add_log("灾劫预警：%s 降临，目标节点为%s。" % [String(current.get("name", "灾劫")), String(current.get("target_node", "仙窍"))])
	state.tribulation_state = data
	return warnings

static func prepare_defense(state) -> bool:
	ensure_tribulation_state(state)
	if state.defense_scripts.is_empty():
		var fallback: Dictionary = state.get_active_killer_move()
		if fallback.is_empty():
			state.add_log("防御脚本准备失败：暂无可用杀招。")
			return false
		state.add_defense_script(fallback)
	state.tribulation_state["prepared_script_index"] = clampi(int(state.active_defense_script), 0, state.defense_scripts.size() - 1)
	var script: Dictionary = state.get_active_defense_script()
	state.add_log("防御脚本已装载：%s。" % String(script.get("name", "未命名脚本")))
	return true

static func resolve(state, force: bool = false) -> Dictionary:
	ensure_tribulation_state(state)
	ApertureService.ensure_ecology_state(state)
	var data: Dictionary = state.tribulation_state
	if not bool(data.get("active", false)):
		if not force:
			return {"resolved": false, "text": "暂无可渡灾劫。"}
		var current := TribulationDefs.pick_for_state(state)
		current["spawn_month"] = int(state.world_month)
		current["severity"] = clampi(int(current.get("severity", current.get("base_severity", 50))) + int(data.get("pressure", 0)) / 5, 30, 100)
		data["active"] = true
		data["current"] = current
	var tribulation: Dictionary = data.get("current", {})
	if tribulation.is_empty():
		tribulation = TribulationDefs.pick_for_state(state)
	var script: Dictionary = state.get_active_defense_script()
	var severity := clampi(int(tribulation.get("severity", tribulation.get("base_severity", 55))) + int(data.get("pressure", 0)) / 8, 30, 110)
	var condition_penalty := ApertureService.condition_penalty_for_move(state, script)
	var tags: Array = script.get("tags", [])
	var defense_score := int(script.get("stability", 55)) + int(script.get("power", 200)) / 28
	defense_score += int(state.aperture.get("stability", 50)) / 3 + int(state.aperture.get("qi_balance", 50)) / 4
	defense_score -= int(script.get("risk", 20)) / 2 + condition_penalty
	if tags.has("guard"):
		defense_score += 18
	if String(tribulation.get("target_node", "")) == "虫巢" and tags.has("homing"):
		defense_score += 8
	if String(tribulation.get("id", "")) == "earth_fire" and String(script.get("core", "")) == "refine_core":
		defense_score += 12
	var roll := randi_range(-10, 12)
	var success := defense_score + roll >= severity
	var text := ""
	if success:
		var reward_school := String(tribulation.get("reward_school", "运道"))
		var dao_marks: Dictionary = state.character.get("dao_marks", {}).duplicate(true)
		dao_marks[reward_school] = int(dao_marks.get(reward_school, 0)) + 8 + severity / 14
		state.character["dao_marks"] = dao_marks
		state.aperture["stability"] = clampi(int(state.aperture.get("stability", 50)) + 7, 0, 100)
		state.aperture["stone_delta"] = int(state.aperture.get("stone_delta", 20)) + 4
		state.add_resource("materials", 1)
		text = "渡过%s：新增%s道痕，仙窍扩容。" % [String(tribulation.get("name", "灾劫")), reward_school]
		state.add_log(text)
	else:
		var damage := clampi(severity - defense_score / 2, 10, 80)
		state.character["hp"] = max(1, int(state.character.get("hp", 100)) - damage)
		state.character["lifespan_days"] = max(0, int(state.character.get("lifespan_days", 0)) - damage * 4)
		state.aperture["stability"] = clampi(int(state.aperture.get("stability", 50)) - damage / 3, 0, 100)
		state.aperture["food_saturation"] = clampi(int(state.aperture.get("food_saturation", 50)) - damage / 4, 0, 100)
		_damage_target_node(state, String(tribulation.get("target_node", "")), damage)
		text = "渡劫失败：%s 重创仙窍，生命与寿元受损。" % String(tribulation.get("name", "灾劫"))
		state.add_log(text)
	var history: Array = data.get("history", [])
	history.push_front({
		"month": int(state.world_month),
		"name": String(tribulation.get("name", "灾劫")),
		"severity": severity,
		"score": defense_score + roll,
		"success": success,
		"text": text
	})
	while history.size() > 12:
		history.pop_back()
	data["history"] = history
	data["active"] = false
	data["current"] = {}
	data["pressure"] = clampi(int(data.get("pressure", 0)) - (34 if success else 18), 12, 100)
	data["next_month"] = int(state.world_month) + 10 + randi_range(0, 5)
	state.tribulation_state = data
	return {"resolved": true, "success": success, "text": text, "severity": severity, "score": defense_score + roll}

static func current_warnings(state) -> Array:
	ensure_tribulation_state(state)
	var warnings: Array = []
	var data: Dictionary = state.tribulation_state
	if bool(data.get("active", false)):
		var current: Dictionary = data.get("current", {})
		warnings.append("%s 正在压迫仙窍，目标：%s。" % [String(current.get("name", "灾劫")), String(current.get("target_node", "未知"))])
	elif int(data.get("pressure", 0)) >= 72:
		warnings.append("灾劫压力已达 %d%%，下次推进可能触发压测。" % int(data.get("pressure", 0)))
	return warnings

static func state_summary(state) -> Dictionary:
	ensure_tribulation_state(state)
	var data: Dictionary = state.tribulation_state
	var current: Dictionary = data.get("current", {})
	var name := String(current.get("name", "未锁定"))
	return {
		"active": bool(data.get("active", false)),
		"name": name,
		"pressure": int(data.get("pressure", 0)),
		"next_month": int(data.get("next_month", int(state.world_month) + 12)),
		"months_left": max(0, int(data.get("next_month", 0)) - int(state.world_month)),
		"target": String(current.get("target_node", "未知")),
		"description": String(current.get("description", "天地将定期压测仙窍。")),
		"history": data.get("history", [])
	}

static func _damage_target_node(state, node_name: String, damage: int) -> void:
	var nodes: Array = state.aperture.get("nodes", [])
	for i in range(nodes.size()):
		var node: Dictionary = nodes[i]
		if String(node.get("name", "")) == node_name:
			node["pressure"] = clampi(int(node.get("pressure", 40)) + damage / 2, 0, 100)
			node["status"] = "危险"
			nodes[i] = node
			state.aperture["nodes"] = nodes
			return

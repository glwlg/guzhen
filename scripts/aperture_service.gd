extends RefCounted

const GuEcologyDefs := preload("res://scripts/data/gu_ecology_defs.gd")
const GuService := preload("res://scripts/gu_service.gd")

static func ensure_ecology_state(state) -> void:
	GuService.ensure_instance_state(state)
	if typeof(state.gu_ecology) != TYPE_DICTIONARY:
		state.gu_ecology = {}
	var ecology: Dictionary = state.gu_ecology
	for gu_id_value in state.gu_inventory.keys():
		var gu_id := String(gu_id_value)
		var amount: int = max(1, int(state.gu_inventory.get(gu_id, 1)))
		var entry: Dictionary = {}
		if typeof(ecology.get(gu_id, null)) == TYPE_DICTIONARY:
			entry = ecology[gu_id]
		else:
			entry = GuEcologyDefs.default_state_for(gu_id, amount)
		var def: Dictionary = GuEcologyDefs.definition(gu_id)
		entry["id"] = gu_id
		entry["amount"] = amount
		entry["food_id"] = String(entry.get("food_id", def.get("food_id", "mixed_qi")))
		entry["food_name"] = String(entry.get("food_name", def.get("food_name", "混合灵气")))
		entry["node"] = String(entry.get("node", def.get("node", "虫巢")))
		entry["food"] = clampi(int(entry.get("food", 100)), 0, 100)
		entry["condition"] = clampi(int(entry.get("condition", 100)), 0, 100)
		entry["status"] = String(entry.get("status", "稳定"))
		entry["starvation_months"] = max(0, int(entry.get("starvation_months", 0)))
		entry["monthly_food"] = int(def.get("monthly_food", 3))
		entry["monthly_qi"] = int(def.get("monthly_qi", 40))
		entry["critical"] = bool(def.get("critical", false))
		entry["last_issue"] = String(entry.get("last_issue", ""))
		ecology[gu_id] = entry
	for gu_id_value in ecology.keys():
		var gu_id := String(gu_id_value)
		if not state.gu_inventory.has(gu_id):
			ecology.erase(gu_id)
	state.gu_ecology = ecology

static func advance_months(state, months: int) -> Array:
	months = max(1, months)
	ensure_ecology_state(state)
	var warnings: Array = []
	var total_food: int = 0
	var total_condition: int = 0
	var tracked: int = 0
	var stress: int = 0
	var global_food: int = int(state.aperture.get("food_saturation", 50))
	var qi_balance: int = int(state.aperture.get("qi_balance", 50))
	for gu_id_value in state.gu_ecology.keys():
		var gu_id := String(gu_id_value)
		var entry: Dictionary = state.gu_ecology[gu_id]
		var amount: int = max(1, int(entry.get("amount", 1)))
		var def: Dictionary = GuEcologyDefs.definition(gu_id)
		var qi_need: int = int(def.get("monthly_qi", 40)) * amount * months
		var qi_paid: int = min(qi_need, state.get_resource("spirit_qi"))
		if qi_paid > 0:
			state.add_resource("spirit_qi", -qi_paid)
		var food_loss: int = int(def.get("monthly_food", 3)) * amount * months
		if global_food < 55:
			food_loss += int(ceil(float(55 - global_food) * 0.08 * float(months)))
		if qi_balance < 45:
			food_loss += int(ceil(float(45 - qi_balance) * 0.06 * float(months)))
		if qi_paid < qi_need:
			food_loss += 5 * months
		var food: int = clampi(int(entry.get("food", 100)) - food_loss + int(ceil(float(global_food) * 0.015 * float(months))), 0, 100)
		var condition_loss: int = int(def.get("monthly_wear", 1)) * months
		if food < 35:
			condition_loss += 4 * months
			entry["starvation_months"] = int(entry.get("starvation_months", 0)) + months
		else:
			entry["starvation_months"] = max(0, int(entry.get("starvation_months", 0)) - months)
		var condition: int = clampi(int(entry.get("condition", 100)) - condition_loss, 0, 100)
		var status: String = "稳定"
		var issue: String = ""
		if food <= 0 or condition <= 0:
			status = "濒死"
			issue = "依赖断裂"
			stress += 12
			if bool(entry.get("critical", false)):
				state.character["hp"] = max(1, int(state.character.get("hp", 100)) - 6 * months)
				warnings.append("%s 生态断供，核心服务反噬生命。" % _gu_name(state, gu_id))
			elif state.remove_gu(gu_id, 1):
				amount = max(0, amount - 1)
				if amount <= 0:
					state.gu_ecology.erase(gu_id)
					warnings.append("%s 因长期断供损毁。" % _gu_name(state, gu_id))
					continue
				condition = 42
				food = 32
				warnings.append("%s 因长期断供损毁一只。" % _gu_name(state, gu_id))
		elif food < 25 or condition < 35:
			status = "危险"
			issue = "饥饿磨损"
			stress += 8
			warnings.append("%s 依赖不足，杀招稳定度会明显下降。" % _gu_name(state, gu_id))
		elif food < 50 or condition < 65:
			status = "告警"
			issue = "维护不足"
			stress += 4
		entry["amount"] = max(1, amount)
		entry["food"] = food
		entry["condition"] = condition
		entry["status"] = status
		entry["last_issue"] = issue
		state.gu_ecology[gu_id] = entry
		total_food += food
		total_condition += condition
		tracked += 1
	if tracked > 0:
		var avg_food := int(round(float(total_food) / float(tracked)))
		var avg_condition := int(round(float(total_condition) / float(tracked)))
		state.aperture["food_saturation"] = clampi(int(round((float(global_food) * 2.0 + float(avg_food)) / 3.0)), 0, 100)
		if avg_condition < 55:
			state.aperture["stability"] = clampi(int(state.aperture.get("stability", 50)) - int(ceil(float(55 - avg_condition) / 12.0)), 0, 100)
		if stress > 0:
			state.aperture["conflict_rate"] = clampi(int(state.aperture.get("conflict_rate", 30)) + int(ceil(float(stress) / 18.0)), 0, 100)
	return warnings

static func condition_penalty_for_move(state, move: Dictionary) -> int:
	ensure_ecology_state(state)
	var ids: Array = [String(move.get("core", ""))]
	for plugin_id in move.get("plugins", []):
		ids.append(String(plugin_id))
	var penalty := 0
	for gu_id in ids:
		if gu_id == "":
			continue
		if not state.gu_ecology.has(gu_id):
			penalty += 10
			continue
		var entry: Dictionary = state.gu_ecology[gu_id]
		var food := int(entry.get("food", 100))
		var condition := int(entry.get("condition", 100))
		if food < 55:
			penalty += int(ceil(float(55 - food) / 7.0))
		if condition < 75:
			penalty += int(ceil(float(75 - condition) / 8.0))
	return clampi(penalty, 0, 38)

static func runtime_degrade_gu(state, gu_id: String, pressure: int) -> Dictionary:
	ensure_ecology_state(state)
	if not state.gu_ecology.has(gu_id):
		return {}
	GuService.degrade_gu_instance(state, gu_id, pressure)
	var entry: Dictionary = state.gu_ecology[gu_id]
	entry["condition"] = clampi(int(entry.get("condition", 100)) - max(1, pressure), 0, 100)
	entry["food"] = clampi(int(entry.get("food", 100)) - max(1, int(ceil(float(pressure) * 0.35))), 0, 100)
	if int(entry["condition"]) < 30 or int(entry["food"]) < 20:
		entry["status"] = "危险"
	elif int(entry["condition"]) < 60 or int(entry["food"]) < 45:
		entry["status"] = "告警"
	state.gu_ecology[gu_id] = entry
	return entry

static func repair_gu(state, gu_id: String) -> bool:
	ensure_ecology_state(state)
	if not state.gu_ecology.has(gu_id):
		state.add_log("补链失败：未找到对应蛊虫服务。")
		return false
	var entry: Dictionary = state.gu_ecology[gu_id]
	var condition_gap := 100 - int(entry.get("condition", 100))
	var food_gap := 100 - int(entry.get("food", 100))
	var costs := {
		"immortal_stone": 90 + condition_gap * 3,
		"spirit_qi": 420 + food_gap * 18,
		"materials": 1 if condition_gap > 35 else 0
	}
	if not state.can_pay(costs):
		state.add_log("补链失败：仙元石、灵气或材料不足。")
		return false
	state.pay(costs)
	entry["condition"] = clampi(int(entry.get("condition", 100)) + 42, 0, 100)
	entry["food"] = clampi(int(entry.get("food", 100)) + 48, 0, 100)
	entry["status"] = "稳定" if int(entry["condition"]) >= 70 and int(entry["food"]) >= 60 else "告警"
	entry["last_issue"] = ""
	state.gu_ecology[gu_id] = entry
	state.add_log("补链完成：%s 的饱食度与健康度回升。" % _gu_name(state, gu_id))
	return true

static func repair_worst_gu(state) -> bool:
	var worst := worst_gu_state(state)
	if worst.is_empty():
		state.add_log("补链失败：暂无可维护蛊虫。")
		return false
	return repair_gu(state, String(worst.get("id", "")))

static func worst_gu_state(state) -> Dictionary:
	ensure_ecology_state(state)
	var worst: Dictionary = {}
	var worst_score := 999
	for gu_id_value in state.gu_ecology.keys():
		var gu_id := String(gu_id_value)
		var entry: Dictionary = state.gu_ecology[gu_id]
		var score := int(entry.get("food", 100)) + int(entry.get("condition", 100))
		if score < worst_score:
			worst_score = score
			worst = entry.duplicate(true)
	return worst

static func ecology_rows(state, limit: int = 6) -> Array:
	ensure_ecology_state(state)
	var rows: Array = []
	for gu_id_value in state.gu_ecology.keys():
		var gu_id := String(gu_id_value)
		var entry: Dictionary = state.gu_ecology[gu_id].duplicate(true)
		entry["name"] = _gu_name(state, gu_id)
		entry["sort_score"] = int(entry.get("food", 100)) + int(entry.get("condition", 100))
		rows.append(entry)
	rows.sort_custom(func(a, b): return int(a.get("sort_score", 999)) < int(b.get("sort_score", 999)))
	return rows.slice(0, min(limit, rows.size()))

static func current_warnings(state) -> Array:
	ensure_ecology_state(state)
	var warnings: Array = []
	for row in ecology_rows(state, 4):
		var food := int(row.get("food", 100))
		var condition := int(row.get("condition", 100))
		if food < 30 or condition < 35:
			warnings.append("%s 生态链危险：饱食 %d%% / 健康 %d%%。" % [String(row.get("name", row.get("id", ""))), food, condition])
	return warnings

static func _gu_name(state, gu_id: String) -> String:
	if state.has_method("get_gu_name"):
		return String(state.get_gu_name(gu_id))
	return gu_id

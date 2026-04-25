extends RefCounted

const WorldSimulator := preload("res://scripts/world_simulator.gd")
const ApertureService := preload("res://scripts/aperture_service.gd")
const TribulationService := preload("res://scripts/tribulation_service.gd")
const CultivationService := preload("res://scripts/cultivation_service.gd")

static func advance_months(state, months: int, reason: String) -> Array:
	months = max(1, months)
	state.world_month += months
	var days: int = months * 30
	state.character["lifespan_days"] = max(0, int(state.character.get("lifespan_days", 0)) - days)

	var stability: int = int(state.aperture.get("stability", 50))
	var conflict: int = int(state.aperture.get("conflict_rate", 30))
	var food: int = int(state.aperture.get("food_saturation", 50))
	var stone_delta: int = int(state.aperture.get("stone_delta", 20))
	var qi_balance: int = int(state.aperture.get("qi_balance", 60))

	var stone_income: int = max(0, stone_delta * months)
	var qi_income: int = max(0, int((stability + qi_balance) * 9 * months))
	var intel_income: int = max(0, int((100 - conflict) * 0.35 * months))

	state.add_resource("immortal_stone", stone_income)
	state.add_resource("spirit_qi", qi_income)
	state.add_resource("intel", intel_income)

	food = clampi(food - int(ceil(conflict * 0.08 * months)) + int(stability * 0.02 * months), 0, 100)
	conflict = clampi(conflict + randi_range(-2, 4) * months, 0, 100)
	stability = clampi(stability + randi_range(-3, 2) * months - (1 if food < 35 else 0), 0, 100)
	qi_balance = clampi(qi_balance + randi_range(-3, 3) * months, 0, 100)

	state.aperture["food_saturation"] = food
	state.aperture["conflict_rate"] = conflict
	state.aperture["stability"] = stability
	state.aperture["qi_balance"] = qi_balance

	var nodes: Array = state.aperture.get("nodes", [])
	for node in nodes:
		var pressure: int = clampi(int(node.get("pressure", 40)) + randi_range(-6, 8), 0, 100)
		node["pressure"] = pressure
		if pressure > 78:
			node["status"] = "危险"
		elif pressure > 62:
			node["status"] = "压力"
		elif food < 38 and String(node.get("name", "")) == "虫巢":
			node["status"] = "饥饿"
		else:
			node["status"] = "稳定"
	state.aperture["nodes"] = nodes

	var ecology_warnings := ApertureService.advance_months(state, months)
	var tribulation_warnings := TribulationService.advance_months(state, months)
	var cultivation_gain: int = CultivationService.passive_monthly_gain(state, months)
	CultivationService.add_exp(state, cultivation_gain)
	var warnings: Array = state.get_warnings()
	for warning in ecology_warnings:
		if not warnings.has(warning):
			warnings.append(warning)
	for warning in tribulation_warnings:
		if not warnings.has(warning):
			warnings.append(warning)
	state.add_log("%s：推进 %d 月，产出仙元石 +%d、灵气 +%d、情报 +%d、修为 +%d。" % [reason, months, stone_income, qi_income, intel_income, cultivation_gain])
	for warning in warnings:
		state.add_log("告警：%s" % warning)
	WorldSimulator.advance_months(state, months)
	return warnings

static func repair_aperture(state) -> bool:
	var costs := {"immortal_stone": 260, "spirit_qi": 1800}
	if not state.can_pay(costs):
		state.add_log("修复生态失败：资源不足。")
		return false
	state.pay(costs)
	state.aperture["stability"] = clampi(int(state.aperture.get("stability", 50)) + 12, 0, 100)
	state.aperture["food_saturation"] = clampi(int(state.aperture.get("food_saturation", 50)) + 15, 0, 100)
	state.aperture["conflict_rate"] = clampi(int(state.aperture.get("conflict_rate", 30)) - 8, 0, 100)
	state.add_log("修复生态完成：稳定度与饱食度回升。")
	advance_months(state, 1, "修复生态")
	return true

static func expand_node(state) -> bool:
	var costs := {"immortal_stone": 420, "spirit_qi": 2600, "materials": 1}
	if not state.can_pay(costs):
		state.add_log("扩容节点失败：资源不足。")
		return false
	state.pay(costs)
	state.aperture["stone_delta"] = int(state.aperture.get("stone_delta", 20)) + 8
	state.aperture["stability"] = clampi(int(state.aperture.get("stability", 50)) + 4, 0, 100)
	var nodes: Array = state.aperture.get("nodes", [])
	if nodes.size() > 0:
		var node: Dictionary = nodes[randi_range(0, nodes.size() - 1)]
		node["level"] = int(node.get("level", 1)) + 1
	state.aperture["nodes"] = nodes
	state.add_log("扩容节点完成：仙元石产出提升。")
	advance_months(state, 2, "扩容节点")
	return true

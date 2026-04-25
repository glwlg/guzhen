extends RefCounted

const GameState := preload("res://scripts/game_state.gd")
const MarketService := preload("res://scripts/market_service.gd")

const EVENT_KINDS := ["寿蛊线索", "仙蛊出世", "NPC渡劫", "宗门冲突", "假情报陷阱", "资源点争夺"]
const REGION_PRESSURE_EFFECTS := {
	"寿蛊线索": {"intel_price": 10},
	"仙蛊出世": {"market_risk": 16},
	"NPC渡劫": {"market_risk": 10},
	"宗门冲突": {"market_risk": 12},
	"假情报陷阱": {"intel_price": -6},
	"资源点争夺": {"material_price": 8}
}

static func advance_months(state, months: int) -> Array:
	months = max(1, months)
	if state.has_method("ensure_world_defaults"):
		state.ensure_world_defaults()
	var world_logs: Array = []
	for step in range(months):
		_advance_npcs_one_month(state, world_logs)
		_settle_player_posts(state, world_logs)
		_tick_factions(state)
		_maybe_spawn_world_event(state, world_logs)
		_expire_events(state)
	MarketService.cleanup_and_seed(state)
	for line in world_logs:
		state.add_log(String(line))
	return world_logs

static func _advance_npcs_one_month(state, world_logs: Array) -> void:
	for i in range(state.npcs.size()):
		var npc: Dictionary = state.npcs[i]
		var resources: Dictionary = npc.get("resources", {})
		var rank: int = int(npc.get("rank", npc.get("realm_index", 1)))
		var lifespan: int = max(0, int(npc.get("lifespan_days", 0)) - 30)
		npc["lifespan_days"] = lifespan

		resources["immortal_stone"] = max(0, int(resources.get("immortal_stone", 0)) + 18 + rank * 4 - randi_range(0, 24))
		resources["spirit_qi"] = max(0, int(resources.get("spirit_qi", 0)) + 420 + rank * 80 - randi_range(0, 360))
		resources["intel"] = max(0, int(resources.get("intel", 0)) + randi_range(10, 42))
		npc["resources"] = resources

		var urgency: int = int(npc.get("urgency", 50))
		if lifespan < 360:
			urgency += 10
		elif lifespan < 720:
			urgency += 6
		elif lifespan < 1440:
			urgency += 3
		if int(resources.get("immortal_stone", 0)) < 420:
			urgency += 4
		if int(resources.get("materials", 0)) < 2:
			urgency += 3
		urgency += randi_range(-3, 3)
		npc["urgency"] = clampi(urgency, 0, 100)

		var consumed_action: bool = _maybe_refine_unique_gu(state, npc, world_logs)
		if not consumed_action:
			_choose_npc_action(state, npc, world_logs)

		state.npcs[i] = npc

static func _choose_npc_action(state, npc: Dictionary, world_logs: Array) -> void:
	var urgency: int = int(npc.get("urgency", 50))
	var trust: int = int(npc.get("trust", 30))
	var relation: int = int(npc.get("relation", 0))
	var roll: int = randi_range(1, 100)

	if urgency > 74 or roll <= 34:
		var post: Dictionary = MarketService.generate_npc_post(state, npc, "NPC行动")
		state.market_posts.push_front(post)
		npc["last_action"] = "发布宝黄天订单：%s" % String(post.get("title", "订单"))
		world_logs.append("NPC行动：%s发布%s。" % [String(npc.get("name", "某人")), String(post.get("kind", "订单"))])
		return

	if relation < -28 and trust < 24 and urgency > 55 and roll <= 62:
		_create_event(state, "战后袭击窗口", String(npc.get("id", "")), "player", 58 + urgency / 2)
		npc["last_action"] = "暗中筹备战后袭击"
		world_logs.append("敌意发酵：%s正在寻找你战后虚弱的窗口。" % String(npc.get("name", "某人")))
		return

	if trust >= 58 and relation >= 18 and roll <= 78:
		state.add_resource("intel", 18 + int(trust / 4))
		npc["last_action"] = "分享低风险情报"
		npc["urgency"] = clampi(urgency - 3, 0, 100)
		world_logs.append("盟友馈赠：%s传来一条可用情报。" % String(npc.get("name", "某人")))
		return

	if roll <= 88:
		_create_event(state, "资源点争夺", String(npc.get("id", "")), "", 35 + urgency / 2)
		npc["last_action"] = "参与资源点争夺"
		npc["urgency"] = clampi(urgency + 2, 0, 100)
		return

	npc["last_action"] = "蛰伏观望，等待市场变动"
	npc["urgency"] = clampi(urgency - 1, 0, 100)

static func _maybe_refine_unique_gu(state, npc: Dictionary, world_logs: Array) -> bool:
	var npc_id: String = String(npc.get("id", ""))
	var target_gu: String = ""
	if npc_id == "baiwusheng" or String(npc.get("current_goal", "")).find("唯一") >= 0:
		target_gu = "taixu_immortal"
	elif npc_id == "chixiao":
		target_gu = "blood_sword"
	if target_gu == "":
		return false
	if state.unique_gu.has(target_gu):
		return false

	var resources: Dictionary = npc.get("resources", {})
	var materials: int = int(resources.get("materials", 0))
	var stones: int = int(resources.get("immortal_stone", 0))
	if materials < 3 or stones < 500:
		return false

	var urgency: int = int(npc.get("urgency", 50))
	var rank: int = int(npc.get("rank", npc.get("realm_index", 1)))
	var chance: int = clampi(8 + rank * 4 + urgency / 6, 8, 54)
	resources["materials"] = max(0, materials - 3)
	resources["immortal_stone"] = max(0, stones - 420)
	resources["spirit_qi"] = max(0, int(resources.get("spirit_qi", 0)) - 1800)
	npc["resources"] = resources

	if randi_range(1, 100) <= chance:
		var owned_gu: Array = npc.get("owned_gu", [])
		owned_gu.append(target_gu)
		npc["owned_gu"] = owned_gu
		state.unique_gu[target_gu] = String(npc.get("name", "NPC"))
		var gu_def: Dictionary = GameState.GU_DEFINITIONS.get(target_gu, {})
		npc["last_action"] = "炼成唯一仙蛊：%s" % String(gu_def.get("name", target_gu))
		npc["current_goal"] = "巩固唯一仙蛊优势"
		_create_event(state, "仙蛊出世", npc_id, "", 82)
		world_logs.append("仙蛊出世：%s炼成%s，唯一性已锁定。" % [String(npc.get("name", "某人")), String(gu_def.get("name", target_gu))])
	else:
		npc["last_action"] = "尝试炼制唯一仙蛊失败"
		npc["urgency"] = clampi(urgency + 9, 0, 100)
		world_logs.append("炼蛊失败：%s冲击唯一仙蛊受挫，市场需求升温。" % String(npc.get("name", "某人")))
	return true

static func _settle_player_posts(state, world_logs: Array) -> void:
	for i in range(state.market_posts.size() - 1, -1, -1):
		var post: Dictionary = state.market_posts[i]
		if String(post.get("seller_npc_id", "")) != "player":
			continue
		var chance: int = 32
		for raw_npc in state.npcs:
			var npc: Dictionary = raw_npc
			chance += 2 if int(npc.get("trust", 0)) >= 45 else 0
		if randi_range(1, 100) > clampi(chance, 20, 70):
			continue
		if String(post.get("kind", "")) == "抛售":
			state.add_resource("immortal_stone", int(post.get("price", 0)))
			world_logs.append("宝黄天成交：你的灵气挂单被 NPC 买走。")
		elif String(post.get("kind", "")) == "求购":
			state.add_resource(String(post.get("resource_id", "materials")), int(post.get("quantity", 1)))
			world_logs.append("宝黄天成交：你的求购单得到回应。")
		state.market_posts.remove_at(i)

static func _tick_factions(state) -> void:
	for i in range(state.factions.size()):
		var faction: Dictionary = state.factions[i]
		var tension: int = clampi(int(faction.get("tension", 50)) + randi_range(-2, 3), 0, 100)
		var wealth: int = clampi(int(faction.get("wealth", 50)) + randi_range(-2, 2), 0, 100)
		faction["tension"] = tension
		faction["wealth"] = wealth
		state.factions[i] = faction

static func _maybe_spawn_world_event(state, world_logs: Array) -> void:
	if state.world_events.size() >= 10:
		return
	if randi_range(1, 100) > 52:
		return
	var kind: String = EVENT_KINDS[randi_range(0, EVENT_KINDS.size() - 1)]
	var source_id: String = ""
	var target_id: String = ""
	if not state.npcs.is_empty():
		var source_npc: Dictionary = state.npcs[randi_range(0, state.npcs.size() - 1)]
		source_id = String(source_npc.get("id", ""))
		if state.npcs.size() > 1:
			var target_npc: Dictionary = state.npcs[randi_range(0, state.npcs.size() - 1)]
			target_id = String(target_npc.get("id", ""))
	_create_event(state, kind, source_id, target_id, randi_range(34, 86))
	world_logs.append("世界事件：%s在五域发酵。" % kind)

static func _expire_events(state) -> void:
	for i in range(state.world_events.size()):
		var event: Dictionary = state.world_events[i]
		if int(event.get("expires_month", 0)) <= int(state.world_month):
			event["resolved"] = true
		state.world_events[i] = event

static func _create_event(state, kind: String, source_npc_id: String, target_npc_id: String, severity: int) -> void:
	state.world_events.push_front({
		"id": "event_%d_%d" % [int(state.world_month), randi_range(1000, 9999)],
		"kind": kind,
		"region": _pick_region_id(state),
		"severity": clampi(severity, 1, 100),
		"source_npc_id": source_npc_id,
		"target_npc_id": target_npc_id,
		"expires_month": int(state.world_month) + randi_range(2, 8),
		"resolved": false,
		"effects": REGION_PRESSURE_EFFECTS.get(kind, {"market_risk": int(severity / 10)})
	})

static func _pick_region_id(state) -> String:
	if state.world_regions.is_empty():
		return "southern_border"
	var region: Dictionary = state.world_regions[randi_range(0, state.world_regions.size() - 1)]
	return String(region.get("id", "southern_border"))

extends RefCounted

const LongevityService := preload("res://scripts/longevity_service.gd")

const RESOURCE_NAMES := {
	"immortal_stone": "仙元石",
	"spirit_qi": "灵气",
	"intel": "情报值",
	"materials": "炼蛊材料"
}

const POST_KINDS := ["求购", "抛售", "悬赏", "情报", "疑似假情报"]

static func cleanup_and_seed(state) -> void:
	if state.has_method("ensure_world_defaults"):
		state.ensure_world_defaults()
	var kept_posts: Array = []
	for raw_post in state.market_posts:
		var post: Dictionary = raw_post
		if int(post.get("expires_month", 0)) > int(state.world_month):
			kept_posts.append(post)
	state.market_posts = kept_posts

	var kept_events: Array = []
	for raw_event in state.world_events:
		var event: Dictionary = raw_event
		if not bool(event.get("resolved", false)) and int(event.get("expires_month", 0)) > int(state.world_month):
			kept_events.append(event)
	state.world_events = kept_events

	var guard: int = 0
	while state.market_posts.size() < 8 and guard < 16:
		guard += 1
		var alive_npcs := _alive_npcs(state)
		if alive_npcs.is_empty():
			return
		var npc: Dictionary = alive_npcs[randi_range(0, alive_npcs.size() - 1)]
		state.market_posts.append(generate_npc_post(state, npc, "宝黄天自然刷新"))

static func generate_npc_post(state, npc: Dictionary, reason: String = "") -> Dictionary:
	var urgency: int = int(npc.get("urgency", 50))
	var trust: int = int(npc.get("trust", 30))
	var relation: int = int(npc.get("relation", 0))
	var resource_id: String = "intel"
	var kind: String = "情报"
	var title: String = "五域情报换仙元石"
	var body: String = "%s在宝黄天留下暗号，愿意以情报换取修行资源。" % String(npc.get("name", "匿名蛊仙"))
	var quantity: int = 120 + urgency * 2
	var price: int = 160 + urgency * 5
	var risk: int = clampi(25 + urgency / 2 - trust / 4 + randi_range(-8, 12), 5, 95)
	var truthfulness: int = clampi(58 + trust / 3 + relation / 4 + randi_range(-18, 18), 5, 96)

	if urgency > 78:
		kind = "求购"
		resource_id = "intel"
		quantity = 140
		price = 240 + urgency * 5
		title = "急购寿蛊或延寿线索"
		body = "%s寿元压力极高，愿以高价换取可验证的延寿线索。" % String(npc.get("name", "匿名蛊仙"))
	elif trust < 25 and randi_range(0, 100) < 45:
		kind = "疑似假情报"
		resource_id = "intel"
		quantity = 180
		price = 150 + urgency * 3
		truthfulness = clampi(truthfulness - 30, 3, 72)
		risk = clampi(risk + 18, 10, 98)
		title = "疑似仙蛊出世密报"
		body = "来源几经转手，指向一处未公开遗迹。低价，但需要自行验真。"
	elif int(npc.get("resources", {}).get("spirit_qi", 0)) > 18000:
		kind = "抛售"
		resource_id = "spirit_qi"
		quantity = 1800 + randi_range(0, 1800)
		price = 280 + int(quantity / 14)
		title = "抛售灵泉结晶"
		body = "%s近期灵气充裕，愿快速换取仙元石。" % String(npc.get("name", "匿名蛊仙"))
	elif int(npc.get("resources", {}).get("materials", 0)) > 4:
		kind = "抛售"
		resource_id = "materials"
		quantity = randi_range(1, 3)
		price = 220 * quantity + randi_range(40, 140)
		title = "出手一批炼蛊材料"
		body = "材料来自%s，品质尚可，但路线上有争夺风险。" % _region_name(state, _pick_region_id(state))
	elif relation < -15:
		kind = "悬赏"
		resource_id = "intel"
		quantity = 220
		price = 360 + urgency * 4
		title = "悬赏仇敌行踪"
		body = "%s正在寻找敌对蛊师的战后虚弱窗口。" % String(npc.get("name", "匿名蛊仙"))

	if reason != "":
		body += "\n来源：%s。" % reason

	return {
		"id": _make_post_id(state),
		"kind": kind,
		"title": title,
		"body": body,
		"seller_npc_id": String(npc.get("id", "")),
		"price": price,
		"resource_id": resource_id,
		"quantity": quantity,
		"risk": risk,
		"truthfulness": truthfulness,
		"expires_month": int(state.world_month) + randi_range(3, 8)
	}

static func publish_player_post(state, kind: String) -> String:
	if state.has_method("ensure_world_defaults"):
		state.ensure_world_defaults()
	var post: Dictionary = {}
	if kind == "抛售":
		if state.get_resource("spirit_qi") < 1600:
			return "灵气不足，无法挂出抛售单。"
		state.add_resource("spirit_qi", -1600)
		post = {
			"id": _make_post_id(state),
			"kind": "抛售",
			"title": "玩家抛售灵气",
		"body": "你在宝黄天挂出一批灵气，等待人物吃单。",
			"seller_npc_id": "player",
			"price": 260,
			"resource_id": "spirit_qi",
			"quantity": 1600,
			"risk": 12,
			"truthfulness": 95,
			"expires_month": int(state.world_month) + 4
		}
	elif kind == "求购":
		if state.get_resource("immortal_stone") < 260:
			return "仙元石不足，无法挂出求购单。"
		state.add_resource("immortal_stone", -260)
		post = {
			"id": _make_post_id(state),
			"kind": "求购",
			"title": "玩家求购炼蛊材料",
		"body": "你以仙元石托宝黄天收购材料，低信任人物可能借机抬价。",
			"seller_npc_id": "player",
			"price": 260,
			"resource_id": "materials",
			"quantity": 1,
			"risk": 24,
			"truthfulness": 92,
			"expires_month": int(state.world_month) + 4
		}
	else:
		return "暂不支持这种挂单。"
	state.market_posts.push_front(post)
	state.add_log("宝黄天挂单：%s。" % String(post.get("title", "订单")))
	return "挂单完成，后续世界刻会影响人物响应。"

static func apply_post_action(state, post_id: String, action: String) -> String:
	cleanup_and_seed(state)
	var index: int = find_post_index(state, post_id)
	if index < 0:
		return "订单已过期或不存在。"
	var post: Dictionary = state.market_posts[index]
	match action:
		"trade":
			return _trade_post(state, index, post)
		"investigate":
			return _investigate_post(state, index, post)
		"rumor":
			return _spread_rumor(state, index, post)
	return "未知操作。"

static func _trade_post(state, index: int, post: Dictionary) -> String:
	var kind: String = String(post.get("kind", "情报"))
	var price: int = int(post.get("price", 0))
	var resource_id: String = String(post.get("resource_id", "intel"))
	var quantity: int = int(post.get("quantity", 1))
	var risk: int = int(post.get("risk", 30))
	var truthfulness: int = int(post.get("truthfulness", 70))
	var seller_id: String = String(post.get("seller_npc_id", ""))
	if seller_id == "player":
		return "这是你自己的挂单，等待世界刻结算。"

	if kind == "抛售":
		var buy_costs: Dictionary = {"immortal_stone": price}
		if not state.can_pay(buy_costs):
			return "仙元石不足，交易失败。"
		state.pay(buy_costs)
		state.add_resource(resource_id, quantity)
		_adjust_npc(state, seller_id, 3, 5, -4)
		state.market_posts.remove_at(index)
		state.add_log("宝黄天成交：购得%s +%d。" % [resource_name(resource_id), quantity])
		return "交易成功，获得%s +%d。" % [resource_name(resource_id), quantity]

	if kind == "求购":
		var sell_quantity: int = quantity
		if resource_id == "intel":
			sell_quantity = max(quantity, 100)
		if state.get_resource(resource_id) < sell_quantity:
			return "%s不足，无法完成求购单。" % resource_name(resource_id)
		state.add_resource(resource_id, -sell_quantity)
		state.add_resource("immortal_stone", price)
		_adjust_npc(state, seller_id, 5, 8, -10)
		state.market_posts.remove_at(index)
		state.add_log("宝黄天成交：出售%s，得仙元石 +%d。" % [resource_name(resource_id), price])
		return "交易成功，获得仙元石 +%d。" % price

	var costs: Dictionary = {"immortal_stone": price}
	if not state.can_pay(costs):
		return "仙元石不足，无法购买情报。"
	state.pay(costs)
	state.market_posts.remove_at(index)
	if post.has("longevity_lead") or String(post.get("title", "")).find("寿蛊") >= 0 or String(post.get("body", "")).find("延寿") >= 0:
		var lead_message: String = LongevityService.resolve_market_lead_purchase(state, post)
		_adjust_npc(state, seller_id, 1, 2, -2)
		return lead_message
	if truthfulness < 45 and randi_range(0, 100) < risk:
		state.add_resource("intel", -min(state.get_resource("intel"), 80))
		_adjust_npc(state, seller_id, -6, -8, 6)
		_create_event(state, "假情报陷阱", seller_id, risk)
		state.add_log("宝黄天陷阱：%s疑似为假情报，损失情报值。" % String(post.get("title", "订单")))
		return "情报有诈，损失部分情报并提高世界风险。"
	state.add_resource("intel", max(quantity, 120))
	_adjust_npc(state, seller_id, 2, 3, -3)
	if kind == "悬赏":
		_create_event(state, "战后袭击窗口", seller_id, risk)
	state.add_log("宝黄天成交：获得情报 +%d。" % max(quantity, 120))
	return "购买成功，获得情报 +%d。" % max(quantity, 120)

static func _investigate_post(state, index: int, post: Dictionary) -> String:
	var costs: Dictionary = {"intel": 90}
	if not state.can_pay(costs):
		return "情报值不足，无法调查。"
	state.pay(costs)
	var truthfulness: int = int(post.get("truthfulness", 50))
	var risk: int = int(post.get("risk", 50))
	var seller_id: String = String(post.get("seller_npc_id", ""))
	if truthfulness < 45:
		post["risk"] = clampi(risk + 12, 0, 100)
		post["truthfulness"] = clampi(truthfulness - 8, 0, 100)
		_adjust_npc(state, seller_id, -2, -5, 2)
		state.add_log("调查宝黄天：%s破绽明显，疑似假情报。" % String(post.get("title", "订单")))
		state.market_posts[index] = post
		return "调查完成：来源破绽明显，可信度下降。"
	post["risk"] = clampi(risk - 12, 0, 100)
	post["truthfulness"] = clampi(truthfulness + 8, 0, 100)
	_adjust_npc(state, seller_id, 1, 2, -1)
	state.market_posts[index] = post
	state.add_log("调查宝黄天：%s可信度提高。" % String(post.get("title", "订单")))
	return "调查完成：风险下降，可信度提高。"

static func _spread_rumor(state, index: int, post: Dictionary) -> String:
	var costs: Dictionary = {"intel": 120}
	if not state.can_pay(costs):
		return "情报值不足，无法散布。"
	state.pay(costs)
	var seller_id: String = String(post.get("seller_npc_id", ""))
	_adjust_npc(state, seller_id, -10, -12, 8)
	post["risk"] = clampi(int(post.get("risk", 30)) + 10, 0, 100)
	state.market_posts[index] = post
	_create_event(state, "谣言扩散", seller_id, int(post.get("risk", 40)))
	state.add_log("宝黄天谣言：围绕%s扩散，相关人物信任下降。" % String(post.get("title", "订单")))
	return "谣言已散布，对方信任下降，但市场风险上升。"

static func find_post_index(state, post_id: String) -> int:
	for i in range(state.market_posts.size()):
		var post: Dictionary = state.market_posts[i]
		if String(post.get("id", "")) == post_id:
			return i
	return -1

static func find_npc_index(state, npc_id: String) -> int:
	for i in range(state.npcs.size()):
		var npc: Dictionary = state.npcs[i]
		if String(npc.get("id", "")) == npc_id:
			return i
	return -1

static func seller_name(state, npc_id: String) -> String:
	if npc_id == "player":
		return "玩家"
	var index: int = find_npc_index(state, npc_id)
	if index >= 0:
		var npc: Dictionary = state.npcs[index]
		if not bool(npc.get("alive", true)):
			return "已死人物"
		return String(npc.get("name", "匿名"))
	return "匿名"

static func resource_name(id: String) -> String:
	return String(RESOURCE_NAMES.get(id, id))

static func post_label(state, post: Dictionary) -> String:
	return "%s｜%s｜%s｜%d月止" % [
		String(post.get("kind", "订单")),
		String(post.get("title", "无题")),
		seller_name(state, String(post.get("seller_npc_id", ""))),
		int(post.get("expires_month", 0))
	]

static func _adjust_npc(state, npc_id: String, relation_delta: int, trust_delta: int, urgency_delta: int) -> void:
	var index: int = find_npc_index(state, npc_id)
	if index < 0:
		return
	var npc: Dictionary = state.npcs[index]
	npc["relation"] = clampi(int(npc.get("relation", 0)) + relation_delta, -100, 100)
	npc["trust"] = clampi(int(npc.get("trust", 30)) + trust_delta, 0, 100)
	npc["urgency"] = clampi(int(npc.get("urgency", 50)) + urgency_delta, 0, 100)
	npc["last_action"] = "宝黄天交易关系变化"
	state.npcs[index] = npc

static func _alive_npcs(state) -> Array:
	var result: Array = []
	for raw_npc in state.npcs:
		var npc: Dictionary = raw_npc
		if bool(npc.get("alive", true)):
			result.append(npc)
	return result

static func _create_event(state, kind: String, source_npc_id: String, severity: int) -> void:
	state.world_events.push_front({
		"id": "event_%d_%d" % [int(state.world_month), randi_range(1000, 9999)],
		"kind": kind,
		"region": _pick_region_id(state),
		"severity": clampi(severity, 1, 100),
		"source_npc_id": source_npc_id,
		"target_npc_id": "",
		"expires_month": int(state.world_month) + randi_range(2, 6),
		"resolved": false,
		"effects": {"market_risk": int(severity / 8)}
	})

static func _make_post_id(state) -> String:
	return "post_%d_%d_%d" % [int(state.world_month), state.market_posts.size(), randi_range(1000, 9999)]

static func _pick_region_id(state) -> String:
	if state.world_regions.is_empty():
		return "southern_border"
	var region: Dictionary = state.world_regions[randi_range(0, state.world_regions.size() - 1)]
	return String(region.get("id", "southern_border"))

static func _region_name(state, region_id: String) -> String:
	for raw_region in state.world_regions:
		var region: Dictionary = raw_region
		if String(region.get("id", "")) == region_id:
			return String(region.get("name", region_id))
	return region_id

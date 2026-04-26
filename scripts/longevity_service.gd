extends RefCounted

const LongevityDefs := preload("res://scripts/data/longevity_defs.gd")

static func ensure_longevity_state(state) -> void:
	if typeof(state.death_state) != TYPE_DICTIONARY:
		state.death_state = {}
	if typeof(state.longevity_leads) != TYPE_ARRAY:
		state.longevity_leads = []
	if typeof(state.longevity_gu_inventory) != TYPE_DICTIONARY:
		state.longevity_gu_inventory = {}
	if typeof(state.reincarnation_history) != TYPE_ARRAY:
		state.reincarnation_history = []
	if typeof(state.ending_flags) != TYPE_DICTIONARY:
		state.ending_flags = {}
	for tier_id in LongevityDefs.gu_tier_ids():
		state.longevity_gu_inventory[tier_id] = max(0, int(state.longevity_gu_inventory.get(tier_id, 0)))
	if state.death_state.is_empty():
		state.death_state = {"locked": false, "death_month": -1, "reason": "", "last_status": LongevityDefs.STATUS_STABLE}
	if not state.death_state.has("locked"):
		state.death_state["locked"] = false
	if not state.death_state.has("death_month"):
		state.death_state["death_month"] = -1
	if not state.death_state.has("reason"):
		state.death_state["reason"] = ""
	if not state.death_state.has("last_status"):
		state.death_state["last_status"] = LongevityDefs.STATUS_STABLE
	if String(state.lifespan_status) == "":
		state.lifespan_status = LongevityDefs.STATUS_STABLE
	_migrate_leads(state)
	if state.longevity_leads.is_empty():
		for i in range(2):
			state.longevity_leads.append(_new_lead(state, "初始暗线"))
	update_lifespan_status(state, false)

static func _migrate_leads(state) -> void:
	for i in range(state.longevity_leads.size()):
		var lead: Dictionary = state.longevity_leads[i]
		if not lead.has("id"):
			lead["id"] = _make_lead_id(state)
		if not lead.has("status"):
			lead["status"] = "rumor"
		if not lead.has("expires_month"):
			lead["expires_month"] = int(state.world_month) + 6
		if not lead.has("truthfulness"):
			lead["truthfulness"] = 55
		if not lead.has("risk"):
			lead["risk"] = 50
		if not lead.has("tier"):
			lead["tier"] = "mortal"
		state.longevity_leads[i] = lead

static func advance_months(state, months: int, reason: String = "") -> Array:
	ensure_longevity_state(state)
	var warnings: Array = []
	_cleanup_leads(state)
	var old_status: String = String(state.death_state.get("last_status", state.lifespan_status))
	var status: String = update_lifespan_status(state, true)
	if status != LongevityDefs.STATUS_STABLE:
		warnings.append("寿元状态：%s，行动风险上升。" % LongevityDefs.status_label(status))
	if old_status != status:
		state.death_state["last_status"] = status
	if state.longevity_leads.size() < 4 and _should_spawn_player_lead(state, months):
		var lead: Dictionary = _new_lead(state, "寿元压力")
		state.longevity_leads.push_front(lead)
		state.add_log("寿蛊线索：%s。" % String(lead.get("title", "未知线索")))
	if status in [LongevityDefs.STATUS_CRITICAL, LongevityDefs.STATUS_DYING] and randi_range(1, 100) <= 42:
		_spawn_lifespan_hunt_event(state, "寿元将尽")
		warnings.append("夺寿追杀窗口正在形成。")
	_maybe_seed_auction_post(state)
	return warnings

static func update_lifespan_status(state, emit_log: bool = true) -> String:
	var days: int = int(state.character.get("lifespan_days", 0))
	var previous: String = String(state.lifespan_status)
	var status: String = LongevityDefs.status_for_days(days)
	state.lifespan_status = status
	if status == LongevityDefs.STATUS_DEAD:
		state.character["lifespan_days"] = 0
		state.death_state["locked"] = true
		if int(state.death_state.get("death_month", -1)) < 0:
			state.death_state["death_month"] = int(state.world_month)
			state.death_state["reason"] = "寿元耗尽"
			state.ending_flags["lifespan_death"] = true
	else:
		state.death_state["locked"] = false
		state.death_state["reason"] = ""
	if emit_log and previous != status:
		state.add_log("寿元状态转为：%s。" % LongevityDefs.status_label(status))
	return status

static func is_death_locked(state) -> bool:
	ensure_longevity_state(state)
	return bool(state.death_state.get("locked", false)) or String(state.lifespan_status) == LongevityDefs.STATUS_DEAD

static func is_combat_death(state) -> bool:
	ensure_longevity_state(state)
	return String(state.death_state.get("reason", "")).begins_with("战斗死亡")

static func handle_combat_death(state, encounter: Dictionary) -> String:
	ensure_longevity_state(state)
	var encounter_name := String(encounter.get("name", "未知战斗"))
	if state.has_method("has_gu") and state.has_gu("substitute_life_gu"):
		state.remove_gu("substitute_life_gu", 1)
		state.character["hp"] = max(1, int(state.character.get("max_hp", 100)) / 2)
		state.character["lifespan_days"] = max(1, int(state.character.get("lifespan_days", 0)) - 180)
		update_lifespan_status(state, true)
		state.ending_flags["substitute_life_used"] = true
		state.add_log("替命蛊挡下死劫，你从%s中爬回一口气。" % encounter_name)
		return "替命蛊破碎，挡下战斗死亡。寿元折损 180 天。"
	if state.has_method("has_gu") and state.has_gu("spring_autumn_cicada"):
		state.character["hp"] = max(1, int(state.character.get("max_hp", 100)) / 2)
		state.character["lifespan_days"] = max(30, int(state.character.get("lifespan_days", 0)) - 720)
		state.resources["intel"] = max(0, int(state.resources.get("intel", 0)) / 2)
		state.resources["spirit_qi"] = max(0, int(state.resources.get("spirit_qi", 0)) / 2)
		state.ending_flags["spring_autumn_rebirth"] = true
		update_lifespan_status(state, true)
		state.add_log("春秋蝉逆流发动，战斗死亡被改写，但代价沉重。")
		return "春秋蝉逆流发动，保住一线生机；情报与灵气折半，寿元大损。"
	state.character["hp"] = 0
	state.character["lifespan_days"] = 0
	state.lifespan_status = LongevityDefs.STATUS_DEAD
	state.death_state["locked"] = true
	state.death_state["death_month"] = int(state.world_month)
	state.death_state["reason"] = "战斗死亡：%s" % encounter_name
	state.death_state["last_status"] = LongevityDefs.STATUS_DEAD
	state.ending_flags["combat_death"] = true
	state.add_log("战斗死亡：%s。没有春秋蝉或替死手段，旧身终局。" % encounter_name)
	return "你死于%s。没有春秋蝉或替死手段，本局结束。" % encounter_name

static func status_label(state) -> String:
	ensure_longevity_state(state)
	return LongevityDefs.status_label(String(state.lifespan_status))

static func current_warning(state) -> String:
	ensure_longevity_state(state)
	if is_combat_death(state):
		return "战斗死亡已成定局。寿蛊无法逆转肉身灭亡。"
	var status: String = String(state.lifespan_status)
	if status == LongevityDefs.STATUS_DEAD:
		return "寿元耗尽，已进入死亡锁定。"
	if status == LongevityDefs.STATUS_DYING:
		return "寿元不足一月，只能优先处理续命。"
	if status == LongevityDefs.STATUS_CRITICAL:
		return "寿元不足半年，人物夺寿和抬价概率上升。"
	if status == LongevityDefs.STATUS_WARNING:
		return "寿元不足两年，应追查寿蛊线索。"
	return ""

static func active_leads(state) -> Array:
	ensure_longevity_state(state)
	var result: Array = []
	for raw_lead in state.longevity_leads:
		var lead: Dictionary = raw_lead
		if int(lead.get("expires_month", 0)) > int(state.world_month) and String(lead.get("status", "")) != "resolved":
			result.append(lead)
	return result

static func find_lead_index(state, lead_id: String) -> int:
	for i in range(state.longevity_leads.size()):
		var lead: Dictionary = state.longevity_leads[i]
		if String(lead.get("id", "")) == lead_id:
			return i
	return -1

static func search_lead(state) -> String:
	ensure_longevity_state(state)
	var costs: Dictionary = {"intel": 80, "immortal_stone": 120}
	if not state.can_pay(costs):
		return "搜寻失败：情报或仙元石不足。"
	state.pay(costs)
	var lead: Dictionary = _new_lead(state, "主动搜寻")
	state.longevity_leads.push_front(lead)
	state.add_log("你沿宝黄天暗线搜出新寿蛊线索：%s。" % String(lead.get("title", "未知线索")))
	return "发现新线索：%s。" % String(lead.get("title", "未知线索"))

static func investigate_lead(state, lead_id: String) -> String:
	ensure_longevity_state(state)
	var index: int = find_lead_index(state, lead_id)
	if index < 0:
		return "线索已过期或不存在。"
	var costs: Dictionary = {"intel": 120}
	if not state.can_pay(costs):
		return "调查失败：情报值不足。"
	state.pay(costs)
	var lead: Dictionary = state.longevity_leads[index]
	var truthfulness: int = int(lead.get("truthfulness", 50))
	var risk: int = int(lead.get("risk", 50))
	if truthfulness < 42:
		lead["status"] = "fake"
		lead["risk"] = clampi(risk + 12, 0, 100)
		state.adjust_morality(1, "识破寿蛊假线")
		state.add_log("寿蛊调查：%s被判定为假情报。" % String(lead.get("title", "线索")))
		state.longevity_leads[index] = lead
		return "调查完成：这条线索很可能是陷阱。"
	lead["status"] = "verified"
	lead["truthfulness"] = clampi(truthfulness + 14, 0, 100)
	lead["risk"] = clampi(risk - 10, 0, 100)
	state.longevity_leads[index] = lead
	state.add_log("寿蛊调查：%s得到验证。" % String(lead.get("title", "线索")))
	return "调查完成：线索已确认，可追踪。"

static func pursue_lead(state, lead_id: String) -> String:
	ensure_longevity_state(state)
	var index: int = find_lead_index(state, lead_id)
	if index < 0:
		return "线索已过期或不存在。"
	var lead: Dictionary = state.longevity_leads[index]
	if String(lead.get("status", "")) == "fake":
		state.character["hp"] = max(1, int(state.character.get("hp", 100)) - 22)
		_spawn_lifespan_hunt_event(state, "误入假线")
		lead["status"] = "resolved"
		state.longevity_leads[index] = lead
		return "你追入假线，遭遇伏击后负伤撤退。"
	var costs: Dictionary = {"immortal_stone": 260, "spirit_qi": 1800}
	if not state.can_pay(costs):
		return "追踪失败：仙元石或灵气不足。"
	state.pay(costs)
	var truthfulness: int = int(lead.get("truthfulness", 50))
	var risk: int = int(lead.get("risk", 50))
	var chance: int = clampi(42 + truthfulness / 2 - risk / 3 + (12 if String(lead.get("status", "")) == "verified" else 0), 18, 88)
	if randi_range(1, 100) <= chance:
		var tier_id: String = String(lead.get("tier", "mortal"))
		add_longevity_gu(state, tier_id, 1)
		lead["status"] = "resolved"
		state.longevity_leads[index] = lead
		state.adjust_morality(2, "夺得寿蛊")
		state.add_log("追踪成功：获得%s x1。" % gu_name(tier_id))
		return "追踪成功，获得%s x1。" % gu_name(tier_id)
	state.character["hp"] = max(1, int(state.character.get("hp", 100)) - 18)
	state.character["lifespan_days"] = max(0, int(state.character.get("lifespan_days", 0)) - 20)
	_spawn_lifespan_hunt_event(state, "线索争夺失败")
	lead["risk"] = clampi(risk + 16, 0, 100)
	state.longevity_leads[index] = lead
	update_lifespan_status(state, true)
	return "追踪失败：竞争者抢先一步，你损伤生命与寿元。"

static func bid_auction(state) -> String:
	ensure_longevity_state(state)
	var auction: Dictionary = LongevityDefs.random_auction(int(state.character.get("lifespan_days", 0)))
	var base_price: int = int(auction.get("base_price", 900))
	var status: String = String(state.lifespan_status)
	var pressure_markup: int = 420 if status in [LongevityDefs.STATUS_CRITICAL, LongevityDefs.STATUS_DYING] else 0
	var price: int = base_price + pressure_markup + randi_range(0, 320)
	if state.get_resource("immortal_stone") < price:
		return "竞拍失败：本轮底价约 %d 仙元石，你的仙元石不足。" % price
	state.add_resource("immortal_stone", -price)
	var chance: int = clampi(62 - int(auction.get("risk", 50)) / 3 + int(state.get_resource("intel")) / 220, 18, 78)
	if randi_range(1, 100) <= chance:
		var tier_id: String = String(auction.get("tier", "mortal"))
		add_longevity_gu(state, tier_id, 1)
		state.add_log("寿蛊竞拍成功：耗费仙元石 %d，获得%s。" % [price, gu_name(tier_id)])
		return "竞拍成功，获得%s。" % gu_name(tier_id)
	_spawn_lifespan_hunt_event(state, "寿蛊竞拍失利")
	state.add_log("寿蛊竞拍失败：耗费仙元石 %d，被匿名买家截胡。" % price)
	return "竞拍失败：被匿名买家截胡，并留下追踪风险。"

static func use_best_gu(state) -> String:
	ensure_longevity_state(state)
	if is_combat_death(state):
		return "续命失败：战斗死亡只能由春秋蝉或替死手段在死亡瞬间改写。"
	var order: Array = ["heaven", "earth", "mortal"]
	for tier_id in order:
		if int(state.longevity_gu_inventory.get(tier_id, 0)) > 0:
			return use_gu(state, tier_id)
	return "续命失败：没有可用寿蛊。"

static func use_gu(state, tier_id: String) -> String:
	ensure_longevity_state(state)
	if is_combat_death(state):
		return "续命失败：寿蛊只能补寿，不能复活战死之身。"
	if int(state.longevity_gu_inventory.get(tier_id, 0)) <= 0:
		return "续命失败：没有%s。" % gu_name(tier_id)
	var tier: Dictionary = LongevityDefs.gu_tier(tier_id)
	state.longevity_gu_inventory[tier_id] = int(state.longevity_gu_inventory.get(tier_id, 0)) - 1
	var days: int = int(tier.get("days", 180))
	state.character["lifespan_days"] = max(0, int(state.character.get("lifespan_days", 0))) + days
	state.death_state["locked"] = false
	state.death_state["death_month"] = -1
	state.death_state["reason"] = ""
	state.ending_flags["escaped_death_once"] = true
	var risk: int = int(tier.get("side_effect_risk", 0))
	if risk > 0 and randi_range(1, 100) <= risk:
		state.aperture["stability"] = clampi(int(state.aperture.get("stability", 50)) - 4, 0, 100)
		state.aperture["conflict_rate"] = clampi(int(state.aperture.get("conflict_rate", 30)) + 3, 0, 100)
		state.add_log("%s副作用：仙窍轻微震荡。" % String(tier.get("name", "寿蛊")))
	update_lifespan_status(state, true)
	state.add_log("使用%s续命，寿元增加%d天。" % [String(tier.get("name", "寿蛊")), days])
	return "已使用%s，寿元增加%d天。" % [String(tier.get("name", "寿蛊")), days]

static func add_longevity_gu(state, tier_id: String, amount: int = 1) -> void:
	ensure_longevity_state(state)
	state.longevity_gu_inventory[tier_id] = max(0, int(state.longevity_gu_inventory.get(tier_id, 0)) + amount)

static func gu_name(tier_id: String) -> String:
	return String(LongevityDefs.gu_tier(tier_id).get("name", tier_id))

static func gu_inventory_text(state) -> String:
	ensure_longevity_state(state)
	var parts: Array = []
	for tier_id in LongevityDefs.gu_tier_ids():
		var count: int = int(state.longevity_gu_inventory.get(tier_id, 0))
		if count > 0:
			parts.append("%s x%d" % [gu_name(tier_id), count])
	if parts.is_empty():
		return "无"
	return _join_strings(parts, " / ")

static func reincarnate(state) -> String:
	ensure_longevity_state(state)
	var record: Dictionary = {
		"name": String(state.character.get("name", "无名")),
		"rank": int(state.character.get("rank", 1)),
		"rank_stage": int(state.character.get("rank_stage", 0)),
		"world_month": int(state.world_month),
		"reason": String(state.death_state.get("reason", "寿元耗尽")),
		"logs": state.logs.slice(0, min(5, state.logs.size()))
	}
	var history: Array = state.reincarnation_history.duplicate(true)
	history.push_front(record)
	state.reset_defaults()
	state.reincarnation_history = history
	state.created = false
	state.add_log("旧身已死，转世新局开启。")
	ensure_longevity_state(state)
	return "转世新局已准备，旧身记录已保留。"

static func market_lead_post(state, npc: Dictionary, reason: String = "") -> Dictionary:
	var lead: Dictionary = _new_lead(state, reason)
	var urgency: int = int(npc.get("urgency", 50))
	var trust: int = int(npc.get("trust", 30))
	return {
		"id": "post_longevity_%d_%d" % [int(state.world_month), randi_range(1000, 9999)],
		"kind": "情报" if int(lead.get("truthfulness", 50)) >= 45 else "疑似假情报",
		"title": "寿蛊线索：%s" % String(lead.get("title", "未命名线索")),
		"body": "%s\n%s愿意出售这条暗线，但买家可能被其他势力盯上。" % [String(lead.get("body", "")), String(npc.get("name", "匿名蛊仙"))],
		"seller_npc_id": String(npc.get("id", "")),
		"price": 260 + urgency * 7,
		"resource_id": "intel",
		"quantity": 1,
		"risk": clampi(int(lead.get("risk", 50)) + urgency / 4, 5, 98),
		"truthfulness": clampi(int(lead.get("truthfulness", 50)) + trust / 8, 3, 96),
		"expires_month": int(state.world_month) + randi_range(2, 6),
		"longevity_lead": lead
	}

static func resolve_market_lead_purchase(state, post: Dictionary) -> String:
	ensure_longevity_state(state)
	var truthfulness: int = int(post.get("truthfulness", 50))
	var risk: int = int(post.get("risk", 50))
	var lead: Dictionary = {}
	if typeof(post.get("longevity_lead", null)) == TYPE_DICTIONARY:
		lead = post["longevity_lead"].duplicate(true)
	else:
		lead = _new_lead(state, "宝黄天")
	lead["id"] = _make_lead_id(state)
	lead["truthfulness"] = truthfulness
	lead["risk"] = risk
	lead["status"] = "suspicious"
	lead["source"] = "宝黄天"
	if truthfulness < 38 and randi_range(1, 100) <= risk:
		lead["status"] = "fake"
		state.longevity_leads.push_front(lead)
		_spawn_lifespan_hunt_event(state, "购买假寿蛊线索")
		return "买下寿蛊暗线，但来源污浊，疑似假情报。"
	state.longevity_leads.push_front(lead)
	state.add_log("宝黄天购得寿蛊线索：%s。" % String(lead.get("title", "未知线索")))
	return "获得寿蛊线索：%s。" % String(lead.get("title", "未知线索"))

static func npc_longevity_action(state, npc: Dictionary, world_logs: Array) -> bool:
	ensure_longevity_state(state)
	var lifespan: int = int(npc.get("lifespan_days", 0))
	var urgency: int = int(npc.get("urgency", 50))
	if lifespan > 720 and urgency < 78:
		return false
	var roll: int = randi_range(1, 100)
	if roll <= 48:
		var post: Dictionary = market_lead_post(state, npc, "人物求生")
		state.market_posts.push_front(post)
		npc["last_action"] = "发布寿蛊线索订单"
		world_logs.append("人物求生：%s发布寿蛊线索订单。" % String(npc.get("name", "某人")))
		return true
	if roll <= 76:
		_spawn_lifespan_hunt_event(state, "低寿元人物夺寿")
		npc["last_action"] = "暗中筹备夺寿追杀"
		world_logs.append("夺寿暗潮：%s正在寻找寿蛊持有者。" % String(npc.get("name", "某人")))
		return true
	npc["last_action"] = "参与寿蛊竞拍"
	world_logs.append("寿蛊竞拍：%s在宝黄天抬高延寿资源价格。" % String(npc.get("name", "某人")))
	return true

static func _new_lead(state, source_reason: String) -> Dictionary:
	var template: Dictionary = LongevityDefs.random_lead_template()
	var risk: int = clampi(int(template.get("risk", 50)) + randi_range(-10, 12), 5, 98)
	var truthfulness: int = clampi(int(template.get("truthfulness", 55)) + randi_range(-12, 12), 3, 96)
	return {
		"id": _make_lead_id(state),
		"title": String(template.get("title", "寿蛊线索")),
		"body": String(template.get("body", "")),
		"region": String(template.get("region", "southern_border")),
		"source": String(template.get("source", source_reason)),
		"status": "rumor" if truthfulness >= 42 else "suspicious",
		"truthfulness": truthfulness,
		"risk": risk,
		"tier": String(template.get("tier", "mortal")),
		"discovered_month": int(state.world_month),
		"expires_month": int(state.world_month) + randi_range(4, 9)
	}

static func _cleanup_leads(state) -> void:
	for i in range(state.longevity_leads.size()):
		var lead: Dictionary = state.longevity_leads[i]
		if int(lead.get("expires_month", 0)) <= int(state.world_month) and String(lead.get("status", "")) != "resolved":
			lead["status"] = "expired"
		state.longevity_leads[i] = lead

static func _should_spawn_player_lead(state, months: int) -> bool:
	var status: String = String(state.lifespan_status)
	var chance: int = 18 + months * 4
	if status == LongevityDefs.STATUS_WARNING:
		chance += 18
	elif status == LongevityDefs.STATUS_CRITICAL:
		chance += 28
	elif status == LongevityDefs.STATUS_DYING:
		chance += 40
	return randi_range(1, 100) <= clampi(chance, 10, 82)

static func _maybe_seed_auction_post(state) -> void:
	var status: String = String(state.lifespan_status)
	if status == LongevityDefs.STATUS_STABLE and randi_range(1, 100) > 14:
		return
	if state.market_posts.size() > 0:
		for raw_post in state.market_posts:
			var post: Dictionary = raw_post
			if post.has("longevity_lead") or String(post.get("title", "")).find("寿蛊") >= 0:
				return
	if state.npcs.is_empty():
		return
	var npc: Dictionary = state.npcs[randi_range(0, state.npcs.size() - 1)]
	state.market_posts.push_front(market_lead_post(state, npc, "寿蛊竞拍"))

static func _spawn_lifespan_hunt_event(state, reason: String) -> void:
	state.world_events.push_front({
		"id": "event_lifespan_hunt_%d_%d" % [int(state.world_month), randi_range(1000, 9999)],
		"kind": "夺寿追杀",
		"region": _pick_region_id(state),
		"severity": clampi(62 + randi_range(-8, 18), 1, 100),
		"source_npc_id": "",
		"target_npc_id": "player",
		"expires_month": int(state.world_month) + randi_range(2, 5),
		"resolved": false,
		"effects": {"lifespan_hunt": 1, "market_risk": 12, "reason": reason}
	})

static func _pick_region_id(state) -> String:
	if state.world_regions.is_empty():
		return "southern_border"
	var region: Dictionary = state.world_regions[randi_range(0, state.world_regions.size() - 1)]
	return String(region.get("id", "southern_border"))

static func _make_lead_id(state) -> String:
	return "lead_%d_%d_%d" % [int(state.world_month), state.longevity_leads.size(), randi_range(1000, 9999)]

static func _join_strings(parts: Array, separator: String) -> String:
	var text: String = ""
	for part in parts:
		if text != "":
			text += separator
		text += String(part)
	return text

extends RefCounted

const RealmService := preload("res://scripts/realm_service.gd")
const SchoolLoadouts := preload("res://scripts/data/school_loadouts.gd")
const ApertureService := preload("res://scripts/aperture_service.gd")
const TribulationService := preload("res://scripts/tribulation_service.gd")
const CultivationService := preload("res://scripts/cultivation_service.gd")
const LongevityService := preload("res://scripts/longevity_service.gd")

const RANK_NAMES := ["一转", "二转", "三转", "四转", "五转", "六转", "七转", "八转", "九转"]
const RANK_STAGES := ["初阶", "中阶", "高阶", "巅峰"]
const REALM_NAMES := RANK_NAMES
const DAO_SCHOOLS := ["剑道", "炼道", "奴道", "智道", "运道"]

const GU_DEFINITIONS := {
	"sword_core": {
		"name": "剑道仙蛊",
		"type": "core",
		"school": "剑道",
		"grade": "仙蛊",
		"unique": false,
		"power": 620,
		"spirit_cost": 120,
		"stability": 86,
		"cooldown": 1.8,
		"description": "生成一道高威力剑气，是最稳定的起手主程序。"
	},
	"refine_core": {
		"name": "炉心仙蛊",
		"type": "core",
		"school": "炼道",
		"grade": "仙蛊",
		"unique": false,
		"power": 420,
		"spirit_cost": 95,
		"stability": 91,
		"cooldown": 2.2,
		"description": "以炼化之火持续灼烧目标，并提升炼蛊成功率。"
	},
	"enslave_core": {
		"name": "万兽魂蛊",
		"type": "core",
		"school": "奴道",
		"grade": "仙蛊",
		"unique": false,
		"power": 360,
		"spirit_cost": 105,
		"stability": 78,
		"cooldown": 2.6,
		"description": "召唤魂影牵制敌人，适合拖延与围杀。"
	},
	"wisdom_core": {
		"name": "推演星蛊",
		"type": "core",
		"school": "智道",
		"grade": "仙蛊",
		"unique": false,
		"power": 390,
		"spirit_cost": 90,
		"stability": 88,
		"cooldown": 2.0,
		"description": "推演敌阵破绽，提升奇袭收益并强化情报流。"
	},
	"luck_core": {
		"name": "转运金蛊",
		"type": "core",
		"school": "运道",
		"grade": "仙蛊",
		"unique": false,
		"power": 340,
		"spirit_cost": 85,
		"stability": 96,
		"cooldown": 2.3,
		"description": "趋吉避凶，降低反噬风险，但杀伤依赖辅助蛊补足。"
	},
	"chase_plugin": {
		"name": "追踪凡蛊",
		"type": "plugin",
		"school": "剑道",
		"grade": "凡蛊",
		"power": 80,
		"spirit_cost": 35,
		"stability": -4,
		"cooldown": 0.2,
		"tag": "homing",
		"description": "让弹道自动追踪最近敌人。"
	},
	"split_plugin": {
		"name": "分裂凡蛊",
		"type": "plugin",
		"school": "剑道",
		"grade": "凡蛊",
		"power": 120,
		"spirit_cost": 80,
		"stability": -12,
		"cooldown": 0.5,
		"tag": "split",
		"description": "将杀招拆成多道子弹道。"
	},
	"pierce_plugin": {
		"name": "穿透凡蛊",
		"type": "plugin",
		"school": "剑道",
		"grade": "凡蛊",
		"power": 110,
		"spirit_cost": 60,
		"stability": -8,
		"cooldown": 0.3,
		"tag": "pierce",
		"description": "击穿第一个目标后继续飞行。"
	},
	"stealth_plugin": {
		"name": "隐匿凡蛊",
		"type": "plugin",
		"school": "智道",
		"grade": "凡蛊",
		"power": 50,
		"spirit_cost": 55,
		"stability": -7,
		"cooldown": 0.1,
		"tag": "crit",
		"description": "提高暴击与奇袭收益。"
	},
	"guard_plugin": {
		"name": "稳固凡蛊",
		"type": "plugin",
		"school": "运道",
		"grade": "凡蛊",
		"power": 20,
		"spirit_cost": 40,
		"stability": 12,
		"cooldown": 0.0,
		"tag": "guard",
		"description": "降低反噬风险，牺牲一部分输出。"
	},
	"taixu_immortal": {
		"name": "太虚玄灵蛊",
		"type": "core",
		"school": "智道",
		"grade": "仙阶·上品",
		"unique": true,
		"power": 920,
		"spirit_cost": 180,
		"stability": 82,
		"cooldown": 2.4,
		"description": "天地间唯一仙蛊，引动太虚之力，对敌群造成大量真实伤害。"
	},
	"blood_sword": {
		"name": "化血神剑蛊",
		"type": "core",
		"school": "剑道",
		"grade": "仙阶·中品",
		"unique": true,
		"power": 780,
		"spirit_cost": 150,
		"stability": 74,
		"cooldown": 2.0,
		"description": "以寿元和灵气催生血剑，威力惊人但反噬明显。"
	}
}

const REFINE_RECIPES := {
	"taixu_immortal": {
		"name": "炼制太虚玄灵蛊",
		"result": "taixu_immortal",
		"costs": {"immortal_stone": 780, "spirit_qi": 3600, "intel": 180, "materials": 4},
		"base_success": 0.58,
		"months": 3,
		"description": "全局唯一。成功后可作为高阶杀招核心，失败会损失资源并扣寿元。"
	},
	"blood_sword": {
		"name": "炼制化血神剑蛊",
		"result": "blood_sword",
		"costs": {"immortal_stone": 520, "spirit_qi": 2200, "intel": 120, "materials": 3},
		"base_success": 0.66,
		"months": 2,
		"description": "全局唯一。剑道爆发核心，适合快速结束战斗。"
	},
	"chase_plugin": {
		"name": "补炼追踪凡蛊",
		"result": "chase_plugin",
		"costs": {"immortal_stone": 120, "spirit_qi": 700, "intel": 25, "materials": 1},
		"base_success": 0.86,
		"months": 1,
		"description": "常规插件，可叠加库存。"
	},
	"split_plugin": {
		"name": "补炼分裂凡蛊",
		"result": "split_plugin",
		"costs": {"immortal_stone": 160, "spirit_qi": 900, "intel": 40, "materials": 1},
		"base_success": 0.78,
		"months": 1,
		"description": "常规插件，提高战斗覆盖面。"
	}
}

var created := false
var character := {}
var resources := {}
var aperture := {}
var gu_inventory := {}
var unique_gu := {}
var killer_moves := []
var active_killer_move := -1
var world_month := 0
var logs := []
var npc := {}
var world_regions := []
var factions := []
var npcs := []
var market_posts := []
var world_events := []
var story_progress := {}
var dungeon_progress := {}
var gu_ecology := {}
var tribulation_state := {}
var defense_scripts := []
var active_defense_script := -1
var runtime_injection_history := []
var cultivation_exp := 0
var bottleneck := 0
var breakthrough_progress := 0
var ascension_state := {}
var breakthrough_history := []
var lifespan_status := "stable"
var death_state := {}
var longevity_leads := []
var longevity_gu_inventory := {}
var reincarnation_history := []
var ending_flags := {}

func _init() -> void:
	reset_defaults()

func reset_defaults() -> void:
	created = false
	world_month = 0
	active_killer_move = -1
	character = {
		"name": "顾无生",
		"gender": "男",
		"origin": "寒门子弟",
		"talent": "散修",
		"primary_school": "剑道",
		"rank": 1,
		"rank_stage": 0,
		"realm_index": 1,
		"morality_score": 0,
		"lifespan_days": 73 * 360 + 147,
		"max_hp": 100,
		"hp": 100,
		"dao_marks": {"剑道": 81, "炼道": 49, "奴道": 35, "智道": 68, "运道": 42}
	}
	resources = {
		"immortal_stone": 2350,
		"spirit_qi": 86420,
		"intel": 1260,
		"materials": 12
	}
	aperture = {
		"qi_balance": 72,
		"conflict_rate": 31,
		"food_saturation": 48,
		"stone_delta": 32,
		"stability": 64,
		"nodes": [
			{"name": "仙窍核心", "level": 8, "status": "稳定", "pressure": 42},
			{"name": "灵泉", "level": 7, "status": "压力", "pressure": 82},
			{"name": "药田", "level": 6, "status": "稳定", "pressure": 36},
			{"name": "虫巢", "level": 7, "status": "饥饿", "pressure": 72},
			{"name": "矿脉", "level": 6, "status": "稳定", "pressure": 44}
		],
		"warnings": []
	}
	gu_inventory = {}
	unique_gu = {}
	killer_moves = []
	npc = {"name": "玄雾子", "relation": 18, "trust": 36, "urgency": 64}
	world_regions = _default_world_regions()
	factions = _default_factions()
	npcs = _default_npcs()
	market_posts = _default_market_posts()
	world_events = _default_world_events()
	story_progress = {}
	dungeon_progress = {}
	gu_ecology = {}
	tribulation_state = {}
	defense_scripts = []
	active_defense_script = -1
	runtime_injection_history = []
	cultivation_exp = 0
	bottleneck = 0
	breakthrough_progress = 0
	ascension_state = {}
	breakthrough_history = []
	lifespan_status = "stable"
	death_state = {"locked": false, "death_month": -1, "reason": "", "last_status": "stable"}
	longevity_leads = []
	longevity_gu_inventory = {"mortal": 0, "earth": 0, "heaven": 0}
	reincarnation_history = []
	ending_flags = {}
	logs = []
	add_log("新存档已初始化。寿元持续流逝，一切行为都会留下代价。")

func ensure_world_defaults() -> void:
	ensure_character_defaults()
	if world_regions.is_empty():
		world_regions = _default_world_regions()
	if factions.is_empty():
		factions = _default_factions()
	if npcs.is_empty():
		npcs = _default_npcs()
	if market_posts.is_empty():
		market_posts = _default_market_posts()
	if world_events.is_empty():
		world_events = _default_world_events()
	if npc.is_empty() and not npcs.is_empty():
		var first_npc: Dictionary = npcs[0]
		npc = {"name": first_npc.get("name", "玄雾子"), "relation": first_npc.get("relation", 0), "trust": first_npc.get("trust", 0), "urgency": first_npc.get("urgency", 50)}
	if story_progress.is_empty():
		story_progress = {"three_kings_mountain": {"unlocked": true, "intro_seen": false, "rumor_month": world_month, "branches": {}}}
	if dungeon_progress.is_empty():
		dungeon_progress = {
			"dog_king": {"attempts": 0, "victories": 0, "best_difficulty": "", "cleared": false},
			"xin_king": {"attempts": 0, "victories": 0, "best_difficulty": "", "cleared": false},
			"bao_king": {"attempts": 0, "victories": 0, "best_difficulty": "", "cleared": false}
		}
	for i in range(npcs.size()):
		var npc_state: Dictionary = npcs[i]
		if not npc_state.has("rank"):
			npc_state["rank"] = clampi(int(npc_state.get("realm_index", 1)), 1, 9)
		if not npc_state.has("rank_stage"):
			npc_state["rank_stage"] = 1
		npcs[i] = npc_state
	if typeof(gu_ecology) != TYPE_DICTIONARY:
		gu_ecology = {}
	if typeof(tribulation_state) != TYPE_DICTIONARY:
		tribulation_state = {}
	if typeof(defense_scripts) != TYPE_ARRAY:
		defense_scripts = []
	if typeof(runtime_injection_history) != TYPE_ARRAY:
		runtime_injection_history = []
	if typeof(ascension_state) != TYPE_DICTIONARY:
		ascension_state = {}
	if typeof(breakthrough_history) != TYPE_ARRAY:
		breakthrough_history = []
	cultivation_exp = max(0, int(cultivation_exp))
	bottleneck = clampi(int(bottleneck), 0, 100)
	breakthrough_progress = clampi(int(breakthrough_progress), 0, 100)
	active_defense_script = clampi(int(active_defense_script), -1, max(-1, defense_scripts.size() - 1))
	ApertureService.ensure_ecology_state(self)
	TribulationService.ensure_tribulation_state(self)
	CultivationService.ensure_cultivation_state(self)
	LongevityService.ensure_longevity_state(self)

func ensure_character_defaults() -> void:
	character = RealmService.migrate_character(character)
	if not character.has("primary_school"):
		character["primary_school"] = "剑道"
	if not character.has("dao_marks"):
		character["dao_marks"] = {"剑道": 81, "炼道": 49, "奴道": 35, "智道": 68, "运道": 42}

func _default_world_regions() -> Array:
	return [
		{"id": "southern_border", "name": "南疆", "danger": 62, "resource": "蛊材", "owner": "shadow_sect"},
		{"id": "central_continent", "name": "中洲", "danger": 48, "resource": "情报", "owner": "heavenly_court"},
		{"id": "northern_plains", "name": "北原", "danger": 70, "resource": "战利品", "owner": "blood_alliance"},
		{"id": "eastern_sea", "name": "东海", "danger": 44, "resource": "仙元石", "owner": "loose_cultivators"},
		{"id": "western_desert", "name": "西漠", "danger": 57, "resource": "遗迹", "owner": "loose_cultivators"}
	]

func _default_factions() -> Array:
	return [
		{"id": "shadow_sect", "name": "幽泉宗", "stance": -12, "wealth": 64, "tension": 48},
		{"id": "heavenly_court", "name": "天庭余脉", "stance": -28, "wealth": 82, "tension": 55},
		{"id": "blood_alliance", "name": "血盟", "stance": -42, "wealth": 58, "tension": 72},
		{"id": "loose_cultivators", "name": "散修市盟", "stance": 8, "wealth": 45, "tension": 38}
	]

func _default_npcs() -> Array:
	return [
		{"id": "xuanwuzi", "name": "玄雾子", "faction": "shadow_sect", "rank": 5, "rank_stage": 2, "realm_index": 5, "lifespan_days": 5 * 360 + 90, "resources": {"immortal_stone": 920, "spirit_qi": 18000, "intel": 360, "materials": 5}, "personality": "逐利谨慎", "relation": 18, "trust": 36, "urgency": 64, "known_intel": ["极北遗迹入口"], "owned_gu": [], "current_goal": "搜集寿蛊线索", "last_action": "试探玩家底价"},
		{"id": "chixiao", "name": "赤霄散人", "faction": "blood_alliance", "rank": 4, "rank_stage": 3, "realm_index": 4, "lifespan_days": 2 * 360 + 180, "resources": {"immortal_stone": 620, "spirit_qi": 12000, "intel": 180, "materials": 3}, "personality": "激进嗜战", "relation": -22, "trust": 18, "urgency": 78, "known_intel": ["血道残图"], "owned_gu": [], "current_goal": "夺取仙元石", "last_action": "在北原伏击商队"},
		{"id": "baiwusheng", "name": "白无生", "faction": "heavenly_court", "rank": 6, "rank_stage": 1, "realm_index": 6, "lifespan_days": 8 * 360 + 40, "resources": {"immortal_stone": 1600, "spirit_qi": 26000, "intel": 640, "materials": 8}, "personality": "冷静算计", "relation": -8, "trust": 28, "urgency": 42, "known_intel": ["太虚玄灵蛊配方"], "owned_gu": [], "current_goal": "竞速炼制唯一仙蛊", "last_action": "收购九幽玄铁"},
		{"id": "qingluan", "name": "青鸾仙子", "faction": "loose_cultivators", "rank": 4, "rank_stage": 2, "realm_index": 4, "lifespan_days": 11 * 360 + 120, "resources": {"immortal_stone": 740, "spirit_qi": 21000, "intel": 420, "materials": 6}, "personality": "交易优先", "relation": 24, "trust": 52, "urgency": 34, "known_intel": ["东海灵泉潮汐"], "owned_gu": [], "current_goal": "稳定出售资源", "last_action": "发布灵泉结晶订单"},
		{"id": "guixin", "name": "归墟子", "faction": "loose_cultivators", "rank": 5, "rank_stage": 0, "realm_index": 5, "lifespan_days": 3 * 360 + 20, "resources": {"immortal_stone": 480, "spirit_qi": 9000, "intel": 520, "materials": 2}, "personality": "情报投机", "relation": 4, "trust": 22, "urgency": 86, "known_intel": ["疑似寿蛊假线"], "owned_gu": [], "current_goal": "散布真假情报换寿元", "last_action": "匿名抛售寿蛊线索"}
	]

func _default_market_posts() -> Array:
	return [
		{"id": "post_seed_1", "kind": "求购", "title": "求购寿蛊线索", "body": "寿元将尽，任何可验证线索皆可议价。", "seller_npc_id": "xuanwuzi", "price": 320, "resource_id": "intel", "quantity": 1, "risk": 42, "truthfulness": 78, "expires_month": world_month + 6},
		{"id": "post_seed_2", "kind": "抛售", "title": "灵泉结晶三十枚", "body": "东海新出，适合维持仙窍灵气。", "seller_npc_id": "qingluan", "price": 460, "resource_id": "spirit_qi", "quantity": 3200, "risk": 18, "truthfulness": 88, "expires_month": world_month + 4},
		{"id": "post_seed_3", "kind": "疑似假情报", "title": "春秋蝉现世", "body": "据称可逆转寿元，来源混乱。", "seller_npc_id": "guixin", "price": 180, "resource_id": "intel", "quantity": 160, "risk": 74, "truthfulness": 28, "expires_month": world_month + 3}
	]

func _default_world_events() -> Array:
	return [
		{"id": "event_seed_1", "kind": "寿蛊线索", "region": "northern_plains", "severity": 58, "source_npc_id": "guixin", "target_npc_id": "", "expires_month": world_month + 5, "resolved": false, "effects": {"intel_price": 12}},
		{"id": "event_seed_2", "kind": "宗门冲突", "region": "southern_border", "severity": 46, "source_npc_id": "chixiao", "target_npc_id": "xuanwuzi", "expires_month": world_month + 4, "resolved": false, "effects": {"market_risk": 8}}
	]

func setup_new_character(name_value: String, gender_value: String, origin_value: String, talent_value: String, primary_school: String) -> void:
	reset_defaults()
	created = true
	character["name"] = name_value.strip_edges() if name_value.strip_edges() != "" else "顾无生"
	character["gender"] = gender_value
	character["origin"] = origin_value
	character["talent"] = talent_value
	character["primary_school"] = primary_school
	var loadout: Dictionary = SchoolLoadouts.apply_to_state(self, primary_school)
	var dao_marks: Dictionary = character.get("dao_marks", loadout.get("dao_marks", {})).duplicate(true)
	match origin_value:
		"世家嫡系":
			resources["immortal_stone"] += 800
			resources["intel"] += 160
		"流浪孤儿":
			character["max_hp"] += 12
			character["hp"] = character["max_hp"]
			resources["materials"] += 3
		"蛊虫转世":
			dao_marks["智道"] += 12
			resources["spirit_qi"] += 5000
		"宗门弃徒":
			dao_marks["炼道"] += 10
			resources["intel"] += 260
	if talent_value == "商贸背景":
		resources["immortal_stone"] += 360
	if talent_value == "情报天赋":
		resources["intel"] += 420
	if talent_value == "魔道":
		character["max_hp"] += 18
		character["hp"] = character["max_hp"]
		aperture["conflict_rate"] += 8
		adjust_morality(-6, "出身天赋")
	character["dao_marks"] = dao_marks
	CultivationService.ensure_cultivation_state(self)
	LongevityService.ensure_longevity_state(self)
	add_log("创建角色：%s，主修%s，寿元 %s。" % [character["name"], primary_school, format_lifespan()])

func format_lifespan() -> String:
	var days: int = int(character.get("lifespan_days", 0))
	var years: int = days / 360
	var left_days: int = days % 360
	return "%d年%d天" % [years, left_days]

func get_realm_name() -> String:
	ensure_character_defaults()
	return RealmService.display_realm(character)

func get_cultivation_title() -> String:
	ensure_character_defaults()
	return RealmService.cultivation_title(character)

func adjust_morality(amount: int, reason: String = "") -> void:
	character["morality_score"] = clampi(int(character.get("morality_score", 0)) + amount, -999, 999)
	if reason != "":
		add_log("%s之后，命数暗流微变。" % reason)

func get_resource(id: String) -> int:
	return int(resources.get(id, 0))

func add_resource(id: String, amount: int) -> void:
	resources[id] = max(0, get_resource(id) + amount)

func can_pay(costs: Dictionary) -> bool:
	for id in costs.keys():
		if get_resource(id) < int(costs[id]):
			return false
	return true

func pay(costs: Dictionary) -> void:
	for id in costs.keys():
		add_resource(id, -int(costs[id]))

func has_gu(id: String, amount: int = 1) -> bool:
	return int(gu_inventory.get(id, 0)) >= amount

func add_gu(id: String, amount: int = 1) -> void:
	gu_inventory[id] = int(gu_inventory.get(id, 0)) + amount
	if bool(GU_DEFINITIONS.get(id, {}).get("unique", false)):
		unique_gu[id] = character.get("name", "玩家")
	ApertureService.ensure_ecology_state(self)

func remove_gu(id: String, amount: int = 1) -> bool:
	if not has_gu(id, amount):
		return false
	gu_inventory[id] = int(gu_inventory[id]) - amount
	if int(gu_inventory[id]) <= 0:
		gu_inventory.erase(id)
	ApertureService.ensure_ecology_state(self)
	return true

func get_gu_name(id: String) -> String:
	var def: Dictionary = GU_DEFINITIONS.get(id, {})
	return String(def.get("name", id))

func get_gu_ids(type_filter: String = "") -> Array:
	var ids: Array = []
	for id in gu_inventory.keys():
		var def: Dictionary = GU_DEFINITIONS.get(id, {})
		if type_filter == "" or String(def.get("type", "")) == type_filter:
			ids.append(id)
	return ids

func build_killer_move(core_id: String, plugin_ids: Array) -> Dictionary:
	var core: Dictionary = GU_DEFINITIONS.get(core_id, {})
	var power: int = int(core.get("power", 0))
	var spirit_cost: int = int(core.get("spirit_cost", 0))
	var stability: int = int(core.get("stability", 70))
	var cooldown: float = float(core.get("cooldown", 2.0))
	var tags: Array = []
	var plugin_names: Array = []
	for plugin_id in plugin_ids:
		var plugin: Dictionary = GU_DEFINITIONS.get(plugin_id, {})
		power += int(plugin.get("power", 0))
		spirit_cost += int(plugin.get("spirit_cost", 0))
		stability += int(plugin.get("stability", 0))
		cooldown += float(plugin.get("cooldown", 0.0))
		var tag: String = String(plugin.get("tag", ""))
		if tag != "":
			tags.append(tag)
		plugin_names.append(String(plugin.get("name", plugin_id)))
	var condition_probe := {"core": core_id, "plugins": plugin_ids.duplicate()}
	var condition_penalty := ApertureService.condition_penalty_for_move(self, condition_probe)
	stability = clampi(stability - condition_penalty, 5, 100)
	var risk: int = clampi(100 - stability + max(0, plugin_ids.size() - 2) * 8, 0, 95)
	var name: String = "%s·%s" % [String(core.get("school", "无相")), String(core.get("name", "杀招"))]
	if plugin_names.size() > 0:
		name = "%s (%s)" % [name, _join_strings(plugin_names, " / ")]
	return {
		"name": name,
		"core": core_id,
		"plugins": plugin_ids.duplicate(),
		"power": power,
		"spirit_cost": spirit_cost,
		"stability": stability,
		"risk": risk,
		"cooldown": cooldown,
		"tags": tags,
		"condition_penalty": condition_penalty
	}

func _join_strings(parts: Array, separator: String) -> String:
	var text: String = ""
	for part in parts:
		if text != "":
			text += separator
		text += String(part)
	return text

func add_killer_move(move: Dictionary) -> void:
	killer_moves.append(move)
	active_killer_move = killer_moves.size() - 1
	add_log("保存杀招：%s，稳定度 %d%%。" % [move.get("name", "未命名杀招"), int(move.get("stability", 0))])

func get_active_killer_move() -> Dictionary:
	if active_killer_move >= 0 and active_killer_move < killer_moves.size():
		return killer_moves[active_killer_move]
	if killer_moves.size() > 0:
		active_killer_move = 0
		return killer_moves[0]
	return SchoolLoadouts.default_move_for_school(self, String(character.get("primary_school", "剑道")))

func add_defense_script(move: Dictionary) -> void:
	var script := move.duplicate(true)
	script["defense_role"] = "tribulation"
	defense_scripts.append(script)
	active_defense_script = defense_scripts.size() - 1
	add_log("保存防御脚本：%s。" % String(script.get("name", "未命名脚本")))

func get_active_defense_script() -> Dictionary:
	if active_defense_script >= 0 and active_defense_script < defense_scripts.size():
		return defense_scripts[active_defense_script]
	if not defense_scripts.is_empty():
		active_defense_script = 0
		return defense_scripts[0]
	return get_active_killer_move()

func get_warnings() -> Array:
	var warnings: Array = []
	if int(aperture.get("food_saturation", 0)) < 45:
		warnings.append("蛊虫饱食度不足，战斗中稳定度下降。")
	if int(aperture.get("conflict_rate", 0)) > 62:
		warnings.append("道痕互斥率过高，炼蛊反噬风险上升。")
	if int(aperture.get("stability", 0)) < 45:
		warnings.append("仙窍生态濒临崩溃，资源产出下降。")
	if int(character.get("lifespan_days", 0)) < 720:
		warnings.append("寿元不足两年，NPC 会更容易背叛。")
	var lifespan_warning: String = LongevityService.current_warning(self)
	if lifespan_warning != "":
		warnings.append(lifespan_warning)
	for warning in ApertureService.current_warnings(self):
		warnings.append(warning)
	for warning in TribulationService.current_warnings(self):
		warnings.append(warning)
	aperture["warnings"] = warnings
	return warnings

func add_log(text: String) -> void:
	logs.push_front("[%s] %s" % [format_lifespan(), text])
	while logs.size() > 16:
		logs.pop_back()

func to_dict() -> Dictionary:
	return {
		"created": created,
		"character": character,
		"resources": resources,
		"aperture": aperture,
		"gu_inventory": gu_inventory,
		"unique_gu": unique_gu,
		"killer_moves": killer_moves,
		"active_killer_move": active_killer_move,
		"world_month": world_month,
		"logs": logs,
		"npc": npc,
		"world_regions": world_regions,
		"factions": factions,
		"npcs": npcs,
		"market_posts": market_posts,
		"world_events": world_events,
		"story_progress": story_progress,
		"dungeon_progress": dungeon_progress,
		"gu_ecology": gu_ecology,
		"tribulation_state": tribulation_state,
		"defense_scripts": defense_scripts,
		"active_defense_script": active_defense_script,
		"runtime_injection_history": runtime_injection_history,
		"cultivation_exp": cultivation_exp,
		"bottleneck": bottleneck,
		"breakthrough_progress": breakthrough_progress,
		"ascension_state": ascension_state,
		"breakthrough_history": breakthrough_history,
		"lifespan_status": lifespan_status,
		"death_state": death_state,
		"longevity_leads": longevity_leads,
		"longevity_gu_inventory": longevity_gu_inventory,
		"reincarnation_history": reincarnation_history,
		"ending_flags": ending_flags
	}

static func from_dict(data: Dictionary) -> RefCounted:
	var state = load("res://scripts/game_state.gd").new()
	state.created = bool(data.get("created", false))
	if typeof(data.get("character", null)) == TYPE_DICTIONARY:
		state.character = data["character"]
	if typeof(data.get("resources", null)) == TYPE_DICTIONARY:
		state.resources = data["resources"]
	if typeof(data.get("aperture", null)) == TYPE_DICTIONARY:
		state.aperture = data["aperture"]
	if typeof(data.get("gu_inventory", null)) == TYPE_DICTIONARY:
		state.gu_inventory = data["gu_inventory"]
	if typeof(data.get("unique_gu", null)) == TYPE_DICTIONARY:
		state.unique_gu = data["unique_gu"]
	if typeof(data.get("killer_moves", null)) == TYPE_ARRAY:
		state.killer_moves = data["killer_moves"]
	state.active_killer_move = int(data.get("active_killer_move", state.active_killer_move))
	state.world_month = int(data.get("world_month", state.world_month))
	if typeof(data.get("logs", null)) == TYPE_ARRAY:
		state.logs = data["logs"]
	if typeof(data.get("npc", null)) == TYPE_DICTIONARY:
		state.npc = data["npc"]
	if typeof(data.get("world_regions", null)) == TYPE_ARRAY:
		state.world_regions = data["world_regions"]
	if typeof(data.get("factions", null)) == TYPE_ARRAY:
		state.factions = data["factions"]
	if typeof(data.get("npcs", null)) == TYPE_ARRAY:
		state.npcs = data["npcs"]
	if typeof(data.get("market_posts", null)) == TYPE_ARRAY:
		state.market_posts = data["market_posts"]
	if typeof(data.get("world_events", null)) == TYPE_ARRAY:
		state.world_events = data["world_events"]
	if typeof(data.get("story_progress", null)) == TYPE_DICTIONARY:
		state.story_progress = data["story_progress"]
	if typeof(data.get("dungeon_progress", null)) == TYPE_DICTIONARY:
		state.dungeon_progress = data["dungeon_progress"]
	if typeof(data.get("gu_ecology", null)) == TYPE_DICTIONARY:
		state.gu_ecology = data["gu_ecology"]
	if typeof(data.get("tribulation_state", null)) == TYPE_DICTIONARY:
		state.tribulation_state = data["tribulation_state"]
	if typeof(data.get("defense_scripts", null)) == TYPE_ARRAY:
		state.defense_scripts = data["defense_scripts"]
	state.active_defense_script = int(data.get("active_defense_script", state.active_defense_script))
	if typeof(data.get("runtime_injection_history", null)) == TYPE_ARRAY:
		state.runtime_injection_history = data["runtime_injection_history"]
	state.cultivation_exp = int(data.get("cultivation_exp", state.cultivation_exp))
	state.bottleneck = int(data.get("bottleneck", state.bottleneck))
	state.breakthrough_progress = int(data.get("breakthrough_progress", state.breakthrough_progress))
	if typeof(data.get("ascension_state", null)) == TYPE_DICTIONARY:
		state.ascension_state = data["ascension_state"]
	if typeof(data.get("breakthrough_history", null)) == TYPE_ARRAY:
		state.breakthrough_history = data["breakthrough_history"]
	state.lifespan_status = String(data.get("lifespan_status", state.lifespan_status))
	if typeof(data.get("death_state", null)) == TYPE_DICTIONARY:
		state.death_state = data["death_state"]
	if typeof(data.get("longevity_leads", null)) == TYPE_ARRAY:
		state.longevity_leads = data["longevity_leads"]
	if typeof(data.get("longevity_gu_inventory", null)) == TYPE_DICTIONARY:
		state.longevity_gu_inventory = data["longevity_gu_inventory"]
	if typeof(data.get("reincarnation_history", null)) == TYPE_ARRAY:
		state.reincarnation_history = data["reincarnation_history"]
	if typeof(data.get("ending_flags", null)) == TYPE_DICTIONARY:
		state.ending_flags = data["ending_flags"]
	state.ensure_world_defaults()
	return state

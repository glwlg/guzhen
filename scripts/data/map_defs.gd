extends RefCounted

const DEFAULT_CHUNK_SIZE := Vector2(2048, 1152)

const ORIGIN_SPAWN_IDS := {
	"寒门子弟": "mountain_village",
	"世家嫡系": "clan_gate",
	"流浪孤儿": "caravan_camp",
	"宗门弃徒": "mist_pavilion",
	"蛊虫转世": "insect_burrow"
}

const MAPS := {
	"qingmao_outer": {
		"name": "青茅山外域",
		"subtitle": "2.5D 探索 / 剧情触发",
		"rows": 2,
		"cols": 2,
		"chunk_size": Vector2(2048, 1152),
		"fallback_background": "res://assets/backgrounds/story/qingmao_crisis.png",
		"minimap": "res://assets/backgrounds/maps/qingmao_outer/qingmao_outer_minimap.png",
		"base_pattern": "res://assets/backgrounds/maps/qingmao_outer/base/qingmao_outer_base_r%d_c%d.png",
		"foreground_pattern": "res://assets/backgrounds/maps/qingmao_outer/foreground/qingmao_outer_fg_r%d_c%d.png",
		"light_pattern": "res://assets/backgrounds/maps/qingmao_outer/light/qingmao_outer_light_r%d_c%d.png",
		"collision_guide": "res://assets/backgrounds/maps/qingmao_outer/qingmao_outer_collision_guide.png",
		"spawn_points": {
			"clan_gate": Vector2(650, 360),
			"mountain_village": Vector2(700, 1760),
			"caravan_camp": Vector2(1280, 1880),
			"mist_pavilion": Vector2(3040, 470),
			"insect_burrow": Vector2(3060, 1780),
			"meditation_stone": Vector2(2050, 1430)
		},
		"triggers": [
			{
				"id": "clan_school_gate",
				"kind": "story",
				"title": "族学门口",
				"prompt": "进入族学，触发古月山寨开局抉择。",
				"position": Vector2(720, 420),
				"radius": 160,
				"once": false,
				"chapter_id": "gu_yue_village",
				"requires": {"chapter_unlocked": "gu_yue_village"}
			},
			{
				"id": "medicine_slope",
				"kind": "resource",
				"title": "采药坡",
				"prompt": "搜集山野药材与低阶灵气。",
				"position": Vector2(880, 1710),
				"radius": 140,
				"once": true,
				"rewards": {"materials": 2, "spirit_qi": 520},
				"log": "你在采药坡搜得一批低阶材料，顺手记下山寨外路。"
			},
			{
				"id": "caravan_camp",
				"kind": "person",
				"title": "商队营地",
				"prompt": "与青鸾仙子接触，开启早期交易人物线。",
				"position": Vector2(1300, 1885),
				"radius": 150,
				"once": true,
				"meet_npc_id": "qingluan",
				"rewards": {"intel": 80},
				"log": "你在商队营地见到青鸾仙子，获得一条南疆货物流向情报。"
			},
			{
				"id": "old_wine_cellar",
				"kind": "story",
				"title": "旧酒窖",
				"prompt": "酒香里藏着早期机缘，也可能引来族中视线。",
				"position": Vector2(1210, 720),
				"radius": 120,
				"once": false,
				"chapter_id": "gu_yue_village",
				"requires": {"chapter_unlocked": "gu_yue_village"}
			},
			{
				"id": "black_market_shrine",
				"kind": "person",
				"title": "黑市残坛",
				"prompt": "归墟子在此兜售真假难辨的情报。",
				"position": Vector2(3220, 690),
				"radius": 150,
				"once": true,
				"meet_npc_id": "guixin",
				"rewards": {"intel": 110},
				"log": "黑市残坛的烛火一闪，归墟子记住了你的价码。"
			},
			{
				"id": "wolf_tide_ridge",
				"kind": "story",
				"title": "狼潮山脊",
				"prompt": "山风里有血腥味，青茅山变局正在逼近。",
				"position": Vector2(3410, 1910),
				"radius": 180,
				"once": false,
				"chapter_id": "qingmao_crisis",
				"requires": {"chapter_unlocked": "qingmao_crisis"}
			},
			{
				"id": "aperture_meditation_stone",
				"kind": "map_exit",
				"title": "入定石台",
				"prompt": "盘膝入定，探索自身空窍。",
				"position": Vector2(2050, 1430),
				"radius": 170,
				"once": false,
				"target_map": "aperture_inner",
				"target_spawn": "aperture_gate"
			}
		]
	},
	"aperture_inner": {
		"name": "空窍内景",
		"subtitle": "真元海 / 蛊虫生态",
		"rows": 1,
		"cols": 2,
		"chunk_size": Vector2(2048, 1152),
		"fallback_background": "res://assets/backgrounds/aperture_map.png",
		"minimap": "res://assets/backgrounds/maps/aperture_inner/aperture_inner_minimap.png",
		"base_pattern": "res://assets/backgrounds/maps/aperture_inner/base/aperture_inner_base_r%d_c%d.png",
		"foreground_pattern": "res://assets/backgrounds/maps/aperture_inner/foreground/aperture_inner_fg_r%d_c%d.png",
		"light_pattern": "res://assets/backgrounds/maps/aperture_inner/light/aperture_inner_light_r%d_c%d.png",
		"collision_guide": "res://assets/backgrounds/maps/aperture_inner/aperture_inner_collision_guide.png",
		"spawn_points": {
			"aperture_gate": Vector2(420, 610),
			"qi_sea": Vector2(1150, 610),
			"return_world": Vector2(300, 950)
		},
		"triggers": [
			{
				"id": "aperture_qi_sea",
				"kind": "aperture_node",
				"title": "真元海",
				"prompt": "观察真元潮汐，获得少量修为。",
				"position": Vector2(1160, 610),
				"radius": 150,
				"once": false,
				"node": "qi_sea",
				"rewards": {"spirit_qi": 260},
				"cultivation_exp": 48,
				"log": "你在真元海边入定片刻，空窍潮汐带来新的修行感悟。"
			},
			{
				"id": "aperture_spirit_spring",
				"kind": "aperture_node",
				"title": "灵泉",
				"prompt": "调息灵泉，稳定仙窍灵气。",
				"position": Vector2(1780, 420),
				"radius": 140,
				"once": false,
				"node": "spirit_spring",
				"rewards": {"spirit_qi": 520},
				"aperture_delta": {"qi_balance": 3},
				"log": "灵泉涌动，天地二气短暂趋于平衡。"
			},
			{
				"id": "aperture_gu_nest",
				"kind": "aperture_node",
				"title": "虫巢",
				"prompt": "检查蛊虫饱食度，尝试缓解生态压力。",
				"position": Vector2(2580, 610),
				"radius": 150,
				"once": false,
				"node": "gu_nest",
				"costs": {"materials": 1},
				"aperture_delta": {"food_saturation": 6, "stability": 2},
				"log": "你投喂虫巢，几只凡蛊暂时安分下来。"
			},
			{
				"id": "aperture_mine_vein",
				"kind": "aperture_node",
				"title": "矿脉",
				"prompt": "梳理矿脉，获得少量仙元石。",
				"position": Vector2(3200, 770),
				"radius": 140,
				"once": false,
				"node": "mine_vein",
				"rewards": {"immortal_stone": 26},
				"aperture_delta": {"conflict_rate": 1},
				"log": "矿脉被轻轻撬动，几枚仙元石落入掌中。"
			},
			{
				"id": "aperture_return_world",
				"kind": "map_exit",
				"title": "回返外界",
				"prompt": "收束心神，回到青茅山外域。",
				"position": Vector2(300, 950),
				"radius": 160,
				"once": false,
				"target_map": "qingmao_outer",
				"target_spawn": "meditation_stone"
			}
		]
	}
}

static func map_ids() -> Array:
	return MAPS.keys()

static func map_def(map_id: String) -> Dictionary:
	return MAPS.get(map_id, MAPS["qingmao_outer"])

static func map_size(map_id: String) -> Vector2:
	var def: Dictionary = map_def(map_id)
	var chunk_size: Vector2 = def.get("chunk_size", DEFAULT_CHUNK_SIZE)
	return Vector2(int(def.get("cols", 1)) * chunk_size.x, int(def.get("rows", 1)) * chunk_size.y)

static func spawn_for_origin(origin: String) -> String:
	return String(ORIGIN_SPAWN_IDS.get(origin, "mountain_village"))

static func spawn_position(map_id: String, spawn_id: String) -> Vector2:
	var def: Dictionary = map_def(map_id)
	var spawns: Dictionary = def.get("spawn_points", {})
	if spawns.has(spawn_id):
		return spawns[spawn_id]
	for key in spawns.keys():
		return spawns[key]
	return map_size(map_id) * 0.5

static func trigger(map_id: String, trigger_id: String) -> Dictionary:
	for raw_trigger in map_def(map_id).get("triggers", []):
		var item: Dictionary = raw_trigger
		if String(item.get("id", "")) == trigger_id:
			return item
	return {}

static func trigger_by_id(trigger_id: String) -> Dictionary:
	for map_id in MAPS.keys():
		var item: Dictionary = trigger(String(map_id), trigger_id)
		if not item.is_empty():
			return item
	return {}

static func chunk_path(map_id: String, layer: String, row: int, col: int) -> String:
	var def: Dictionary = map_def(map_id)
	var key: String = "%s_pattern" % layer
	if not def.has(key):
		return ""
	return String(def[key]) % [row, col]

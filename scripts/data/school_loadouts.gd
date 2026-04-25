extends RefCounted

const LOADOUTS := {
	"剑道": {
		"inventory": {"sword_core": 1, "chase_plugin": 3, "pierce_plugin": 2, "guard_plugin": 1},
		"default_core": "sword_core",
		"default_plugins": ["chase_plugin", "pierce_plugin", "guard_plugin"],
		"resource_bonus": {"spirit_qi": 1200},
		"dao_marks": {"剑道": 84, "炼道": 35, "奴道": 36, "智道": 42, "运道": 38},
		"description": "剑气迅疾，适合以高命中和贯穿快速清场。"
	},
	"炼道": {
		"inventory": {"refine_core": 1, "guard_plugin": 2, "split_plugin": 2, "pierce_plugin": 1},
		"default_core": "refine_core",
		"default_plugins": ["guard_plugin", "split_plugin"],
		"resource_bonus": {"materials": 2, "intel": 120},
		"dao_marks": {"剑道": 34, "炼道": 84, "奴道": 33, "智道": 48, "运道": 40},
		"description": "炉火控局，炼蛊容错更高，战斗爆发稍慢。"
	},
	"奴道": {
		"inventory": {"enslave_core": 1, "chase_plugin": 2, "guard_plugin": 2, "stealth_plugin": 1},
		"default_core": "enslave_core",
		"default_plugins": ["chase_plugin", "guard_plugin"],
		"resource_bonus": {"spirit_qi": 1600},
		"dao_marks": {"剑道": 36, "炼道": 34, "奴道": 84, "智道": 43, "运道": 41},
		"description": "魂影牵制，适合拖延、围杀和低风险试探。"
	},
	"智道": {
		"inventory": {"wisdom_core": 1, "stealth_plugin": 2, "chase_plugin": 2, "guard_plugin": 1},
		"default_core": "wisdom_core",
		"default_plugins": ["stealth_plugin", "chase_plugin"],
		"resource_bonus": {"intel": 360},
		"dao_marks": {"剑道": 38, "炼道": 42, "奴道": 34, "智道": 84, "运道": 44},
		"description": "推演破绽，情报收益高，奇袭风险收益并存。"
	},
	"运道": {
		"inventory": {"luck_core": 1, "guard_plugin": 3, "split_plugin": 1, "stealth_plugin": 1},
		"default_core": "luck_core",
		"default_plugins": ["guard_plugin", "split_plugin"],
		"resource_bonus": {"immortal_stone": 260, "materials": 1},
		"dao_marks": {"剑道": 40, "炼道": 38, "奴道": 35, "智道": 42, "运道": 84},
		"description": "趋吉避凶，反噬更低，输出依赖后续补强。"
	}
}

static func loadout_for(school: String) -> Dictionary:
	return LOADOUTS.get(school, LOADOUTS["剑道"]).duplicate(true)

static func apply_to_state(state, school: String) -> Dictionary:
	var loadout := loadout_for(school)
	state.gu_inventory = loadout.get("inventory", {}).duplicate(true)
	state.character["primary_school"] = school
	state.character["dao_marks"] = loadout.get("dao_marks", {}).duplicate(true)
	var bonuses: Dictionary = loadout.get("resource_bonus", {})
	for id in bonuses.keys():
		state.add_resource(String(id), int(bonuses[id]))
	return loadout

static func default_move_for_school(state, school: String) -> Dictionary:
	var loadout := loadout_for(school)
	return state.build_killer_move(String(loadout.get("default_core", "sword_core")), loadout.get("default_plugins", []).duplicate())

static func default_core_for_school(school: String) -> String:
	return String(loadout_for(school).get("default_core", "sword_core"))

static func default_plugins_for_school(school: String) -> Array:
	return loadout_for(school).get("default_plugins", []).duplicate()

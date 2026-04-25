extends RefCounted

const DEFAULT_DEFINITION := {
	"food_id": "mixed_qi",
	"food_name": "混合灵气",
	"node": "虫巢",
	"monthly_food": 3,
	"monthly_qi": 40,
	"monthly_wear": 1,
	"critical": false
}

const DEFINITIONS := {
	"sword_core": {
		"food_id": "metal_qi",
		"food_name": "剑金灵气",
		"node": "矿脉",
		"monthly_food": 5,
		"monthly_qi": 120,
		"monthly_wear": 1,
		"critical": true
	},
	"refine_core": {
		"food_id": "fire_qi",
		"food_name": "炉火灵气",
		"node": "仙窍核心",
		"monthly_food": 5,
		"monthly_qi": 110,
		"monthly_wear": 1,
		"critical": true
	},
	"enslave_core": {
		"food_id": "beast_soul",
		"food_name": "兽魂余烬",
		"node": "虫巢",
		"monthly_food": 6,
		"monthly_qi": 120,
		"monthly_wear": 2,
		"critical": true
	},
	"wisdom_core": {
		"food_id": "star_thought",
		"food_name": "星念灵气",
		"node": "灵泉",
		"monthly_food": 4,
		"monthly_qi": 105,
		"monthly_wear": 1,
		"critical": true
	},
	"luck_core": {
		"food_id": "fortune_qi",
		"food_name": "运潮灵气",
		"node": "药田",
		"monthly_food": 4,
		"monthly_qi": 95,
		"monthly_wear": 1,
		"critical": true
	},
	"taixu_immortal": {
		"food_id": "void_qi",
		"food_name": "太虚玄气",
		"node": "灵泉",
		"monthly_food": 9,
		"monthly_qi": 260,
		"monthly_wear": 2,
		"critical": true
	},
	"blood_sword": {
		"food_id": "blood_qi",
		"food_name": "血煞灵气",
		"node": "矿脉",
		"monthly_food": 8,
		"monthly_qi": 210,
		"monthly_wear": 2,
		"critical": true
	},
	"chase_plugin": {
		"food_id": "wind_qi",
		"food_name": "追风灵气",
		"node": "灵泉",
		"monthly_food": 2,
		"monthly_qi": 35,
		"monthly_wear": 1,
		"critical": false
	},
	"split_plugin": {
		"food_id": "mirror_qi",
		"food_name": "镜裂灵气",
		"node": "仙窍核心",
		"monthly_food": 3,
		"monthly_qi": 50,
		"monthly_wear": 1,
		"critical": false
	},
	"pierce_plugin": {
		"food_id": "sharp_qi",
		"food_name": "锐金灵气",
		"node": "矿脉",
		"monthly_food": 3,
		"monthly_qi": 45,
		"monthly_wear": 1,
		"critical": false
	},
	"stealth_plugin": {
		"food_id": "shadow_qi",
		"food_name": "影息灵气",
		"node": "药田",
		"monthly_food": 3,
		"monthly_qi": 45,
		"monthly_wear": 1,
		"critical": false
	},
	"guard_plugin": {
		"food_id": "stable_qi",
		"food_name": "稳态灵气",
		"node": "仙窍核心",
		"monthly_food": 2,
		"monthly_qi": 40,
		"monthly_wear": 1,
		"critical": false
	}
}

static func definition(gu_id: String) -> Dictionary:
	var data: Dictionary = DEFAULT_DEFINITION.duplicate(true)
	var override: Dictionary = DEFINITIONS.get(gu_id, {})
	for key in override.keys():
		data[key] = override[key]
	return data

static func default_state_for(gu_id: String, amount: int = 1) -> Dictionary:
	var def := definition(gu_id)
	return {
		"id": gu_id,
		"amount": max(1, amount),
		"food_id": String(def.get("food_id", "mixed_qi")),
		"food_name": String(def.get("food_name", "混合灵气")),
		"node": String(def.get("node", "虫巢")),
		"food": 100,
		"condition": 100,
		"status": "稳定",
		"starvation_months": 0,
		"monthly_food": int(def.get("monthly_food", 3)),
		"monthly_qi": int(def.get("monthly_qi", 40)),
		"critical": bool(def.get("critical", false)),
		"last_issue": ""
	}

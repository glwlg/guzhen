extends RefCounted

const ORDER := ["heavenly_thunder", "earth_fire", "qi_collapse", "beast_hunger"]

const DEFINITIONS := {
	"heavenly_thunder": {
		"id": "heavenly_thunder",
		"name": "青雷天劫",
		"target_node": "灵泉",
		"base_severity": 52,
		"effect": "tribulation_lightning",
		"background": "res://assets/backgrounds/tribulations/heavenly_tribulation_sky.png",
		"reward_school": "剑道",
		"description": "雷劫会优先冲击灵泉与弹道类杀招，追踪和穿透插件更容易过载。"
	},
	"earth_fire": {
		"id": "earth_fire",
		"name": "地火焚窍",
		"target_node": "矿脉",
		"base_severity": 58,
		"effect": "earth_fire_burst",
		"background": "res://assets/backgrounds/tribulations/earth_fire_pressure.png",
		"reward_school": "炼道",
		"description": "地火从矿脉反冲，炼道防御脚本能更好吸收余波。"
	},
	"qi_collapse": {
		"id": "qi_collapse",
		"name": "二气坍缩",
		"target_node": "仙窍核心",
		"base_severity": 64,
		"effect": "qi_collapse_wave",
		"background": "res://assets/backgrounds/tribulations/qi_collapse.png",
		"reward_school": "智道",
		"description": "天地二气剧烈失衡，稳定度不足时会直接撕裂仙窍核心。"
	},
	"beast_hunger": {
		"id": "beast_hunger",
		"name": "虫巢饥劫",
		"target_node": "虫巢",
		"base_severity": 49,
		"effect": "beast_command",
		"background": "res://assets/backgrounds/tribulations/beast_hunger_swarm.png",
		"reward_school": "奴道",
		"description": "蛊群饥饿互噬，奴道与稳固类插件能降低损耗。"
	}
}

static func definition(tribulation_id: String) -> Dictionary:
	return DEFINITIONS.get(tribulation_id, DEFINITIONS[ORDER[0]]).duplicate(true)

static func pick_for_state(state) -> Dictionary:
	var index: int = abs(int(state.world_month) + int(state.aperture.get("conflict_rate", 0)) + int(state.aperture.get("qi_balance", 0))) % ORDER.size()
	var picked: Dictionary = definition(ORDER[index])
	picked["severity"] = clampi(int(picked.get("base_severity", 50)) + int(ceil(float(state.aperture.get("conflict_rate", 30)) / 8.0)), 30, 95)
	return picked

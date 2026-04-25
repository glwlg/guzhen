extends RefCounted

const DIFFICULTIES := {
	"normal": {"name": "普通", "enemy_scale": 1.0, "reward_scale": 1.0, "lifespan_loss": 120, "risk": 24},
	"danger": {"name": "凶险", "enemy_scale": 1.35, "reward_scale": 1.45, "lifespan_loss": 240, "risk": 48},
	"desperate": {"name": "绝境", "enemy_scale": 1.8, "reward_scale": 2.1, "lifespan_loss": 420, "risk": 76}
}

const BRANCHES := {
	"dog_king": {
		"name": "犬王传承",
		"school": "奴道",
		"subtitle": "犬群试炼",
		"background": "res://assets/backgrounds/dungeons/dog_king_trial.png",
		"effect": "beast_command",
		"intro": "犬王残念盘踞山腹，以犬群与魂影考校来者的奴道掌控。",
		"choice_mercy": 3,
		"choice_ruthless": -4,
		"rewards": {"immortal_stone": 360, "spirit_qi": 1800, "intel": 120, "materials": 2},
		"gu_reward": "enslave_core",
		"enemies": [
			{"name": "铁牙犬群", "sheet": "summoned_soul", "hp": 360, "speed": 175, "damage_min": 6, "damage_max": 13, "pos_ratio": Vector2(0.70, 0.28)},
			{"name": "影犬蛊修", "sheet": "enemy", "hp": 460, "speed": 136, "damage_min": 8, "damage_max": 15, "pos_ratio": Vector2(0.78, 0.55)},
			{"name": "奔袭犬魂", "sheet": "summoned_soul", "hp": 330, "speed": 190, "damage_min": 5, "damage_max": 12, "pos_ratio": Vector2(0.62, 0.76)}
		],
		"boss": {"name": "犬王残念", "sheet": "dog_king_boss", "hp": 880, "speed": 118, "damage_min": 12, "damage_max": 22, "pos_ratio": Vector2(0.86, 0.42)}
	},
	"xin_king": {
		"name": "信王传承",
		"school": "炼道",
		"subtitle": "机关炉阵",
		"background": "res://assets/backgrounds/dungeons/xin_king_trial.png",
		"effect": "refine_seal",
		"intro": "信王遗阵重视炼道次序，机关灵会惩罚急躁与资源不足的闯入者。",
		"choice_mercy": 2,
		"choice_ruthless": -2,
		"rewards": {"immortal_stone": 280, "spirit_qi": 1400, "intel": 240, "materials": 4},
		"gu_reward": "guard_plugin",
		"enemies": [
			{"name": "铜炉机关傀", "sheet": "enemy_elite", "hp": 620, "speed": 82, "damage_min": 10, "damage_max": 18, "pos_ratio": Vector2(0.72, 0.36)},
			{"name": "炼火守阵蛊师", "sheet": "enemy", "hp": 520, "speed": 96, "damage_min": 9, "damage_max": 16, "pos_ratio": Vector2(0.66, 0.68)}
		],
		"boss": {"name": "信王机关灵", "sheet": "xin_king_boss", "hp": 1040, "speed": 74, "damage_min": 14, "damage_max": 25, "pos_ratio": Vector2(0.84, 0.50)}
	},
	"bao_king": {
		"name": "爆王传承",
		"school": "炎爆",
		"subtitle": "爆炎死斗",
		"background": "res://assets/backgrounds/dungeons/bao_king_trial.png",
		"effect": "fire_burst",
		"intro": "爆王传承只认生死一线，火魄会以范围爆裂不断压缩走位空间。",
		"choice_mercy": 1,
		"choice_ruthless": -6,
		"rewards": {"immortal_stone": 520, "spirit_qi": 2200, "intel": 90, "materials": 3},
		"gu_reward": "split_plugin",
		"enemies": [
			{"name": "爆炎蛊修", "sheet": "enemy", "hp": 540, "speed": 124, "damage_min": 11, "damage_max": 20, "pos_ratio": Vector2(0.74, 0.30)},
			{"name": "火毒虫群", "sheet": "summoned_soul", "hp": 400, "speed": 170, "damage_min": 7, "damage_max": 17, "pos_ratio": Vector2(0.62, 0.58)},
			{"name": "赤焰护阵者", "sheet": "enemy_elite", "hp": 680, "speed": 102, "damage_min": 12, "damage_max": 22, "pos_ratio": Vector2(0.82, 0.72)}
		],
		"boss": {"name": "爆王火魄", "sheet": "bao_king_boss", "hp": 1120, "speed": 108, "damage_min": 16, "damage_max": 30, "pos_ratio": Vector2(0.88, 0.45)}
	}
}

const WILD_ENCOUNTER := {
	"id": "wild_ambush",
	"name": "野外遭遇",
	"objective": "击败所有敌人",
	"background": "res://assets/backgrounds/battle_ruins.png",
	"branch_id": "wild",
	"difficulty_id": "normal",
	"rewards": {"immortal_stone": 420, "intel": 160, "materials": 2},
	"failure": {"lifespan_loss": 360, "months": 2},
	"morality_delta": -1,
	"enemies": [
		{"name": "血煞蛊修", "sheet": "enemy", "hp": 520, "max_hp": 520, "speed": 118, "damage_min": 8, "damage_max": 16, "pos_ratio": Vector2(0.72, 0.30)},
		{"name": "六转蛊仙·玄阴子", "sheet": "enemy_elite", "hp": 780, "max_hp": 780, "speed": 86, "damage_min": 10, "damage_max": 18, "pos_ratio": Vector2(0.82, 0.55)},
		{"name": "噬灵虫群", "sheet": "summoned_soul", "hp": 420, "max_hp": 420, "speed": 145, "damage_min": 7, "damage_max": 15, "pos_ratio": Vector2(0.65, 0.76)}
	]
}

static func branch_ids() -> Array:
	return BRANCHES.keys()

static func difficulty_ids() -> Array:
	return ["normal", "danger", "desperate"]

static func branch(branch_id: String) -> Dictionary:
	return BRANCHES.get(branch_id, BRANCHES["dog_king"]).duplicate(true)

static func difficulty(difficulty_id: String) -> Dictionary:
	return DIFFICULTIES.get(difficulty_id, DIFFICULTIES["normal"]).duplicate(true)

static func difficulty_name(difficulty_id: String) -> String:
	return String(difficulty(difficulty_id).get("name", "普通"))

static func build_branch_encounter(branch_id: String, difficulty_id: String) -> Dictionary:
	var data := branch(branch_id)
	var diff := difficulty(difficulty_id)
	var enemy_scale: float = float(diff.get("enemy_scale", 1.0))
	var reward_scale: float = float(diff.get("reward_scale", 1.0))
	var enemies: Array = []
	for raw_enemy in data.get("enemies", []):
		enemies.append(_scaled_enemy(raw_enemy, enemy_scale))
	enemies.append(_scaled_enemy(data.get("boss", {}), enemy_scale))
	return {
		"id": "%s_%s" % [branch_id, difficulty_id],
		"name": "%s·%s" % [String(data.get("name", "传承")), difficulty_name(difficulty_id)],
		"objective": "通过%s，击败最终残念" % String(data.get("subtitle", "试炼")),
		"background": String(data.get("background", "res://assets/backgrounds/battle_ruins.png")),
		"branch_id": branch_id,
		"difficulty_id": difficulty_id,
		"effect": String(data.get("effect", "sword_qi")),
		"school": String(data.get("school", "")),
		"rewards": _scale_rewards(data.get("rewards", {}), reward_scale),
		"gu_reward": String(data.get("gu_reward", "")),
		"failure": {"lifespan_loss": int(diff.get("lifespan_loss", 180)), "months": 2},
		"morality_delta": int(data.get("choice_ruthless", -2)) if difficulty_id == "desperate" else int(data.get("choice_mercy", 1)),
		"risk": int(diff.get("risk", 25)),
		"enemies": enemies
	}

static func build_wild_encounter() -> Dictionary:
	return WILD_ENCOUNTER.duplicate(true)

static func _scaled_enemy(enemy_data, scale: float) -> Dictionary:
	var enemy: Dictionary = {}
	if typeof(enemy_data) == TYPE_DICTIONARY:
		enemy = enemy_data.duplicate(true)
	var hp: int = int(round(float(enemy.get("hp", 300)) * scale))
	enemy["hp"] = hp
	enemy["max_hp"] = hp
	enemy["speed"] = int(round(float(enemy.get("speed", 100)) * (0.92 + scale * 0.08)))
	enemy["damage_min"] = int(round(float(enemy.get("damage_min", 8)) * scale))
	enemy["damage_max"] = int(round(float(enemy.get("damage_max", 16)) * scale))
	return enemy

static func _scale_rewards(rewards: Dictionary, scale: float) -> Dictionary:
	var scaled := {}
	for id in rewards.keys():
		scaled[id] = int(round(float(rewards[id]) * scale))
	return scaled

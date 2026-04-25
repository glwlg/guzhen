extends RefCounted

static func runtime_enemies(encounter: Dictionary, battle_rect: Rect2) -> Array:
	var enemies: Array = []
	for raw_enemy in encounter.get("enemies", []):
		var enemy: Dictionary = raw_enemy.duplicate(true)
		var ratio: Vector2 = enemy.get("pos_ratio", Vector2(0.75, 0.50))
		enemy["pos"] = battle_rect.position + battle_rect.size * ratio
		enemy["facing"] = Vector2.LEFT
		enemy["action"] = "walk"
		enemy["attack_cd"] = 0.4
		enemy["attack_interval"] = float(enemy.get("attack_interval", 1.05))
		enemies.append(enemy)
	return enemies

static func enemy_damage(enemy: Dictionary) -> int:
	return randi_range(int(enemy.get("damage_min", 8)), int(enemy.get("damage_max", 16)))

static func combat_title(encounter: Dictionary) -> String:
	return String(encounter.get("name", "实时战斗"))

static func combat_objective(encounter: Dictionary) -> String:
	return String(encounter.get("objective", "击败所有敌人"))

static func combat_background(encounter: Dictionary) -> String:
	return String(encounter.get("background", "res://assets/backgrounds/battle_ruins.png"))

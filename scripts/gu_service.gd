extends RefCounted

const QUALITY_SCORE := {
	"残缺": -8,
	"普通": 0,
	"良品": 4,
	"上品": 8,
	"仙品": 12
}

static func ensure_instance_state(state) -> void:
	if typeof(state.gu_instances) != TYPE_DICTIONARY:
		state.gu_instances = {}
	state.gu_instance_next_id = max(1, int(state.gu_instance_next_id))
	if state.gu_instances.is_empty() and typeof(state.gu_inventory) == TYPE_DICTIONARY:
		_migrate_counts_to_instances(state)
	else:
		_normalize_instances(state)
	sync_inventory_counts(state)

static func add_gu(state, gu_id: String, amount: int = 1, rank_override: int = -1, quality: String = "") -> void:
	ensure_instance_state(state)
	for i in range(max(1, amount)):
		_create_instance(state, gu_id, rank_override, quality)
	sync_inventory_counts(state)

static func remove_gu(state, gu_id: String, amount: int = 1) -> bool:
	ensure_instance_state(state)
	if count_gu(state, gu_id) < amount:
		return false
	for i in range(amount):
		var key: String = _weakest_instance_key(state, gu_id)
		if key == "":
			return false
		state.gu_instances.erase(key)
	sync_inventory_counts(state)
	return true

static func count_gu(state, gu_id: String) -> int:
	ensure_instance_state(state)
	return int(state.gu_inventory.get(gu_id, 0))

static func has_gu(state, gu_id: String, amount: int = 1) -> bool:
	return count_gu(state, gu_id) >= amount

static func sync_inventory_counts(state) -> void:
	var counts: Dictionary = {}
	var unique_gu: Dictionary = {}
	for key_value in state.gu_instances.keys():
		var key: String = String(key_value)
		var instance: Dictionary = state.gu_instances[key]
		var gu_id: String = String(instance.get("gu_id", ""))
		if gu_id == "":
			continue
		counts[gu_id] = int(counts.get(gu_id, 0)) + 1
		var def: Dictionary = state.GU_DEFINITIONS.get(gu_id, {})
		if bool(def.get("unique", false)):
			unique_gu[gu_id] = String(instance.get("owner", state.character.get("name", "玩家")))
	state.gu_inventory = counts
	for unique_id_value in state.unique_gu.keys():
		var unique_id: String = String(unique_id_value)
		if not counts.has(unique_id):
			unique_gu[unique_id] = state.unique_gu[unique_id]
	state.unique_gu = unique_gu

static func best_instance(state, gu_id: String) -> Dictionary:
	ensure_instance_state(state)
	var best: Dictionary = {}
	var best_score: int = -99999
	for key_value in state.gu_instances.keys():
		var instance: Dictionary = state.gu_instances[String(key_value)]
		if String(instance.get("gu_id", "")) != gu_id:
			continue
		var score: int = int(instance.get("rank", 1)) * 1000 + int(instance.get("health", 100)) + int(instance.get("satiety", 100)) + int(QUALITY_SCORE.get(String(instance.get("quality", "普通")), 0))
		if score > best_score:
			best_score = score
			best = instance
	return best.duplicate(true)

static func best_rank(state, gu_id: String) -> int:
	var instance: Dictionary = best_instance(state, gu_id)
	if instance.is_empty():
		var def: Dictionary = state.GU_DEFINITIONS.get(gu_id, {})
		return clampi(int(def.get("rank", 1)), 1, 9)
	return clampi(int(instance.get("rank", 1)), 1, 9)

static func status_text(state, gu_id: String) -> String:
	ensure_instance_state(state)
	var count: int = count_gu(state, gu_id)
	if count <= 0:
		return "无"
	var instance: Dictionary = best_instance(state, gu_id)
	var rank: int = clampi(int(instance.get("rank", 1)), 1, 9)
	var quality: String = String(instance.get("quality", "普通"))
	var health: int = int(instance.get("health", 100))
	var satiety: int = int(instance.get("satiety", 100))
	var tier: String = "仙蛊" if rank >= 6 else "凡蛊"
	return "x%d / %s%s / %s / 饱食%d%% / 健康%d%%" % [count, state.RANK_NAMES[rank - 1], tier, quality, satiety, health]

static func move_component_modifier(state, gu_id: String) -> Dictionary:
	var instance: Dictionary = best_instance(state, gu_id)
	var def: Dictionary = state.GU_DEFINITIONS.get(gu_id, {})
	var rank: int = clampi(int(instance.get("rank", def.get("rank", 1))), 1, 9)
	var health: int = clampi(int(instance.get("health", 100)), 0, 100)
	var satiety: int = clampi(int(instance.get("satiety", 100)), 0, 100)
	var quality_score: int = int(QUALITY_SCORE.get(String(instance.get("quality", "普通")), 0))
	var power_multiplier: float = 1.0 + float(rank - 1) * 0.16 + float(quality_score) * 0.008
	var stability_delta: int = quality_score
	if health < 75:
		stability_delta -= int(ceil(float(75 - health) / 6.0))
	if satiety < 65:
		stability_delta -= int(ceil(float(65 - satiety) / 7.0))
	var spirit_multiplier: float = 1.0 + max(0.0, float(rank - 1) * 0.08)
	return {
		"rank": rank,
		"health": health,
		"satiety": satiety,
		"power_multiplier": power_multiplier,
		"spirit_multiplier": spirit_multiplier,
		"stability_delta": stability_delta,
		"quality": String(instance.get("quality", "普通"))
	}

static func degrade_gu_instance(state, gu_id: String, pressure: int) -> Dictionary:
	ensure_instance_state(state)
	var key: String = _weakest_instance_key(state, gu_id)
	if key == "":
		return {}
	var instance: Dictionary = state.gu_instances[key]
	instance["health"] = clampi(int(instance.get("health", 100)) - max(1, pressure), 0, 100)
	instance["satiety"] = clampi(int(instance.get("satiety", 100)) - max(1, int(ceil(float(pressure) * 0.35))), 0, 100)
	instance["wounded"] = int(instance.get("health", 100)) < 65
	state.gu_instances[key] = instance
	return instance.duplicate(true)

static func upgrade_best_mortal(state, gu_id: String) -> bool:
	ensure_instance_state(state)
	var key: String = _best_mortal_instance_key(state, gu_id)
	if key == "":
		return false
	var instance: Dictionary = state.gu_instances[key]
	var rank: int = clampi(int(instance.get("rank", 1)), 1, 9)
	if rank >= 5:
		return false
	instance["rank"] = rank + 1
	instance["health"] = clampi(int(instance.get("health", 100)) + 24, 0, 100)
	instance["satiety"] = clampi(int(instance.get("satiety", 100)) + 20, 0, 100)
	instance["quality"] = _improve_quality(String(instance.get("quality", "普通")))
	state.gu_instances[key] = instance
	sync_inventory_counts(state)
	return true

static func can_upgrade_mortal(state, gu_id: String) -> bool:
	var instance: Dictionary = best_instance(state, gu_id)
	if instance.is_empty():
		return false
	return int(instance.get("rank", 1)) < 5

static func instance_summary(state) -> Dictionary:
	ensure_instance_state(state)
	var result: Dictionary = {"total": 0, "mortal": 0, "immortal": 0, "wounded": 0, "hungry": 0}
	for key_value in state.gu_instances.keys():
		var instance: Dictionary = state.gu_instances[String(key_value)]
		result["total"] = int(result["total"]) + 1
		if int(instance.get("rank", 1)) >= 6:
			result["immortal"] = int(result["immortal"]) + 1
		else:
			result["mortal"] = int(result["mortal"]) + 1
		if int(instance.get("health", 100)) < 60:
			result["wounded"] = int(result["wounded"]) + 1
		if int(instance.get("satiety", 100)) < 50:
			result["hungry"] = int(result["hungry"]) + 1
	return result

static func _migrate_counts_to_instances(state) -> void:
	for gu_id_value in state.gu_inventory.keys():
		var gu_id: String = String(gu_id_value)
		var amount: int = max(0, int(state.gu_inventory.get(gu_id, 0)))
		for i in range(amount):
			_create_instance(state, gu_id)

static func _normalize_instances(state) -> void:
	var remove_keys: Array = []
	for key_value in state.gu_instances.keys():
		var key: String = String(key_value)
		var instance: Dictionary = state.gu_instances[key]
		var gu_id: String = String(instance.get("gu_id", ""))
		if gu_id == "" or not state.GU_DEFINITIONS.has(gu_id):
			remove_keys.append(key)
			continue
		var def: Dictionary = state.GU_DEFINITIONS.get(gu_id, {})
		instance["uid"] = String(instance.get("uid", key))
		instance["gu_id"] = gu_id
		instance["rank"] = clampi(int(instance.get("rank", def.get("rank", 1))), 1, 9)
		instance["quality"] = String(instance.get("quality", "仙品" if int(instance["rank"]) >= 6 else "普通"))
		instance["health"] = clampi(int(instance.get("health", 100)), 0, 100)
		instance["satiety"] = clampi(int(instance.get("satiety", 100)), 0, 100)
		instance["owner"] = String(instance.get("owner", state.character.get("name", "玩家")))
		if typeof(instance.get("bound_move_ids", null)) != TYPE_ARRAY:
			instance["bound_move_ids"] = []
		instance["created_month"] = int(instance.get("created_month", state.world_month))
		state.gu_instances[key] = instance
	for key in remove_keys:
		state.gu_instances.erase(key)

static func _create_instance(state, gu_id: String, rank_override: int = -1, quality: String = "") -> String:
	var def: Dictionary = state.GU_DEFINITIONS.get(gu_id, {})
	var rank: int = clampi(rank_override if rank_override > 0 else int(def.get("rank", 1)), 1, 9)
	var uid: String = "gu_%06d" % int(state.gu_instance_next_id)
	state.gu_instance_next_id = int(state.gu_instance_next_id) + 1
	var resolved_quality: String = quality
	if resolved_quality == "":
		resolved_quality = "仙品" if rank >= 6 else "普通"
	state.gu_instances[uid] = {
		"uid": uid,
		"gu_id": gu_id,
		"rank": rank,
		"quality": resolved_quality,
		"health": 100,
		"satiety": 100,
		"owner": String(state.character.get("name", "玩家")),
		"bound_move_ids": [],
		"created_month": int(state.world_month),
		"wounded": false
	}
	return uid

static func _weakest_instance_key(state, gu_id: String) -> String:
	var chosen: String = ""
	var score: int = 999999
	for key_value in state.gu_instances.keys():
		var key: String = String(key_value)
		var instance: Dictionary = state.gu_instances[key]
		if String(instance.get("gu_id", "")) != gu_id:
			continue
		var instance_score: int = int(instance.get("rank", 1)) * 1000 + int(instance.get("health", 100)) + int(instance.get("satiety", 100))
		if instance_score < score:
			score = instance_score
			chosen = key
	return chosen

static func _best_mortal_instance_key(state, gu_id: String) -> String:
	var chosen: String = ""
	var score: int = -999999
	for key_value in state.gu_instances.keys():
		var key: String = String(key_value)
		var instance: Dictionary = state.gu_instances[key]
		if String(instance.get("gu_id", "")) != gu_id:
			continue
		var rank: int = int(instance.get("rank", 1))
		if rank >= 5:
			continue
		var instance_score: int = rank * 1000 + int(instance.get("health", 100)) + int(instance.get("satiety", 100))
		if instance_score > score:
			score = instance_score
			chosen = key
	return chosen

static func _improve_quality(quality: String) -> String:
	if quality == "残缺":
		return "普通"
	if quality == "普通":
		return "良品"
	if quality == "良品":
		return "上品"
	return quality

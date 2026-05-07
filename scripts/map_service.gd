extends RefCounted

const MapDefs := preload("res://scripts/data/map_defs.gd")
const CultivationService := preload("res://scripts/cultivation_service.gd")

static func ensure_map_state(state) -> void:
	if String(state.current_map_id) == "":
		state.current_map_id = "qingmao_outer"
	if typeof(state.map_position) != TYPE_DICTIONARY or state.map_position.is_empty():
		var spawn_id: String = MapDefs.spawn_for_origin(String(state.character.get("origin", "寒门子弟")))
		set_map_position(state, MapDefs.spawn_position("qingmao_outer", spawn_id))
	if typeof(state.visited_maps) != TYPE_ARRAY:
		state.visited_maps = []
	if not state.visited_maps.has(state.current_map_id):
		state.visited_maps.append(state.current_map_id)
	if typeof(state.resolved_map_triggers) != TYPE_DICTIONARY:
		state.resolved_map_triggers = {}
	if typeof(state.discovered_locations) != TYPE_ARRAY:
		state.discovered_locations = []
	if typeof(state.aperture_map_state) != TYPE_DICTIONARY:
		state.aperture_map_state = {}

static func setup_new_map_state(state) -> void:
	state.current_map_id = "qingmao_outer"
	state.visited_maps = ["qingmao_outer"]
	state.resolved_map_triggers = {}
	state.discovered_locations = []
	state.aperture_map_state = {}
	var spawn_id: String = MapDefs.spawn_for_origin(String(state.character.get("origin", "寒门子弟")))
	set_map_position(state, MapDefs.spawn_position("qingmao_outer", spawn_id))
	state.add_log("你踏入青茅山外域，因果不再从菜单开始，而在脚下展开。")

static func current_position(state) -> Vector2:
	if typeof(state.map_position) != TYPE_DICTIONARY:
		return Vector2.ZERO
	return Vector2(float(state.map_position.get("x", 0.0)), float(state.map_position.get("y", 0.0)))

static func set_map_position(state, position: Vector2) -> void:
	state.map_position = {"x": position.x, "y": position.y}

static func enter_map(state, map_id: String, spawn_id: String = "") -> void:
	var target_map: String = map_id if MapDefs.MAPS.has(map_id) else "qingmao_outer"
	state.current_map_id = target_map
	if not state.visited_maps.has(target_map):
		state.visited_maps.append(target_map)
	var spawn: String = spawn_id
	if spawn == "":
		spawn = MapDefs.spawn_for_origin(String(state.character.get("origin", "寒门子弟"))) if target_map == "qingmao_outer" else "aperture_gate"
	set_map_position(state, MapDefs.spawn_position(target_map, spawn))
	state.add_log("抵达：%s。" % String(MapDefs.map_def(target_map).get("name", target_map)))

static func visible_triggers(state, map_id: String) -> Array:
	ensure_map_state(state)
	var visible: Array = []
	for raw_trigger in MapDefs.map_def(map_id).get("triggers", []):
		var trigger: Dictionary = raw_trigger
		if trigger_available(state, trigger):
			visible.append(trigger)
	return visible

static func trigger_available(state, trigger: Dictionary) -> bool:
	var trigger_id: String = String(trigger.get("id", ""))
	if bool(trigger.get("once", false)) and is_trigger_resolved(state, trigger_id):
		return false
	var requires: Dictionary = trigger.get("requires", {})
	if requires.has("chapter_unlocked"):
		var chapter_id: String = String(requires["chapter_unlocked"])
		var progress: Dictionary = state.story_progress.get(chapter_id, {})
		if not bool(progress.get("unlocked", false)) and not bool(progress.get("resolved", false)):
			return false
	if requires.has("chapter_resolved"):
		var resolved_chapter_id: String = String(requires["chapter_resolved"])
		var resolved_progress: Dictionary = state.story_progress.get(resolved_chapter_id, {})
		if not bool(resolved_progress.get("resolved", false)):
			return false
	if requires.has("rank_min"):
		if int(state.character.get("rank", 1)) < int(requires["rank_min"]):
			return false
	return true

static func is_trigger_resolved(state, trigger_id: String) -> bool:
	return bool(state.resolved_map_triggers.get(trigger_id, false))

static func mark_trigger_resolved(state, trigger_id: String) -> void:
	if trigger_id == "":
		return
	state.resolved_map_triggers[trigger_id] = true

static func discover_location(state, trigger: Dictionary) -> void:
	var title: String = String(trigger.get("title", "未知地点"))
	if not state.discovered_locations.has(title):
		state.discovered_locations.append(title)

static func resolve_simple_trigger(state, trigger: Dictionary) -> Dictionary:
	ensure_map_state(state)
	if trigger.is_empty():
		return {"ok": false, "message": "此处没有可交互事件。"}
	if not trigger_available(state, trigger):
		return {"ok": false, "message": "这条因果已经沉寂，暂时不能再次触发。"}
	var costs: Dictionary = trigger.get("costs", {})
	if costs.size() > 0 and not state.can_pay(costs):
		return {"ok": false, "message": "资源不足，无法完成此处行动。"}
	if costs.size() > 0:
		state.pay(costs)
	var rewards: Dictionary = trigger.get("rewards", {})
	for reward_id in rewards.keys():
		state.add_resource(String(reward_id), int(rewards[reward_id]))
	var aperture_delta: Dictionary = trigger.get("aperture_delta", {})
	for field in aperture_delta.keys():
		state.aperture[String(field)] = clampi(int(state.aperture.get(String(field), 0)) + int(aperture_delta[field]), 0, 100)
	var cultivation_gain: int = int(trigger.get("cultivation_exp", 0))
	if cultivation_gain > 0:
		CultivationService.add_exp(state, cultivation_gain, "地图探索")
	var npc_id: String = String(trigger.get("meet_npc_id", ""))
	if npc_id != "":
		_mark_person_met(state, npc_id)
	discover_location(state, trigger)
	if bool(trigger.get("once", false)):
		mark_trigger_resolved(state, String(trigger.get("id", "")))
	var message: String = String(trigger.get("log", "%s：事件已处理。" % String(trigger.get("title", "地点"))))
	state.add_log(message)
	return {"ok": true, "message": message}

static func _mark_person_met(state, npc_id: String) -> void:
	for i in range(state.npcs.size()):
		var npc: Dictionary = state.npcs[i]
		if String(npc.get("id", "")) == npc_id:
			npc["met"] = true
			if not npc.has("alive"):
				npc["alive"] = true
			state.npcs[i] = npc
			return

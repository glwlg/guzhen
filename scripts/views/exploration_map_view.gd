extends Control

signal trigger_requested(trigger_id: String)
signal story_choice_requested(trigger_id: String, chapter_id: String, choice_id: String)
signal save_position_requested(map_id: String, position: Vector2)

const MapDefs := preload("res://scripts/data/map_defs.gd")
const MapService := preload("res://scripts/map_service.gd")
const MapChunkLayer := preload("res://scripts/views/map_chunk_layer.gd")

const PLAYER_MALE_SHEET_CANDIDATES := [
	"res://assets/characters/sheets/player_male_sheet.png",
	"res://assets/characters/exploration/player_male_explore_sheet.png"
]
const PLAYER_FEMALE_SHEET_CANDIDATES := [
	"res://assets/characters/sheets/player_female_sheet.png",
	"res://assets/characters/exploration/player_female_explore_sheet.png"
]

const PLAYER_IMAGE_PATHS := {
	"男": "res://assets/characters/player_male.png",
	"女": "res://assets/characters/player_female.png"
}

const MARKER_ICON_PATHS := {
	"story": "res://assets/ui/exploration/location_marker_story.png",
	"resource": "res://assets/ui/exploration/location_marker_resource.png",
	"person": "res://assets/ui/exploration/location_marker_person.png",
	"map_exit": "res://assets/ui/exploration/location_marker_aperture.png",
	"aperture_node": "res://assets/ui/exploration/location_marker_resource.png"
}

const COLLISION_BLOCKED_LUMINANCE := 0.22
const COLLISION_SLOW_LUMINANCE := 0.72
const COLLISION_SLOW_MULTIPLIER := 0.52
const FOOT_SAMPLE_OFFSETS := [
	Vector2.ZERO,
	Vector2(-28, 0),
	Vector2(28, 0),
	Vector2(0, -14),
	Vector2(0, 16)
]

var state_ref
var map_id: String = "qingmao_outer"
var map_size: Vector2 = Vector2(4096, 2304)
var player_pos: Vector2 = Vector2.ZERO
var camera_pos: Vector2 = Vector2.ZERO
var collision_image: Image
var collision_image_size: Vector2 = Vector2.ZERO
var map_root: Node2D
var base_layer: Node2D
var light_layer: Node2D
var foreground_layer: Node2D
var marker_layer: Node2D
var actor_layer: Node2D
var player_sprite: Sprite2D
var player_shadow: Polygon2D
var player_uses_sheet: bool = false
var player_frame_size: Vector2i = Vector2i(256, 256)
var player_frame_columns: int = 1
var player_frame_rows: int = 1
var player_anim_time: float = 0.0
var player_direction_row: int = 0
var player_is_moving: bool = false
var prompt_label: Label
var status_label: Label
var overlay_layer: CanvasLayer
var choice_panel: PanelContainer
var markers: Dictionary = {}
var save_accumulator: float = 0.0
var prompt_trigger_id: String = ""
var speed: float = 340.0

func _ready() -> void:
	clip_contents = true
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_process(true)
	set_process_unhandled_input(true)
	_build_nodes()

func configure(new_state) -> void:
	state_ref = new_state
	MapService.ensure_map_state(state_ref)
	map_id = String(state_ref.current_map_id)
	player_pos = MapService.current_position(state_ref)
	_rebuild_map()

func _build_nodes() -> void:
	map_root = Node2D.new()
	map_root.name = "MapRoot"
	add_child(map_root)
	base_layer = MapChunkLayer.new()
	base_layer.name = "BaseChunks"
	base_layer.z_index = 0
	map_root.add_child(base_layer)
	light_layer = MapChunkLayer.new()
	light_layer.name = "LightChunks"
	light_layer.z_index = 10
	map_root.add_child(light_layer)
	marker_layer = Node2D.new()
	marker_layer.name = "Markers"
	marker_layer.z_index = 30
	map_root.add_child(marker_layer)
	actor_layer = Node2D.new()
	actor_layer.name = "Actors"
	actor_layer.z_index = 50
	map_root.add_child(actor_layer)
	player_shadow = Polygon2D.new()
	player_shadow.color = Color(0.0, 0.0, 0.0, 0.35)
	player_shadow.z_index = 1
	player_shadow.polygon = _ellipse_points(54.0, 18.0, 28)
	actor_layer.add_child(player_shadow)
	player_sprite = Sprite2D.new()
	player_sprite.centered = true
	player_sprite.z_index = 2
	actor_layer.add_child(player_sprite)
	foreground_layer = MapChunkLayer.new()
	foreground_layer.name = "ForegroundChunks"
	foreground_layer.z_index = 9000
	map_root.add_child(foreground_layer)

	var hud := PanelContainer.new()
	hud.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	hud.offset_left = 18
	hud.offset_top = -86
	hud.offset_right = 560
	hud.offset_bottom = -18
	hud.add_theme_stylebox_override("panel", _style_panel(Color(0.02, 0.025, 0.022, 0.72), Color(0.72, 0.52, 0.22, 0.86), 1))
	add_child(hud)
	var hud_box := VBoxContainer.new()
	hud_box.add_theme_constant_override("separation", 4)
	hud.add_child(hud_box)
	status_label = Label.new()
	status_label.add_theme_color_override("font_color", Color(0.90, 0.72, 0.42, 1.0))
	status_label.add_theme_font_size_override("font_size", 18)
	hud_box.add_child(status_label)
	prompt_label = Label.new()
	prompt_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	prompt_label.add_theme_color_override("font_color", Color(0.42, 0.92, 0.86, 1.0))
	prompt_label.add_theme_font_size_override("font_size", 16)
	hud_box.add_child(prompt_label)

	overlay_layer = CanvasLayer.new()
	add_child(overlay_layer)

func _rebuild_map() -> void:
	var map_def: Dictionary = MapDefs.map_def(map_id)
	map_size = MapDefs.map_size(map_id)
	_load_collision_guide(map_def)
	var adjusted_pos: Vector2 = _nearest_walkable_position(_clamp_to_map(player_pos))
	if adjusted_pos.distance_to(player_pos) > 0.5:
		player_pos = adjusted_pos
		emit_signal("save_position_requested", map_id, player_pos)
	base_layer.setup(map_id, "base")
	light_layer.setup(map_id, "light")
	foreground_layer.setup(map_id, "foreground")
	_load_player_sprite()
	_rebuild_markers()
	_clear_choice_panel()
	_update_camera()
	_update_prompt()

func _load_player_sprite() -> void:
	if state_ref == null:
		return
	if _load_player_from_sheet():
		return
	var gender: String = String(state_ref.character.get("gender", "男"))
	var path: String = String(PLAYER_IMAGE_PATHS.get(gender, PLAYER_IMAGE_PATHS["男"]))
	if ResourceLoader.exists(path):
		player_sprite.texture = load(path)
		var tex_size: Vector2 = Vector2(player_sprite.texture.get_width(), player_sprite.texture.get_height())
		var scale_factor: float = 150.0 / max(1.0, max(tex_size.x, tex_size.y))
		player_sprite.scale = Vector2(scale_factor, scale_factor)

func _load_player_from_sheet() -> bool:
	var gender: String = String(state_ref.character.get("gender", ""))
	var candidates: Array = PLAYER_MALE_SHEET_CANDIDATES
	if gender.find("女") >= 0 or gender.find("female") >= 0 or gender.find("еҐі") >= 0:
		candidates = PLAYER_FEMALE_SHEET_CANDIDATES
	for raw_path in candidates:
		var path: String = String(raw_path)
		if not ResourceLoader.exists(path):
			continue
		var texture: Texture2D = load(path)
		if texture == null:
			continue
		var tex_size: Vector2i = Vector2i(texture.get_width(), texture.get_height())
		if tex_size.x < 512 or tex_size.y < 512:
			continue
		player_sprite.texture = texture
		player_sprite.region_enabled = true
		player_frame_columns = max(1, int(tex_size.x / 256))
		player_frame_rows = max(1, int(tex_size.y / 256))
		player_frame_size = Vector2i(int(tex_size.x / player_frame_columns), int(tex_size.y / player_frame_rows))
		player_sprite.scale = Vector2(0.58, 0.58)
		player_uses_sheet = true
		_update_player_frame()
		return true
	player_uses_sheet = false
	player_sprite.region_enabled = false
	return false

func _rebuild_markers() -> void:
	for child in marker_layer.get_children():
		child.queue_free()
	markers.clear()
	for raw_trigger in MapService.visible_triggers(state_ref, map_id):
		var trigger: Dictionary = raw_trigger
		var marker: Node2D = _make_marker(trigger)
		marker_layer.add_child(marker)
		markers[String(trigger.get("id", ""))] = marker

func _make_marker(trigger: Dictionary) -> Node2D:
	var node := Node2D.new()
	node.name = String(trigger.get("id", "trigger"))
	node.position = trigger.get("position", Vector2.ZERO)
	node.z_index = 100
	var kind: String = String(trigger.get("kind", "story"))
	var icon_path: String = String(MARKER_ICON_PATHS.get(kind, MARKER_ICON_PATHS["story"]))
	if ResourceLoader.exists(icon_path):
		var sprite := Sprite2D.new()
		sprite.texture = load(icon_path)
		sprite.centered = true
		sprite.scale = Vector2(0.55, 0.55)
		node.add_child(sprite)
	else:
		var diamond := Polygon2D.new()
		diamond.polygon = PackedVector2Array([Vector2(0, -28), Vector2(40, 0), Vector2(0, 28), Vector2(-40, 0)])
		diamond.color = _marker_color(kind)
		node.add_child(diamond)
		var outline := Line2D.new()
		outline.width = 3.0
		outline.default_color = Color(0.92, 0.72, 0.42, 0.95)
		outline.closed = true
		outline.points = PackedVector2Array([Vector2(0, -30), Vector2(42, 0), Vector2(0, 30), Vector2(-42, 0)])
		node.add_child(outline)
	return node

func _marker_color(kind: String) -> Color:
	match kind:
		"resource", "aperture_node":
			return Color(0.10, 0.45, 0.34, 0.84)
		"person":
			return Color(0.36, 0.24, 0.58, 0.84)
		"map_exit":
			return Color(0.10, 0.36, 0.55, 0.88)
		_:
			return Color(0.48, 0.30, 0.10, 0.86)

func _process(delta: float) -> void:
	if state_ref == null or choice_panel != null:
		return
	var move := Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		move.x -= 1.0
	if Input.is_action_pressed("move_right"):
		move.x += 1.0
	if Input.is_action_pressed("move_up"):
		move.y -= 1.0
	if Input.is_action_pressed("move_down"):
		move.y += 1.0
	if move.length_squared() > 0.0:
		move = move.normalized()
		var current_pos: Vector2 = player_pos
		var move_speed: float = speed * _movement_multiplier_at(player_pos)
		var target_pos: Vector2 = _clamp_to_map(player_pos + move * move_speed * delta)
		player_pos = _resolve_walkable_move(player_pos, target_pos)
		var moved: bool = player_pos.distance_to(current_pos) > 0.1
		if moved:
			player_sprite.flip_h = (not player_uses_sheet) and move.x < -0.05
			save_accumulator += delta
			if save_accumulator >= 0.8:
				save_accumulator = 0.0
				emit_signal("save_position_requested", map_id, player_pos)
			player_anim_time += delta
			_update_player_direction(move)
		player_is_moving = moved
	else:
		player_is_moving = false
		player_anim_time = 0.0
	_update_player_frame()
	_update_camera()
	_update_prompt()

func _update_player_direction(move: Vector2) -> void:
	if abs(move.x) > abs(move.y):
		player_direction_row = 2 if move.x > 0.0 else 1
	else:
		player_direction_row = 0 if move.y > 0.0 else 3

func _update_player_frame() -> void:
	if not player_uses_sheet:
		return
	var row: int = clampi(player_direction_row, 0, max(0, player_frame_rows - 1))
	var frame: int = 0
	if player_is_moving:
		frame = int(floor(player_anim_time * 8.0)) % max(1, player_frame_columns)
	player_sprite.region_rect = Rect2(
		Vector2(frame * player_frame_size.x, row * player_frame_size.y),
		Vector2(player_frame_size.x, player_frame_size.y)
	)

func _unhandled_input(event: InputEvent) -> void:
	if choice_panel != null:
		return
	if event.is_action_pressed("interact"):
		if prompt_trigger_id != "":
			emit_signal("trigger_requested", prompt_trigger_id)
			accept_event()

func _update_camera() -> void:
	var view_size: Vector2 = size
	if view_size.x <= 1.0 or view_size.y <= 1.0:
		view_size = get_viewport_rect().size
	if map_size.x <= view_size.x:
		camera_pos.x = map_size.x * 0.5
	else:
		camera_pos.x = clampf(player_pos.x, view_size.x * 0.5, map_size.x - view_size.x * 0.5)
	if map_size.y <= view_size.y:
		camera_pos.y = map_size.y * 0.5
	else:
		camera_pos.y = clampf(player_pos.y, view_size.y * 0.5, map_size.y - view_size.y * 0.5)
	map_root.position = view_size * 0.5 - camera_pos
	player_shadow.position = player_pos + Vector2(0, 8)
	player_sprite.position = player_pos + Vector2(0, -74)
	player_shadow.z_index = int(player_pos.y)
	player_sprite.z_index = int(player_pos.y) + 1

func _update_prompt() -> void:
	var nearest: Dictionary = _nearest_trigger()
	prompt_trigger_id = String(nearest.get("id", ""))
	var map_name: String = String(MapDefs.map_def(map_id).get("name", map_id))
	status_label.text = "%s  ｜  坐标 %d, %d" % [map_name, int(player_pos.x), int(player_pos.y)]
	if nearest.is_empty():
		prompt_label.text = "WASD 移动，靠近地点后按 E 交互。"
	else:
		prompt_label.text = "按 E：%s｜%s" % [String(nearest.get("title", "地点")), String(nearest.get("prompt", ""))]

func _nearest_trigger() -> Dictionary:
	var best: Dictionary = {}
	var best_distance: float = INF
	for raw_trigger in MapService.visible_triggers(state_ref, map_id):
		var trigger: Dictionary = raw_trigger
		var trigger_pos: Vector2 = trigger.get("position", Vector2.ZERO)
		var distance: float = player_pos.distance_to(trigger_pos)
		var radius: float = float(trigger.get("radius", 120.0))
		if distance <= radius and distance < best_distance:
			best_distance = distance
			best = trigger
	return best

func refresh_from_state() -> void:
	if state_ref == null:
		return
	map_id = String(state_ref.current_map_id)
	player_pos = MapService.current_position(state_ref)
	_rebuild_map()

func _load_collision_guide(map_def: Dictionary) -> void:
	collision_image = null
	collision_image_size = Vector2.ZERO
	var guide_path: String = String(map_def.get("collision_guide", ""))
	if guide_path == "" or not ResourceLoader.exists(guide_path):
		return
	var texture: Texture2D = load(guide_path)
	if texture == null:
		return
	var image: Image = texture.get_image()
	if image == null or image.is_empty():
		return
	collision_image = image
	collision_image_size = Vector2(image.get_width(), image.get_height())

func _clamp_to_map(position: Vector2) -> Vector2:
	return Vector2(
		clampf(position.x, 48.0, maxf(48.0, map_size.x - 48.0)),
		clampf(position.y, 84.0, maxf(84.0, map_size.y - 84.0))
	)

func _resolve_walkable_move(from_pos: Vector2, target_pos: Vector2) -> Vector2:
	if _is_walkable_position(target_pos):
		return target_pos
	var horizontal: Vector2 = _clamp_to_map(Vector2(target_pos.x, from_pos.y))
	if _is_walkable_position(horizontal):
		return horizontal
	var vertical: Vector2 = _clamp_to_map(Vector2(from_pos.x, target_pos.y))
	if _is_walkable_position(vertical):
		return vertical
	return from_pos

func _nearest_walkable_position(position: Vector2) -> Vector2:
	var clamped: Vector2 = _clamp_to_map(position)
	if _is_walkable_position(clamped):
		return clamped
	for radius in range(24, 961, 24):
		var samples: int = maxi(12, int(ceil(float(radius) / 12.0)))
		for index in range(samples):
			var angle: float = TAU * float(index) / float(samples)
			var candidate: Vector2 = _clamp_to_map(clamped + Vector2(cos(angle), sin(angle)) * float(radius))
			if _is_walkable_position(candidate):
				return candidate
	return clamped

func _movement_multiplier_at(position: Vector2) -> float:
	var luminance: float = _lowest_foot_luminance(position)
	if luminance < COLLISION_SLOW_LUMINANCE:
		return COLLISION_SLOW_MULTIPLIER
	return 1.0

func _is_walkable_position(position: Vector2) -> bool:
	return _lowest_foot_luminance(position) >= COLLISION_BLOCKED_LUMINANCE

func _lowest_foot_luminance(position: Vector2) -> float:
	if collision_image == null or collision_image_size.x <= 0.0 or collision_image_size.y <= 0.0:
		return 1.0
	var lowest: float = 1.0
	for raw_offset in FOOT_SAMPLE_OFFSETS:
		var offset: Vector2 = raw_offset
		lowest = minf(lowest, _collision_luminance(position + offset))
	return lowest

func _collision_luminance(position: Vector2) -> float:
	var sample_x: int = int(round(clampf(position.x / maxf(1.0, map_size.x), 0.0, 1.0) * (collision_image_size.x - 1.0)))
	var sample_y: int = int(round(clampf(position.y / maxf(1.0, map_size.y), 0.0, 1.0) * (collision_image_size.y - 1.0)))
	var color: Color = collision_image.get_pixel(sample_x, sample_y)
	return (color.r + color.g + color.b) / 3.0

func show_message(message: String) -> void:
	prompt_label.text = message

func show_story_choices(trigger: Dictionary, choices: Array, already_resolved: bool) -> void:
	_clear_choice_panel()
	choice_panel = PanelContainer.new()
	choice_panel.add_theme_stylebox_override("panel", _style_panel(Color(0.025, 0.030, 0.028, 0.94), Color(0.78, 0.56, 0.26, 0.95), 2))
	choice_panel.set_anchors_preset(Control.PRESET_CENTER)
	choice_panel.custom_minimum_size = Vector2(760, 440)
	choice_panel.offset_left = -380
	choice_panel.offset_right = 380
	choice_panel.offset_top = -220
	choice_panel.offset_bottom = 220
	overlay_layer.add_child(choice_panel)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_bottom", 18)
	choice_panel.add_child(margin)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	margin.add_child(box)
	var title := Label.new()
	title.text = String(trigger.get("title", "剧情地点"))
	title.add_theme_font_size_override("font_size", 28)
	title.add_theme_color_override("font_color", Color(0.92, 0.72, 0.42, 1.0))
	box.add_child(title)
	var body := Label.new()
	body.text = String(trigger.get("prompt", "此地因果正在显化。"))
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_theme_color_override("font_color", Color(0.82, 0.80, 0.72, 1.0))
	box.add_child(body)
	var chapter_id: String = String(trigger.get("chapter_id", ""))
	if already_resolved:
		box.add_child(_modal_label("这段剧情已经发生，无法再次改写。", Color(0.92, 0.46, 0.38, 1.0)))
	else:
		for raw_choice in choices:
			var choice: Dictionary = raw_choice
			var button := Button.new()
			button.text = "%s\n%s" % [String(choice.get("title", "抉择")), String(choice.get("body", ""))]
			button.custom_minimum_size = Vector2(0, 78)
			button.add_theme_color_override("font_color", Color(0.42, 0.92, 0.86, 1.0))
			button.pressed.connect(Callable(self, "_emit_story_choice").bind(String(trigger.get("id", "")), chapter_id, String(choice.get("id", ""))))
			box.add_child(button)
	var close := Button.new()
	close.text = "暂不介入"
	close.custom_minimum_size = Vector2(0, 46)
	close.pressed.connect(Callable(self, "_clear_choice_panel"))
	box.add_child(close)

func _emit_story_choice(trigger_id: String, chapter_id: String, choice_id: String) -> void:
	_clear_choice_panel()
	emit_signal("story_choice_requested", trigger_id, chapter_id, choice_id)

func _clear_choice_panel() -> void:
	if choice_panel != null:
		choice_panel.queue_free()
		choice_panel = null

func _modal_label(text: String, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", 18)
	return label

func _ellipse_points(radius_x: float, radius_y: float, steps: int) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i in range(steps):
		var angle: float = TAU * float(i) / float(steps)
		points.append(Vector2(cos(angle) * radius_x, sin(angle) * radius_y))
	return points

func _style_panel(color: Color, border: Color, width: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = border
	style.set_border_width_all(width)
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 4
	style.corner_radius_bottom_right = 4
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	return style

extends Node2D

const MapDefs := preload("res://scripts/data/map_defs.gd")

var map_id := "qingmao_outer"
var layer := "base"
var chunk_size := Vector2(2048, 1152)
var rows := 1
var cols := 1
var map_size := Vector2(2048, 1152)
var fallback_path := ""
var loaded_any_chunk := false

func setup(new_map_id: String, new_layer: String) -> void:
	map_id = new_map_id
	layer = new_layer
	for child in get_children():
		child.queue_free()
	var def: Dictionary = MapDefs.map_def(map_id)
	chunk_size = def.get("chunk_size", MapDefs.DEFAULT_CHUNK_SIZE)
	rows = int(def.get("rows", 1))
	cols = int(def.get("cols", 1))
	map_size = MapDefs.map_size(map_id)
	fallback_path = String(def.get("fallback_background", ""))
	loaded_any_chunk = false
	for row in range(rows):
		for col in range(cols):
			_add_chunk(row, col)
	if not loaded_any_chunk and layer == "base":
		_add_fallback_sprite()
	queue_redraw()

func _add_chunk(row: int, col: int) -> void:
	var path: String = MapDefs.chunk_path(map_id, layer, row, col)
	if path == "" or not ResourceLoader.exists(path):
		return
	var texture: Texture2D = load(path)
	if texture == null:
		return
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.centered = false
	sprite.position = Vector2(col * chunk_size.x, row * chunk_size.y)
	match layer:
		"foreground":
			sprite.z_index = row * 10 + col
		"light":
			sprite.z_index = 0
			sprite.modulate = Color(1.0, 1.0, 1.0, 0.46)
		_:
			sprite.z_index = 0
	add_child(sprite)
	loaded_any_chunk = true

func _add_fallback_sprite() -> void:
	if fallback_path == "" or not ResourceLoader.exists(fallback_path):
		return
	var texture: Texture2D = load(fallback_path)
	if texture == null:
		return
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.centered = true
	sprite.position = map_size * 0.5
	var tex_size: Vector2 = Vector2(texture.get_width(), texture.get_height())
	var scale_factor: float = max(map_size.x / max(1.0, tex_size.x), map_size.y / max(1.0, tex_size.y))
	sprite.scale = Vector2(scale_factor, scale_factor)
	sprite.z_index = 0
	sprite.modulate = Color(0.84, 0.84, 0.84, 0.96)
	add_child(sprite)

func _draw() -> void:
	if loaded_any_chunk or layer != "base":
		return
	for row in range(rows):
		for col in range(cols):
			var rect := Rect2(Vector2(col * chunk_size.x, row * chunk_size.y), chunk_size)
			var tint := Color(0.04 + 0.015 * float((row + col) % 2), 0.055, 0.052, 1.0)
			draw_rect(rect, tint, true)
			draw_rect(rect, Color(0.40, 0.30, 0.16, 0.40), false, 2.0)
			draw_line(rect.position + Vector2(80, rect.size.y * 0.75), rect.position + Vector2(rect.size.x - 80, rect.size.y * 0.30), Color(0.18, 0.32, 0.30, 0.45), 8.0)
			draw_circle(rect.position + rect.size * Vector2(0.5, 0.52), 90.0, Color(0.08, 0.25, 0.22, 0.36))

extends Control

const GameState := preload("res://scripts/game_state.gd")
const SaveService := preload("res://scripts/save_service.gd")
const WorldClock := preload("res://scripts/world_clock.gd")
const MarketService := preload("res://scripts/market_service.gd")
const RealmService := preload("res://scripts/realm_service.gd")
const SchoolLoadouts := preload("res://scripts/data/school_loadouts.gd")
const DungeonDefs := preload("res://scripts/data/dungeon_defs.gd")
const StoryService := preload("res://scripts/story_service.gd")
const DungeonService := preload("res://scripts/dungeon_service.gd")
const CombatService := preload("res://scripts/combat_service.gd")
const ApertureService := preload("res://scripts/aperture_service.gd")
const TribulationService := preload("res://scripts/tribulation_service.gd")
const CultivationService := preload("res://scripts/cultivation_service.gd")
const AscensionDefs := preload("res://scripts/data/ascension_defs.gd")

const COLOR_BG := Color(0.025, 0.03, 0.028, 1.0)
const COLOR_PANEL := Color(0.035, 0.040, 0.038, 0.46)
const COLOR_PANEL_ALT := Color(0.055, 0.052, 0.042, 0.38)
const COLOR_GOLD := Color(0.92, 0.72, 0.42, 1.0)
const COLOR_CYAN := Color(0.42, 0.88, 0.82, 1.0)
const COLOR_RED := Color(0.95, 0.28, 0.22, 1.0)
const COLOR_GREEN := Color(0.42, 0.85, 0.48, 1.0)

const RESOURCE_ICON_PATHS := {
	"lifespan": "res://assets/ui/icons/lifespan_hourglass.png",
	"immortal_stone": "res://assets/ui/icons/immortal_stone.png",
	"spirit_qi": "res://assets/ui/icons/spirit_qi.png",
	"intel": "res://assets/ui/icons/intel_scroll.png",
	"materials": "res://assets/ui/icons/material_bundle.png"
}

const GU_ICON_PATHS := {
	"sword_core": "res://assets/ui/gu/sword_core.png",
	"refine_core": "res://assets/ui/gu/refine_core.png",
	"enslave_core": "res://assets/ui/gu/enslave_core.png",
	"wisdom_core": "res://assets/ui/gu/wisdom_core.png",
	"luck_core": "res://assets/ui/gu/luck_core.png",
	"chase_plugin": "res://assets/ui/gu/chase_plugin.png",
	"split_plugin": "res://assets/ui/gu/split_plugin.png",
	"pierce_plugin": "res://assets/ui/gu/pierce_plugin.png",
	"stealth_plugin": "res://assets/ui/gu/stealth_plugin.png",
	"guard_plugin": "res://assets/ui/gu/guard_plugin.png",
	"taixu_immortal": "res://assets/ui/gu/taixu_immortal.png",
	"blood_sword": "res://assets/ui/gu/blood_sword.png"
}

const SCREEN_BACKGROUND_PATHS := {
	"aperture": "res://assets/backgrounds/aperture_map.png",
	"refining": "res://assets/backgrounds/refining_chamber.png",
	"cultivation": "res://assets/backgrounds/cultivation_retreat.png",
	"ascension": "res://assets/backgrounds/ascension_trial.png",
	"killer": "res://assets/backgrounds/refining_chamber.png",
	"market": "res://assets/backgrounds/market_baohuangtian.png",
	"npc": "res://assets/backgrounds/market_baohuangtian.png",
	"story": "res://assets/backgrounds/story_three_kings_mountain.png",
	"dungeon": "res://assets/backgrounds/story_three_kings_mountain.png",
	"dog_king": "res://assets/backgrounds/dungeons/dog_king_trial.png",
	"xin_king": "res://assets/backgrounds/dungeons/xin_king_trial.png",
	"bao_king": "res://assets/backgrounds/dungeons/bao_king_trial.png",
	"tribulation": "res://assets/backgrounds/tribulations/heavenly_tribulation_sky.png",
	"combat": "res://assets/backgrounds/battle_ruins.png"
}

const APERTURE_NODE_POSITIONS := {
	"仙窍核心": Vector2(0.50, 0.48),
	"灵泉": Vector2(0.67, 0.24),
	"药田": Vector2(0.24, 0.57),
	"虫巢": Vector2(0.72, 0.58),
	"矿脉": Vector2(0.38, 0.30)
}

const CHARACTER_IMAGE_PATHS := {
	"player_male": "res://assets/characters/player_male.png",
	"player_female": "res://assets/characters/player_female.png",
	"enemy": "res://assets/characters/enemy_cultivator.png",
	"npc_xuanwuzi": "res://assets/characters/npc_xuanwuzi.png"
}

const EFFECT_IMAGE_PATHS := {
	"sword_qi": "res://assets/effects/sword_qi.png",
	"refine_success": "res://assets/effects/refine_success.png",
	"backlash": "res://assets/effects/backlash.png"
}

const UI_SKIN_PATHS := {
	"panel": "res://assets/ui/skin/panel_dark_gold_9slice.png",
	"inner_panel": "res://assets/ui/skin/panel_inner_9slice.png",
	"header": "res://assets/ui/skin/header_plate_9slice.png",
	"button": "res://assets/ui/skin/button_default_9slice.png",
	"button_hover": "res://assets/ui/skin/button_hover_9slice.png",
	"button_active": "res://assets/ui/skin/button_active_9slice.png",
	"button_danger": "res://assets/ui/skin/button_danger_9slice.png",
	"resource_card": "res://assets/ui/skin/resource_card_9slice.png",
	"lifespan_bar": "res://assets/ui/skin/lifespan_bar_frame.png",
	"nav_tab": "res://assets/ui/skin/nav_tab_9slice.png",
	"corner": "res://assets/ui/skin/ornament_corner_gold.png",
	"divider": "res://assets/ui/skin/divider_gold.png",
	"noise": "res://assets/ui/skin/noise_scratches_overlay.png"
}

const KILLER_UI_PATHS := {
	"matrix_bg": "res://assets/ui/killer/matrix_bg.png",
	"core_slot": "res://assets/ui/killer/matrix_core_slot_frame.png",
	"plugin_slot": "res://assets/ui/killer/matrix_plugin_slot_frame.png",
	"empty_slot": "res://assets/ui/killer/matrix_empty_slot_frame.png",
	"slot_glow": "res://assets/ui/killer/matrix_slot_selected_glow.png",
	"connection_line": "res://assets/ui/killer/matrix_connection_line.png",
	"connection_arrow": "res://assets/ui/killer/matrix_connection_arrow.png",
	"gu_tile": "res://assets/ui/killer/gu_tile_default_9slice.png",
	"gu_tile_selected": "res://assets/ui/killer/gu_tile_selected_9slice.png",
	"gu_tile_locked": "res://assets/ui/killer/gu_tile_locked_9slice.png",
	"gu_info": "res://assets/ui/killer/gu_info_plate_9slice.png",
	"result_row": "res://assets/ui/killer/result_row_9slice.png",
	"diagnosis_ok": "res://assets/ui/killer/diagnosis_ok_9slice.png",
	"diagnosis_warning": "res://assets/ui/killer/diagnosis_warning_9slice.png",
	"diagnosis_danger": "res://assets/ui/killer/diagnosis_danger_9slice.png",
	"combat_preview": "res://assets/ui/killer/combat_preview_frame.png",
	"shortcut_bar": "res://assets/ui/killer/shortcut_bar_9slice.png",
	"action_save": "res://assets/ui/killer/action_bar_button_save.png",
	"action_default": "res://assets/ui/killer/action_bar_button_default.png"
}

const UI_ICON_PATHS := {
	"search": "res://assets/ui/icons/search_magnifier.png",
	"help": "res://assets/ui/icons/help_question.png",
	"settings": "res://assets/ui/icons/settings_gear.png",
	"plus": "res://assets/ui/icons/plus_square.png",
	"clear_matrix": "res://assets/ui/icons/clear_matrix.png",
	"attr_power": "res://assets/ui/icons/attr_power.png",
	"attr_spirit_cost": "res://assets/ui/icons/attr_spirit_cost.png",
	"attr_stability": "res://assets/ui/icons/attr_stability.png",
	"attr_range": "res://assets/ui/icons/attr_range.png",
	"attr_homing": "res://assets/ui/icons/attr_homing.png",
	"attr_risk": "res://assets/ui/icons/attr_risk.png",
	"warning_red": "res://assets/ui/icons/warning_red.png",
	"warning_yellow": "res://assets/ui/icons/warning_yellow.png",
	"info_blue": "res://assets/ui/icons/info_blue.png",
	"play_preview": "res://assets/ui/icons/play_preview.png"
}

const FONT_PATHS := {
	"title": "res://assets/fonts/title_calligraphy.ttf",
	"ui": "res://assets/fonts/ui_serif_cn.ttf"
}

const LOGO_PATHS := {
	"title": "res://assets/ui/logo/main_title_brush.png",
	"seal": "res://assets/ui/logo/red_seal.png"
}

const REFINING_UI_PATHS := {
	"cauldron_idle": "res://assets/ui/refining/cauldron_idle.png",
	"recipe_card": "res://assets/ui/refining/recipe_card_9slice.png"
}

const MARKET_UI_PATHS := {
	"post_card": "res://assets/ui/market/post_card_9slice.png"
}

const NPC_UI_PATHS := {
	"relation_bar": "res://assets/ui/npc/relation_bar_frame.png",
	"list_item": "res://assets/ui/npc/npc_list_item_default_9slice.png",
	"list_item_selected": "res://assets/ui/npc/npc_list_item_selected_9slice.png",
	"portrait_frame": "res://assets/ui/npc/npc_portrait_frame_9slice.png",
	"relation_track": "res://assets/ui/npc/relation_track_9slice.png",
	"relation_fill_cyan": "res://assets/ui/npc/relation_fill_cyan_9slice.png",
	"relation_fill_red": "res://assets/ui/npc/relation_fill_red_9slice.png"
}

const COMBAT_UI_PATHS := {
	"hotbar_slot": "res://assets/ui/combat/hotbar_slot_9slice.png"
}

const PROGRESS_UI_PATHS := {
	"track": "res://assets/ui/progress/progress_track_9slice.png",
	"fill_cyan": "res://assets/ui/progress/progress_fill_cyan_9slice.png",
	"fill_gold": "res://assets/ui/progress/progress_fill_gold_9slice.png",
	"fill_red": "res://assets/ui/progress/progress_fill_red_9slice.png",
	"thumb": "res://assets/ui/progress/progress_thumb_glow.png"
}

const HUD_UI_PATHS := {
	"lifespan_meter": "res://assets/ui/hud/lifespan_meter_track.png",
	"lifespan_tick": "res://assets/ui/hud/lifespan_stage_tick.png",
	"resource_icon_slot": "res://assets/ui/hud/resource_icon_slot.png",
	"resource_plus": "res://assets/ui/hud/resource_plus_button.png",
	"resource_value_plate": "res://assets/ui/hud/resource_value_plate_9slice.png",
	"settings_frame": "res://assets/ui/hud/settings_button_frame.png"
}

const APERTURE_UI_PATHS := {
	"metric_row": "res://assets/ui/aperture/aperture_metric_row_9slice.png",
	"node_marker_stable": "res://assets/ui/aperture/node_marker_stable_9slice.png",
	"node_marker_warning": "res://assets/ui/aperture/node_marker_warning_9slice.png",
	"node_marker_danger": "res://assets/ui/aperture/node_marker_danger_9slice.png",
	"node_beacon": "res://assets/ui/aperture/node_beacon_ring.png",
	"node_connector": "res://assets/ui/aperture/node_connector_line.png"
}

const LOG_UI_PATHS := {
	"item": "res://assets/ui/log/log_item_9slice.png"
}

const CHARACTER_SHEET_PATHS := {
	"player_male": "res://assets/characters/sheets/player_male_sheet.png",
	"player_female": "res://assets/characters/sheets/player_female_sheet.png",
	"enemy": "res://assets/characters/sheets/enemy_cultivator_sheet.png",
	"enemy_elite": "res://assets/characters/sheets/enemy_elite_sheet.png",
	"npc": "res://assets/characters/sheets/npc_cultivator_sheet.png",
	"summoned_soul": "res://assets/characters/sheets/summoned_soul_sheet.png",
	"dog_king_boss": "res://assets/characters/boss/dog_king_will_sheet.png",
	"xin_king_boss": "res://assets/characters/boss/xin_king_construct_sheet.png",
	"bao_king_boss": "res://assets/characters/boss/bao_king_flame_sheet.png"
}

const EFFECT_SHEET_PATHS := {
	"sword_qi": "res://assets/effects/sheets/sword_qi_projectile_sheet.png",
	"cast_charge": "res://assets/effects/sheets/cast_charge_sheet.png",
	"hit_spark": "res://assets/effects/sheets/hit_spark_sheet.png",
	"backlash": "res://assets/effects/sheets/backlash_burst_sheet.png",
	"fire_burst": "res://assets/effects/sheets/fire_burst_sheet.png",
	"beast_command": "res://assets/effects/sheets/beast_command_aura_sheet.png",
	"refine_seal": "res://assets/effects/sheets/refine_seal_sheet.png",
	"runtime_injection": "res://assets/effects/sheets/runtime_injection_sheet.png",
	"matrix_overload": "res://assets/effects/sheets/matrix_overload_sheet.png",
	"defense_barrier": "res://assets/effects/sheets/defense_barrier_sheet.png",
	"tribulation_lightning": "res://assets/effects/sheets/tribulation_lightning_sheet.png",
	"earth_fire_burst": "res://assets/effects/sheets/earth_fire_burst_sheet.png",
	"qi_collapse_wave": "res://assets/effects/sheets/qi_collapse_wave_sheet.png",
	"breakthrough_pulse": "res://assets/effects/sheets/breakthrough_pulse_sheet.png",
	"ascension_qi_surge": "res://assets/effects/sheets/ascension_qi_surge_sheet.png",
	"inner_demon": "res://assets/effects/sheets/inner_demon_sheet.png"
}

const STORY_UI_PATHS := {
	"chapter_card": "res://assets/ui/story/three_kings_chapter_card_9slice.png"
}

const DUNGEON_UI_PATHS := {
	"badge_normal": "res://assets/ui/dungeon/difficulty_badge_normal.png",
	"badge_danger": "res://assets/ui/dungeon/difficulty_badge_danger.png",
	"badge_desperate": "res://assets/ui/dungeon/difficulty_badge_desperate.png"
}

const TRIBULATION_UI_PATHS := {
	"pressure_gauge": "res://assets/ui/tribulation/pressure_gauge_frame.png",
	"disaster_card": "res://assets/ui/tribulation/disaster_card_9slice.png",
	"defense_slot": "res://assets/ui/tribulation/defense_script_slot_9slice.png",
	"history_item": "res://assets/ui/tribulation/tribulation_history_item_9slice.png"
}

const ECOLOGY_UI_PATHS := {
	"row": "res://assets/ui/ecology/gu_ecology_row_9slice.png",
	"food_chain": "res://assets/ui/ecology/gu_food_chain_connector.png",
	"status_badge": "res://assets/ui/ecology/gu_status_badge_9slice.png",
	"critical_icon": "res://assets/ui/ecology/critical_gu_badge.png"
}

const INJECTION_UI_PATHS := {
	"slot": "res://assets/ui/combat/injection_hotkey_slot_9slice.png",
	"panel": "res://assets/ui/combat/runtime_injection_panel_9slice.png",
	"overload": "res://assets/ui/combat/overload_warning_frame.png"
}

const CULTIVATION_UI_PATHS := {
	"rank_progress": "res://assets/ui/cultivation/rank_progress_frame_9slice.png",
	"stage_low": "res://assets/ui/cultivation/stage_badge_low.png",
	"stage_mid": "res://assets/ui/cultivation/stage_badge_mid.png",
	"stage_high": "res://assets/ui/cultivation/stage_badge_high.png",
	"stage_peak": "res://assets/ui/cultivation/stage_badge_peak.png",
	"breakthrough_card": "res://assets/ui/cultivation/breakthrough_card_9slice.png",
	"ascension_phase_card": "res://assets/ui/cultivation/ascension_phase_card_9slice.png"
}

const SPRITE_FRAME_SIZE := Vector2i(256, 256)
const SPRITE_FOOT_ANCHOR := Vector2(128, 198)
const SPRITE_ACTION_ROW_OFFSET := {
	"idle": 0,
	"walk": 8,
	"cast": 16,
	"hit": 24,
	"death": 32
}

var state
var current_screen := ""
var rng := RandomNumberGenerator.new()
var root_box: VBoxContainer
var texture_cache: Dictionary = {}
var font_cache: Dictionary = {}

var create_name := "顾无生"
var create_gender := "男"
var create_origin := "寒门子弟"
var create_talent := "散修"
var create_school := "剑道"

var selected_recipe := "taixu_immortal"
var refining_feedback_path := ""
var refining_feedback_text := "炉鼎待启"
var selected_core := "sword_core"
var selected_plugins := []
var selected_npc_id := "xuanwuzi"
var selected_market_post_id := ""
var selected_story_branch := "dog_king"
var selected_difficulty := "normal"

var battle_rect := Rect2(Vector2(350, 150), Vector2(1220, 690))
var combat_active := false
var combat_encounter := {}
var combat_player_pos := Vector2.ZERO
var combat_enemies := []
var combat_projectiles := []
var combat_effects := []
var combat_cooldown := 0.0
var combat_elapsed := 0.0
var combat_player_facing := Vector2.RIGHT
var combat_player_action := "idle"
var combat_player_action_time := 0.0
var combat_message := ""
var combat_logs := []
var combat_hp_bar: ProgressBar
var combat_cd_bar: ProgressBar
var combat_log_label: RichTextLabel
var combat_runtime_injections := []
var combat_injection_cooldown := 0.0
var combat_overload := 0.0

func _ready() -> void:
	randomize()
	rng.randomize()
	_ensure_input_actions()
	state = SaveService.load_game()
	if state.has_method("ensure_world_defaults"):
		state.ensure_world_defaults()
	StoryService.ensure_story_state(state)
	ApertureService.ensure_ecology_state(state)
	TribulationService.ensure_tribulation_state(state)
	CultivationService.ensure_cultivation_state(state)
	if state.created:
		_show_aperture()
	else:
		_show_create()

func _process(delta: float) -> void:
	if current_screen == "combat" and combat_active:
		_update_combat(delta)

func _draw() -> void:
	if current_screen != "combat":
		return
	_draw_combat_scene()

func _ensure_input_actions() -> void:
	_add_key_action("move_up", KEY_W)
	_add_key_action("move_down", KEY_S)
	_add_key_action("move_left", KEY_A)
	_add_key_action("move_right", KEY_D)
	_add_key_action("cast_1", KEY_1)
	_add_key_action("cast_1", KEY_SPACE)
	_add_key_action("inject_q", KEY_Q)
	_add_key_action("inject_e", KEY_E)
	_add_key_action("inject_r", KEY_R)

func _add_key_action(action: String, keycode: Key) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var has_key := false
	for event in InputMap.action_get_events(action):
		if event is InputEventKey and event.keycode == keycode:
			has_key = true
	if not has_key:
		var key := InputEventKey.new()
		key.keycode = keycode
		InputMap.action_add_event(action, key)

func _clear() -> void:
	for child in get_children():
		child.queue_free()
	current_screen = ""
	combat_active = false
	queue_redraw()

func _build_shell(title: String, reference_path: String, screen_id: String) -> VBoxContainer:
	_clear()
	current_screen = screen_id
	_add_scene_background(reference_path, screen_id)
	root_box = VBoxContainer.new()
	root_box.set_anchors_preset(Control.PRESET_FULL_RECT)
	root_box.add_theme_constant_override("separation", 10)
	root_box.offset_left = 18
	root_box.offset_top = 12
	root_box.offset_right = -18
	root_box.offset_bottom = -16
	add_child(root_box)
	_build_header(root_box, title)
	if state.created:
		_build_nav(root_box, screen_id)
	return root_box

func _add_scene_background(reference_path: String, screen_id: String) -> void:
	var base := ColorRect.new()
	base.color = COLOR_BG
	base.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(base)
	var path := String(SCREEN_BACKGROUND_PATHS.get(screen_id, reference_path))
	var has_real_background := SCREEN_BACKGROUND_PATHS.has(screen_id) and ResourceLoader.exists(path)
	if path == "":
		return
	var texture = load(path)
	if texture == null:
		return
	var bg := TextureRect.new()
	bg.texture = texture
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.modulate = Color(0.92, 0.92, 0.92, 1.0) if has_real_background else Color(0.18, 0.18, 0.18, 0.26)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var shade := ColorRect.new()
	shade.color = Color(0.0, 0.0, 0.0, 0.06) if has_real_background else Color(0.0, 0.0, 0.0, 0.64)
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(shade)
	var noise_texture: Texture2D = _get_texture(String(UI_SKIN_PATHS["noise"]))
	if noise_texture != null:
		var noise := TextureRect.new()
		noise.texture = noise_texture
		noise.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		noise.stretch_mode = TextureRect.STRETCH_TILE
		noise.modulate = Color(1.0, 1.0, 1.0, 0.08)
		noise.set_anchors_preset(Control.PRESET_FULL_RECT)
		add_child(noise)

func _build_header(parent: Control, title: String) -> void:
	var header := HBoxContainer.new()
	header.custom_minimum_size = Vector2(0, 82)
	header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_theme_constant_override("separation", 8)
	parent.add_child(header)

	var title_panel := _panel_container(Vector2(410, 74), String(UI_SKIN_PATHS["header"]))
	header.add_child(title_panel)
	var title_box := _panel_body(title_panel)
	var title_row := HBoxContainer.new()
	title_row.add_theme_constant_override("separation", 6)
	title_box.add_child(title_row)
	var logo_texture: Texture2D = _get_texture(String(LOGO_PATHS["title"]))
	if logo_texture != null:
		var logo_image := TextureRect.new()
		logo_image.texture = logo_texture
		logo_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		logo_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		logo_image.custom_minimum_size = Vector2(270, 38)
		logo_image.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		title_row.add_child(logo_image)
	else:
		var logo := Label.new()
		logo.text = "蛊真：大道唯我"
		logo.add_theme_font_size_override("font_size", 34)
		logo.add_theme_color_override("font_color", COLOR_GOLD)
		_apply_font(logo, true)
		title_row.add_child(logo)
	var seal_texture: Texture2D = _get_texture(String(LOGO_PATHS["seal"]))
	if seal_texture != null:
		var seal := TextureRect.new()
		seal.texture = seal_texture
		seal.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		seal.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		seal.custom_minimum_size = Vector2(38, 42)
		title_row.add_child(seal)
	var subtitle := Label.new()
	subtitle.text = title
	subtitle.add_theme_color_override("font_color", COLOR_CYAN)
	_apply_font(subtitle)
	title_box.add_child(subtitle)

	var life_panel := _panel_container(Vector2(540, 74), String(UI_SKIN_PATHS["lifespan_bar"]), 0)
	header.add_child(life_panel)
	var life_canvas := Control.new()
	life_canvas.custom_minimum_size = Vector2(540, 74)
	life_panel.add_child(life_canvas)
	var meter := _texture_rect(String(HUD_UI_PATHS["lifespan_meter"]), TextureRect.STRETCH_SCALE)
	_place_control(life_canvas, meter, Vector2(0.58, 0.67), Vector2(400, 30))
	for i in range(7):
		var tick := _texture_rect(String(HUD_UI_PATHS["lifespan_tick"]), TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
		var tick_x := 0.25 + float(i) * 0.095
		_place_control(life_canvas, tick, Vector2(tick_x, 0.66), Vector2(20, 20))
	var life_icon := _texture_rect(String(RESOURCE_ICON_PATHS["lifespan"]), TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	_place_control(life_canvas, life_icon, Vector2(0.12, 0.52), Vector2(48, 48))
	var life := Label.new()
	life.text = "寿元  %s    境界  %s" % [state.format_lifespan(), state.get_realm_name()]
	life.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	life.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	life.add_theme_font_size_override("font_size", 22)
	life.add_theme_color_override("font_color", COLOR_GOLD)
	_apply_font(life)
	_place_control(life_canvas, life, Vector2(0.58, 0.36), Vector2(360, 34))
	var max_lifespan := 73 * 360 + 147
	var current_lifespan := int(state.character.get("lifespan_days", 0))
	var life_bar := _texture_progress_bar(float(current_lifespan), float(max_lifespan), String(PROGRESS_UI_PATHS["fill_cyan"]), String(PROGRESS_UI_PATHS["track"]), Vector2(362, 12), 16)
	_place_control(life_canvas, life_bar, Vector2(0.58, 0.67), Vector2(362, 12))
	var life_ratio: float = clampf(float(current_lifespan) / max(1.0, float(max_lifespan)), 0.0, 1.0)
	var thumb := _texture_rect(String(PROGRESS_UI_PATHS["thumb"]), TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	_place_control(life_canvas, thumb, Vector2(0.245 + 0.670 * life_ratio, 0.67), Vector2(24, 24))
	var cultivation_status: Dictionary = CultivationService.cultivation_status(state)
	var rank_bar := _texture_progress_bar(float(cultivation_status.get("progress", 0)), 100.0, String(PROGRESS_UI_PATHS["fill_gold"]), String(PROGRESS_UI_PATHS["track"]), Vector2(310, 8), 14)
	_place_control(life_canvas, rank_bar, Vector2(0.58, 0.88), Vector2(310, 8))
	var rank_caption := Label.new()
	rank_caption.text = "突破 %d%%" % int(cultivation_status.get("progress", 0))
	rank_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	rank_caption.add_theme_font_size_override("font_size", 12)
	rank_caption.add_theme_color_override("font_color", Color(0.88, 0.78, 0.55, 0.95))
	_apply_font(rank_caption)
	_place_control(life_canvas, rank_caption, Vector2(0.88, 0.88), Vector2(80, 18))

	header.add_child(_resource_chip("仙元石", "immortal_stone"))
	header.add_child(_resource_chip("灵气", "spirit_qi"))
	header.add_child(_resource_chip("情报值", "intel"))
	header.add_child(_resource_chip("材料", "materials"))

func _resource_chip(label_text: String, id: String) -> PanelContainer:
	var panel := _panel_container(Vector2(205, 74), String(UI_SKIN_PATHS["resource_card"]), 0)
	var canvas := Control.new()
	canvas.custom_minimum_size = Vector2(205, 74)
	panel.add_child(canvas)
	var path := String(RESOURCE_ICON_PATHS.get(id, ""))
	var icon_slot := _texture_rect(String(HUD_UI_PATHS["resource_icon_slot"]), TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	_place_control(canvas, icon_slot, Vector2(0.24, 0.50), Vector2(68, 68))
	var icon := _texture_rect(path, TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	_place_control(canvas, icon, Vector2(0.24, 0.50), Vector2(54, 54))
	var value_plate := _texture_rect(String(HUD_UI_PATHS["resource_value_plate"]), TextureRect.STRETCH_SCALE)
	_place_control(canvas, value_plate, Vector2(0.64, 0.66), Vector2(88, 32))
	var plus := _texture_rect(String(HUD_UI_PATHS["resource_plus"]), TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	_place_control(canvas, plus, Vector2(0.90, 0.53), Vector2(30, 30))
	var label := Label.new()
	label.text = label_text
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", COLOR_CYAN)
	_apply_font(label)
	_place_control(canvas, label, Vector2(0.62, 0.31), Vector2(86, 24))
	var value := Label.new()
	value.text = _format_number(state.get_resource(id))
	value.add_theme_font_size_override("font_size", 20)
	value.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	value.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	value.add_theme_color_override("font_color", COLOR_GOLD)
	_apply_font(value)
	_place_control(canvas, value, Vector2(0.63, 0.64), Vector2(88, 30))
	return panel

func _build_nav(parent: VBoxContainer, active: String) -> void:
	var nav := HBoxContainer.new()
	nav.custom_minimum_size = Vector2(0, 48)
	nav.add_theme_constant_override("separation", 8)
	parent.add_child(nav)
	nav.add_child(_nav_button("仙窍", Callable(self, "_show_aperture"), active == "aperture"))
	nav.add_child(_nav_button("修行", Callable(self, "_show_cultivation"), active == "cultivation"))
	nav.add_child(_nav_button("炼蛊", Callable(self, "_show_refining"), active == "refining"))
	nav.add_child(_nav_button("杀招", Callable(self, "_show_killer_move"), active == "killer"))
	nav.add_child(_nav_button("宝黄天", Callable(self, "_show_market"), active == "market"))
	nav.add_child(_nav_button("NPC", Callable(self, "_show_npc"), active == "npc"))
	nav.add_child(_nav_button("剧情", Callable(self, "_show_story"), active == "story" or active == "dungeon"))
	nav.add_child(_nav_button("战斗", Callable(self, "_start_combat"), active == "combat"))
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nav.add_child(spacer)
	nav.add_child(_icon_nav_button("settings", Callable(self, "_noop")))
	nav.add_child(_nav_button("保存", Callable(self, "_save_and_log")))
	nav.add_child(_nav_button("新生", Callable(self, "_reset_to_create")))

func _noop() -> void:
	pass

func _show_create() -> void:
	state.created = false
	var shell := _build_shell("创建角色", "res://assets/reference/character_create.png", "create")
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 14)
	shell.add_child(body)

	var left := _add_panel(body, "角色信息", Vector2(560, 0))
	var name_edit := LineEdit.new()
	name_edit.text = create_name
	name_edit.placeholder_text = "输入姓名"
	name_edit.text_changed.connect(_on_create_name_changed)
	left.add_child(_labeled_control("姓名", name_edit))
	left.add_child(_section_label("性别"))
	var gender_row := HBoxContainer.new()
	gender_row.add_child(_choice_button("男", create_gender == "男", Callable(self, "_set_create_gender").bind("男")))
	gender_row.add_child(_choice_button("女", create_gender == "女", Callable(self, "_set_create_gender").bind("女")))
	left.add_child(gender_row)
	left.add_child(_section_label("出身"))
	for origin in ["寒门子弟", "世家嫡系", "流浪孤儿", "宗门弃徒", "蛊虫转世"]:
		left.add_child(_choice_button(origin, create_origin == origin, Callable(self, "_set_create_origin").bind(origin)))

	var center := _add_panel(body, "大道独行", Vector2(560, 0))
	var portrait := _image_or_placeholder(_character_image_path(), "角色立绘占位", Color(0.12, 0.16, 0.15, 0.92), Vector2(0, 520))
	center.add_child(portrait)
	var quote := Label.new()
	quote.text = "天地不仁，以万物为刍狗。\n大道无情，唯我独行。"
	quote.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	quote.add_theme_font_size_override("font_size", 24)
	quote.add_theme_color_override("font_color", COLOR_GOLD)
	center.add_child(quote)

	var right := _add_panel(body, "初始道痕与天赋", Vector2(650, 0))
	right.add_child(_section_label("主修流派"))
	var school_grid := GridContainer.new()
	school_grid.columns = 2
	school_grid.add_theme_constant_override("h_separation", 8)
	school_grid.add_theme_constant_override("v_separation", 8)
	right.add_child(school_grid)
	for school in GameState.DAO_SCHOOLS:
		school_grid.add_child(_school_choice_control(school))
	right.add_child(_section_label("开局天赋"))
	for talent in ["散修", "魔道", "商贸背景", "情报天赋"]:
		right.add_child(_choice_button(talent, create_talent == talent, Callable(self, "_set_create_talent").bind(talent)))
	right.add_child(_section_label("开局蛊虫"))
	var loadout: Dictionary = SchoolLoadouts.loadout_for(create_school)
	right.add_child(_dialogue_line(create_school, String(loadout.get("description", ""))))
	var inventory: Dictionary = loadout.get("inventory", {})
	for gu_id in inventory.keys():
		var gu_def: Dictionary = GameState.GU_DEFINITIONS.get(String(gu_id), {})
		right.add_child(_icon_text_line(String(gu_def.get("name", gu_id)), "x%d" % int(inventory[gu_id]), "plus"))
	var enter := _button("进入五域", Callable(self, "_enter_world"))
	enter.custom_minimum_size = Vector2(0, 86)
	enter.add_theme_font_size_override("font_size", 34)
	right.add_child(enter)

func _on_create_name_changed(text: String) -> void:
	create_name = text

func _set_create_gender(value: String) -> void:
	create_gender = value
	_show_create()

func _set_create_origin(value: String) -> void:
	create_origin = value
	_show_create()

func _set_create_talent(value: String) -> void:
	create_talent = value
	_show_create()

func _set_create_school(value: String) -> void:
	create_school = value
	_show_create()

func _enter_world() -> void:
	state.setup_new_character(create_name, create_gender, create_origin, create_talent, create_school)
	selected_core = SchoolLoadouts.default_core_for_school(create_school)
	selected_plugins = SchoolLoadouts.default_plugins_for_school(create_school)
	var default_move: Dictionary = SchoolLoadouts.default_move_for_school(state, create_school)
	state.add_killer_move(default_move)
	StoryService.ensure_story_state(state)
	ApertureService.ensure_ecology_state(state)
	TribulationService.ensure_tribulation_state(state)
	CultivationService.ensure_cultivation_state(state)
	SaveService.save_game(state)
	_show_aperture()

func _show_aperture() -> void:
	ApertureService.ensure_ecology_state(state)
	TribulationService.ensure_tribulation_state(state)
	var shell := _build_shell("仙窍总览", "res://assets/reference/aperture.png", "aperture")
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	shell.add_child(body)

	var left := _add_panel(body, "仙窍监控", Vector2(520, 0))
	var tribulation_summary: Dictionary = TribulationService.state_summary(state)
	left.add_child(_aperture_metric("天地二气平衡度", int(state.aperture.get("qi_balance", 0)), COLOR_CYAN))
	left.add_child(_aperture_metric("道痕互斥率", int(state.aperture.get("conflict_rate", 0)), COLOR_GOLD))
	left.add_child(_aperture_metric("蛊虫饱食度", int(state.aperture.get("food_saturation", 0)), COLOR_RED if int(state.aperture.get("food_saturation", 0)) < 50 else COLOR_GREEN))
	left.add_child(_aperture_metric("生态稳定性", int(state.aperture.get("stability", 0)), COLOR_GREEN))
	left.add_child(_aperture_metric("灾劫压力", int(tribulation_summary.get("pressure", 0)), COLOR_RED if int(tribulation_summary.get("pressure", 0)) > 72 else COLOR_GOLD))
	left.add_child(_text_line("仙元石净产出", "+%d/月" % int(state.aperture.get("stone_delta", 0))))
	left.add_child(_text_line("世界刻", "第 %d 月" % int(state.world_month)))
	left.add_child(_text_line("下次压测", "已锁定" if bool(tribulation_summary.get("active", false)) else "%d 月后" % int(tribulation_summary.get("months_left", 0))))
	left.add_child(_button("闭关修行（推进3月）", Callable(self, "_cultivation_retreat")))
	left.add_child(_button("冲击小阶", Callable(self, "_try_breakthrough")))
	left.add_child(_button("准备升仙", Callable(self, "_prepare_ascension")))
	left.add_child(_button("升仙试炼", Callable(self, "_resolve_ascension_phase")))
	left.add_child(_button("调度资源（推进1月）", Callable(self, "_advance_one_month")))
	left.add_child(_button("扩容节点", Callable(self, "_expand_node")))
	left.add_child(_button("修复生态", Callable(self, "_repair_aperture")))
	left.add_child(_button("补链最弱蛊虫", Callable(self, "_repair_worst_gu")))
	left.add_child(_button("准备防御脚本", Callable(self, "_prepare_tribulation_defense")))
	left.add_child(_button("提前渡劫压测", Callable(self, "_resolve_tribulation_now")))

	var center := _add_panel(body, "节点拓扑", Vector2(760, 0))
	center.add_child(_aperture_node_map(state.aperture.get("nodes", [])))
	center.add_child(_section_label("蛊虫生态链"))
	center.add_child(_gu_ecology_list())
	var loop_hint := Label.new()
	loop_hint.text = "玩法闭环：经营仙窍 → 炼蛊 → 编译杀招 → 战斗博弈 → 奖励回流。"
	loop_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	loop_hint.add_theme_color_override("font_color", COLOR_GOLD)
	center.add_child(loop_hint)

	var right := _add_panel(body, "告警中心 / 日志", Vector2(560, 0))
	var warnings: Array = state.get_warnings()
	if warnings.is_empty():
		right.add_child(_text_line("状态", "暂无严重告警"))
	else:
		for warning in warnings:
			right.add_child(_warning_line(warning))
	right.add_child(_section_label("灾劫"))
	right.add_child(_text_line("当前灾劫", String(tribulation_summary.get("name", "未锁定"))))
	right.add_child(_text_line("目标节点", String(tribulation_summary.get("target", "未知"))))
	right.add_child(_dialogue_line("压测说明", String(tribulation_summary.get("description", ""))))
	right.add_child(_section_label("最近事件"))
	right.add_child(_log_view(state.logs, 10))

func _advance_one_month() -> void:
	WorldClock.advance_months(state, 1, "调度资源")
	SaveService.save_game(state)
	_show_aperture()

func _expand_node() -> void:
	WorldClock.expand_node(state)
	SaveService.save_game(state)
	_show_aperture()

func _repair_aperture() -> void:
	WorldClock.repair_aperture(state)
	SaveService.save_game(state)
	_show_aperture()

func _repair_worst_gu() -> void:
	ApertureService.repair_worst_gu(state)
	SaveService.save_game(state)
	_show_aperture()

func _prepare_tribulation_defense() -> void:
	if state.defense_scripts.is_empty():
		state.add_defense_script(state.get_active_killer_move())
	TribulationService.prepare_defense(state)
	SaveService.save_game(state)
	_show_aperture()

func _resolve_tribulation_now() -> void:
	var result: Dictionary = TribulationService.resolve(state, true)
	if not bool(result.get("resolved", false)):
		state.add_log(String(result.get("text", "暂无灾劫可处理。")))
	SaveService.save_game(state)
	_show_aperture()

func _show_cultivation() -> void:
	CultivationService.ensure_cultivation_state(state)
	var status: Dictionary = CultivationService.cultivation_status(state)
	var shell := _build_shell("修行 / 升仙", "res://assets/reference/ascension.png", "cultivation")
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	shell.add_child(body)

	var left := _add_panel(body, "修行状态", Vector2(520, 0))
	left.add_child(_image_or_placeholder(String(SCREEN_BACKGROUND_PATHS["cultivation"]), "闭关洞府", Color(0.08, 0.07, 0.055, 0.58), Vector2(0, 150)))
	left.add_child(_text_line("当前境界", String(status.get("realm", state.get_realm_name()))))
	left.add_child(_cultivation_progress_card(status))
	left.add_child(_aperture_metric("瓶颈压力", int(status.get("bottleneck", 0)), COLOR_RED if int(status.get("bottleneck", 0)) > 60 else COLOR_GOLD))
	left.add_child(_text_line("突破成功率", "%d%%" % int(status.get("breakthrough_chance", 0))))
	left.add_child(_section_label("突破材料"))
	var costs: Dictionary = AscensionDefs.breakthrough_cost(int(status.get("rank", 1)), int(status.get("stage", 0)))
	for cost_id in costs.keys():
		left.add_child(_text_line(_resource_name(String(cost_id)), "%d / %d" % [state.get_resource(String(cost_id)), int(costs[cost_id])]))
	left.add_child(_button("闭关修行（推进3月）", Callable(self, "_cultivation_retreat"), true))
	left.add_child(_button("冲击小阶", Callable(self, "_try_breakthrough")))

	var center := _add_panel(body, "升仙试炼", Vector2(760, 0))
	center.add_child(_image_or_placeholder(String(SCREEN_BACKGROUND_PATHS["ascension"]), "升仙试炼", Color(0.05, 0.05, 0.06, 0.70), Vector2(0, 180)))
	var ascension: Dictionary = status.get("ascension", {})
	center.add_child(_text_line("试炼状态", _ascension_status_name(String(ascension.get("status", "idle")))))
	center.add_child(_text_line("升仙资格", "五转巅峰已具备" if bool(status.get("can_ascend", false)) else "尚需修至五转巅峰"))
	center.add_child(_section_label("三段试炼"))
	for phase_data in ascension.get("phases", []):
		center.add_child(_ascension_phase_card(phase_data))
	var ascension_row := HBoxContainer.new()
	ascension_row.add_theme_constant_override("separation", 10)
	center.add_child(ascension_row)
	ascension_row.add_child(_button("准备升仙", Callable(self, "_prepare_ascension"), bool(status.get("can_ascend", false))))
	ascension_row.add_child(_button("推进试炼阶段", Callable(self, "_resolve_ascension_phase")))

	var right := _add_panel(body, "突破记录 / 风险诊断", Vector2(560, 0))
	right.add_child(_section_label("风险诊断"))
	if int(status.get("rank", 1)) >= 6:
		right.add_child(_dialogue_line("道心", "你已成六转蛊仙，七转以上将在后续阶段展开。"))
	elif bool(status.get("can_ascend", false)):
		right.add_child(_warning_line("五转巅峰：下一步是升仙试炼，失败会伤寿元与仙窍。"))
	elif int(status.get("progress", 0)) >= 100:
		right.add_child(_dialogue_line("瓶颈", "修为已足，可尝试冲击小阶。"))
	else:
		right.add_child(_dialogue_line("修行", "闭关、战斗和经营都会积累修为，但寿元不可逆。"))
	right.add_child(_text_line("天地二气", "%d%%" % int(state.aperture.get("qi_balance", 0))))
	right.add_child(_text_line("仙窍稳定", "%d%%" % int(state.aperture.get("stability", 0))))
	right.add_child(_text_line("道痕互斥", "%d%%" % int(state.aperture.get("conflict_rate", 0))))
	right.add_child(_section_label("突破历史"))
	right.add_child(_breakthrough_history_view(status.get("history", [])))
	right.add_child(_section_label("最近事件"))
	right.add_child(_log_view(state.logs, 7))
	SaveService.save_game(state)

func _cultivation_retreat() -> void:
	var result: Dictionary = CultivationService.retreat(state, 3)
	if bool(result.get("ok", false)):
		WorldClock.advance_months(state, 3, "闭关修行")
	SaveService.save_game(state)
	_show_cultivation()

func _try_breakthrough() -> void:
	CultivationService.try_breakthrough(state)
	SaveService.save_game(state)
	_show_cultivation()

func _prepare_ascension() -> void:
	CultivationService.prepare_ascension(state)
	SaveService.save_game(state)
	_show_cultivation()

func _resolve_ascension_phase() -> void:
	CultivationService.resolve_next_ascension_phase(state)
	SaveService.save_game(state)
	_show_cultivation()

func _cultivation_progress_card(status: Dictionary) -> PanelContainer:
	var panel := _panel_container(Vector2(0, 128), String(CULTIVATION_UI_PATHS["rank_progress"]), 8)
	var box := _panel_body(panel)
	var title := Label.new()
	title.text = "%s  %d / %d 修为" % [String(status.get("stage_name", "")), int(status.get("exp", 0)), int(status.get("threshold", 0))]
	title.add_theme_color_override("font_color", COLOR_GOLD)
	_apply_font(title, true)
	box.add_child(title)
	var bar := _texture_progress_bar(float(status.get("progress", 0)), 100.0, String(PROGRESS_UI_PATHS["fill_gold"]), String(PROGRESS_UI_PATHS["track"]), Vector2(0, 16), 16)
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(bar)
	var badge_path: String = String(CULTIVATION_UI_PATHS.get("stage_%s" % String(status.get("stage_id", "low")), ""))
	box.add_child(_image_or_placeholder(badge_path, String(status.get("stage_name", "小阶")), Color(0.08, 0.07, 0.05, 0.42), Vector2(0, 42)))
	return panel

func _ascension_phase_card(phase_data) -> PanelContainer:
	var phase: Dictionary = phase_data if typeof(phase_data) == TYPE_DICTIONARY else {}
	var status_text := String(phase.get("status", "pending"))
	var color := COLOR_CYAN
	if status_text == "failed":
		color = COLOR_RED
	elif status_text == "success":
		color = COLOR_GREEN
	var panel := _panel_container(Vector2(0, 118), String(CULTIVATION_UI_PATHS["ascension_phase_card"]), 8)
	var box := _panel_body(panel)
	box.add_child(_text_line(String(phase.get("name", "试炼阶段")), _ascension_phase_status(status_text)))
	var desc := Label.new()
	desc.text = String(phase.get("description", ""))
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.add_theme_color_override("font_color", Color(0.82, 0.78, 0.66, 1.0))
	_apply_font(desc)
	box.add_child(desc)
	var score_line := Label.new()
	score_line.text = "难度 %d / 评分 %d" % [int(phase.get("difficulty", 0)), int(phase.get("score", 0))]
	score_line.add_theme_color_override("font_color", color)
	_apply_font(score_line)
	box.add_child(score_line)
	return panel

func _breakthrough_history_view(history_value) -> Control:
	var history: Array = history_value if typeof(history_value) == TYPE_ARRAY else []
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(0, 220)
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	scroll.add_child(box)
	if history.is_empty():
		box.add_child(_text_line("记录", "暂无突破记录"))
		return scroll
	for i in range(min(6, history.size())):
		var item: Dictionary = history[i]
		box.add_child(_dialogue_line("第%d月" % int(item.get("month", 0)), String(item.get("text", ""))))
	return scroll

func _ascension_status_name(status_text: String) -> String:
	match status_text:
		"active":
			return "试炼中"
		"complete":
			return "已升仙"
		"failed":
			return "上次失败"
	return "未开启"

func _ascension_phase_status(status_text: String) -> String:
	match status_text:
		"success":
			return "通过"
		"failed":
			return "失败"
	return "待试炼"

func _show_story() -> void:
	StoryService.ensure_story_state(state)
	StoryService.mark_intro_seen(state)
	var shell := _build_shell("三王山传承", "res://assets/reference/killer_move.png", "story")
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	shell.add_child(body)

	var left := _add_panel(body, "剧情线索", Vector2(520, 0))
	left.add_child(_image_or_placeholder(String(SCREEN_BACKGROUND_PATHS["story"]), "三王山远景", Color(0.08, 0.07, 0.055, 0.55), Vector2(0, 190)))
	left.add_child(_dialogue_line("南疆传闻", "三叉山旧地忽现三道传承光柱，犬王、信王、爆王残念各守一线。"))
	left.add_child(_dialogue_line("你的判断", "此地不只争传承，也争情报、声名与退路。选择会在暗处改变他人对你的评判。"))
	left.add_child(_section_label("难度"))
	for difficulty_id in DungeonDefs.difficulty_ids():
		left.add_child(_difficulty_button(String(difficulty_id)))

	var center := _add_panel(body, "三王传承", Vector2(780, 0))
	for branch_id in DungeonDefs.branch_ids():
		center.add_child(_branch_choice_card(String(branch_id)))
	var start_button := _button("进入传承", Callable(self, "_start_story_dungeon"), true)
	start_button.custom_minimum_size = Vector2(0, 72)
	center.add_child(start_button)

	var right := _add_panel(body, "副本记录", Vector2(560, 0))
	right.add_child(_text_line("章节进度", "%d / 3" % StoryService.chapter_completion(state)))
	var selected_branch: Dictionary = DungeonDefs.branch(selected_story_branch)
	right.add_child(_section_label(String(selected_branch.get("name", "传承"))))
	right.add_child(_text_line("流派", String(selected_branch.get("school", "未知"))))
	right.add_child(_text_line("试炼", String(selected_branch.get("subtitle", "未知"))))
	right.add_child(_text_line("难度", DungeonDefs.difficulty_name(selected_difficulty)))
	right.add_child(_dialogue_line("残念低语", String(selected_branch.get("intro", ""))))
	var progress: Dictionary = state.dungeon_progress.get(selected_story_branch, {})
	right.add_child(_text_line("尝试", "%d 次" % int(progress.get("attempts", 0))))
	right.add_child(_text_line("胜利", "%d 次" % int(progress.get("victories", 0))))
	right.add_child(_text_line("最高难度", _difficulty_display(String(progress.get("best_difficulty", "")))))
	right.add_child(_section_label("最近事件"))
	right.add_child(_log_view(state.logs, 8))
	SaveService.save_game(state)

func _difficulty_button(difficulty_id: String) -> Button:
	var label := DungeonDefs.difficulty_name(difficulty_id)
	var button := _choice_button(label, selected_difficulty == difficulty_id, Callable(self, "_set_story_difficulty").bind(difficulty_id))
	var badge_key := "badge_%s" % difficulty_id
	var badge_path := String(DUNGEON_UI_PATHS.get(badge_key, ""))
	var badge: Texture2D = _get_texture(badge_path)
	if badge != null:
		button.icon = badge
		button.expand_icon = true
	return button

func _branch_choice_card(branch_id: String) -> PanelContainer:
	var branch: Dictionary = DungeonDefs.branch(branch_id)
	var selected := selected_story_branch == branch_id
	var skin_path := String(STORY_UI_PATHS["chapter_card"])
	if not ResourceLoader.exists(skin_path):
		skin_path = String(UI_SKIN_PATHS["inner_panel"])
	var panel := _panel_container(Vector2(0, 150), skin_path, 12)
	var box := _panel_body(panel)
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 10)
	box.add_child(top)
	var button := _choice_button(String(branch.get("name", branch_id)), selected, Callable(self, "_set_story_branch").bind(branch_id))
	button.custom_minimum_size = Vector2(220, 58)
	top.add_child(button)
	var info := VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(info)
	info.add_child(_text_line("流派", String(branch.get("school", "未知"))))
	info.add_child(_text_line("试炼", String(branch.get("subtitle", "未知"))))
	var progress: Dictionary = state.dungeon_progress.get(branch_id, {})
	info.add_child(_text_line("记录", "胜利 %d / 最高 %s" % [int(progress.get("victories", 0)), _difficulty_display(String(progress.get("best_difficulty", "")))]))
	var intro := Label.new()
	intro.text = String(branch.get("intro", ""))
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.add_theme_color_override("font_color", COLOR_CYAN if selected else Color(0.82, 0.78, 0.66, 1.0))
	_apply_font(intro)
	box.add_child(intro)
	return panel

func _set_story_branch(branch_id: String) -> void:
	selected_story_branch = branch_id
	_show_story()

func _set_story_difficulty(difficulty_id: String) -> void:
	selected_difficulty = difficulty_id
	_show_story()

func _start_story_dungeon() -> void:
	var encounter: Dictionary = DungeonService.start_branch(state, selected_story_branch, selected_difficulty)
	SaveService.save_game(state)
	_start_combat(encounter)

func _difficulty_display(difficulty_id: String) -> String:
	if difficulty_id == "":
		return "未通关"
	return DungeonDefs.difficulty_name(difficulty_id)

func _show_refining() -> void:
	var shell := _build_shell("仙蛊炼制", "res://assets/reference/gu_refining.png", "refining")
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	shell.add_child(body)

	var left := _add_panel(body, "炼制配方", Vector2(520, 0))
	for recipe_id in GameState.REFINE_RECIPES.keys():
		var recipe: Dictionary = GameState.REFINE_RECIPES[recipe_id]
		left.add_child(_recipe_choice_button(String(recipe_id), recipe, selected_recipe == recipe_id, Callable(self, "_set_recipe").bind(recipe_id)))

	var recipe: Dictionary = GameState.REFINE_RECIPES[selected_recipe]
	var result_id := String(recipe["result"])
	var result_def: Dictionary = GameState.GU_DEFINITIONS[result_id]
	var center := _add_panel(body, "炉鼎推演", Vector2(760, 0))
	center.add_child(_text_line("目标", "%s / %s / %s" % [result_def["name"], result_def["grade"], result_def["school"]]))
	var unique_note: String = "已被占有，继续炼制必反噬" if bool(result_def.get("unique", false)) and state.unique_gu.has(result_id) else "可尝试炼制"
	center.add_child(_warning_line(unique_note) if unique_note.begins_with("已") else _text_line("唯一性校验", unique_note))
	var refine_button := _button("开始炼制", Callable(self, "_try_refine"))
	refine_button.custom_minimum_size = Vector2(0, 64)
	center.add_child(refine_button)
	if refining_feedback_path == "":
		center.add_child(_image_or_placeholder(String(REFINING_UI_PATHS["cauldron_idle"]), refining_feedback_text, Color(0.08, 0.07, 0.045, 0.62), Vector2(0, 150)))
	else:
		center.add_child(_image_or_placeholder(refining_feedback_path, refining_feedback_text, Color(0.16, 0.10, 0.04, 0.86), Vector2(0, 110)))
	center.add_child(_image_or_placeholder(String(GU_ICON_PATHS.get(result_id, "")), String(result_def["name"]), Color(0.19, 0.12, 0.05, 0.93), Vector2(0, 230)))
	center.add_child(_text_line("说明", String(recipe["description"])))
	center.add_child(_text_line("基础成功率", "%d%%" % int(float(recipe["base_success"]) * 100.0)))
	center.add_child(_text_line("预计耗时", "%d 月" % int(recipe["months"])))
	center.add_child(_section_label("材料消耗"))
	for cost_id in recipe["costs"].keys():
		center.add_child(_text_line(_resource_name(cost_id), "%d / %d" % [state.get_resource(cost_id), int(recipe["costs"][cost_id])]))

	var right := _add_panel(body, "蛊虫库存", Vector2(560, 0))
	right.add_child(_inventory_list(""))
	right.add_child(_section_label("炼蛊日志"))
	right.add_child(_log_view(state.logs, 8))

func _set_recipe(recipe_id: String) -> void:
	selected_recipe = recipe_id
	refining_feedback_path = ""
	refining_feedback_text = "炉鼎待启"
	_show_refining()

func _try_refine() -> void:
	var recipe: Dictionary = GameState.REFINE_RECIPES[selected_recipe]
	var result_id := String(recipe["result"])
	var result_def: Dictionary = GameState.GU_DEFINITIONS[result_id]
	var costs: Dictionary = recipe["costs"]
	if not state.can_pay(costs):
		refining_feedback_path = ""
		refining_feedback_text = "材料不足"
		state.add_log("炼蛊失败：材料或资源不足。")
		SaveService.save_game(state)
		_show_refining()
		return
	state.pay(costs)
	var months: int = int(recipe["months"])
	var duplicate_unique: bool = bool(result_def.get("unique", false)) and state.unique_gu.has(result_id)
	if duplicate_unique:
		refining_feedback_path = String(EFFECT_IMAGE_PATHS["backlash"])
		refining_feedback_text = "唯一仙蛊反噬"
		state.character["lifespan_days"] = max(0, int(state.character.get("lifespan_days", 0)) - 180)
		state.character["hp"] = max(1, int(state.character.get("hp", 100)) - 30)
		WorldClock.advance_months(state, months, "强炼唯一仙蛊")
		state.add_log("炼蛊反噬：%s 已存在，材料尽毁，寿元折损。" % result_def["name"])
		SaveService.save_game(state)
		_show_refining()
		return

	var dao_bonus: float = float(state.character.get("dao_marks", {}).get(String(result_def.get("school", "")), 35)) / 400.0
	var aperture_penalty: float = float(state.aperture.get("conflict_rate", 30)) / 500.0
	var success_rate: float = clampf(float(recipe["base_success"]) + dao_bonus - aperture_penalty, 0.05, 0.95)
	var roll: float = rng.randf()
	WorldClock.advance_months(state, months, "炼制%s" % result_def["name"])
	if roll <= success_rate:
		refining_feedback_path = String(EFFECT_IMAGE_PATHS["refine_success"])
		refining_feedback_text = "炼制成功"
		state.add_gu(result_id, 1)
		state.add_log("炼制成功：%s 归入仙窍。" % result_def["name"])
	else:
		refining_feedback_path = String(EFFECT_IMAGE_PATHS["backlash"])
		refining_feedback_text = "炉火反噬"
		state.character["lifespan_days"] = max(0, int(state.character.get("lifespan_days", 0)) - 90)
		state.character["hp"] = max(1, int(state.character.get("hp", 100)) - 18)
		state.add_log("炼制失败：炉火失控，材料尽毁并受到反噬。")
	SaveService.save_game(state)
	_show_refining()

func _show_killer_move() -> void:
	if not state.has_gu(selected_core):
		var cores: Array = state.get_gu_ids("core")
		selected_core = String(cores[0]) if cores.size() > 0 else "sword_core"
	var shell := _build_shell("杀招配置", "res://assets/reference/killer_move.png", "killer")
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	shell.add_child(body)

	var left := _add_panel(body, "蛊虫库", Vector2(520, 0))
	left.add_child(_section_label("核心仙蛊"))
	for id in state.get_gu_ids("core"):
		var def: Dictionary = GameState.GU_DEFINITIONS[id]
		left.add_child(_gu_choice_button(String(id), "%s x%d" % [def["name"], state.gu_inventory[id]], selected_core == id, Callable(self, "_set_core_gu").bind(id)))
	left.add_child(_section_label("辅助凡蛊"))
	for id in state.get_gu_ids("plugin"):
		var def: Dictionary = GameState.GU_DEFINITIONS[id]
		left.add_child(_gu_choice_button(String(id), "%s x%d" % [def["name"], state.gu_inventory[id]], selected_plugins.has(id), Callable(self, "_toggle_plugin").bind(id)))

	var move: Dictionary = state.build_killer_move(selected_core, selected_plugins)
	var center := _add_panel(body, "杀招矩阵", Vector2(760, 0))
	center.add_child(_matrix_preview(move))
	var action_row := HBoxContainer.new()
	action_row.add_theme_constant_override("separation", 10)
	center.add_child(action_row)
	action_row.add_child(_killer_action_button("保存杀招", Callable(self, "_save_killer_move"), true))
	action_row.add_child(_killer_action_button("保存为防御脚本", Callable(self, "_save_defense_script"), false))
	action_row.add_child(_killer_action_button("模拟运行（推进1月）", Callable(self, "_simulate_killer_move"), false))
	action_row.add_child(_killer_action_button("清空矩阵", Callable(self, "_clear_killer_matrix"), false, "clear_matrix"))

	var right := _add_panel(body, "编译结果", Vector2(560, 0))
	right.add_child(_killer_result_row("威力", int(move["power"] / 12), COLOR_CYAN, "attr_power"))
	right.add_child(_killer_result_row("稳定度", int(move["stability"]), COLOR_GREEN if int(move["stability"]) >= 70 else COLOR_GOLD, "attr_stability"))
	right.add_child(_killer_result_row("异常风险", int(move["risk"]), COLOR_RED if int(move["risk"]) > 35 else COLOR_GOLD, "attr_risk"))
	var tags: Array = move.get("tags", [])
	var coverage_text := "单体"
	if tags.has("split"):
		coverage_text = "分裂弹道"
	elif tags.has("pierce"):
		coverage_text = "单体贯穿"
	right.add_child(_icon_text_line("灵气消耗", "%d / 次" % int(move["spirit_cost"]), "attr_spirit_cost"))
	right.add_child(_icon_text_line("覆盖范围", coverage_text, "attr_range"))
	right.add_child(_icon_text_line("自动寻敌", "是" if tags.has("homing") else "否", "attr_homing"))
	right.add_child(_text_line("冷却", "%.1f 秒" % float(move["cooldown"])))
	right.add_child(_killer_diagnosis_box(move))
	right.add_child(_killer_preview_card())
	right.add_child(_text_line("当前激活", String(state.get_active_killer_move().get("name", "无"))))
	right.add_child(_text_line("防御脚本", String(state.get_active_defense_script().get("name", "未保存")) if not state.defense_scripts.is_empty() else "未保存"))
	right.add_child(_section_label("已保存杀招"))
	for i in range(state.killer_moves.size()):
		var saved: Dictionary = state.killer_moves[i]
		right.add_child(_choice_button(saved.get("name", "杀招"), state.active_killer_move == i, Callable(self, "_set_active_move").bind(i)))

func _clear_killer_matrix() -> void:
	selected_plugins = []
	_show_killer_move()

func _set_core_gu(id: String) -> void:
	selected_core = id
	_show_killer_move()

func _toggle_plugin(id: String) -> void:
	if selected_plugins.has(id):
		selected_plugins.erase(id)
	elif selected_plugins.size() < 4:
		selected_plugins.append(id)
	else:
		state.add_log("杀招矩阵最多注入 4 个辅助蛊。")
	_show_killer_move()

func _save_killer_move() -> void:
	var move: Dictionary = state.build_killer_move(selected_core, selected_plugins)
	state.add_killer_move(move)
	SaveService.save_game(state)
	_show_killer_move()

func _save_defense_script() -> void:
	var move: Dictionary = state.build_killer_move(selected_core, selected_plugins)
	state.add_defense_script(move)
	TribulationService.prepare_defense(state)
	SaveService.save_game(state)
	_show_killer_move()

func _simulate_killer_move() -> void:
	var move: Dictionary = state.build_killer_move(selected_core, selected_plugins)
	WorldClock.advance_months(state, 1, "模拟运行%s" % move["name"])
	if rng.randi_range(1, 100) <= int(move["risk"]):
		state.character["hp"] = max(1, int(state.character.get("hp", 100)) - 12)
		state.add_log("模拟出现反噬：依赖链震荡，生命受损。")
	else:
		state.add_log("模拟通过：矩阵稳定，可投入实战。")
	SaveService.save_game(state)
	_show_killer_move()

func _set_active_move(index: int) -> void:
	state.active_killer_move = index
	SaveService.save_game(state)
	_show_killer_move()

func _show_dynamic_market() -> void:
	if state.has_method("ensure_world_defaults"):
		state.ensure_world_defaults()
	MarketService.cleanup_and_seed(state)
	_sync_selected_market_post()
	var shell: VBoxContainer = _build_shell("宝黄天：动态订单流", "res://assets/reference/market.png", "market")
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	shell.add_child(body)

	var left: VBoxContainer = _add_panel(body, "市场态势", Vector2(420, 0))
	left.add_child(_text_line("当前世界刻", "第 %d 月" % int(state.world_month)))
	left.add_child(_text_line("活跃订单", "%d" % state.market_posts.size()))
	left.add_child(_text_line("未决事件", "%d" % _active_world_event_count()))
	left.add_child(_text_line("高风险订单", "%d" % _market_high_risk_count()))
	left.add_child(_button("刷新订单流（推进1月）", Callable(self, "_market_refresh_world")))
	left.add_child(_button("挂售灵气", Callable(self, "_market_publish_sale")))
	left.add_child(_button("挂求材料", Callable(self, "_market_publish_buy")))
	left.add_child(_section_label("近期事件"))
	var event_limit: int = min(5, state.world_events.size())
	for i in range(event_limit):
		var event: Dictionary = state.world_events[i]
		left.add_child(_text_line(String(event.get("kind", "事件")), "%s / 威胁%d" % [_region_name(String(event.get("region", ""))), int(event.get("severity", 0))]))

	var center: VBoxContainer = _add_panel(body, "订单流", Vector2(920, 0))
	center.add_child(_icon_text_line("搜索", "订单标题、资源、风险", "search"))
	if state.market_posts.is_empty():
		center.add_child(_warning_line("宝黄天暂时没有可见订单。"))
	for raw_post in state.market_posts:
		var post: Dictionary = raw_post
		var post_id: String = String(post.get("id", ""))
		var selected: bool = post_id == selected_market_post_id
		center.add_child(_market_post_button(post, selected, Callable(self, "_market_select_post").bind(post_id)))

	var right: VBoxContainer = _add_panel(body, "订单详情", Vector2(560, 0))
	var selected_post: Dictionary = _selected_market_post()
	if selected_post.is_empty():
		right.add_child(_warning_line("请选择一条订单。"))
	else:
		right.add_child(_image_or_placeholder("res://assets/ui/icons/intel_scroll.png", String(selected_post.get("kind", "订单")), Color(0.05, 0.12, 0.10, 0.92), Vector2(0, 170)))
		right.add_child(_text_line("标题", String(selected_post.get("title", "无题"))))
		right.add_child(_text_line("发布者", MarketService.seller_name(state, String(selected_post.get("seller_npc_id", "")))))
		right.add_child(_text_line("价格", "%d 仙元石" % int(selected_post.get("price", 0))))
		right.add_child(_text_line("标的", "%s x%d" % [MarketService.resource_name(String(selected_post.get("resource_id", ""))), int(selected_post.get("quantity", 0))]))
		right.add_child(_metric("交易风险", int(selected_post.get("risk", 0)), _risk_color(int(selected_post.get("risk", 0)))))
		right.add_child(_metric("可信度", int(selected_post.get("truthfulness", 0)), _trust_color(int(selected_post.get("truthfulness", 0)))))
		right.add_child(_dialogue_line("正文", String(selected_post.get("body", ""))))
		right.add_child(_button("交易 / 接单", Callable(self, "_market_trade_selected")))
		right.add_child(_button("调查真伪（90情报）", Callable(self, "_market_investigate_selected")))
		right.add_child(_button("散布谣言（120情报）", Callable(self, "_market_rumor_selected")))
		right.add_child(_warning_line("低信任 NPC 可能抬价、设伏或借订单传播假情报。"))

func _sync_selected_market_post() -> void:
	if MarketService.find_post_index(state, selected_market_post_id) >= 0:
		return
	if state.market_posts.is_empty():
		selected_market_post_id = ""
		return
	var first_post: Dictionary = state.market_posts[0]
	selected_market_post_id = String(first_post.get("id", ""))

func _selected_market_post() -> Dictionary:
	var index: int = MarketService.find_post_index(state, selected_market_post_id)
	if index < 0:
		return {}
	var post: Dictionary = state.market_posts[index]
	return post

func _market_select_post(post_id: String) -> void:
	selected_market_post_id = post_id
	_show_market()

func _market_trade_selected() -> void:
	var message: String = MarketService.apply_post_action(state, selected_market_post_id, "trade")
	state.add_log(message)
	SaveService.save_game(state)
	_show_market()

func _market_investigate_selected() -> void:
	var message: String = MarketService.apply_post_action(state, selected_market_post_id, "investigate")
	state.add_log(message)
	SaveService.save_game(state)
	_show_market()

func _market_rumor_selected() -> void:
	var message: String = MarketService.apply_post_action(state, selected_market_post_id, "rumor")
	state.adjust_morality(-2, "散布谣言")
	state.add_log(message)
	SaveService.save_game(state)
	_show_market()

func _market_refresh_world() -> void:
	WorldClock.advance_months(state, 1, "宝黄天刷新")
	SaveService.save_game(state)
	_show_market()

func _market_publish_sale() -> void:
	var message: String = MarketService.publish_player_post(state, "抛售")
	state.add_log(message)
	SaveService.save_game(state)
	_show_market()

func _market_publish_buy() -> void:
	var message: String = MarketService.publish_player_post(state, "求购")
	state.add_log(message)
	SaveService.save_game(state)
	_show_market()

func _market_high_risk_count() -> int:
	var count: int = 0
	for raw_post in state.market_posts:
		var post: Dictionary = raw_post
		if int(post.get("risk", 0)) >= 65:
			count += 1
	return count

func _active_world_event_count() -> int:
	var count: int = 0
	for raw_event in state.world_events:
		var event: Dictionary = raw_event
		if not bool(event.get("resolved", false)):
			count += 1
	return count

func _show_dynamic_npc() -> void:
	if state.has_method("ensure_world_defaults"):
		state.ensure_world_defaults()
	_sync_selected_npc()
	var shell: VBoxContainer = _build_shell("NPC 利益博弈", "res://assets/reference/npc_dialogue.png", "npc")
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	shell.add_child(body)

	var left: VBoxContainer = _add_panel(body, "五域人物", Vector2(470, 0))
	for raw_npc in state.npcs:
		var npc: Dictionary = raw_npc
		var npc_id: String = String(npc.get("id", ""))
		var selected: bool = npc_id == selected_npc_id
		left.add_child(_npc_list_button(npc, selected, Callable(self, "_npc_select").bind(npc_id)))
	left.add_child(_section_label("势力"))
	for raw_faction in state.factions:
		var faction: Dictionary = raw_faction
		left.add_child(_text_line(String(faction.get("name", "势力")), "财富%d / 紧张%d" % [int(faction.get("wealth", 0)), int(faction.get("tension", 0))]))

	var center: VBoxContainer = _add_panel(body, "人物详情", Vector2(840, 0))
	var npc_index: int = _selected_npc_index()
	if npc_index < 0:
		center.add_child(_warning_line("暂无可交互 NPC。"))
	else:
		var npc: Dictionary = state.npcs[npc_index]
		var portrait_path: String = "res://assets/characters/npc_%s.png" % String(npc.get("id", "xuanwuzi"))
		center.add_child(_npc_portrait_view(portrait_path, String(npc.get("name", "NPC"))))
		center.add_child(_text_line("姓名", String(npc.get("name", "匿名"))))
		center.add_child(_text_line("势力", _faction_name(String(npc.get("faction", "")))))
		center.add_child(_text_line("境界", RealmService.npc_realm_name(npc)))
		center.add_child(_text_line("寿元", _format_days(int(npc.get("lifespan_days", 0)))))
		center.add_child(_text_line("性格", String(npc.get("personality", "未知"))))
		center.add_child(_text_line("目标", String(npc.get("current_goal", "观望"))))
		center.add_child(_text_line("近况", String(npc.get("last_action", "无"))))
		center.add_child(_text_line("持有蛊", _owned_gu_text(npc.get("owned_gu", []))))
		center.add_child(_npc_relation_metric("关系", int(npc.get("relation", 0)), _relation_color(int(npc.get("relation", 0)))))
		center.add_child(_npc_relation_metric("信任", int(npc.get("trust", 0)), _trust_color(int(npc.get("trust", 0)))))
		center.add_child(_npc_relation_metric("紧迫", int(npc.get("urgency", 0)), _risk_color(int(npc.get("urgency", 0)))))

		var actions := HBoxContainer.new()
		actions.add_theme_constant_override("separation", 10)
		center.add_child(actions)
		var action_left := VBoxContainer.new()
		action_left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		actions.add_child(action_left)
		var action_right := VBoxContainer.new()
		action_right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		actions.add_child(action_right)
		action_left.add_child(_button("以情报换材料", Callable(self, "_npc_trade_selected")))
		action_left.add_child(_button("结盟共抗灾劫", Callable(self, "_npc_ally_selected")))
		action_left.add_child(_button("打探情报", Callable(self, "_npc_probe_selected")))
		action_right.add_child(_button("威胁夺取线索", Callable(self, "_npc_threaten_selected")))
		action_right.add_child(_button("标记仇敌", Callable(self, "_npc_mark_enemy_selected")))
		action_right.add_child(_button("结束交谈（推进1月）", Callable(self, "_npc_wait_selected")))

	var right: VBoxContainer = _add_panel(body, "行动日志", Vector2(610, 0))
	right.add_child(_section_label("世界事件"))
	var event_count: int = min(7, state.world_events.size())
	for i in range(event_count):
		var event: Dictionary = state.world_events[i]
		right.add_child(_text_line(String(event.get("kind", "事件")), "%s / 威胁%d / %d月止" % [_region_name(String(event.get("region", ""))), int(event.get("severity", 0)), int(event.get("expires_month", 0))]))
	right.add_child(_section_label("近期日志"))
	right.add_child(_log_view(state.logs, 9))
	right.add_child(_warning_line("低信任 NPC 会拒绝、抬价、散布谣言，甚至在你战后虚弱时制造袭击窗口。"))

func _sync_selected_npc() -> void:
	if _selected_npc_index() >= 0:
		return
	if state.npcs.is_empty():
		selected_npc_id = ""
		return
	var npc: Dictionary = state.npcs[0]
	selected_npc_id = String(npc.get("id", ""))

func _selected_npc_index() -> int:
	for i in range(state.npcs.size()):
		var npc: Dictionary = state.npcs[i]
		if String(npc.get("id", "")) == selected_npc_id:
			return i
	return -1

func _npc_select(npc_id: String) -> void:
	selected_npc_id = npc_id
	_show_npc()

func _npc_trade_selected() -> void:
	var index: int = _selected_npc_index()
	if index < 0:
		return
	var npc: Dictionary = state.npcs[index]
	var resources: Dictionary = npc.get("resources", {})
	if state.get_resource("intel") >= 160 and int(resources.get("materials", 0)) >= 2:
		state.add_resource("intel", -160)
		state.add_resource("materials", 2)
		resources["materials"] = int(resources.get("materials", 0)) - 2
		resources["intel"] = int(resources.get("intel", 0)) + 160
		npc["relation"] = clampi(int(npc.get("relation", 0)) + 5, -100, 100)
		npc["trust"] = clampi(int(npc.get("trust", 0)) + 4, 0, 100)
		npc["urgency"] = clampi(int(npc.get("urgency", 0)) - 4, 0, 100)
		npc["last_action"] = "与玩家完成情报换材料"
		npc["resources"] = resources
		state.adjust_morality(1, "公平交易")
		state.add_log("%s收下情报，交出炼蛊材料 x2。" % String(npc.get("name", "NPC")))
	else:
		state.add_log("谈判失败：你缺少情报，或对方材料库存不足。")
	state.npcs[index] = npc
	SaveService.save_game(state)
	_show_npc()

func _npc_ally_selected() -> void:
	var index: int = _selected_npc_index()
	if index < 0:
		return
	var npc: Dictionary = state.npcs[index]
	var costs: Dictionary = {"immortal_stone": 180}
	if state.can_pay(costs):
		state.pay(costs)
		npc["trust"] = clampi(int(npc.get("trust", 0)) + 10, 0, 100)
		npc["relation"] = clampi(int(npc.get("relation", 0)) + 8, -100, 100)
		npc["urgency"] = clampi(int(npc.get("urgency", 0)) - 6, 0, 100)
		npc["last_action"] = "与玩家缔结临时盟约"
		state.add_resource("intel", 90)
		state.adjust_morality(3, "结盟互助")
		state.add_log("临时结盟达成：%s提供一条遗迹情报。" % String(npc.get("name", "NPC")))
		WorldClock.advance_months(state, 1, "结盟谈判")
	else:
		state.add_log("结盟失败：仙元石不足。")
	state.npcs[index] = npc
	SaveService.save_game(state)
	_show_npc()

func _npc_probe_selected() -> void:
	var index: int = _selected_npc_index()
	if index < 0:
		return
	var npc: Dictionary = state.npcs[index]
	var costs: Dictionary = {"intel": 120}
	if not state.can_pay(costs):
		state.add_log("打探失败：情报值不足。")
	else:
		state.pay(costs)
		var known: Array = npc.get("known_intel", [])
		var clue: String = String(known[rng.randi_range(0, known.size() - 1)]) if not known.is_empty() else "宝黄天暗线"
		state.add_resource("intel", 150)
		npc["trust"] = clampi(int(npc.get("trust", 0)) - 2, 0, 100)
		npc["last_action"] = "被玩家旁敲侧击"
		state.adjust_morality(-1, "暗中试探")
		state.add_log("打探成功：你从%s处套出“%s”。" % [String(npc.get("name", "NPC")), clue])
	state.npcs[index] = npc
	SaveService.save_game(state)
	_show_npc()

func _npc_threaten_selected() -> void:
	var index: int = _selected_npc_index()
	if index < 0:
		return
	var npc: Dictionary = state.npcs[index]
	var success_chance: int = clampi(56 + int(npc.get("urgency", 0)) / 3 - int(npc.get("trust", 0)) / 4, 18, 82)
	npc["trust"] = clampi(int(npc.get("trust", 0)) - 18, 0, 100)
	npc["relation"] = clampi(int(npc.get("relation", 0)) - 22, -100, 100)
	state.adjust_morality(-6, "威胁夺取")
	if rng.randi_range(1, 100) <= success_chance:
		state.add_resource("intel", 260)
		npc["last_action"] = "被玩家威胁后交出线索"
		state.add_log("威胁奏效：%s交出高价值线索，但仇怨加深。" % String(npc.get("name", "NPC")))
	else:
		state.character["hp"] = max(1, int(state.character.get("hp", 100)) - 24)
		_add_world_event("反噬伏击", String(npc.get("id", "")), "player", 72)
		npc["last_action"] = "反制玩家威胁"
		state.add_log("威胁失败：%s暗中反击，你受伤撤退。" % String(npc.get("name", "NPC")))
	state.npcs[index] = npc
	SaveService.save_game(state)
	_show_npc()

func _npc_mark_enemy_selected() -> void:
	var index: int = _selected_npc_index()
	if index < 0:
		return
	var npc: Dictionary = state.npcs[index]
	npc["relation"] = clampi(int(npc.get("relation", 0)) - 30, -100, 100)
	npc["trust"] = clampi(int(npc.get("trust", 0)) - 24, 0, 100)
	npc["urgency"] = clampi(int(npc.get("urgency", 0)) + 10, 0, 100)
	npc["last_action"] = "被玩家标记为仇敌"
	_add_world_event("仇敌标记", String(npc.get("id", "")), "player", 68)
	state.adjust_morality(-4, "标记仇敌")
	state.add_log("你将%s标记为仇敌，后续可能触发袭击或悬赏。" % String(npc.get("name", "NPC")))
	state.npcs[index] = npc
	SaveService.save_game(state)
	_show_npc()

func _npc_wait_selected() -> void:
	WorldClock.advance_months(state, 1, "结束交谈")
	SaveService.save_game(state)
	_show_npc()

func _add_world_event(kind: String, source_npc_id: String, target_npc_id: String, severity: int) -> void:
	state.world_events.push_front({
		"id": "event_ui_%d_%d" % [int(state.world_month), rng.randi_range(1000, 9999)],
		"kind": kind,
		"region": _pick_region_id(),
		"severity": clampi(severity, 1, 100),
		"source_npc_id": source_npc_id,
		"target_npc_id": target_npc_id,
		"expires_month": int(state.world_month) + rng.randi_range(2, 6),
		"resolved": false,
		"effects": {"market_risk": int(severity / 10)}
	})

func _faction_name(faction_id: String) -> String:
	for raw_faction in state.factions:
		var faction: Dictionary = raw_faction
		if String(faction.get("id", "")) == faction_id:
			return String(faction.get("name", faction_id))
	return faction_id

func _region_name(region_id: String) -> String:
	for raw_region in state.world_regions:
		var region: Dictionary = raw_region
		if String(region.get("id", "")) == region_id:
			return String(region.get("name", region_id))
	return region_id

func _pick_region_id() -> String:
	if state.world_regions.is_empty():
		return "southern_border"
	var region: Dictionary = state.world_regions[rng.randi_range(0, state.world_regions.size() - 1)]
	return String(region.get("id", "southern_border"))

func _realm_name(index: int) -> String:
	return RealmService.display_realm({"rank": clampi(index, 1, 9), "rank_stage": 1, "morality_score": 0})

func _format_days(days: int) -> String:
	return "%d年%d天" % [days / 360, days % 360]

func _owned_gu_text(owned_gu: Array) -> String:
	if owned_gu.is_empty():
		return "无"
	var names: Array = []
	for gu_id in owned_gu:
		var gu_def: Dictionary = GameState.GU_DEFINITIONS.get(String(gu_id), {})
		names.append(String(gu_def.get("name", String(gu_id))))
	return state._join_strings(names, " / ")

func _risk_color(value: int) -> Color:
	if value >= 70:
		return COLOR_RED
	if value >= 45:
		return COLOR_GOLD
	return COLOR_GREEN

func _trust_color(value: int) -> Color:
	if value >= 65:
		return COLOR_GREEN
	if value >= 35:
		return COLOR_GOLD
	return COLOR_RED

func _relation_color(value: int) -> Color:
	if value >= 20:
		return COLOR_GREEN
	if value <= -20:
		return COLOR_RED
	return COLOR_GOLD

func _show_market() -> void:
	_show_dynamic_market()
	return
	var shell := _build_shell("宝黄天", "res://assets/reference/market.png", "market")
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	shell.add_child(body)

	var left := _add_panel(body, "交易分类", Vector2(420, 0))
	left.add_child(_text_line("灵泉结晶", "156 仙元石 / 枚"))
	left.add_child(_text_line("九幽玄铁", "320 仙元石 / 份"))
	left.add_child(_text_line("寿蛊线索", "情报值 280"))
	left.add_child(_button("出售灵泉结晶", Callable(self, "_market_sell")))
	left.add_child(_button("购买材料", Callable(self, "_market_buy_materials")))
	left.add_child(_button("散布假情报", Callable(self, "_market_rumor")))

	var center := _add_panel(body, "全图广播", Vector2(900, 0))
	var posts := [
		"[求购] 寿蛊线索，有偿，面谈从优。",
		"[抛售] 灵泉结晶 x30，匿名卖家，价格略议。",
		"[悬赏] 追查散修“归墟子”下落，报酬 500 仙元石。",
		"[疑似假情报] 春秋蝉现世可令寿元逆转，来源可疑。",
		"[求购] 九幽玄铁，越多越好。",
		"[情报] 有修士在极北冰原发现上古遗迹入口。"
	]
	for post in posts:
		center.add_child(_text_line("广播", post))
	center.add_child(_log_view(state.logs, 8))

	var right := _add_panel(body, "订单详情", Vector2(560, 0))
	right.add_child(_image_or_placeholder("res://assets/ui/icons/immortal_stone.png", "匿名交易", Color(0.05, 0.12, 0.10, 0.92), Vector2(0, 280)))
	right.add_child(_text_line("交易风险", "高"))
	right.add_child(_text_line("卖家信誉", "%d/100" % int(45 + state.npc.get("trust", 0) / 2)))
	right.add_child(_warning_line("宝黄天不对交易结果负责。"))

func _market_sell() -> void:
	state.add_resource("immortal_stone", 312)
	state.add_resource("spirit_qi", -1800)
	WorldClock.advance_months(state, 1, "宝黄天出售资源")
	SaveService.save_game(state)
	_show_market()

func _market_buy_materials() -> void:
	var costs := {"immortal_stone": 520}
	if state.can_pay(costs):
		state.pay(costs)
		state.add_resource("materials", 4)
		state.add_log("宝黄天购入炼蛊材料 x4。")
	else:
		state.add_log("宝黄天交易失败：仙元石不足。")
	SaveService.save_game(state)
	_show_market()

func _market_rumor() -> void:
	state.add_resource("intel", -180)
	state.npc["trust"] = clampi(int(state.npc.get("trust", 30)) - 6, 0, 100)
	state.add_log("你散布了疑似假情报，短期扰乱市场，但信誉下降。")
	WorldClock.advance_months(state, 1, "散布情报")
	SaveService.save_game(state)
	_show_market()

func _show_npc() -> void:
	_show_dynamic_npc()
	return
	var shell := _build_shell("NPC 利益交互", "res://assets/reference/npc_dialogue.png", "npc")
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	shell.add_child(body)

	var left := _add_panel(body, "幽泉宗长老", Vector2(520, 0))
	left.add_child(_image_or_placeholder("res://assets/characters/npc_xuanwuzi.png", String(state.npc.get("name", "玄雾子")), Color(0.10, 0.08, 0.13, 0.94), Vector2(0, 430)))
	left.add_child(_metric("关系", int(state.npc.get("relation", 0)), COLOR_CYAN))
	left.add_child(_metric("信任", int(state.npc.get("trust", 0)), COLOR_GREEN))
	left.add_child(_metric("渡劫紧迫", int(state.npc.get("urgency", 0)), COLOR_RED))

	var center := _add_panel(body, "谈判选项", Vector2(820, 0))
	center.add_child(_dialogue_line("玄雾子", "年轻人，你握着情报，却未必握得住命。说吧，你想交换什么？"))
	center.add_child(_button("以情报换材料", Callable(self, "_npc_trade")))
	center.add_child(_button("结盟共抗灾劫", Callable(self, "_npc_ally")))
	center.add_child(_button("威胁夺取线索", Callable(self, "_npc_threaten")))
	center.add_child(_button("结束交谈（推进1月）", Callable(self, "_npc_wait")))

	var right := _add_panel(body, "交互日志", Vector2(560, 0))
	right.add_child(_log_view(state.logs, 12))
	right.add_child(_warning_line("NPC 行动以自身利益最大化为准，关系不足时可能背叛。"))

func _npc_trade() -> void:
	if state.get_resource("intel") >= 160:
		state.add_resource("intel", -160)
		state.add_resource("materials", 2)
		state.npc["relation"] = clampi(int(state.npc.get("relation", 0)) + 4, -100, 100)
		state.add_log("玄雾子收下情报，交出炼蛊材料 x2。")
	else:
		state.add_log("谈判失败：情报值不足。")
	SaveService.save_game(state)
	_show_npc()

func _npc_ally() -> void:
	state.npc["trust"] = clampi(int(state.npc.get("trust", 0)) + 8, 0, 100)
	state.npc["relation"] = clampi(int(state.npc.get("relation", 0)) + 6, -100, 100)
	state.add_resource("intel", 90)
	WorldClock.advance_months(state, 1, "结盟谈判")
	state.add_log("短暂结盟达成，你获得一条遗迹情报。")
	SaveService.save_game(state)
	_show_npc()

func _npc_threaten() -> void:
	state.npc["trust"] = clampi(int(state.npc.get("trust", 0)) - 16, 0, 100)
	state.npc["relation"] = clampi(int(state.npc.get("relation", 0)) - 18, -100, 100)
	if rng.randi_range(1, 100) <= 58:
		state.add_resource("intel", 240)
		state.add_log("威胁奏效，你夺得寿蛊线索，但仇怨加深。")
	else:
		state.character["hp"] = max(1, int(state.character.get("hp", 100)) - 22)
		state.add_log("威胁失败，玄雾子暗中反击，你受伤撤退。")
	SaveService.save_game(state)
	_show_npc()

func _npc_wait() -> void:
	WorldClock.advance_months(state, 1, "结束交谈")
	state.npc["urgency"] = clampi(int(state.npc.get("urgency", 0)) + 5, 0, 100)
	SaveService.save_game(state)
	_show_npc()

func _start_combat(encounter: Dictionary = {}) -> void:
	_clear()
	if encounter.is_empty():
		encounter = DungeonService.wild_encounter(state)
	combat_encounter = encounter.duplicate(true)
	current_screen = "combat"
	combat_active = true
	combat_elapsed = 0.0
	combat_cooldown = 0.0
	combat_message = ""
	combat_logs = []
	combat_projectiles = []
	combat_effects = []
	combat_runtime_injections = []
	combat_injection_cooldown = 0.0
	combat_overload = 0.0
	combat_player_pos = battle_rect.position + battle_rect.size * Vector2(0.24, 0.58)
	combat_player_facing = Vector2.RIGHT
	combat_player_action = "idle"
	combat_player_action_time = 0.0
	state.character["hp"] = int(state.character.get("max_hp", 100))
	combat_enemies = CombatService.runtime_enemies(combat_encounter, battle_rect)
	_combat_log("战斗开始：%s。" % CombatService.combat_objective(combat_encounter))
	_build_combat_screen()

func _restart_combat() -> void:
	_start_combat(combat_encounter)

func _build_combat_screen() -> void:
	for child in get_children():
		child.queue_free()
	current_screen = "combat"
	var top := HBoxContainer.new()
	top.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top.offset_left = 18
	top.offset_top = 12
	top.offset_right = -18
	top.offset_bottom = 92
	top.add_theme_constant_override("separation", 10)
	add_child(top)
	_build_header(top, "实时战斗")

	var left_panel := _floating_panel("战斗信息", Rect2(18, 112, 312, 800))
	var left := _panel_body(left_panel)
	left.add_child(_text_line("遭遇", CombatService.combat_title(combat_encounter)))
	left.add_child(_text_line("杀招", String(state.get_active_killer_move().get("name", "未配置"))))
	left.add_child(_text_line("灵气", _format_number(state.get_resource("spirit_qi"))))
	combat_hp_bar = ProgressBar.new()
	combat_hp_bar.max_value = int(state.character.get("max_hp", 100))
	combat_hp_bar.value = int(state.character.get("hp", 100))
	combat_hp_bar.show_percentage = false
	_apply_progress_skin(combat_hp_bar, String(PROGRESS_UI_PATHS["fill_red"]))
	left.add_child(_labeled_control("生命", combat_hp_bar))
	combat_cd_bar = ProgressBar.new()
	combat_cd_bar.max_value = max(0.1, float(state.get_active_killer_move().get("cooldown", 2.0)))
	combat_cd_bar.value = 0
	combat_cd_bar.show_percentage = false
	_apply_progress_skin(combat_cd_bar, String(PROGRESS_UI_PATHS["fill_cyan"]))
	left.add_child(_labeled_control("冷却", combat_cd_bar))
	left.add_child(_section_label("操作"))
	left.add_child(_text_line("移动", "W / A / S / D"))
	left.add_child(_text_line("释放杀招", "Space 或 1"))
	left.add_child(_text_line("运行时注入", "Q / E / R"))
	left.add_child(_text_line("矩阵过载", "%d%%" % int(combat_overload)))
	left.add_child(_button("释放杀招", Callable(self, "_cast_killer_move")))
	left.add_child(_button("撤回仙窍", Callable(self, "_retreat_combat")))

	var right_panel := _floating_panel("战斗目标 / 日志", Rect2(1590, 112, 312, 800))
	var right := _panel_body(right_panel)
	right.add_child(_text_line("目标", CombatService.combat_objective(combat_encounter)))
	right.add_child(_text_line("难度", DungeonDefs.difficulty_name(String(combat_encounter.get("difficulty_id", "normal"))) if String(combat_encounter.get("branch_id", "wild")) != "wild" else "野外"))
	right.add_child(_text_line("时间", "%.1f 秒" % combat_elapsed))
	right.add_child(_warning_line("反噬会直接损伤生命与寿元。"))
	combat_log_label = RichTextLabel.new()
	combat_log_label.bbcode_enabled = false
	combat_log_label.fit_content = true
	combat_log_label.custom_minimum_size = Vector2(0, 430)
	right.add_child(combat_log_label)
	_refresh_combat_log()

	var bottom := HBoxContainer.new()
	bottom.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	bottom.offset_left = 360
	bottom.offset_right = -360
	bottom.offset_top = -126
	bottom.offset_bottom = -18
	bottom.add_theme_constant_override("separation", 10)
	add_child(bottom)
	var move: Dictionary = state.get_active_killer_move()
	bottom.add_child(_hotbar_card("1", String(move.get("name", "杀招")), "威力 %d / 稳定 %d%%" % [int(move.get("power", 0)), int(move.get("stability", 0))]))
	var injection_ids := _combat_injection_candidates(move)
	bottom.add_child(_hotbar_card("Q", _injection_title(injection_ids, 0), _injection_desc(injection_ids, 0)))
	bottom.add_child(_hotbar_card("E", _injection_title(injection_ids, 1), _injection_desc(injection_ids, 1)))
	bottom.add_child(_hotbar_card("R", _injection_title(injection_ids, 2), _injection_desc(injection_ids, 2)))

	if combat_message != "":
		var overlay := _floating_panel("战斗结算", Rect2(650, 350, 620, 280))
		var box := _panel_body(overlay)
		var result := Label.new()
		result.text = combat_message
		result.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		result.add_theme_font_size_override("font_size", 30)
		result.add_theme_color_override("font_color", COLOR_GOLD)
		box.add_child(result)
		box.add_child(_button("返回仙窍", Callable(self, "_show_aperture")))
		box.add_child(_button("再次挑战", Callable(self, "_restart_combat")))
	queue_redraw()

func _update_combat(delta: float) -> void:
	combat_elapsed += delta
	combat_cooldown = max(0.0, combat_cooldown - delta)
	combat_injection_cooldown = max(0.0, combat_injection_cooldown - delta)
	combat_overload = max(0.0, combat_overload - delta * 2.5)
	combat_player_action_time = max(0.0, combat_player_action_time - delta)
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction.length() > 0.01:
		combat_player_facing = direction.normalized()
		if combat_player_action_time <= 0.0:
			combat_player_action = "walk"
		combat_player_pos += direction * 340.0 * delta
		combat_player_pos.x = clampf(combat_player_pos.x, battle_rect.position.x + 24.0, battle_rect.end.x - 24.0)
		combat_player_pos.y = clampf(combat_player_pos.y, battle_rect.position.y + 24.0, battle_rect.end.y - 24.0)
	elif combat_player_action_time <= 0.0:
		combat_player_action = "idle"
	if Input.is_action_just_pressed("cast_1"):
		_cast_killer_move()
	if Input.is_action_just_pressed("inject_q"):
		_inject_runtime_gu(0)
	if Input.is_action_just_pressed("inject_e"):
		_inject_runtime_gu(1)
	if Input.is_action_just_pressed("inject_r"):
		_inject_runtime_gu(2)
	_update_projectiles(delta)
	_update_effects(delta)
	_update_enemies(delta)
	_refresh_combat_bars()
	if combat_enemies.is_empty():
		_finish_combat(true)
	elif int(state.character.get("hp", 0)) <= 0:
		_finish_combat(false)
	queue_redraw()

func _update_projectiles(delta: float) -> void:
	for i in range(combat_projectiles.size() - 1, -1, -1):
		var projectile: Dictionary = combat_projectiles[i]
		var projectile_pos: Vector2 = projectile["pos"]
		var projectile_vel: Vector2 = projectile["vel"]
		if bool(projectile.get("homing", false)) and not combat_enemies.is_empty():
			var target_pos := _nearest_enemy_pos(projectile_pos)
			var desired: Vector2 = (target_pos - projectile_pos).normalized() * float(projectile.get("speed", 720.0))
			projectile_vel = projectile_vel.lerp(desired, 4.0 * delta)
			projectile["vel"] = projectile_vel
		projectile_pos += projectile_vel * delta
		projectile["pos"] = projectile_pos
		projectile["life"] = float(projectile.get("life", 0.0)) - delta
		var remove_projectile: bool = float(projectile["life"]) <= 0.0 or not battle_rect.grow(80).has_point(projectile_pos)
		for j in range(combat_enemies.size() - 1, -1, -1):
			var enemy: Dictionary = combat_enemies[j]
			var enemy_pos: Vector2 = enemy["pos"]
			if projectile_pos.distance_to(enemy_pos) <= float(projectile.get("radius", 26.0)):
				var damage: int = int(projectile.get("damage", 100))
				if bool(projectile.get("crit", false)) and rng.randi_range(1, 100) <= 28:
					damage = int(round(float(damage) * 1.55))
				enemy["hp"] = int(enemy.get("hp", 0)) - damage
				combat_enemies[j] = enemy
				_add_combat_effect("hit_spark", enemy_pos, Vector2(96, 96), 0.20, Color(0.80, 0.95, 1.0, 0.65))
				_combat_log("命中 %s，造成 %d 伤害。" % [enemy.get("name", "敌人"), damage])
				if int(enemy["hp"]) <= 0:
					_combat_log("%s 被击溃。" % enemy.get("name", "敌人"))
					combat_enemies.remove_at(j)
				if not bool(projectile.get("pierce", false)):
					remove_projectile = true
					break
		if remove_projectile:
			combat_projectiles.remove_at(i)
		else:
			combat_projectiles[i] = projectile

func _update_effects(delta: float) -> void:
	for i in range(combat_effects.size() - 1, -1, -1):
		var effect: Dictionary = combat_effects[i]
		effect["life"] = float(effect.get("life", 0.0)) - delta
		if float(effect["life"]) <= 0.0:
			combat_effects.remove_at(i)
		else:
			combat_effects[i] = effect

func _update_enemies(delta: float) -> void:
	for i in range(combat_enemies.size()):
		var enemy: Dictionary = combat_enemies[i]
		var enemy_pos: Vector2 = enemy["pos"]
		var to_player := combat_player_pos - enemy_pos
		if to_player.length() > 42.0:
			var enemy_dir := to_player.normalized()
			enemy["facing"] = enemy_dir
			enemy["action"] = "walk"
			enemy_pos += enemy_dir * float(enemy["speed"]) * delta
			enemy["pos"] = enemy_pos
		else:
			enemy["action"] = "idle"
		enemy["attack_cd"] = max(0.0, float(enemy.get("attack_cd", 0.0)) - delta)
		if to_player.length() <= 58.0 and float(enemy["attack_cd"]) <= 0.0:
			var damage := CombatService.enemy_damage(enemy)
			state.character["hp"] = max(0, int(state.character.get("hp", 100)) - damage)
			enemy["attack_cd"] = float(enemy.get("attack_interval", 1.05))
			enemy["action"] = "cast"
			_combat_log("%s 近身攻击，造成 %d 伤害。" % [enemy.get("name", "敌人"), damage])
		combat_enemies[i] = enemy

func _cast_killer_move() -> void:
	if current_screen != "combat" or not combat_active:
		return
	var move: Dictionary = state.get_active_killer_move()
	var cost: int = int(move.get("spirit_cost", 100))
	if combat_cooldown > 0.0:
		_combat_log("杀招冷却中。")
		return
	if state.get_resource("spirit_qi") < cost:
		_combat_log("灵气不足，杀招编译中断。")
		return
	state.add_resource("spirit_qi", -cost)
	combat_cooldown = float(move.get("cooldown", 2.0))
	var target := _nearest_enemy_pos(combat_player_pos)
	var base_dir := (target - combat_player_pos).normalized()
	if base_dir.length() < 0.01:
		base_dir = Vector2.RIGHT
	combat_player_facing = base_dir
	combat_player_action = "cast"
	combat_player_action_time = 0.38
	_add_combat_effect("cast_charge", combat_player_pos, Vector2(120, 120), 0.34, Color(0.60, 1.0, 0.92, 0.76))
	var tags: Array = move.get("tags", [])
	var count := 5 if tags.has("split") else 1
	var spread := 0.42 if count > 1 else 0.0
	for i in range(count):
		var t := 0.0 if count == 1 else (float(i) / float(count - 1) - 0.5)
		var dir := base_dir.rotated(t * spread)
		combat_projectiles.append({
			"pos": combat_player_pos + dir * 34.0,
			"vel": dir * 760.0,
			"speed": 760.0,
			"damage": max(80, int(move.get("power", 600)) / count),
			"radius": 32.0 if tags.has("split") else 38.0,
			"life": 1.8,
			"homing": tags.has("homing"),
			"pierce": tags.has("pierce"),
			"crit": tags.has("crit"),
			"effect": _projectile_effect_for_move(move)
		})
	var risk: int = int(move.get("risk", 0))
	if rng.randi_range(1, 100) <= int(ceil(float(risk) * 0.35)):
		var backlash := rng.randi_range(8, 18)
		if tags.has("guard"):
			backlash = max(3, backlash - 8)
		state.character["hp"] = max(1, int(state.character.get("hp", 100)) - backlash)
		_add_combat_effect("backlash", combat_player_pos, Vector2(150, 150), 0.45, Color(1.0, 0.35, 0.30, 0.88))
		_combat_log("杀招依赖震荡，反噬 %d 生命。" % backlash)
	else:
		_combat_log("释放 %s。" % move.get("name", "杀招"))
	_refresh_combat_bars()

func _combat_injection_candidates(move: Dictionary) -> Array:
	ApertureService.ensure_ecology_state(state)
	var ids: Array = []
	for plugin_id_value in move.get("plugins", []):
		var plugin_id := String(plugin_id_value)
		if state.has_gu(plugin_id) and not ids.has(plugin_id):
			ids.append(plugin_id)
	for plugin_id_value in state.get_gu_ids("plugin"):
		var plugin_id := String(plugin_id_value)
		if not ids.has(plugin_id):
			ids.append(plugin_id)
	return ids

func _injection_title(ids: Array, index: int) -> String:
	if index < 0 or index >= ids.size():
		return "空注入槽"
	var gu_id := String(ids[index])
	var def: Dictionary = GameState.GU_DEFINITIONS.get(gu_id, {})
	return String(def.get("name", gu_id))

func _injection_desc(ids: Array, index: int) -> String:
	if index < 0 or index >= ids.size():
		return "未装载凡蛊"
	var gu_id := String(ids[index])
	var entry: Dictionary = state.gu_ecology.get(gu_id, {})
	return "注入矩阵 / 饱食 %d%% / 健康 %d%%" % [int(entry.get("food", 100)), int(entry.get("condition", 100))]

func _inject_runtime_gu(slot_index: int) -> void:
	if current_screen != "combat" or not combat_active:
		return
	if combat_injection_cooldown > 0.0:
		_combat_log("运行时注入冷却中。")
		return
	var move: Dictionary = state.get_active_killer_move()
	var ids := _combat_injection_candidates(move)
	if slot_index < 0 or slot_index >= ids.size():
		_combat_log("注入槽为空。")
		return
	var gu_id := String(ids[slot_index])
	var def: Dictionary = GameState.GU_DEFINITIONS.get(gu_id, {})
	var tag := String(def.get("tag", ""))
	if combat_projectiles.is_empty() and tag != "guard":
		_combat_log("当前没有可注入的运行杀招。")
		return
	var cost: int = max(25, int(round(float(def.get("spirit_cost", 40)) * 0.55)) + 18)
	if state.get_resource("spirit_qi") < cost:
		_combat_log("灵气不足，无法注入 %s。" % String(def.get("name", gu_id)))
		return
	state.add_resource("spirit_qi", -cost)
	var active_plugins: Array = move.get("plugins", [])
	var entry: Dictionary = ApertureService.runtime_degrade_gu(state, gu_id, 5 + slot_index * 2 + int(combat_overload) / 12)
	var condition := int(entry.get("condition", 100))
	var overload_gain := 4
	if not active_plugins.has(gu_id):
		overload_gain += 9
	if condition < 35:
		overload_gain += 12
	combat_overload = clampf(combat_overload + float(overload_gain), 0.0, 100.0)
	_apply_runtime_injection(gu_id, tag)
	_add_combat_effect("runtime_injection", combat_player_pos, Vector2(118, 118), 0.32, Color(0.45, 1.0, 0.92, 0.74))
	combat_injection_cooldown = 0.75 + combat_overload * 0.012
	_push_runtime_history(gu_id, overload_gain)
	if combat_overload >= 65.0:
		var damage := int(ceil((combat_overload - 52.0) * 0.42))
		state.character["hp"] = max(1, int(state.character.get("hp", 100)) - damage)
		_add_combat_effect("matrix_overload", combat_player_pos, Vector2(170, 170), 0.52, Color(1.0, 0.24, 0.18, 0.88))
		_combat_log("矩阵过载 %d%%，反噬 %d 生命。" % [int(combat_overload), damage])
	_combat_log("运行时注入：%s。" % String(def.get("name", gu_id)))
	_refresh_combat_bars()

func _apply_runtime_injection(gu_id: String, tag: String) -> void:
	match tag:
		"homing":
			for i in range(combat_projectiles.size()):
				var projectile: Dictionary = combat_projectiles[i]
				projectile["homing"] = true
				projectile["speed"] = max(780.0, float(projectile.get("speed", 760.0)) + 90.0)
				var vel: Vector2 = projectile.get("vel", Vector2.RIGHT)
				if vel.length() > 0.01:
					projectile["vel"] = vel.normalized() * float(projectile["speed"])
				combat_projectiles[i] = projectile
		"split":
			var clones: Array = []
			var source_count: int = min(4, combat_projectiles.size())
			for i in range(source_count):
				var source_index := combat_projectiles.size() - 1 - i
				var base: Dictionary = combat_projectiles[source_index]
				for angle in [-0.26, 0.26]:
					var clone: Dictionary = base.duplicate(true)
					var vel: Vector2 = clone.get("vel", combat_player_facing * 760.0)
					clone["vel"] = vel.rotated(float(angle))
					clone["damage"] = max(45, int(round(float(clone.get("damage", 90)) * 0.68)))
					clone["life"] = max(0.45, float(clone.get("life", 1.0)) - 0.12)
					clones.append(clone)
			for clone in clones:
				combat_projectiles.append(clone)
		"pierce":
			for i in range(combat_projectiles.size()):
				var projectile: Dictionary = combat_projectiles[i]
				projectile["pierce"] = true
				projectile["damage"] = int(round(float(projectile.get("damage", 90)) * 1.12))
				projectile["radius"] = float(projectile.get("radius", 32.0)) + 5.0
				combat_projectiles[i] = projectile
		"crit":
			for i in range(combat_projectiles.size()):
				var projectile: Dictionary = combat_projectiles[i]
				projectile["crit"] = true
				projectile["damage"] = int(round(float(projectile.get("damage", 90)) * 1.18))
				projectile["life"] = float(projectile.get("life", 1.0)) + 0.22
				combat_projectiles[i] = projectile
		"guard":
			combat_overload = max(0.0, combat_overload - 18.0)
			state.character["hp"] = min(int(state.character.get("max_hp", 100)), int(state.character.get("hp", 100)) + 8)
			_add_combat_effect("defense_barrier", combat_player_pos, Vector2(185, 185), 0.62, Color(0.55, 1.0, 0.86, 0.78))
		_:
			for i in range(combat_projectiles.size()):
				var projectile: Dictionary = combat_projectiles[i]
				projectile["damage"] = int(round(float(projectile.get("damage", 90)) * 1.08))
				combat_projectiles[i] = projectile

func _push_runtime_history(gu_id: String, overload_gain: int) -> void:
	if typeof(state.runtime_injection_history) != TYPE_ARRAY:
		state.runtime_injection_history = []
	state.runtime_injection_history.push_front({
		"month": int(state.world_month),
		"gu_id": gu_id,
		"overload_gain": overload_gain,
		"combat": CombatService.combat_title(combat_encounter)
	})
	while state.runtime_injection_history.size() > 18:
		state.runtime_injection_history.pop_back()

func _add_combat_effect(effect_id: String, position: Vector2, draw_size: Vector2, life: float, color: Color) -> void:
	combat_effects.append({
		"effect": effect_id,
		"pos": position,
		"size": draw_size,
		"life": life,
		"max_life": life,
		"color": color
	})

func _projectile_effect_for_move(move: Dictionary) -> String:
	var branch_effect := String(combat_encounter.get("effect", ""))
	if branch_effect == "fire_burst":
		return branch_effect
	var core_id := String(move.get("core", ""))
	var core_def: Dictionary = GameState.GU_DEFINITIONS.get(core_id, {})
	match String(core_def.get("school", "")):
		"奴道":
			return "beast_command"
		"炼道":
			return "refine_seal"
	return "sword_qi"

func _nearest_enemy_pos(from_pos: Vector2) -> Vector2:
	if combat_enemies.is_empty():
		return from_pos + Vector2.RIGHT
	var best: Vector2 = combat_enemies[0]["pos"]
	var best_dist := from_pos.distance_squared_to(best)
	for enemy in combat_enemies:
		var pos: Vector2 = enemy["pos"]
		var dist := from_pos.distance_squared_to(pos)
		if dist < best_dist:
			best = pos
			best_dist = dist
	return best

func _finish_combat(victory: bool) -> void:
	combat_active = false
	var result_text: String = DungeonService.apply_result(state, combat_encounter, victory)
	if victory:
		WorldClock.advance_months(state, 1, "战斗胜利")
		state.add_log("战斗胜利：%s。" % result_text)
		combat_message = "战斗胜利\n%s" % result_text
	else:
		var failure: Dictionary = combat_encounter.get("failure", {})
		WorldClock.advance_months(state, int(failure.get("months", 2)), "战斗失败")
		state.add_log("战斗失败：%s。" % result_text)
		combat_message = "战斗失败\n%s" % result_text
	SaveService.save_game(state)
	_build_combat_screen()

func _retreat_combat() -> void:
	combat_active = false
	WorldClock.advance_months(state, 1, "主动撤退")
	state.add_log("你撤出战场，失去本次收益。")
	SaveService.save_game(state)
	_show_aperture()

func _draw_combat_scene() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.015, 0.018, 0.018, 1.0), true)
	draw_rect(battle_rect.grow(14), Color(0.02, 0.025, 0.023, 1.0), true)
	var battle_texture: Texture2D = _get_texture(CombatService.combat_background(combat_encounter))
	if battle_texture != null:
		draw_texture_rect(battle_texture, battle_rect, false, Color(0.72, 0.72, 0.72, 1.0))
		draw_rect(battle_rect, Color(0.0, 0.0, 0.0, 0.22), true)
	else:
		draw_rect(battle_rect, Color(0.08, 0.08, 0.075, 1.0), true)
	for x in range(int(battle_rect.position.x), int(battle_rect.end.x), 64):
		draw_line(Vector2(x, battle_rect.position.y), Vector2(x, battle_rect.end.y), Color(0.18, 0.18, 0.16, 0.18), 1.0)
	for y in range(int(battle_rect.position.y), int(battle_rect.end.y), 64):
		draw_line(Vector2(battle_rect.position.x, y), Vector2(battle_rect.end.x, y), Color(0.18, 0.18, 0.16, 0.18), 1.0)
	for n in range(9):
		var p := battle_rect.position + Vector2(150 + n * 120, 120 + (n % 3) * 150)
		draw_circle(p, 34, Color(0.03, 0.035, 0.035, 0.45))
		draw_arc(p, 42, 0.0, TAU, 24, Color(0.32, 0.25, 0.18, 0.24), 2.0)
	draw_arc(combat_player_pos, 42, 0.0, TAU, 48, COLOR_CYAN, 3.0)
	var player_drawn := _draw_actor_sheet(_player_sheet_path(), combat_player_pos, Vector2(128, 128), combat_player_action, combat_player_facing, Color.WHITE)
	var player_texture: Texture2D = _get_texture(_character_image_path())
	if not player_drawn and player_texture != null:
		_draw_texture_centered(player_texture, combat_player_pos, Vector2(84, 84), 0.0, Color(1.0, 1.0, 1.0, 1.0))
	elif not player_drawn:
		draw_circle(combat_player_pos, 22, Color(0.08, 0.18, 0.18, 1.0))
		draw_circle(combat_player_pos, 10, COLOR_CYAN)
	var enemy_texture: Texture2D = _get_texture(String(CHARACTER_IMAGE_PATHS["enemy"]))
	for enemy in combat_enemies:
		var pos: Vector2 = enemy["pos"]
		var hp_ratio: float = clampf(float(enemy.get("hp", 0)) / float(enemy.get("max_hp", 1)), 0.0, 1.0)
		draw_arc(pos, 38, 0.0, TAU, 36, Color(0.65, 0.16, 0.14, 0.86), 3.0)
		var enemy_drawn := _draw_actor_sheet(String(CHARACTER_SHEET_PATHS.get(String(enemy.get("sheet", "enemy")), CHARACTER_SHEET_PATHS["enemy"])), pos, Vector2(118, 118), String(enemy.get("action", "walk")), enemy.get("facing", Vector2.LEFT), Color(1.0, 1.0, 1.0, 0.96))
		if not enemy_drawn and enemy_texture != null:
			_draw_texture_centered(enemy_texture, pos, Vector2(76, 76), 0.0, Color(1.0, 1.0, 1.0, 0.96))
		elif not enemy_drawn:
			draw_circle(pos, 21, Color(0.18, 0.04, 0.05, 1.0))
			draw_circle(pos, 9, COLOR_RED)
		draw_rect(Rect2(pos + Vector2(-34, -48), Vector2(68, 6)), Color(0.10, 0.04, 0.03, 1.0), true)
		draw_rect(Rect2(pos + Vector2(-34, -48), Vector2(68 * hp_ratio, 6)), COLOR_RED, true)
	for projectile in combat_projectiles:
		var pos: Vector2 = projectile["pos"]
		var vel: Vector2 = projectile["vel"]
		var projectile_effect := String(projectile.get("effect", "sword_qi"))
		var sword_texture: Texture2D = _get_texture(String(EFFECT_IMAGE_PATHS.get(projectile_effect, "")))
		var projectile_size := Vector2(132, 38)
		var projectile_frame := Vector2i(512, 128)
		var projectile_rotation := vel.angle()
		if projectile_effect == "fire_burst":
			projectile_size = Vector2(92, 92)
			projectile_frame = Vector2i(512, 512)
			projectile_rotation = 0.0
		elif projectile_effect == "beast_command" or projectile_effect == "refine_seal":
			projectile_size = Vector2(82, 82)
			projectile_frame = Vector2i(256, 256)
			projectile_rotation = 0.0
		if _draw_effect_sheet_frame(String(EFFECT_SHEET_PATHS.get(projectile_effect, EFFECT_SHEET_PATHS["sword_qi"])), pos, projectile_size, projectile_frame, 8, projectile_rotation, Color(0.92, 0.98, 1.0, 0.96)):
			pass
		elif sword_texture != null:
			_draw_texture_centered(sword_texture, pos, projectile_size, projectile_rotation, Color(0.92, 0.98, 1.0, 0.96))
		else:
			var tail := pos - vel.normalized() * 72.0
			draw_line(tail, pos, Color(0.78, 0.95, 1.0, 0.9), 5.0)
			draw_circle(pos, 7, Color(0.92, 0.98, 1.0, 1.0))
	for effect in combat_effects:
		var effect_id := String(effect.get("effect", ""))
		var effect_texture: Texture2D = _get_texture(String(EFFECT_IMAGE_PATHS.get(effect_id, "")))
		var effect_pos: Vector2 = effect["pos"]
		var effect_size: Vector2 = effect["size"]
		var life_ratio: float = clampf(float(effect.get("life", 0.0)) / max(0.01, float(effect.get("max_life", 1.0))), 0.0, 1.0)
		var effect_color: Color = effect.get("color", Color.WHITE)
		effect_color.a *= life_ratio
		var sheet_path: String = String(EFFECT_SHEET_PATHS.get(effect_id, ""))
		var frame_size := Vector2i(256, 256)
		var frame_count := 8
		if effect_id == "backlash":
			frame_size = Vector2i(512, 512)
			frame_count = 10
		if _draw_effect_sheet_frame(sheet_path, effect_pos, effect_size * (1.0 + (1.0 - life_ratio) * 0.35), frame_size, frame_count, 0.0, effect_color):
			continue
		if effect_texture != null:
			_draw_texture_centered(effect_texture, effect_pos, effect_size * (1.0 + (1.0 - life_ratio) * 0.35), 0.0, effect_color)
		else:
			draw_arc(effect_pos, max(effect_size.x, effect_size.y) * 0.35 * (1.0 + (1.0 - life_ratio)), 0.0, TAU, 42, effect_color, 3.0)
			draw_circle(effect_pos, max(4.0, effect_size.x * 0.08), Color(effect_color.r, effect_color.g, effect_color.b, effect_color.a * 0.45))

func _draw_texture_centered(texture: Texture2D, center: Vector2, draw_size: Vector2, rotation: float, color: Color) -> void:
	draw_set_transform(center, rotation, Vector2.ONE)
	draw_texture_rect(texture, Rect2(-draw_size * 0.5, draw_size), false, color)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _player_sheet_path() -> String:
	if create_gender == "女" or String(state.character.get("gender", "")) == "女":
		return String(CHARACTER_SHEET_PATHS["player_female"])
	return String(CHARACTER_SHEET_PATHS["player_male"])

func _draw_actor_sheet(sheet_path: String, foot_center: Vector2, draw_size: Vector2, action: String, facing_value, color: Color) -> bool:
	var texture: Texture2D = _get_texture(sheet_path)
	if texture == null:
		return false
	var facing := Vector2.RIGHT
	if typeof(facing_value) == TYPE_VECTOR2:
		facing = facing_value
	var action_name := action
	if not SPRITE_ACTION_ROW_OFFSET.has(action_name):
		action_name = "idle"
	var frame_count := 4 if action_name == "hit" else 8
	var frame := int(floor(combat_elapsed * 8.0)) % frame_count
	var direction_index := _sprite_direction_index(facing)
	var row := int(SPRITE_ACTION_ROW_OFFSET[action_name]) + direction_index
	var source_frame_size := _actor_sheet_frame_size(sheet_path)
	var src := Rect2(Vector2(frame * source_frame_size.x, row * source_frame_size.y), Vector2(source_frame_size.x, source_frame_size.y))
	var scale := draw_size.x / float(source_frame_size.x)
	var frame_size := Vector2(source_frame_size.x, source_frame_size.y) * scale
	var foot_anchor := Vector2(float(source_frame_size.x) * 0.5, float(source_frame_size.y) * (SPRITE_FOOT_ANCHOR.y / float(SPRITE_FRAME_SIZE.y)))
	var top_left := foot_center - foot_anchor * scale
	draw_texture_rect_region(texture, Rect2(top_left, frame_size), src, color)
	return true

func _actor_sheet_frame_size(sheet_path: String) -> Vector2i:
	if sheet_path.ends_with("enemy_elite_sheet.png") or sheet_path.find("/boss/") >= 0:
		return Vector2i(320, 320)
	return SPRITE_FRAME_SIZE

func _sprite_direction_index(direction: Vector2) -> int:
	if direction.length() < 0.01:
		return 2
	var sector := int(round(direction.angle() / (PI / 4.0))) % 8
	if sector < 0:
		sector += 8
	match sector:
		0:
			return 2
		1:
			return 1
		2:
			return 0
		3:
			return 7
		4:
			return 6
		5:
			return 5
		6:
			return 4
		_:
			return 3

func _draw_effect_sheet_frame(sheet_path: String, center: Vector2, draw_size: Vector2, frame_size: Vector2i, frame_count: int, rotation: float, color: Color) -> bool:
	var texture: Texture2D = _get_texture(sheet_path)
	if texture == null:
		return false
	var count: int = max(1, frame_count)
	var frame := int(floor(combat_elapsed * 14.0)) % count
	var src := Rect2(Vector2(frame * frame_size.x, 0), Vector2(frame_size.x, frame_size.y))
	draw_set_transform(center, rotation, Vector2.ONE)
	draw_texture_rect_region(texture, Rect2(-draw_size * 0.5, draw_size), src, color)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	return true

func _refresh_combat_bars() -> void:
	if combat_hp_bar != null:
		combat_hp_bar.value = int(state.character.get("hp", 0))
	if combat_cd_bar != null:
		combat_cd_bar.value = combat_cd_bar.max_value - combat_cooldown

func _combat_log(text: String) -> void:
	combat_logs.push_front(text)
	while combat_logs.size() > 10:
		combat_logs.pop_back()
	_refresh_combat_log()

func _refresh_combat_log() -> void:
	if combat_log_label == null:
		return
	combat_log_label.text = _join_strings(combat_logs, "\n")

func _save_and_log() -> void:
	state.add_log("手动保存。")
	SaveService.save_game(state)
	match current_screen:
		"aperture":
			_show_aperture()
		"cultivation":
			_show_cultivation()
		"refining":
			_show_refining()
		"killer":
			_show_killer_move()
		"market":
			_show_market()
		"npc":
			_show_npc()
		"story", "dungeon":
			_show_story()
		"combat":
			_build_combat_screen()
		_:
			pass

func _reset_to_create() -> void:
	SaveService.reset_save()
	state = GameState.new()
	create_name = "顾无生"
	_show_create()

func _panel_container(min_size: Vector2 = Vector2.ZERO, skin_path: String = "", content_margin: int = 14) -> PanelContainer:
	var panel := PanelContainer.new()
	var panel_skin: String = skin_path if skin_path != "" else String(UI_SKIN_PATHS["panel"])
	var textured_style = _style_texture(panel_skin, 48, content_margin)
	if textured_style != null:
		panel.add_theme_stylebox_override("panel", textured_style)
	else:
		panel.add_theme_stylebox_override("panel", _style_box(COLOR_PANEL, Color(0.52, 0.38, 0.18, 0.70), 2))
	if min_size != Vector2.ZERO:
		panel.custom_minimum_size = min_size
	return panel

func _floating_panel(title: String, rect: Rect2) -> PanelContainer:
	var panel := _panel_container(rect.size)
	panel.position = rect.position
	panel.size = rect.size
	add_child(panel)
	var box := _panel_body(panel)
	var label := _section_label(title)
	box.add_child(label)
	return panel

func _add_panel(parent: Control, title: String, min_size: Vector2 = Vector2.ZERO) -> VBoxContainer:
	var panel := _panel_container(min_size)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(panel)
	var box := _panel_body(panel)
	box.add_child(_panel_title_row(title))
	box.add_child(_divider())
	return box

func _panel_body(panel: PanelContainer) -> VBoxContainer:
	if panel.has_node("Margin/Body"):
		return panel.get_node("Margin/Body")
	var margin := MarginContainer.new()
	margin.name = "Margin"
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)
	var box := VBoxContainer.new()
	box.name = "Body"
	box.add_theme_constant_override("separation", 8)
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(box)
	return box

func _style_box(color: Color, border: Color, width: int = 1) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = border
	style.set_border_width_all(width)
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 4
	style.corner_radius_bottom_right = 4
	style.content_margin_left = 6
	style.content_margin_right = 6
	style.content_margin_top = 6
	style.content_margin_bottom = 6
	return style

func _style_texture(path: String, texture_margin: int = 40, content_margin: int = 8):
	var texture: Texture2D = _get_texture(path)
	if texture == null:
		return null
	var style := StyleBoxTexture.new()
	style.texture = texture
	style.texture_margin_left = texture_margin
	style.texture_margin_right = texture_margin
	style.texture_margin_top = texture_margin
	style.texture_margin_bottom = texture_margin
	style.content_margin_left = content_margin
	style.content_margin_right = content_margin
	style.content_margin_top = content_margin
	style.content_margin_bottom = content_margin
	style.draw_center = true
	return style

func _progress_fill_path(color: Color) -> String:
	if color == COLOR_RED or color.r > 0.80 and color.g < 0.45:
		return String(PROGRESS_UI_PATHS["fill_red"])
	if color == COLOR_GOLD or color.r > 0.75 and color.g > 0.55 and color.b < 0.55:
		return String(PROGRESS_UI_PATHS["fill_gold"])
	return String(PROGRESS_UI_PATHS["fill_cyan"])

func _apply_progress_skin(bar: ProgressBar, fill_path: String = "", track_path: String = "") -> void:
	var track_style = _style_texture(track_path if track_path != "" else String(PROGRESS_UI_PATHS["track"]), 18, 0)
	if track_style != null:
		bar.add_theme_stylebox_override("background", track_style)
	var fill_style = _style_texture(fill_path if fill_path != "" else String(PROGRESS_UI_PATHS["fill_cyan"]), 16, 0)
	if fill_style != null:
		bar.add_theme_stylebox_override("fill", fill_style)
	bar.add_theme_font_size_override("font_size", 1)

func _texture_progress_bar(value: float, max_value: float, fill_path: String, track_path: String, min_size: Vector2, margin: int = 16) -> Control:
	var track_texture: Texture2D = _get_texture(track_path)
	var fill_texture: Texture2D = _get_texture(fill_path)
	if track_texture != null and fill_texture != null:
		var bar := TextureProgressBar.new()
		bar.custom_minimum_size = min_size
		bar.min_value = 0.0
		bar.max_value = max(0.01, max_value)
		bar.value = clampf(value, 0.0, bar.max_value)
		bar.texture_under = track_texture
		bar.texture_progress = fill_texture
		bar.nine_patch_stretch = true
		bar.stretch_margin_left = margin
		bar.stretch_margin_right = margin
		bar.stretch_margin_top = min(8, margin)
		bar.stretch_margin_bottom = min(8, margin)
		return bar
	var fallback := ProgressBar.new()
	fallback.custom_minimum_size = min_size
	fallback.max_value = max(0.01, max_value)
	fallback.value = clampf(value, 0.0, fallback.max_value)
	fallback.show_percentage = false
	_apply_progress_skin(fallback, fill_path, track_path)
	return fallback

func _button(text: String, callback: Callable, pressed_style: bool = false) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(120, 42)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.pressed.connect(callback)
	var color := Color(0.13, 0.095, 0.045, 0.58) if not pressed_style else Color(0.08, 0.25, 0.22, 0.72)
	_apply_button_skin(button, String(UI_SKIN_PATHS["button_active"]) if pressed_style else String(UI_SKIN_PATHS["button"]), String(UI_SKIN_PATHS["button_hover"]), String(UI_SKIN_PATHS["button_active"]), 40)
	if not button.has_theme_stylebox_override("normal"):
		button.add_theme_stylebox_override("normal", _style_box(color, COLOR_GOLD, 1))
	if not button.has_theme_stylebox_override("hover"):
		button.add_theme_stylebox_override("hover", _style_box(Color(0.18, 0.14, 0.06, 0.76), COLOR_CYAN, 1))
	button.add_theme_color_override("font_color", COLOR_GOLD if not pressed_style else COLOR_CYAN)
	_apply_font(button)
	return button

func _nav_button(text: String, callback: Callable, pressed_style: bool = false) -> Button:
	var button := _button(text, callback, pressed_style)
	button.custom_minimum_size = Vector2(120, 48)
	var normal_path: String = String(UI_SKIN_PATHS["button_active"]) if pressed_style else String(UI_SKIN_PATHS["nav_tab"])
	_apply_button_skin(button, normal_path, String(UI_SKIN_PATHS["button_hover"]), String(UI_SKIN_PATHS["button_active"]), 36)
	return button

func _icon_nav_button(icon_key: String, callback: Callable) -> Button:
	var button := _nav_button("", callback, false)
	button.custom_minimum_size = Vector2(54, 48)
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	if icon_key == "settings":
		_apply_button_skin(button, String(HUD_UI_PATHS["settings_frame"]), String(UI_SKIN_PATHS["button_hover"]), String(HUD_UI_PATHS["settings_frame"]), 24)
	button.icon = _get_texture(String(UI_ICON_PATHS.get(icon_key, "")))
	button.expand_icon = true
	button.add_theme_constant_override("icon_max_width", 30)
	return button

func _apply_button_skin(button: Button, normal_path: String, hover_path: String, pressed_path: String, margin: int = 40) -> void:
	var normal_style = _style_texture(normal_path, margin, 10)
	if normal_style != null:
		button.add_theme_stylebox_override("normal", normal_style)
	var hover_style = _style_texture(hover_path, margin, 10)
	if hover_style != null:
		button.add_theme_stylebox_override("hover", hover_style)
	var pressed_style = _style_texture(pressed_path, margin, 10)
	if pressed_style != null:
		button.add_theme_stylebox_override("pressed", pressed_style)
		button.add_theme_stylebox_override("focus", pressed_style)

func _choice_button(text: String, selected: bool, callback: Callable) -> Button:
	return _button(("◆ " if selected else "◇ ") + text, callback, selected)

func _recipe_choice_button(recipe_id: String, recipe: Dictionary, selected: bool, callback: Callable) -> Button:
	var result_id: String = String(recipe.get("result", ""))
	var button := _button(("◆ " if selected else "◇ ") + String(recipe.get("name", recipe_id)), callback, selected)
	button.custom_minimum_size = Vector2(120, 58)
	_apply_button_skin(button, String(UI_SKIN_PATHS["button_active"]) if selected else String(REFINING_UI_PATHS["recipe_card"]), String(UI_SKIN_PATHS["button_hover"]), String(UI_SKIN_PATHS["button_active"]), 34)
	button.icon = _get_texture(String(GU_ICON_PATHS.get(result_id, "")))
	button.expand_icon = true
	button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.add_theme_constant_override("icon_max_width", 42)
	return button

func _gu_choice_button(gu_id: String, text: String, selected: bool, callback: Callable) -> Button:
	var button := _button(("◆ " if selected else "◇ ") + text, callback, selected)
	button.custom_minimum_size = Vector2(120, 54)
	_apply_button_skin(button, String(KILLER_UI_PATHS["gu_tile_selected"]) if selected else String(KILLER_UI_PATHS["gu_tile"]), String(KILLER_UI_PATHS["gu_tile_selected"]), String(KILLER_UI_PATHS["gu_tile_selected"]), 34)
	button.icon = _get_texture(String(GU_ICON_PATHS.get(gu_id, "")))
	button.expand_icon = true
	button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.add_theme_constant_override("icon_max_width", 42)
	return button

func _market_post_button(post: Dictionary, selected: bool, callback: Callable) -> Button:
	var button_text: String = "%s\n价格 %d｜%s x%d｜风险 %d%%｜可信 %d%%" % [
		MarketService.post_label(state, post),
		int(post.get("price", 0)),
		MarketService.resource_name(String(post.get("resource_id", ""))),
		int(post.get("quantity", 0)),
		int(post.get("risk", 0)),
		int(post.get("truthfulness", 0))
	]
	var button := _button(button_text, callback, selected)
	button.custom_minimum_size = Vector2(120, 72)
	_apply_button_skin(button, String(UI_SKIN_PATHS["button_active"]) if selected else String(MARKET_UI_PATHS["post_card"]), String(UI_SKIN_PATHS["button_hover"]), String(UI_SKIN_PATHS["button_active"]), 34)
	button.icon = _get_texture(String(RESOURCE_ICON_PATHS.get(String(post.get("resource_id", "")), "res://assets/ui/icons/intel_scroll.png")))
	button.expand_icon = true
	button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.add_theme_constant_override("icon_max_width", 44)
	return button

func _npc_list_button(npc: Dictionary, selected: bool, callback: Callable) -> Button:
	var text := "%s｜%s\n关系 %d｜信任 %d｜紧迫 %d" % [
		String(npc.get("name", "匿名")),
		_faction_name(String(npc.get("faction", ""))),
		int(npc.get("relation", 0)),
		int(npc.get("trust", 0)),
		int(npc.get("urgency", 0))
	]
	var button := _button(text, callback, selected)
	button.custom_minimum_size = Vector2(120, 76)
	var skin_path: String = String(NPC_UI_PATHS["list_item_selected"]) if selected else String(NPC_UI_PATHS["list_item"])
	_apply_button_skin(button, skin_path, String(NPC_UI_PATHS["list_item_selected"]), String(NPC_UI_PATHS["list_item_selected"]), 36)
	return button

func _killer_action_button(text: String, callback: Callable, primary: bool, icon_key: String = "") -> Button:
	var button := _button(text, callback, primary)
	button.custom_minimum_size = Vector2(0, 66)
	var path: String = String(KILLER_UI_PATHS["action_save"]) if primary else String(KILLER_UI_PATHS["action_default"])
	_apply_button_skin(button, path, String(UI_SKIN_PATHS["button_hover"]), path, 34)
	button.add_theme_font_size_override("font_size", 22)
	if icon_key != "":
		button.icon = _get_texture(String(UI_ICON_PATHS.get(icon_key, "")))
		button.expand_icon = true
		button.add_theme_constant_override("icon_max_width", 34)
	return button

func _killer_result_row(label_text: String, value: int, color: Color, icon_key: String = "") -> PanelContainer:
	var panel := _panel_container(Vector2(0, 70), String(KILLER_UI_PATHS["result_row"]), 0)
	var canvas := Control.new()
	canvas.custom_minimum_size = Vector2(0, 70)
	panel.add_child(canvas)
	if icon_key != "":
		var icon := _texture_rect(String(UI_ICON_PATHS.get(icon_key, "")), TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
		_place_control(canvas, icon, Vector2(0.07, 0.52), Vector2(34, 34))
	var label := Label.new()
	label.text = label_text
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color(0.82, 0.78, 0.66, 1.0))
	_place_control(canvas, label, Vector2(0.16, 0.52), Vector2(112, 34))
	var bar := _texture_progress_bar(float(value), 100.0, _progress_fill_path(color), String(PROGRESS_UI_PATHS["track"]), Vector2(210, 12), 16)
	_place_control(canvas, bar, Vector2(0.55, 0.52), Vector2(210, 12))
	var value_label := Label.new()
	value_label.text = "%d%%" % value
	value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value_label.add_theme_font_size_override("font_size", 22)
	value_label.add_theme_color_override("font_color", color)
	_place_control(canvas, value_label, Vector2(0.90, 0.52), Vector2(70, 34))
	return panel

func _killer_diagnosis_box(move: Dictionary) -> PanelContainer:
	var risk: int = int(move.get("risk", 0))
	var stability: int = int(move.get("stability", 0))
	var path: String = String(KILLER_UI_PATHS["diagnosis_ok"])
	var text := "矩阵稳定：可投入实战。"
	if risk >= 45:
		path = String(KILLER_UI_PATHS["diagnosis_danger"])
		text = "异常风险偏高：释放时可能反噬。"
	elif stability < 70:
		path = String(KILLER_UI_PATHS["diagnosis_warning"])
		text = "稳定度不足：建议加入稳固类辅助蛊。"
	var panel := _panel_container(Vector2(0, 92), path)
	var box := _panel_body(panel)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	box.add_child(row)
	var icon_key := "info_blue"
	if risk >= 45:
		icon_key = "warning_red"
	elif stability < 70:
		icon_key = "warning_yellow"
	row.add_child(_image_or_placeholder(String(UI_ICON_PATHS[icon_key]), "", Color(0.0, 0.0, 0.0, 0.0), Vector2(34, 34)))
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_color_override("font_color", COLOR_RED if risk >= 45 else (COLOR_GOLD if stability < 70 else COLOR_CYAN))
	row.add_child(label)
	return panel

func _killer_preview_card() -> PanelContainer:
	var panel := _panel_container(Vector2(0, 138), String(KILLER_UI_PATHS["combat_preview"]), 0)
	var canvas := Control.new()
	canvas.custom_minimum_size = Vector2(0, 138)
	panel.add_child(canvas)
	var preview := _texture_rect(String(SCREEN_BACKGROUND_PATHS["combat"]), TextureRect.STRETCH_KEEP_ASPECT_COVERED)
	preview.modulate = Color(0.72, 0.72, 0.72, 0.72)
	preview.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(preview)
	var shade := ColorRect.new()
	shade.color = Color(0.0, 0.0, 0.0, 0.36)
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(shade)
	var title := Label.new()
	title.text = "预览（战场模拟）"
	title.add_theme_color_override("font_color", COLOR_GOLD)
	_apply_font(title)
	_place_control(canvas, title, Vector2(0.22, 0.18), Vector2(180, 26))
	var play := _texture_rect(String(UI_ICON_PATHS["play_preview"]), TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	_place_control(canvas, play, Vector2(0.88, 0.74), Vector2(44, 44))
	return panel

func _school_choice_control(school: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	row.add_child(_image_or_placeholder(_school_icon_path(school), school, Color(0.06, 0.08, 0.08, 0.0), Vector2(42, 42)))
	row.add_child(_choice_button(school, create_school == school, Callable(self, "_set_create_school").bind(school)))
	return row

func _school_icon_path(school: String) -> String:
	match school:
		"剑道":
			return String(GU_ICON_PATHS["sword_core"])
		"炼道":
			return String(GU_ICON_PATHS["refine_core"])
		"奴道":
			return String(GU_ICON_PATHS["enslave_core"])
		"智道":
			return String(GU_ICON_PATHS["wisdom_core"])
		"运道":
			return String(GU_ICON_PATHS["luck_core"])
		_:
			return ""

func _section_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_color", COLOR_GOLD)
	_apply_font(label, true)
	return label

func _panel_title_row(text: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	var corner_texture: Texture2D = _get_texture(String(UI_SKIN_PATHS["corner"]))
	if corner_texture != null:
		var corner := TextureRect.new()
		corner.texture = corner_texture
		corner.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		corner.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		corner.custom_minimum_size = Vector2(26, 26)
		row.add_child(corner)
	var label := _section_label(text)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(label)
	var help_texture: Texture2D = _get_texture(String(UI_ICON_PATHS["help"]))
	if help_texture != null:
		var help := TextureRect.new()
		help.texture = help_texture
		help.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		help.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		help.custom_minimum_size = Vector2(26, 26)
		row.add_child(help)
	return row

func _divider() -> Control:
	var texture: Texture2D = _get_texture(String(UI_SKIN_PATHS["divider"]))
	if texture != null:
		var rect := TextureRect.new()
		rect.texture = texture
		rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		rect.stretch_mode = TextureRect.STRETCH_SCALE
		rect.custom_minimum_size = Vector2(0, 8)
		rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		return rect
	var line := ColorRect.new()
	line.color = Color(0.52, 0.38, 0.18, 0.42)
	line.custom_minimum_size = Vector2(0, 1)
	line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return line

func _text_line(label_text: String, value: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	var label := Label.new()
	label.text = label_text
	label.add_theme_color_override("font_color", Color(0.72, 0.68, 0.58, 1.0))
	label.custom_minimum_size = Vector2(145, 0)
	_apply_font(label)
	row.add_child(label)
	var value_label := Label.new()
	value_label.text = value
	value_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	value_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	value_label.add_theme_color_override("font_color", Color(0.88, 0.82, 0.68, 1.0))
	_apply_font(value_label)
	row.add_child(value_label)
	return row

func _icon_text_line(label_text: String, value: String, icon_key: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	var icon := _texture_rect(String(UI_ICON_PATHS.get(icon_key, "")), TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	icon.custom_minimum_size = Vector2(28, 28)
	row.add_child(icon)
	var text := _text_line(label_text, value)
	text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(text)
	return row

func _warning_line(text: String) -> Label:
	var label := Label.new()
	label.text = "⚠ " + text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_color_override("font_color", COLOR_RED)
	_apply_font(label)
	return label

func _dialogue_line(name_text: String, text: String) -> Label:
	var label := Label.new()
	label.text = "%s：%s" % [name_text, text]
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 22)
	label.add_theme_color_override("font_color", Color(0.88, 0.82, 0.72, 1.0))
	_apply_font(label)
	return label

func _npc_portrait_view(path: String, display_name: String) -> Control:
	var wrap := CenterContainer.new()
	wrap.custom_minimum_size = Vector2(0, 250)
	wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var panel := _panel_container(Vector2(360, 240), String(NPC_UI_PATHS["portrait_frame"]), 0)
	panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var canvas := Control.new()
	canvas.custom_minimum_size = Vector2(0, 240)
	panel.add_child(canvas)
	var portrait := _texture_rect(path, TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	_place_control(canvas, portrait, Vector2(0.50, 0.50), Vector2(220, 220))
	var label := Label.new()
	label.text = display_name
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", COLOR_GOLD)
	_apply_font(label, true)
	_place_control(canvas, label, Vector2(0.50, 0.90), Vector2(260, 28))
	wrap.add_child(panel)
	return wrap

func _labeled_control(label_text: String, control: Control) -> VBoxContainer:
	var box := VBoxContainer.new()
	var label := Label.new()
	label.text = label_text
	label.add_theme_color_override("font_color", COLOR_CYAN)
	box.add_child(label)
	box.add_child(control)
	return box

func _metric(label_text: String, value: int, color: Color) -> VBoxContainer:
	var box := VBoxContainer.new()
	var row := HBoxContainer.new()
	var label := Label.new()
	label.text = label_text
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_color_override("font_color", Color(0.82, 0.78, 0.66, 1.0))
	row.add_child(label)
	var value_label := Label.new()
	value_label.text = "%d%%" % value
	value_label.add_theme_font_size_override("font_size", 22)
	value_label.add_theme_color_override("font_color", color)
	row.add_child(value_label)
	box.add_child(row)
	var bar := ProgressBar.new()
	bar.max_value = 100
	bar.value = clampi(value, 0, 100)
	bar.show_percentage = false
	bar.custom_minimum_size = Vector2(0, 14)
	_apply_progress_skin(bar, _progress_fill_path(color))
	box.add_child(bar)
	return box

func _aperture_metric(label_text: String, value: int, color: Color) -> PanelContainer:
	var panel := _panel_container(Vector2(0, 82), String(APERTURE_UI_PATHS["metric_row"]), 0)
	var canvas := Control.new()
	canvas.custom_minimum_size = Vector2(0, 82)
	panel.add_child(canvas)
	var label := Label.new()
	label.text = label_text
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color(0.86, 0.82, 0.70, 1.0))
	_apply_font(label)
	_place_control(canvas, label, Vector2(0.26, 0.30), Vector2(220, 28))
	var value_label := Label.new()
	value_label.text = "%d%%" % value
	value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	value_label.add_theme_font_size_override("font_size", 22)
	value_label.add_theme_color_override("font_color", color)
	_apply_font(value_label)
	_place_control(canvas, value_label, Vector2(0.88, 0.30), Vector2(90, 30))
	var bar := _texture_progress_bar(float(value), 100.0, _progress_fill_path(color), String(PROGRESS_UI_PATHS["track"]), Vector2(390, 14), 16)
	_place_control(canvas, bar, Vector2(0.50, 0.70), Vector2(390, 14))
	return panel

func _npc_relation_metric(label_text: String, value: int, color: Color) -> PanelContainer:
	var panel := _panel_container(Vector2(0, 70), String(NPC_UI_PATHS["relation_bar"]), 0)
	var canvas := Control.new()
	canvas.custom_minimum_size = Vector2(0, 70)
	panel.add_child(canvas)
	var label := Label.new()
	label.text = label_text
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color(0.82, 0.78, 0.66, 1.0))
	_apply_font(label)
	_place_control(canvas, label, Vector2(0.16, 0.50), Vector2(110, 34))
	var fill_path: String = String(NPC_UI_PATHS["relation_fill_red"]) if color == COLOR_RED or value >= 70 and label_text == "紧迫" else String(NPC_UI_PATHS["relation_fill_cyan"])
	var bar := _texture_progress_bar(float(value), 100.0, fill_path, String(NPC_UI_PATHS["relation_track"]), Vector2(330, 18), 16)
	_place_control(canvas, bar, Vector2(0.57, 0.50), Vector2(330, 18))
	var value_label := Label.new()
	value_label.text = "%d%%" % value
	value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value_label.add_theme_font_size_override("font_size", 20)
	value_label.add_theme_color_override("font_color", color)
	_apply_font(value_label)
	_place_control(canvas, value_label, Vector2(0.88, 0.50), Vector2(72, 32))
	return panel

func _node_card(node: Dictionary) -> PanelContainer:
	var panel := _panel_container(Vector2(350, 128))
	var box := _panel_body(panel)
	box.add_child(_text_line(String(node.get("name", "节点")), "Lv.%d" % int(node.get("level", 1))))
	box.add_child(_text_line("状态", String(node.get("status", "稳定"))))
	box.add_child(_metric("压力", int(node.get("pressure", 0)), COLOR_RED if int(node.get("pressure", 0)) > 70 else COLOR_CYAN))
	return panel

func _aperture_node_map(nodes: Array) -> Control:
	var map := Control.new()
	map.custom_minimum_size = Vector2(0, 640)
	map.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var texture_panel := TextureRect.new()
	texture_panel.texture = _get_texture(String(SCREEN_BACKGROUND_PATHS["aperture"]))
	texture_panel.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_panel.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	texture_panel.modulate = Color(0.75, 0.75, 0.75, 0.62)
	texture_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	map.add_child(texture_panel)
	var veil := ColorRect.new()
	veil.color = Color(0.0, 0.0, 0.0, 0.18)
	veil.set_anchors_preset(Control.PRESET_FULL_RECT)
	map.add_child(veil)
	var core_ratio: Vector2 = APERTURE_NODE_POSITIONS.get("仙窍核心", Vector2(0.50, 0.48))
	for node in nodes:
		var name_for_line := String(node.get("name", "节点"))
		var pos_for_line: Vector2 = APERTURE_NODE_POSITIONS.get(name_for_line, Vector2(0.5, 0.5))
		if pos_for_line != core_ratio:
			map.add_child(_aperture_connector(core_ratio, pos_for_line))
	for node in nodes:
		var name := String(node.get("name", "节点"))
		var pos_ratio: Vector2 = APERTURE_NODE_POSITIONS.get(name, Vector2(0.5, 0.5))
		var beacon := _texture_rect(String(APERTURE_UI_PATHS["node_beacon"]), TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
		beacon.modulate = Color(0.80, 1.0, 0.94, 0.48)
		_place_control(map, beacon, pos_ratio, Vector2(138, 138))
		var marker := _aperture_node_marker(node)
		marker.anchor_left = pos_ratio.x
		marker.anchor_top = pos_ratio.y
		marker.anchor_right = pos_ratio.x
		marker.anchor_bottom = pos_ratio.y
		marker.offset_left = -96
		marker.offset_top = -48
		marker.offset_right = 96
		marker.offset_bottom = 48
		map.add_child(marker)
	return map

func _aperture_connector(from_ratio: Vector2, to_ratio: Vector2) -> Control:
	var line: Control = _texture_rect(String(APERTURE_UI_PATHS["node_connector"]), TextureRect.STRETCH_SCALE)
	var diff := to_ratio - from_ratio
	var center := from_ratio + diff * 0.5
	var length := diff.length() * 640.0
	line.rotation = diff.angle()
	line.modulate = Color(0.70, 1.0, 0.94, 0.42)
	line.anchor_left = center.x
	line.anchor_right = center.x
	line.anchor_top = center.y
	line.anchor_bottom = center.y
	line.offset_left = -length * 0.5
	line.offset_right = length * 0.5
	line.offset_top = -8
	line.offset_bottom = 8
	line.pivot_offset = Vector2(length * 0.5, 8)
	return line

func _aperture_node_marker(node: Dictionary) -> PanelContainer:
	var pressure: int = int(node.get("pressure", 0))
	var status := String(node.get("status", "稳定"))
	var border := COLOR_RED if pressure >= 75 else (COLOR_GOLD if pressure >= 60 else COLOR_CYAN)
	var skin_key := "node_marker_stable"
	if pressure >= 75:
		skin_key = "node_marker_danger"
	elif pressure >= 60:
		skin_key = "node_marker_warning"
	var panel := _panel_container(Vector2(192, 96), String(APERTURE_UI_PATHS[skin_key]), 8)
	var box := _panel_body(panel)
	var name_label := Label.new()
	name_label.text = "%s  Lv.%d" % [String(node.get("name", "节点")), int(node.get("level", 1))]
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_color_override("font_color", COLOR_GOLD)
	box.add_child(name_label)
	var state_label := Label.new()
	state_label.text = "%s / 压力 %d%%" % [status, pressure]
	state_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	state_label.add_theme_color_override("font_color", border)
	box.add_child(state_label)
	var bar := ProgressBar.new()
	bar.max_value = 100
	bar.value = pressure
	bar.show_percentage = false
	bar.custom_minimum_size = Vector2(0, 10)
	_apply_progress_skin(bar, _progress_fill_path(border))
	box.add_child(bar)
	return panel

func _gu_ecology_list() -> VBoxContainer:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	for row in ApertureService.ecology_rows(state, 4):
		box.add_child(_gu_ecology_row(row))
	if box.get_child_count() == 0:
		box.add_child(_text_line("生态链", "暂无蛊虫服务"))
	return box

func _gu_ecology_row(row_data: Dictionary) -> PanelContainer:
	var food := int(row_data.get("food", 100))
	var condition := int(row_data.get("condition", 100))
	var status := String(row_data.get("status", "稳定"))
	var color := COLOR_RED if food < 30 or condition < 35 else (COLOR_GOLD if food < 55 or condition < 65 else COLOR_CYAN)
	var panel := _panel_container(Vector2(0, 86), String(ECOLOGY_UI_PATHS["row"]), 6)
	var canvas := Control.new()
	canvas.custom_minimum_size = Vector2(0, 86)
	panel.add_child(canvas)
	var icon := _texture_rect(String(GU_ICON_PATHS.get(String(row_data.get("id", "")), "")), TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	_place_control(canvas, icon, Vector2(0.08, 0.50), Vector2(54, 54))
	if bool(row_data.get("critical", false)):
		var critical_icon := _texture_rect(String(ECOLOGY_UI_PATHS["critical_icon"]), TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
		critical_icon.modulate = Color(1.0, 0.82, 0.48, 0.95)
		_place_control(canvas, critical_icon, Vector2(0.13, 0.28), Vector2(24, 24))
	var name_label := Label.new()
	name_label.text = "%s / %s" % [String(row_data.get("name", row_data.get("id", ""))), String(row_data.get("node", "节点"))]
	name_label.add_theme_color_override("font_color", COLOR_GOLD)
	_apply_font(name_label)
	_place_control(canvas, name_label, Vector2(0.36, 0.26), Vector2(330, 24))
	var status_label := Label.new()
	status_label.text = "%s  饱食%d%%  健康%d%%" % [status, food, condition]
	status_label.add_theme_color_override("font_color", color)
	_apply_font(status_label)
	_place_control(canvas, status_label, Vector2(0.36, 0.55), Vector2(330, 24))
	var food_bar := _texture_progress_bar(float(food), 100.0, _progress_fill_path(color), String(PROGRESS_UI_PATHS["track"]), Vector2(145, 10), 12)
	_place_control(canvas, food_bar, Vector2(0.73, 0.38), Vector2(145, 10))
	var condition_bar := _texture_progress_bar(float(condition), 100.0, _progress_fill_path(color), String(PROGRESS_UI_PATHS["track"]), Vector2(145, 10), 12)
	_place_control(canvas, condition_bar, Vector2(0.73, 0.66), Vector2(145, 10))
	return panel

func _hero_placeholder(text: String, color: Color, min_size: Vector2) -> ColorRect:
	var rect := ColorRect.new()
	rect.color = color
	rect.custom_minimum_size = min_size
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.add_theme_font_size_override("font_size", 30)
	label.add_theme_color_override("font_color", COLOR_GOLD)
	rect.add_child(label)
	return rect

func _image_or_placeholder(path: String, text: String, color: Color, min_size: Vector2) -> Control:
	var texture: Texture2D = _get_texture(path)
	if texture == null:
		return _hero_placeholder(text, color, min_size)
	var rect := TextureRect.new()
	rect.texture = texture
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	rect.custom_minimum_size = min_size
	rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
	return rect

func _get_texture(path: String) -> Texture2D:
	if path == "" or not ResourceLoader.exists(path):
		return null
	if not texture_cache.has(path):
		texture_cache[path] = load(path) as Texture2D
	return texture_cache[path] as Texture2D

func _get_font(path: String) -> Font:
	if path == "" or not ResourceLoader.exists(path):
		return null
	if not font_cache.has(path):
		font_cache[path] = load(path) as Font
	return font_cache[path] as Font

func _apply_font(control: Control, title_font: bool = false) -> void:
	var path := String(FONT_PATHS["title"] if title_font else FONT_PATHS["ui"])
	var font: Font = _get_font(path)
	if font != null:
		control.add_theme_font_override("font", font)

func _character_image_path() -> String:
	if create_gender == "女" or String(state.character.get("gender", "")) == "女":
		return "res://assets/characters/player_female.png"
	return "res://assets/characters/player_male.png"

func _matrix_preview(move: Dictionary) -> PanelContainer:
	var panel := _panel_container(Vector2(0, 520), String(UI_SKIN_PATHS["inner_panel"]))
	var box := _panel_body(panel)
	var title := Label.new()
	title.text = String(move.get("name", "未命名杀招"))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", COLOR_CYAN)
	box.add_child(title)
	box.add_child(_killer_matrix_canvas(move))
	return panel

func _killer_matrix_canvas(move: Dictionary) -> Control:
	var canvas := Control.new()
	canvas.custom_minimum_size = Vector2(0, 430)
	canvas.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var bg := _texture_rect(String(KILLER_UI_PATHS["matrix_bg"]), TextureRect.STRETCH_KEEP_ASPECT_COVERED)
	bg.modulate = Color(1.0, 1.0, 1.0, 0.86)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(bg)

	var core_id: String = String(move.get("core", ""))
	var plugins: Array = move.get("plugins", [])
	var center := Vector2(0.50, 0.50)
	var slot_positions := [Vector2(0.50, 0.18), Vector2(0.78, 0.50), Vector2(0.50, 0.82), Vector2(0.22, 0.50)]
	var line_rotations := [-PI / 2.0, 0.0, PI / 2.0, PI]
	for i in range(slot_positions.size()):
		var line := _texture_rect(String(KILLER_UI_PATHS["connection_line"]), TextureRect.STRETCH_SCALE)
		line.modulate = Color(0.75, 1.0, 0.95, 0.86)
		line.rotation = line_rotations[i]
		_place_control(canvas, line, (center + slot_positions[i]) * 0.5, Vector2(245, 28))
		var arrow := _texture_rect(String(KILLER_UI_PATHS["connection_arrow"]), TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
		arrow.modulate = Color(0.75, 1.0, 0.95, 0.82)
		arrow.rotation = line_rotations[i]
		_place_control(canvas, arrow, center.lerp(slot_positions[i], 0.64), Vector2(54, 28))

	_place_control(canvas, _matrix_slot(core_id, true, true), center, Vector2(190, 190))
	for i in range(slot_positions.size()):
		if i < plugins.size():
			_place_control(canvas, _matrix_slot(String(plugins[i]), false, true), slot_positions[i], Vector2(142, 142))
		else:
			_place_control(canvas, _matrix_slot("", false, false), slot_positions[i], Vector2(118, 118))

	var cap := Label.new()
	cap.text = "矩阵阶段：一阶杀招（可注入凡蛊上限：4/4）"
	cap.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cap.add_theme_color_override("font_color", COLOR_GOLD)
	_place_control(canvas, cap, Vector2(0.50, 0.94), Vector2(520, 28))
	return canvas

func _matrix_slot(gu_id: String, core: bool, filled: bool) -> Control:
	var slot := Control.new()
	var frame_path: String = String(KILLER_UI_PATHS["core_slot"]) if core else (String(KILLER_UI_PATHS["plugin_slot"]) if filled else String(KILLER_UI_PATHS["empty_slot"]))
	var frame := _texture_rect(frame_path, TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	frame.set_anchors_preset(Control.PRESET_FULL_RECT)
	slot.add_child(frame)
	if filled:
		var glow := _texture_rect(String(KILLER_UI_PATHS["slot_glow"]), TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
		glow.modulate = Color(0.65, 1.0, 0.92, 0.30)
		glow.set_anchors_preset(Control.PRESET_FULL_RECT)
		slot.add_child(glow)
		var icon := _texture_rect(String(GU_ICON_PATHS.get(gu_id, "")), TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
		icon.anchor_left = 0.18
		icon.anchor_top = 0.18
		icon.anchor_right = 0.82
		icon.anchor_bottom = 0.82
		slot.add_child(icon)
	else:
		var plus_texture: Texture2D = _get_texture(String(UI_ICON_PATHS["plus"]))
		if plus_texture != null:
			var plus_icon := TextureRect.new()
			plus_icon.texture = plus_texture
			plus_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			plus_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			plus_icon.anchor_left = 0.28
			plus_icon.anchor_top = 0.28
			plus_icon.anchor_right = 0.72
			plus_icon.anchor_bottom = 0.72
			slot.add_child(plus_icon)
			return slot
		var plus := Label.new()
		plus.text = "+"
		plus.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		plus.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		plus.add_theme_font_size_override("font_size", 42)
		plus.add_theme_color_override("font_color", Color(0.78, 0.66, 0.46, 0.86))
		plus.set_anchors_preset(Control.PRESET_FULL_RECT)
		slot.add_child(plus)
	return slot

func _texture_rect(path: String, stretch_mode: TextureRect.StretchMode) -> TextureRect:
	var rect := TextureRect.new()
	rect.texture = _get_texture(path)
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = stretch_mode
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return rect

func _place_control(parent: Control, child: Control, center_ratio: Vector2, size: Vector2) -> void:
	child.anchor_left = center_ratio.x
	child.anchor_right = center_ratio.x
	child.anchor_top = center_ratio.y
	child.anchor_bottom = center_ratio.y
	child.offset_left = -size.x * 0.5
	child.offset_right = size.x * 0.5
	child.offset_top = -size.y * 0.5
	child.offset_bottom = size.y * 0.5
	child.pivot_offset = size * 0.5
	parent.add_child(child)

func _inventory_list(type_filter: String) -> VBoxContainer:
	var box := VBoxContainer.new()
	for id in state.gu_inventory.keys():
		var def: Dictionary = GameState.GU_DEFINITIONS.get(id, {})
		if type_filter == "" or String(def.get("type", "")) == type_filter:
			box.add_child(_gu_info_row(String(id), "x%d / %s" % [int(state.gu_inventory[id]), String(def.get("grade", ""))]))
	return box

func _gu_info_row(id: String, detail: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	row.add_child(_image_or_placeholder(String(GU_ICON_PATHS.get(id, "")), id, Color(0.06, 0.08, 0.08, 0.0), Vector2(54, 54)))
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(box)
	var def: Dictionary = GameState.GU_DEFINITIONS.get(id, {})
	var name_label := Label.new()
	name_label.text = String(def.get("name", id))
	name_label.add_theme_color_override("font_color", COLOR_GOLD)
	box.add_child(name_label)
	var detail_label := Label.new()
	detail_label.text = detail
	detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_label.add_theme_color_override("font_color", Color(0.80, 0.76, 0.66, 1.0))
	box.add_child(detail_label)
	return row

func _log_view(source_logs: Array, count: int) -> Control:
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(0, 300)
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 4)
	scroll.add_child(box)
	var limit: int = min(count, source_logs.size())
	if limit == 0:
		box.add_child(_log_item("暂无记录"))
		return scroll
	for i in range(limit):
		box.add_child(_log_item(String(source_logs[i])))
	return scroll

func _log_item(text: String) -> PanelContainer:
	var panel := _panel_container(Vector2(0, 58), String(LOG_UI_PATHS["item"]), 8)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var box := _panel_body(panel)
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.clip_text = true
	label.add_theme_color_override("font_color", Color(0.88, 0.84, 0.74, 1.0))
	_apply_font(label)
	box.add_child(label)
	return panel

func _hotbar_card(key: String, title: String, desc: String) -> PanelContainer:
	var panel := _panel_container(Vector2(360, 96), String(COMBAT_UI_PATHS["hotbar_slot"]), 12)
	var box := _panel_body(panel)
	box.add_child(_text_line(key, title))
	var label := Label.new()
	label.text = desc
	label.add_theme_color_override("font_color", COLOR_CYAN)
	box.add_child(label)
	return panel

func _format_number(value: int) -> String:
	var text := str(value)
	var result := ""
	var count := 0
	for i in range(text.length() - 1, -1, -1):
		result = text.substr(i, 1) + result
		count += 1
		if count == 3 and i > 0:
			result = "," + result
			count = 0
	return result

func _join_strings(parts: Array, separator: String) -> String:
	var text := ""
	for part in parts:
		if text != "":
			text += separator
		text += String(part)
	return text

func _resource_name(id: String) -> String:
	match id:
		"immortal_stone":
			return "仙元石"
		"spirit_qi":
			return "灵气"
		"intel":
			return "情报值"
		"materials":
			return "炼蛊材料"
		_:
			return id

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
const LongevityService := preload("res://scripts/longevity_service.gd")
const LongevityDefs := preload("res://scripts/data/longevity_defs.gd")
const GuService := preload("res://scripts/gu_service.gd")
const RefineService := preload("res://scripts/refine_service.gd")
const MapService := preload("res://scripts/map_service.gd")
const MapDefs := preload("res://scripts/data/map_defs.gd")
const ExplorationMapViewScene := preload("res://scenes/views/ExplorationMapView.tscn")

const COLOR_BG := Color(0.025, 0.03, 0.028, 1.0)
const COLOR_PANEL := Color(0.035, 0.040, 0.038, 0.46)
const COLOR_PANEL_ALT := Color(0.055, 0.052, 0.042, 0.38)
const COLOR_GOLD := Color(0.92, 0.72, 0.42, 1.0)
const COLOR_CYAN := Color(0.42, 0.88, 0.82, 1.0)
const COLOR_RED := Color(0.95, 0.28, 0.22, 1.0)
const COLOR_GREEN := Color(0.42, 0.85, 0.48, 1.0)

const RESOURCE_ICON_PATHS := {
	"lifespan": "res://assets/ui/icons/lifespan_hourglass.png",
	"longevity_gu": "res://assets/ui/icons/longevity_gu.png",
	"death_warning": "res://assets/ui/icons/death_warning.png",
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
	"blood_sword": "res://assets/ui/gu/blood_sword.png",
	"liquor_worm": "res://assets/ui/gu/liquor_worm.png",
	"substitute_life_gu": "res://assets/ui/gu/substitute_life_gu.png",
	"time_anchor_gu": "res://assets/ui/gu/time_anchor_gu.png",
	"spring_autumn_cicada": "res://assets/ui/gu/spring_autumn_cicada.png"
}

const SCREEN_BACKGROUND_PATHS := {
	"aperture": "res://assets/backgrounds/aperture_map.png",
	"refining": "res://assets/backgrounds/refining_chamber.png",
	"cultivation": "res://assets/backgrounds/cultivation_retreat.png",
	"ascension": "res://assets/backgrounds/ascension_trial.png",
	"longevity": "res://assets/backgrounds/longevity_search.png",
	"death": "res://assets/backgrounds/death_realm.png",
	"lifespan_auction": "res://assets/backgrounds/lifespan_auction.png",
	"lifespan_hunt": "res://assets/backgrounds/lifespan_hunt.png",
	"killer": "res://assets/backgrounds/refining_chamber.png",
	"market": "res://assets/backgrounds/market_baohuangtian.png",
	"npc": "res://assets/backgrounds/market_baohuangtian.png",
	"story": "res://assets/backgrounds/story_three_kings_mountain.png",
	"gu_yue_village": "res://assets/backgrounds/story/gu_yue_village.png",
	"qingmao_crisis": "res://assets/backgrounds/story/qingmao_crisis.png",
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
	"lifespan_hunter": "res://assets/characters/enemies/lifespan_hunter_sheet.png",
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
	"inner_demon": "res://assets/effects/sheets/inner_demon_sheet.png",
	"longevity_gu_use": "res://assets/effects/sheets/longevity_gu_use_sheet.png",
	"death_fade": "res://assets/effects/sheets/death_fade_sheet.png"
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

const LONGEVITY_UI_PATHS := {
	"crisis_panel": "res://assets/ui/longevity/lifespan_crisis_panel_9slice.png",
	"lead_card": "res://assets/ui/longevity/lead_card_9slice.png",
	"auction_card": "res://assets/ui/longevity/auction_card_9slice.png",
	"death_choice": "res://assets/ui/longevity/death_choice_card_9slice.png",
	"badge_rumor": "res://assets/ui/longevity/lead_status_badge_rumor.png",
	"badge_verified": "res://assets/ui/longevity/lead_status_badge_verified.png",
	"badge_fake": "res://assets/ui/longevity/lead_status_badge_fake.png"
}

const SPRITE_FRAME_SIZE := Vector2i(256, 256)
const SPRITE_FOOT_ANCHOR := Vector2(128, 198)
const SPRITE_COMPACT_COLUMNS := 4
const SPRITE_COMPACT_ROWS := 4
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
var exploration_view: Control
var texture_cache: Dictionary = {}
var font_cache: Dictionary = {}

var create_name := "顾无生"
var create_gender := "男"
var create_origin := "寒门子弟"
var create_talent := "散修"
var create_school := "剑道"

var selected_recipe := "taixu_immortal"
var selected_refine_mode := "immortal"
var selected_upgrade_gu := ""
var refining_feedback_path := ""
var refining_feedback_text := "炉鼎待启"
var selected_core := "sword_core"
var selected_plugins := []
var selected_npc_id := "xuanwuzi"
var selected_market_post_id := ""
var selected_story_chapter_id := "gu_yue_village"
var selected_story_choice_id := ""
var selected_story_branch := "dog_king"
var selected_difficulty := "normal"
var selected_longevity_lead_id := ""

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
	LongevityService.ensure_longevity_state(state)
	MapService.ensure_map_state(state)
	if state.created and LongevityService.is_death_locked(state):
		_show_longevity()
	elif state.created:
		_show_exploration()
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
	_add_key_action("cast_2", KEY_2)
	_add_key_action("cast_3", KEY_3)
	_add_key_action("cast_4", KEY_4)
	_add_key_action("cast_5", KEY_5)
	_add_key_action("interact", KEY_E)

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
	exploration_view = null
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
	var lifespan_status: String = LongevityService.status_label(state)
	life.text = "寿元  %s  [%s]    境界  %s" % [state.format_lifespan(), lifespan_status, state.get_realm_name()]
	life.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	life.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	life.add_theme_font_size_override("font_size", 22)
	life.add_theme_color_override("font_color", _lifespan_status_color(String(state.lifespan_status)))
	_apply_font(life)
	_place_control(life_canvas, life, Vector2(0.58, 0.36), Vector2(360, 34))
	var max_lifespan := 73 * 360 + 147
	var current_lifespan := int(state.character.get("lifespan_days", 0))
	max_lifespan = max(max_lifespan, current_lifespan)
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
	nav.add_child(_nav_button("探索", Callable(self, "_show_exploration"), active == "exploration"))
	nav.add_child(_nav_button("仙窍", Callable(self, "_show_aperture"), active == "aperture"))
	nav.add_child(_nav_button("寿元", Callable(self, "_show_longevity"), active == "longevity" or active == "death"))
	nav.add_child(_nav_button("修行", Callable(self, "_show_cultivation"), active == "cultivation"))
	nav.add_child(_nav_button("炼蛊", Callable(self, "_show_refining"), active == "refining"))
	nav.add_child(_nav_button("杀招", Callable(self, "_show_killer_move"), active == "killer"))
	var market_button := _nav_button("宝黄天", Callable(self, "_show_market"), active == "market")
	market_button.disabled = not _can_use_market()
	market_button.tooltip_text = "六转蛊仙后才能稳定沟通宝黄天。" if market_button.disabled else ""
	nav.add_child(market_button)
	var people_button := _nav_button("人物", Callable(self, "_show_npc"), active == "npc")
	people_button.disabled = _known_people_count() == 0
	people_button.tooltip_text = "需要先在探索中遇到人物。" if people_button.disabled else ""
	nav.add_child(people_button)
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nav.add_child(spacer)
	nav.add_child(_icon_nav_button("settings", Callable(self, "_noop")))
	nav.add_child(_nav_button("保存", Callable(self, "_save_and_log")))
	nav.add_child(_nav_button("新生", Callable(self, "_reset_to_create")))

func _noop() -> void:
	pass

func _current_rank() -> int:
	return clampi(int(state.character.get("rank", state.character.get("realm_index", 1))), 1, 9)

func _can_use_market() -> bool:
	return state.created and _current_rank() >= 6

func _known_people() -> Array:
	var people: Array = []
	if state.has_method("ensure_world_defaults"):
		state.ensure_world_defaults()
	for raw_npc in state.npcs:
		var npc_state: Dictionary = raw_npc
		if bool(npc_state.get("alive", true)) and bool(npc_state.get("met", false)):
			people.append(npc_state)
	return people

func _known_people_count() -> int:
	return _known_people().size()

func _show_exploration() -> void:
	if _redirect_if_death_locked("exploration"):
		return
	MapService.ensure_map_state(state)
	var map_def: Dictionary = MapDefs.map_def(String(state.current_map_id))
	var shell := _build_shell("探索 / %s" % String(map_def.get("name", "青茅山外域")), "", "exploration")
	var view := ExplorationMapViewScene.instantiate()
	exploration_view = view
	view.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	view.custom_minimum_size = Vector2(0, 0)
	shell.add_child(view)
	view.trigger_requested.connect(_on_exploration_trigger)
	view.story_choice_requested.connect(_on_exploration_story_choice)
	view.save_position_requested.connect(_on_exploration_position_save)
	view.configure(state)
	SaveService.save_game(state)

func _on_exploration_position_save(map_id: String, position: Vector2) -> void:
	if state == null or String(state.current_map_id) != map_id:
		return
	MapService.set_map_position(state, position)
	SaveService.save_game(state)

func _on_exploration_trigger(trigger_id: String) -> void:
	MapService.ensure_map_state(state)
	var trigger: Dictionary = MapDefs.trigger(String(state.current_map_id), trigger_id)
	if trigger.is_empty():
		return
	var kind := String(trigger.get("kind", ""))
	match kind:
		"map_exit":
			MapService.enter_map(state, String(trigger.get("target_map", "qingmao_outer")), String(trigger.get("target_spawn", "")))
			SaveService.save_game(state)
			_show_exploration()
		"story":
			var chapter_id := String(trigger.get("chapter_id", ""))
			var progress: Dictionary = StoryService.chapter_progress(state, chapter_id)
			var choices := StoryService.choices(chapter_id)
			if exploration_view != null and exploration_view.has_method("show_story_choices"):
				exploration_view.show_story_choices(trigger, choices, bool(progress.get("resolved", false)))
		"resource", "person", "aperture_node":
			var result: Dictionary = MapService.resolve_simple_trigger(state, trigger)
			SaveService.save_game(state)
			if exploration_view != null and exploration_view.has_method("refresh_from_state"):
				exploration_view.refresh_from_state()
				exploration_view.show_message(String(result.get("message", "")))
		"combat":
			var encounter: Dictionary = trigger.get("encounter", {})
			if not encounter.is_empty():
				MapService.mark_trigger_resolved(state, trigger_id)
				SaveService.save_game(state)
				_start_combat(encounter)
		_:
			var fallback_result: Dictionary = MapService.resolve_simple_trigger(state, trigger)
			SaveService.save_game(state)
			if exploration_view != null and exploration_view.has_method("show_message"):
				exploration_view.show_message(String(fallback_result.get("message", "")))

func _on_exploration_story_choice(trigger_id: String, chapter_id: String, choice_id: String) -> void:
	var result: Dictionary = StoryService.resolve_choice(state, chapter_id, choice_id)
	if bool(result.get("ok", false)):
		MapService.mark_trigger_resolved(state, trigger_id)
	state.add_log(String(result.get("message", "")))
	SaveService.save_game(state)
	var encounter: Dictionary = result.get("encounter", {})
	if bool(result.get("ok", false)) and not encounter.is_empty():
		_start_combat(encounter)
		return
	if exploration_view != null and exploration_view.has_method("refresh_from_state"):
		exploration_view.refresh_from_state()
		exploration_view.show_message(String(result.get("message", "")))

func _show_locked_feature(title: String, message: String, screen_id: String, background_path: String = "") -> void:
	var bg := background_path if background_path != "" else String(SCREEN_BACKGROUND_PATHS.get("story", ""))
	var shell := _build_shell(title, bg, screen_id)
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	shell.add_child(body)
	var panel := _add_panel(body, title, Vector2(0, 0))
	panel.add_child(_warning_line(message))
	panel.add_child(_dialogue_line("开放条件", "功能会随剧情遭遇和境界逐步解锁，不再作为开局常驻菜单。"))
	panel.add_child(_section_label("最近事件"))
	panel.add_child(_log_view(state.logs, 8))

func _redirect_if_death_locked(target_screen: String) -> bool:
	if target_screen == "longevity" or target_screen == "death" or not state.created:
		return false
	LongevityService.ensure_longevity_state(state)
	if not LongevityService.is_death_locked(state):
		return false
	if current_screen != "longevity" and current_screen != "death":
		state.add_log("寿元已尽，普通行动锁定。")
	_show_longevity()
	return true

func _show_longevity() -> void:
	LongevityService.ensure_longevity_state(state)
	LongevityService.update_lifespan_status(state, false)
	_sync_selected_longevity_lead()
	var dead_locked: bool = LongevityService.is_death_locked(state)
	var shell: VBoxContainer = _build_shell("寿元 / 永生", "res://assets/reference/market.png", "death" if dead_locked else "longevity")
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	shell.add_child(body)

	var left := _add_panel(body, "寿元危机", Vector2(500, 0))
	left.add_child(_longevity_crisis_card())
	left.add_child(_text_line("寿蛊库存", LongevityService.gu_inventory_text(state)))
	for tier_id in LongevityDefs.gu_tier_ids():
		var tier: Dictionary = LongevityDefs.gu_tier(tier_id)
		left.add_child(_text_line(String(tier.get("name", tier_id)), "x%d / +%d天" % [int(state.longevity_gu_inventory.get(tier_id, 0)), int(tier.get("days", 0))]))
	var combat_death := LongevityService.is_combat_death(state)
	if not combat_death:
		left.add_child(_button("使用最强寿蛊续命", Callable(self, "_longevity_use_best_gu"), dead_locked))
	if dead_locked:
		left.add_child(_button("结束旧局 / 新建角色", Callable(self, "_longevity_reincarnate"), true))
		if combat_death:
			left.add_child(_warning_line("战斗死亡已成定局。只有春秋蝉或替死手段能在死亡瞬间改写结局。"))
		else:
			left.add_child(_warning_line("寿元已归零。除续命与结束旧局外，普通行动已锁定。"))
	else:
		left.add_child(_button("搜寻线索（推进1月）", Callable(self, "_longevity_search")))
		left.add_child(_button("参与寿蛊竞拍", Callable(self, "_longevity_bid_auction")))
		left.add_child(_warning_line("寿元越低，人物抬价、截胡和夺寿追杀概率越高。"))

	var center := _add_panel(body, "寿蛊线索追踪", Vector2(840, 0))
	var leads: Array = LongevityService.active_leads(state)
	if leads.is_empty():
		center.add_child(_warning_line("暂无有效寿蛊线索，可主动搜寻或从宝黄天购买。"))
	for raw_lead in leads:
		var lead: Dictionary = raw_lead
		var lead_id: String = String(lead.get("id", ""))
		center.add_child(_longevity_lead_button(lead, lead_id == selected_longevity_lead_id, Callable(self, "_longevity_select_lead").bind(lead_id)))

	var right := _add_panel(body, "竞拍 / 追杀 / 死亡记录", Vector2(610, 0))
	var selected_lead: Dictionary = _selected_longevity_lead()
	if selected_lead.is_empty():
		right.add_child(_warning_line("请选择一条寿蛊线索。"))
	else:
		right.add_child(_image_or_placeholder(String(RESOURCE_ICON_PATHS["longevity_gu"]), "寿蛊线索", Color(0.04, 0.08, 0.07, 0.65), Vector2(0, 150)))
		right.add_child(_text_line("线索", String(selected_lead.get("title", "未知"))))
		right.add_child(_text_line("状态", LongevityDefs.lead_status_label(String(selected_lead.get("status", "rumor")))))
		right.add_child(_text_line("区域", _region_name(String(selected_lead.get("region", "")))))
		right.add_child(_metric("可信度", int(selected_lead.get("truthfulness", 0)), _trust_color(int(selected_lead.get("truthfulness", 0)))))
		right.add_child(_metric("争夺风险", int(selected_lead.get("risk", 0)), _risk_color(int(selected_lead.get("risk", 0)))))
		right.add_child(_dialogue_line("线索", String(selected_lead.get("body", ""))))
		right.add_child(_button("调查线索（120情报）", Callable(self, "_longevity_investigate_selected")))
		right.add_child(_button("追踪线索（推进1月）", Callable(self, "_longevity_pursue_selected"), String(selected_lead.get("status", "")) == "verified"))
	right.add_child(_section_label("夺寿事件"))
	var event_count := 0
	for raw_event in state.world_events:
		var event: Dictionary = raw_event
		if String(event.get("kind", "")) == "夺寿追杀":
			right.add_child(_text_line("追杀", "%s / 威胁%d / %d月止" % [_region_name(String(event.get("region", ""))), int(event.get("severity", 0)), int(event.get("expires_month", 0))]))
			event_count += 1
			if event_count >= 3:
				break
	if event_count == 0:
		right.add_child(_text_line("追杀", "暂无明确夺寿窗口"))
	else:
		right.add_child(_button("迎击夺寿追杀", Callable(self, "_start_lifespan_hunt_combat"), true))
	right.add_child(_section_label("死亡记录"))
	if state.reincarnation_history.is_empty():
		right.add_child(_text_line("记录", "尚未转世"))
	else:
		for i in range(min(3, state.reincarnation_history.size())):
			var record: Dictionary = state.reincarnation_history[i]
			right.add_child(_text_line(String(record.get("name", "旧身")), "第%d月 / %s" % [int(record.get("world_month", 0)), String(record.get("reason", ""))]))
	right.add_child(_section_label("最近事件"))
	right.add_child(_log_view(state.logs, 6))
	SaveService.save_game(state)

func _longevity_crisis_card() -> PanelContainer:
	var panel := _panel_container(Vector2(0, 190), String(LONGEVITY_UI_PATHS["crisis_panel"]), 10)
	var box := _panel_body(panel)
	var status: String = String(state.lifespan_status)
	var status_color: Color = _lifespan_status_color(status)
	box.add_child(_text_line("当前状态", LongevityDefs.status_label(status)))
	box.add_child(_text_line("剩余寿元", state.format_lifespan()))
	var days: int = int(state.character.get("lifespan_days", 0))
	var crisis_max: int = max(720, days)
	var bar := _texture_progress_bar(float(days), float(crisis_max), _progress_fill_path(status_color), String(PROGRESS_UI_PATHS["track"]), Vector2(0, 16), 16)
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(bar)
	var warning: String = LongevityService.current_warning(state)
	if warning != "":
		box.add_child(_warning_line(warning))
	else:
		box.add_child(_dialogue_line("命灯", "寿元尚稳，但沙漏从不倒流。"))
	return panel

func _longevity_lead_button(lead: Dictionary, selected: bool, callback: Callable) -> Button:
	var status: String = String(lead.get("status", "rumor"))
	var text := "%s\n%s｜可信 %d%%｜风险 %d%%｜%d月止" % [
		String(lead.get("title", "寿蛊线索")),
		LongevityDefs.lead_status_label(status),
		int(lead.get("truthfulness", 0)),
		int(lead.get("risk", 0)),
		int(lead.get("expires_month", 0))
	]
	var button := _button(("◆ " if selected else "◇ ") + text, callback, selected)
	button.custom_minimum_size = Vector2(120, 92)
	_apply_button_skin(button, String(UI_SKIN_PATHS["button_active"]) if selected else String(LONGEVITY_UI_PATHS["lead_card"]), String(UI_SKIN_PATHS["button_hover"]), String(UI_SKIN_PATHS["button_active"]), 40)
	button.icon = _get_texture(String(RESOURCE_ICON_PATHS["longevity_gu"]))
	button.expand_icon = true
	button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.add_theme_constant_override("icon_max_width", 44)
	return button

func _sync_selected_longevity_lead() -> void:
	if LongevityService.find_lead_index(state, selected_longevity_lead_id) >= 0:
		return
	var leads: Array = LongevityService.active_leads(state)
	if leads.is_empty():
		selected_longevity_lead_id = ""
		return
	var first_lead: Dictionary = leads[0]
	selected_longevity_lead_id = String(first_lead.get("id", ""))

func _selected_longevity_lead() -> Dictionary:
	var index: int = LongevityService.find_lead_index(state, selected_longevity_lead_id)
	if index < 0:
		return {}
	var lead: Dictionary = state.longevity_leads[index]
	return lead

func _longevity_select_lead(lead_id: String) -> void:
	selected_longevity_lead_id = lead_id
	_show_longevity()

func _longevity_search() -> void:
	var message: String = LongevityService.search_lead(state)
	state.add_log(message)
	if message.find("失败") < 0:
		WorldClock.advance_months(state, 1, "搜寻寿蛊线索")
	SaveService.save_game(state)
	_show_longevity()

func _longevity_investigate_selected() -> void:
	var message: String = LongevityService.investigate_lead(state, selected_longevity_lead_id)
	state.add_log(message)
	SaveService.save_game(state)
	_show_longevity()

func _longevity_pursue_selected() -> void:
	var message: String = LongevityService.pursue_lead(state, selected_longevity_lead_id)
	state.add_log(message)
	if message.find("不存在") < 0 and message.find("不足") < 0:
		WorldClock.advance_months(state, 1, "追踪寿蛊线索")
	SaveService.save_game(state)
	_show_longevity()

func _longevity_bid_auction() -> void:
	var message: String = LongevityService.bid_auction(state)
	state.add_log(message)
	if message.find("仙元石不足") < 0:
		WorldClock.advance_months(state, 1, "寿蛊竞拍")
	SaveService.save_game(state)
	_show_longevity()

func _longevity_use_best_gu() -> void:
	var message: String = LongevityService.use_best_gu(state)
	state.add_log(message)
	SaveService.save_game(state)
	_show_longevity()

func _longevity_reincarnate() -> void:
	LongevityService.reincarnate(state)
	SaveService.save_game(state)
	selected_longevity_lead_id = ""
	selected_market_post_id = ""
	selected_npc_id = "xuanwuzi"
	create_name = "顾无生"
	_show_create()

func _start_lifespan_hunt_combat() -> void:
	var encounter: Dictionary = {
		"id": "lifespan_hunt",
		"name": "夺寿追杀",
		"objective": "击败所有追杀者，保住寿蛊线索",
		"background": String(SCREEN_BACKGROUND_PATHS["lifespan_hunt"]),
		"branch_id": "wild",
		"difficulty_id": "danger",
		"effect": "death_fade",
		"rewards": {"immortal_stone": 360, "intel": 220, "materials": 1},
		"failure": {"lifespan_loss": 420, "months": 2},
		"morality_delta": -2,
		"risk": 72,
		"enemies": [
			{"name": "夺寿散修", "sheet": "lifespan_hunter", "hp": 680, "max_hp": 680, "speed": 132, "damage_min": 12, "damage_max": 22, "pos_ratio": Vector2(0.74, 0.32)},
			{"name": "黑市追迹者", "sheet": "enemy_elite", "hp": 760, "max_hp": 760, "speed": 104, "damage_min": 14, "damage_max": 24, "pos_ratio": Vector2(0.82, 0.56)},
			{"name": "索命魂影", "sheet": "summoned_soul", "hp": 480, "max_hp": 480, "speed": 176, "damage_min": 9, "damage_max": 18, "pos_ratio": Vector2(0.66, 0.74)}
		]
	}
	state.add_log("你主动迎击夺寿追杀。")
	_start_combat(encounter)

func _start_person_ambush_combat() -> void:
	var encounter: Dictionary = DungeonDefs.build_wild_encounter()
	encounter["id"] = "person_ambush"
	encounter["name"] = "人物袭击事件"
	encounter["objective"] = "击退敌对人物布下的袭击"
	encounter["branch_id"] = "person_event"
	encounter["difficulty_id"] = "danger"
	encounter["risk"] = 64
	encounter["background"] = String(SCREEN_BACKGROUND_PATHS["lifespan_hunt"])
	encounter["rewards"] = {"immortal_stone": 320, "intel": 180, "materials": 2}
	for i in range(state.world_events.size()):
		var event: Dictionary = state.world_events[i]
		var kind := String(event.get("kind", ""))
		if kind in ["战后袭击窗口", "反噬伏击", "仇敌标记"] and not bool(event.get("resolved", false)):
			event["resolved"] = true
			state.world_events[i] = event
			break
	state.add_log("你主动处理人物袭击窗口。")
	_start_combat(encounter)

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
	StoryService.configure_initial_story(state)
	ApertureService.ensure_ecology_state(state)
	TribulationService.ensure_tribulation_state(state)
	CultivationService.ensure_cultivation_state(state)
	SaveService.save_game(state)
	_show_exploration()

func _show_aperture() -> void:
	if _redirect_if_death_locked("aperture"):
		return
	ApertureService.ensure_ecology_state(state)
	TribulationService.ensure_tribulation_state(state)
	var shell := _build_shell("仙窍总览", "res://assets/reference/aperture.png", "aperture")
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	shell.add_child(body)

	var left := _add_panel(body, "仙窍监控", Vector2(520, 0))
	var left_content := _scroll_box(left)
	var tribulation_summary: Dictionary = TribulationService.state_summary(state)
	left_content.add_child(_aperture_metric("天地二气平衡度", int(state.aperture.get("qi_balance", 0)), COLOR_CYAN))
	left_content.add_child(_aperture_metric("道痕互斥率", int(state.aperture.get("conflict_rate", 0)), COLOR_GOLD))
	left_content.add_child(_aperture_metric("蛊虫饱食度", int(state.aperture.get("food_saturation", 0)), COLOR_RED if int(state.aperture.get("food_saturation", 0)) < 50 else COLOR_GREEN))
	left_content.add_child(_aperture_metric("生态稳定性", int(state.aperture.get("stability", 0)), COLOR_GREEN))
	left_content.add_child(_aperture_metric("灾劫压力", int(tribulation_summary.get("pressure", 0)), COLOR_RED if int(tribulation_summary.get("pressure", 0)) > 72 else COLOR_GOLD))
	left_content.add_child(_text_line("仙元石净产出", "+%d/月" % int(state.aperture.get("stone_delta", 0))))
	left_content.add_child(_text_line("世界刻", "第 %d 月" % int(state.world_month)))
	left_content.add_child(_text_line("下次压测", "已锁定" if bool(tribulation_summary.get("active", false)) else "%d 月后" % int(tribulation_summary.get("months_left", 0))))
	left_content.add_child(_button("闭关修行（推进3月）", Callable(self, "_cultivation_retreat")))
	left_content.add_child(_button("冲击小阶", Callable(self, "_try_breakthrough")))
	left_content.add_child(_button("准备升仙", Callable(self, "_prepare_ascension")))
	left_content.add_child(_button("升仙试炼", Callable(self, "_resolve_ascension_phase")))
	left_content.add_child(_button("调度资源（推进1月）", Callable(self, "_advance_one_month")))
	left_content.add_child(_button("扩容节点", Callable(self, "_expand_node")))
	left_content.add_child(_button("修复生态", Callable(self, "_repair_aperture")))
	left_content.add_child(_button("补链最弱蛊虫", Callable(self, "_repair_worst_gu")))
	left_content.add_child(_button("准备防御脚本", Callable(self, "_prepare_tribulation_defense")))
	left_content.add_child(_button("提前渡劫压测", Callable(self, "_resolve_tribulation_now")))

	var center := _add_panel(body, "节点拓扑", Vector2(760, 0))
	var center_content := _scroll_box(center)
	center_content.add_child(_aperture_node_map(state.aperture.get("nodes", [])))
	center_content.add_child(_section_label("蛊虫生态链"))
	center_content.add_child(_gu_ecology_list())
	var loop_hint := Label.new()
	loop_hint.text = "玩法闭环：经营仙窍 → 炼蛊 → 编译杀招 → 战斗博弈 → 奖励回流。"
	loop_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	loop_hint.add_theme_color_override("font_color", COLOR_GOLD)
	center_content.add_child(loop_hint)

	var right := _add_panel(body, "告警中心 / 日志", Vector2(560, 0))
	var right_content := _scroll_box(right)
	var warnings: Array = state.get_warnings()
	if warnings.is_empty():
		right_content.add_child(_text_line("状态", "暂无严重告警"))
	else:
		for warning in warnings:
			right_content.add_child(_warning_line(warning))
	right_content.add_child(_section_label("灾劫"))
	right_content.add_child(_text_line("当前灾劫", String(tribulation_summary.get("name", "未锁定"))))
	right_content.add_child(_text_line("目标节点", String(tribulation_summary.get("target", "未知"))))
	right_content.add_child(_dialogue_line("压测说明", String(tribulation_summary.get("description", ""))))
	right_content.add_child(_section_label("最近事件"))
	right_content.add_child(_log_view(state.logs, 10))

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
	if _redirect_if_death_locked("cultivation"):
		return
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
	if _redirect_if_death_locked("story"):
		return
	StoryService.ensure_story_state(state)
	_sync_selected_story_chapter()
	_sync_selected_story_choice()
	var chapter: Dictionary = StoryService.chapter(selected_story_chapter_id)
	var chapter_progress: Dictionary = StoryService.chapter_progress(state, selected_story_chapter_id)
	var chapter_bg := String(chapter.get("background", SCREEN_BACKGROUND_PATHS["story"]))
	var shell := _build_shell("剧情 / 副本", chapter_bg, "story")
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	shell.add_child(body)

	var left := _add_panel(body, "剧情线", Vector2(520, 0))
	var left_content := _scroll_box(left)
	left_content.add_child(_image_or_placeholder(chapter_bg, String(chapter.get("name", "剧情")), Color(0.08, 0.07, 0.055, 0.55), Vector2(0, 170)))
	left_content.add_child(_dialogue_line(String(chapter.get("act", "篇章")), String(chapter.get("summary", ""))))
	left_content.add_child(_section_label("已知线索"))
	var visible_chapters := StoryService.visible_chapter_ids(state)
	if visible_chapters.is_empty():
		left_content.add_child(_warning_line("暂无剧情线索。"))
	for chapter_id_value in visible_chapters:
		var chapter_id := String(chapter_id_value)
		var item: Dictionary = StoryService.chapter(chapter_id)
		var progress: Dictionary = StoryService.chapter_progress(state, chapter_id)
		var unlocked := bool(progress.get("unlocked", false))
		var resolved := bool(progress.get("resolved", false))
		var status := "线索"
		if unlocked:
			status = "已发生" if resolved else ("传承线索" if String(item.get("kind", "")) == "dungeon" else "可抉择")
		var button := _choice_button("%s｜%s\n%s" % [String(item.get("act", "")), String(item.get("name", chapter_id)), status], selected_story_chapter_id == chapter_id, Callable(self, "_set_story_chapter").bind(chapter_id))
		button.disabled = not unlocked and not resolved
		left_content.add_child(button)

	var center := _add_panel(body, String(chapter.get("name", "剧情节点")), Vector2(780, 0))
	var center_content := _scroll_box(center)
	var kind := String(chapter.get("kind", "choice"))
	if kind == "dungeon":
		_sync_selected_story_branch()
		center_content.add_child(_dialogue_line("三叉山传闻", String(chapter.get("summary", ""))))
		center_content.add_child(_section_label("传承线"))
		for branch_id in DungeonDefs.branch_ids():
			center_content.add_child(_branch_choice_card(String(branch_id)))
		center_content.add_child(_section_label("难度"))
		for difficulty_id in DungeonDefs.difficulty_ids():
			center_content.add_child(_difficulty_button(String(difficulty_id)))
		var start_button := _button("进入传承", Callable(self, "_start_story_dungeon"), true)
		start_button.custom_minimum_size = Vector2(0, 72)
		start_button.disabled = not StoryService.can_start_branch(state, selected_story_branch)
		center_content.add_child(start_button)
	elif kind == "planned":
		center_content.add_child(_warning_line("尚未形成可执行线索。"))
		center_content.add_child(_dialogue_line("传闻", "这段因果仍在暗处流转，需等更多人物、情报或修为支撑。"))
	else:
		center_content.add_child(_dialogue_line("局势", String(chapter.get("summary", ""))))
		center_content.add_child(_section_label("抉择"))
		for raw_choice in StoryService.choices(selected_story_chapter_id):
			var choice_def: Dictionary = raw_choice
			center_content.add_child(_story_choice_button(choice_def, bool(chapter_progress.get("resolved", false))))
		var resolve_button := _button("定下抉择", Callable(self, "_resolve_story_choice"), true)
		resolve_button.custom_minimum_size = Vector2(0, 70)
		resolve_button.disabled = bool(chapter_progress.get("resolved", false)) or selected_story_choice_id == ""
		center_content.add_child(resolve_button)

	var right := _add_panel(body, "剧情结果", Vector2(560, 0))
	var right_content := _scroll_box(right)
	right_content.add_child(_text_line("篇章状态", "已发生" if bool(chapter_progress.get("resolved", false)) else ("可抉择" if bool(chapter_progress.get("unlocked", false)) else "未解锁")))
	if kind == "dungeon":
		right_content.add_child(_text_line("章节进度", "%d / 3" % StoryService.chapter_completion(state)))
		var selected_branch: Dictionary = DungeonDefs.branch(selected_story_branch)
		right_content.add_child(_section_label(String(selected_branch.get("name", "传承"))))
		right_content.add_child(_text_line("流派", String(selected_branch.get("school", "未知"))))
		right_content.add_child(_text_line("试炼", String(selected_branch.get("subtitle", "未知"))))
		right_content.add_child(_text_line("难度", DungeonDefs.difficulty_name(selected_difficulty)))
		right_content.add_child(_dialogue_line("残念低语", String(selected_branch.get("intro", ""))))
		var progress: Dictionary = state.dungeon_progress.get(selected_story_branch, {})
		right_content.add_child(_text_line("尝试", "%d 次" % int(progress.get("attempts", 0))))
		right_content.add_child(_text_line("胜利", "%d 次" % int(progress.get("victories", 0))))
		right_content.add_child(_text_line("最高难度", _difficulty_display(String(progress.get("best_difficulty", "")))))
		if StoryService.branch_attempted(state, selected_story_branch):
			right_content.add_child(_text_line("传承状态", "残念已散"))
	elif kind == "choice":
		var selected_choice: Dictionary = StoryService.choice(selected_story_chapter_id, selected_story_choice_id)
		if selected_choice.is_empty():
			right_content.add_child(_warning_line("请选择一个剧情抉择。"))
		else:
			right_content.add_child(_section_label(String(selected_choice.get("title", "抉择"))))
			right_content.add_child(_dialogue_line("抉择说明", String(selected_choice.get("body", ""))))
			right_content.add_child(_text_line("资源消耗", _choice_cost_text(selected_choice)))
			right_content.add_child(_text_line("奖励/代价", _choice_reward_text(selected_choice)))
			if typeof(selected_choice.get("encounter", null)) == TYPE_DICTIONARY:
				right_content.add_child(_warning_line("此行会踏入杀局；若无保命手段，败亡即是终局。"))
	right_content.add_child(_section_label("最近事件"))
	right_content.add_child(_log_view(state.logs, 8))
	SaveService.save_game(state)

func _story_choice_button(choice_def: Dictionary, already_resolved: bool) -> Button:
	var choice_id := String(choice_def.get("id", ""))
	var text := "%s\n%s" % [String(choice_def.get("title", choice_id)), String(choice_def.get("body", ""))]
	var button := _choice_button(text, selected_story_choice_id == choice_id, Callable(self, "_set_story_choice").bind(choice_id))
	button.custom_minimum_size = Vector2(120, 96)
	button.disabled = already_resolved
	return button

func _sync_selected_story_chapter() -> void:
	var visible_chapters := StoryService.visible_chapter_ids(state)
	if selected_story_chapter_id != "" and visible_chapters.has(selected_story_chapter_id):
		return
	if not visible_chapters.is_empty():
		selected_story_chapter_id = String(visible_chapters[0])
		return
	selected_story_chapter_id = ""

func _sync_selected_story_choice() -> void:
	var choices := StoryService.choices(selected_story_chapter_id)
	var progress: Dictionary = StoryService.chapter_progress(state, selected_story_chapter_id)
	var resolved_choice_id := String(progress.get("choice_id", ""))
	if bool(progress.get("resolved", false)) and resolved_choice_id != "":
		for raw_choice in choices:
			var resolved_choice: Dictionary = raw_choice
			if String(resolved_choice.get("id", "")) == resolved_choice_id:
				selected_story_choice_id = resolved_choice_id
				return
	for raw_choice in choices:
		var choice_def: Dictionary = raw_choice
		if String(choice_def.get("id", "")) == selected_story_choice_id:
			return
	selected_story_choice_id = StoryService.first_choice_id(selected_story_chapter_id)

func _sync_selected_story_branch() -> void:
	if StoryService.can_start_branch(state, selected_story_branch):
		return
	for branch_id_value in DungeonDefs.branch_ids():
		var branch_id := String(branch_id_value)
		if StoryService.can_start_branch(state, branch_id):
			selected_story_branch = branch_id
			return

func _set_story_chapter(chapter_id: String) -> void:
	if not StoryService.visible_chapter_ids(state).has(chapter_id):
		return
	selected_story_chapter_id = chapter_id
	selected_story_choice_id = ""
	_show_story()

func _set_story_choice(choice_id: String) -> void:
	selected_story_choice_id = choice_id
	_show_story()

func _resolve_story_choice() -> void:
	var result: Dictionary = StoryService.resolve_choice(state, selected_story_chapter_id, selected_story_choice_id)
	state.add_log(String(result.get("message", "")))
	SaveService.save_game(state)
	var encounter: Dictionary = result.get("encounter", {})
	if bool(result.get("ok", false)) and not encounter.is_empty():
		_start_combat(encounter)
		return
	_show_story()

func _choice_cost_text(choice_def: Dictionary) -> String:
	var costs: Dictionary = choice_def.get("costs", {})
	if costs.is_empty():
		return "无"
	var parts: Array = []
	for cost_id in costs.keys():
		parts.append("%s %d" % [_resource_name(String(cost_id)), int(costs[cost_id])])
	return _join_strings(parts, " / ")

func _choice_reward_text(choice_def: Dictionary) -> String:
	var parts: Array = []
	var rewards: Dictionary = choice_def.get("rewards", {})
	for reward_id in rewards.keys():
		parts.append("%s +%d" % [_resource_name(String(reward_id)), int(rewards[reward_id])])
	for gu_id_value in choice_def.get("gu_rewards", []):
		var gu_id := String(gu_id_value)
		parts.append("%s +1" % state.get_gu_name(gu_id))
	var cultivation_gain: int = int(choice_def.get("cultivation_exp", 0))
	if cultivation_gain > 0:
		parts.append("修为 +%d" % cultivation_gain)
	if parts.is_empty():
		return "关系与路线变化"
	return _join_strings(parts, " / ")

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
	var attempted := StoryService.branch_attempted(state, branch_id)
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
	button.disabled = attempted
	top.add_child(button)
	var info := VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(info)
	info.add_child(_text_line("流派", String(branch.get("school", "未知"))))
	info.add_child(_text_line("试炼", String(branch.get("subtitle", "未知"))))
	var progress: Dictionary = state.dungeon_progress.get(branch_id, {})
	var status := "已发生" if attempted else "未发生"
	info.add_child(_text_line("记录", "%s / 胜利 %d / 最高 %s" % [status, int(progress.get("victories", 0)), _difficulty_display(String(progress.get("best_difficulty", "")))]))
	var intro := Label.new()
	intro.text = String(branch.get("intro", ""))
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.add_theme_color_override("font_color", COLOR_CYAN if selected else Color(0.82, 0.78, 0.66, 1.0))
	_apply_font(intro)
	box.add_child(intro)
	return panel

func _set_story_branch(branch_id: String) -> void:
	if StoryService.branch_attempted(state, branch_id):
		state.add_log("这条传承已经触发过，不能重复挑战。")
		_show_story()
		return
	selected_story_branch = branch_id
	_show_story()

func _set_story_difficulty(difficulty_id: String) -> void:
	selected_difficulty = difficulty_id
	_show_story()

func _start_story_dungeon() -> void:
	if not StoryService.can_start_branch(state, selected_story_branch):
		state.add_log("这条传承已经触发过，不能重复挑战。")
		_show_story()
		return
	var encounter: Dictionary = DungeonService.start_branch(state, selected_story_branch, selected_difficulty)
	SaveService.save_game(state)
	_start_combat(encounter)

func _difficulty_display(difficulty_id: String) -> String:
	if difficulty_id == "":
		return "未通关"
	return DungeonDefs.difficulty_name(difficulty_id)

func _show_refining() -> void:
	if _redirect_if_death_locked("refining"):
		return
	GuService.ensure_instance_state(state)
	_sync_selected_upgrade_gu()
	var shell := _build_shell("仙蛊炼制", "res://assets/reference/gu_refining.png", "refining")
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	shell.add_child(body)

	var left := _add_panel(body, "炼制配方", Vector2(520, 0))
	var left_content := _scroll_box(left)
	left_content.add_child(_section_label("炉鼎模式"))
	left_content.add_child(_choice_button("仙蛊合炼\n前置蛊、配方、道痕与机缘共同判定", selected_refine_mode == "immortal", Callable(self, "_set_refine_mode").bind("immortal")))
	left_content.add_child(_choice_button("凡蛊升转\n提升一至五转凡蛊，失败会损伤蛊虫", selected_refine_mode == "upgrade", Callable(self, "_set_refine_mode").bind("upgrade")))
	if selected_refine_mode == "upgrade":
		left_content.add_child(_section_label("可升转蛊虫"))
		var has_upgrade_target := false
		for gu_id_value in state.get_gu_ids(""):
			var gu_id := String(gu_id_value)
			if GuService.can_upgrade_mortal(state, gu_id):
				has_upgrade_target = true
				left_content.add_child(_gu_choice_button(gu_id, "%s\n%s" % [state.get_gu_name(gu_id), state.get_gu_status_text(gu_id)], selected_upgrade_gu == gu_id, Callable(self, "_set_upgrade_gu").bind(gu_id)))
		if not has_upgrade_target:
			left_content.add_child(_warning_line("暂无可升转凡蛊。"))
	else:
		left_content.add_child(_section_label("合炼链"))
		for recipe_id in GameState.REFINE_RECIPES.keys():
			var recipe: Dictionary = GameState.REFINE_RECIPES[recipe_id]
			left_content.add_child(_recipe_choice_button(String(recipe_id), recipe, selected_recipe == recipe_id, Callable(self, "_set_recipe").bind(recipe_id)))

	var center := _add_panel(body, "炉鼎推演", Vector2(760, 0))
	var center_content := _scroll_box(center)
	if selected_refine_mode == "upgrade":
		_render_upgrade_panel(center_content)
	else:
		_render_immortal_refine_panel(center_content)

	var right := _add_panel(body, "蛊虫库存", Vector2(560, 0))
	var right_content := _scroll_box(right)
	var summary: Dictionary = GuService.instance_summary(state)
	right_content.add_child(_text_line("实例蛊虫", "%d 只" % int(summary.get("total", 0))))
	right_content.add_child(_text_line("凡蛊 / 仙蛊", "%d / %d" % [int(summary.get("mortal", 0)), int(summary.get("immortal", 0))]))
	right_content.add_child(_text_line("饥饿 / 受损", "%d / %d" % [int(summary.get("hungry", 0)), int(summary.get("wounded", 0))]))
	right_content.add_child(_inventory_list(""))
	right_content.add_child(_section_label("炼蛊日志"))
	right_content.add_child(_log_view(state.logs, 8))

func _render_immortal_refine_panel(center: VBoxContainer) -> void:
	var recipe: Dictionary = GameState.REFINE_RECIPES[selected_recipe]
	var result_id := String(recipe["result"])
	var result_def: Dictionary = GameState.GU_DEFINITIONS[result_id]
	var preview: Dictionary = RefineService.immortal_refine_preview(state, recipe)
	center.add_child(_text_line("目标", "%s / %s / %s" % [result_def["name"], result_def["grade"], result_def["school"]]))
	var unique_note: String = "已被占有，继续合炼必反噬" if bool(result_def.get("unique", false)) and state.unique_gu.has(result_id) else "唯一锁空闲"
	center.add_child(_warning_line(unique_note) if unique_note.begins_with("已") else _text_line("唯一性校验", unique_note))
	var missing: Array = preview.get("missing", [])
	if not missing.is_empty():
		center.add_child(_warning_line("合炼链缺口：%s" % _join_strings(missing, " / ")))
	var refine_button := _button("开始合炼", Callable(self, "_try_refine"))
	refine_button.custom_minimum_size = Vector2(0, 64)
	center.add_child(refine_button)
	_add_refine_feedback(center, result_id, String(result_def["name"]))
	center.add_child(_text_line("说明", String(recipe["description"])))
	center.add_child(_text_line("合炼链", String(preview.get("chain_hint", ""))))
	center.add_child(_text_line("前置蛊虫", _recipe_gu_requirements_text(recipe)))
	center.add_child(_text_line("推演成功率", "%d%%" % int(float(preview.get("success_rate", recipe.get("base_success", 0.5))) * 100.0)))
	center.add_child(_text_line("预计耗时", "%d 月" % int(recipe["months"])))
	center.add_child(_section_label("材料消耗"))
	for cost_id in recipe["costs"].keys():
		center.add_child(_text_line(_resource_name(cost_id), "%d / %d" % [state.get_resource(cost_id), int(recipe["costs"][cost_id])]))

func _render_upgrade_panel(center: VBoxContainer) -> void:
	if selected_upgrade_gu == "":
		center.add_child(_warning_line("请选择一只凡蛊作为升转对象。"))
		return
	var preview: Dictionary = RefineService.upgrade_preview(state, selected_upgrade_gu)
	var gu_def: Dictionary = GameState.GU_DEFINITIONS.get(selected_upgrade_gu, {})
	center.add_child(_text_line("目标", "%s / %s" % [state.get_gu_name(selected_upgrade_gu), String(gu_def.get("school", "无相"))]))
	if not bool(preview.get("ok", false)):
		center.add_child(_warning_line(String(preview.get("reason", "无法升转"))))
	else:
		center.add_child(_text_line("升转路径", "%s → %s" % [state.RANK_NAMES[int(preview.get("rank", 1)) - 1], state.RANK_NAMES[int(preview.get("next_rank", 2)) - 1]]))
		center.add_child(_text_line("推演成功率", "%d%%" % int(float(preview.get("success_rate", 0.5)) * 100.0)))
		center.add_child(_text_line("同类引子", "需要 %d 只" % int(preview.get("duplicate_need", 0))))
	var button := _button("开始升转", Callable(self, "_try_upgrade_gu"))
	button.custom_minimum_size = Vector2(0, 64)
	button.disabled = not bool(preview.get("ok", false))
	center.add_child(button)
	_add_refine_feedback(center, selected_upgrade_gu, state.get_gu_name(selected_upgrade_gu))
	center.add_child(_text_line("当前状态", state.get_gu_status_text(selected_upgrade_gu)))
	if bool(preview.get("ok", false)):
		center.add_child(_section_label("升转消耗"))
		var costs: Dictionary = preview.get("costs", {})
		for cost_id in costs.keys():
			center.add_child(_text_line(_resource_name(String(cost_id)), "%d / %d" % [state.get_resource(String(cost_id)), int(costs[cost_id])]))

func _add_refine_feedback(parent: VBoxContainer, gu_id: String, display_name: String) -> void:
	if refining_feedback_path == "":
		parent.add_child(_image_or_placeholder(String(REFINING_UI_PATHS["cauldron_idle"]), refining_feedback_text, Color(0.08, 0.07, 0.045, 0.62), Vector2(0, 130)))
	else:
		parent.add_child(_image_or_placeholder(refining_feedback_path, refining_feedback_text, Color(0.16, 0.10, 0.04, 0.86), Vector2(0, 110)))
	parent.add_child(_image_or_placeholder(String(GU_ICON_PATHS.get(gu_id, "")), display_name, Color(0.19, 0.12, 0.05, 0.93), Vector2(0, 180)))

func _set_recipe(recipe_id: String) -> void:
	selected_recipe = recipe_id
	selected_refine_mode = "immortal"
	refining_feedback_path = ""
	refining_feedback_text = "炉鼎待启"
	_show_refining()

func _set_refine_mode(mode: String) -> void:
	selected_refine_mode = mode
	refining_feedback_path = ""
	refining_feedback_text = "炉鼎待启"
	_show_refining()

func _set_upgrade_gu(gu_id: String) -> void:
	selected_upgrade_gu = gu_id
	selected_refine_mode = "upgrade"
	refining_feedback_path = ""
	refining_feedback_text = "升转阵待启"
	_show_refining()

func _sync_selected_upgrade_gu() -> void:
	if selected_upgrade_gu != "" and GuService.can_upgrade_mortal(state, selected_upgrade_gu):
		return
	selected_upgrade_gu = ""
	for gu_id_value in state.get_gu_ids(""):
		var gu_id := String(gu_id_value)
		if GuService.can_upgrade_mortal(state, gu_id):
			selected_upgrade_gu = gu_id
			return

func _try_refine() -> void:
	var recipe: Dictionary = GameState.REFINE_RECIPES[selected_recipe]
	var result_id := String(recipe["result"])
	var result_def: Dictionary = GameState.GU_DEFINITIONS[result_id]
	var costs: Dictionary = recipe["costs"]
	var preview: Dictionary = RefineService.immortal_refine_preview(state, recipe)
	var missing: Array = preview.get("missing", [])
	if not missing.is_empty():
		refining_feedback_path = ""
		refining_feedback_text = "合炼链不足"
		state.add_log("炼蛊失败：合炼链缺口未补齐。")
		SaveService.save_game(state)
		_show_refining()
		return
	if not state.can_pay(costs):
		refining_feedback_path = ""
		refining_feedback_text = "材料不足"
		state.add_log("炼蛊失败：材料或资源不足。")
		SaveService.save_game(state)
		_show_refining()
		return
	state.pay(costs)
	_pay_required_gu(recipe)
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

	var success_rate: float = float(preview.get("success_rate", recipe["base_success"]))
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

func _try_upgrade_gu() -> void:
	if selected_upgrade_gu == "":
		state.add_log("升转失败：未选择蛊虫。")
		_show_refining()
		return
	var result: Dictionary = RefineService.try_upgrade(state, selected_upgrade_gu, rng)
	var months := int(result.get("months", 1))
	if String(result.get("feedback", "")) != "blocked":
		WorldClock.advance_months(state, months, "升转%s" % state.get_gu_name(selected_upgrade_gu))
	if bool(result.get("ok", false)):
		refining_feedback_path = String(EFFECT_IMAGE_PATHS["refine_success"])
		refining_feedback_text = "升转成功"
	else:
		refining_feedback_path = "" if String(result.get("feedback", "")) == "blocked" else String(EFFECT_IMAGE_PATHS["backlash"])
		refining_feedback_text = "升转受阻" if String(result.get("feedback", "")) == "blocked" else "升转反噬"
	state.add_log(String(result.get("message", "")))
	SaveService.save_game(state)
	_show_refining()

func _recipe_gu_requirements_text(recipe: Dictionary) -> String:
	var requires: Dictionary = recipe.get("requires_gu", {})
	if requires.is_empty():
		return "无"
	var parts: Array = []
	for gu_id in requires.keys():
		parts.append("%s x%d" % [state.get_gu_name(String(gu_id)), int(requires[gu_id])])
	return _join_strings(parts, " / ")

func _has_required_gu(recipe: Dictionary) -> bool:
	var requires: Dictionary = recipe.get("requires_gu", {})
	for gu_id in requires.keys():
		if not state.has_gu(String(gu_id), int(requires[gu_id])):
			return false
	return true

func _pay_required_gu(recipe: Dictionary) -> void:
	var requires: Dictionary = recipe.get("requires_gu", {})
	for gu_id in requires.keys():
		state.remove_gu(String(gu_id), int(requires[gu_id]))

func _show_killer_move() -> void:
	if _redirect_if_death_locked("killer"):
		return
	if not state.has_gu(selected_core):
		var cores: Array = state.get_gu_ids("core")
		selected_core = String(cores[0]) if cores.size() > 0 else "sword_core"
	var shell := _build_shell("杀招配置", "res://assets/reference/killer_move.png", "killer")
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	shell.add_child(body)

	var left := _add_panel(body, "蛊虫库", Vector2(520, 0))
	var left_content := _scroll_box(left)
	left_content.add_child(_section_label("核心蛊"))
	for id in state.get_gu_ids("core"):
		var def: Dictionary = GameState.GU_DEFINITIONS[id]
		left_content.add_child(_gu_choice_button(String(id), "%s\n%s" % [def["name"], state.get_gu_status_text(String(id))], selected_core == id, Callable(self, "_set_core_gu").bind(id)))
	left_content.add_child(_section_label("辅助蛊"))
	for id in state.get_gu_ids("plugin"):
		var def: Dictionary = GameState.GU_DEFINITIONS[id]
		left_content.add_child(_gu_choice_button(String(id), "%s\n%s" % [def["name"], state.get_gu_status_text(String(id))], selected_plugins.has(id), Callable(self, "_toggle_plugin").bind(id)))

	var move: Dictionary = state.build_killer_move(selected_core, selected_plugins)
	var center := _add_panel(body, "杀招矩阵", Vector2(760, 0))
	var center_content := _scroll_box(center)
	center_content.add_child(_matrix_preview(move))
	var action_row := HBoxContainer.new()
	action_row.add_theme_constant_override("separation", 10)
	center_content.add_child(action_row)
	action_row.add_child(_killer_action_button("保存杀招", Callable(self, "_save_killer_move"), true))
	action_row.add_child(_killer_action_button("保存为防御脚本", Callable(self, "_save_defense_script"), false))
	action_row.add_child(_killer_action_button("模拟运行（推进1月）", Callable(self, "_simulate_killer_move"), false))
	action_row.add_child(_killer_action_button("清空矩阵", Callable(self, "_clear_killer_matrix"), false, "clear_matrix"))

	var right := _add_panel(body, "编译结果", Vector2(560, 0))
	var right_content := _scroll_box(right)
	right_content.add_child(_killer_result_row("威力", int(move["power"] / 12), COLOR_CYAN, "attr_power"))
	right_content.add_child(_killer_result_row("稳定度", int(move["stability"]), COLOR_GREEN if int(move["stability"]) >= 70 else COLOR_GOLD, "attr_stability"))
	right_content.add_child(_killer_result_row("异常风险", int(move["risk"]), COLOR_RED if int(move["risk"]) > 35 else COLOR_GOLD, "attr_risk"))
	var tags: Array = move.get("tags", [])
	var coverage_text := "单体"
	if tags.has("split"):
		coverage_text = "分裂弹道"
	elif tags.has("pierce"):
		coverage_text = "单体贯穿"
	right_content.add_child(_icon_text_line("灵气消耗", "%d / 次" % int(move["spirit_cost"]), "attr_spirit_cost"))
	right_content.add_child(_icon_text_line("覆盖范围", coverage_text, "attr_range"))
	right_content.add_child(_icon_text_line("自动寻敌", "是" if tags.has("homing") else "否", "attr_homing"))
	right_content.add_child(_text_line("冷却", "%.1f 秒" % float(move["cooldown"])))
	right_content.add_child(_killer_diagnosis_box(move))
	right_content.add_child(_killer_preview_card())
	right_content.add_child(_text_line("出战槽位", "%d / 5" % state.get_combat_killer_moves().size()))
	right_content.add_child(_text_line("防御脚本", String(state.get_active_defense_script().get("name", "未保存")) if not state.defense_scripts.is_empty() else "未保存"))
	right_content.add_child(_section_label("已保存杀招"))
	for i in range(state.killer_moves.size()):
		var saved: Dictionary = state.killer_moves[i]
		right_content.add_child(_saved_killer_move_row(i, saved))

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
	if not _compile_killer_move(move, "保存杀招", true):
		SaveService.save_game(state)
		_show_killer_move()
		return
	state.add_killer_move(move)
	SaveService.save_game(state)
	_show_killer_move()

func _save_defense_script() -> void:
	var move: Dictionary = state.build_killer_move(selected_core, selected_plugins)
	if not _compile_killer_move(move, "保存防御脚本", true):
		SaveService.save_game(state)
		_show_killer_move()
		return
	state.add_defense_script(move)
	TribulationService.prepare_defense(state)
	SaveService.save_game(state)
	_show_killer_move()

func _simulate_killer_move() -> void:
	var move: Dictionary = state.build_killer_move(selected_core, selected_plugins)
	_compile_killer_move(move, "模拟运行", false)
	SaveService.save_game(state)
	_show_killer_move()

func _set_active_move(index: int) -> void:
	state.active_killer_move = index
	SaveService.save_game(state)
	_show_killer_move()

func _toggle_combat_move(index: int) -> void:
	if state.active_combat_moves.has(index):
		state.set_combat_move_enabled(index, false)
		state.add_log("杀招已下阵：%s。" % String(state.killer_moves[index].get("name", "杀招")))
	elif state.active_combat_moves.size() >= 5:
		state.add_log("战斗最多选择 5 个杀招。")
	else:
		state.set_combat_move_enabled(index, true)
		state.add_log("杀招已设为出战：%s。" % String(state.killer_moves[index].get("name", "杀招")))
	SaveService.save_game(state)
	_show_killer_move()

func _saved_killer_move_row(index: int, saved: Dictionary) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	var name_button := _choice_button(String(saved.get("name", "杀招")), state.active_killer_move == index, Callable(self, "_set_active_move").bind(index))
	name_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(name_button)
	var in_battle: bool = state.active_combat_moves.has(index)
	var battle_button := _button("下阵" if in_battle else "出战", Callable(self, "_toggle_combat_move").bind(index), in_battle)
	battle_button.custom_minimum_size = Vector2(92, 42)
	battle_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	row.add_child(battle_button)
	return row

func _compile_killer_move(move: Dictionary, reason: String, for_save: bool) -> bool:
	WorldClock.advance_months(state, 1, "%s%s" % [reason, move.get("name", "杀招")])
	var success_chance: int = clampi(int(move.get("stability", 50)) + 8 - int(move.get("risk", 20)) / 3, 12, 96)
	if rng.randi_range(1, 100) <= success_chance:
		state.add_log("%s成功：%s 通过模拟，成功率判定 %d%%。" % [reason, move.get("name", "杀招"), success_chance])
		return true
	var lost_gu := _damage_killer_move_components(move)
	var damage := rng.randi_range(8, 20)
	state.character["hp"] = max(1, int(state.character.get("hp", 100)) - damage)
	var lifespan_loss := 15 if for_save else 8
	state.character["lifespan_days"] = max(0, int(state.character.get("lifespan_days", 0)) - lifespan_loss)
	state.add_log("%s失败：%s 依赖链反噬，生命 -%d，寿元 -%d 天%s。" % [reason, move.get("name", "杀招"), damage, lifespan_loss, lost_gu])
	return false

func _damage_killer_move_components(move: Dictionary) -> String:
	var plugins: Array = move.get("plugins", [])
	var mortal_plugins: Array = []
	for plugin_id_value in plugins:
		var plugin_id := String(plugin_id_value)
		var gu_def: Dictionary = GameState.GU_DEFINITIONS.get(plugin_id, {})
		if int(gu_def.get("rank", 1)) < 6 and state.has_gu(plugin_id):
			mortal_plugins.append(plugin_id)
	if not mortal_plugins.is_empty():
		var lost_id := String(mortal_plugins[rng.randi_range(0, mortal_plugins.size() - 1)])
		state.remove_gu(lost_id, 1)
		return "，损失凡蛊：%s" % state.get_gu_name(lost_id)
	var core_id := String(move.get("core", ""))
	var core_def: Dictionary = GameState.GU_DEFINITIONS.get(core_id, {})
	if core_id != "" and int(core_def.get("rank", 1)) >= 6 and state.has_gu(core_id):
		ApertureService.runtime_degrade_gu(state, core_id, 18)
		return "，仙蛊受创：%s" % state.get_gu_name(core_id)
	return ""

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
		right.add_child(_warning_line("低信任人物可能抬价、设伏或借订单传播假情报。"))

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

func _has_person_ambush_event() -> bool:
	for raw_event in state.world_events:
		var event: Dictionary = raw_event
		if bool(event.get("resolved", false)):
			continue
		var kind := String(event.get("kind", ""))
		if kind in ["战后袭击窗口", "反噬伏击", "仇敌标记"]:
			return true
	return false

func _show_dynamic_npc() -> void:
	if state.has_method("ensure_world_defaults"):
		state.ensure_world_defaults()
	_sync_selected_npc()
	var shell: VBoxContainer = _build_shell("人物利益博弈", "res://assets/reference/npc_dialogue.png", "npc")
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	shell.add_child(body)

	var left: VBoxContainer = _add_panel(body, "五域人物", Vector2(470, 0))
	var known_people := _known_people()
	for raw_npc in known_people:
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
		center.add_child(_warning_line("暂无可交互人物。"))
	else:
		var npc: Dictionary = state.npcs[npc_index]
		var portrait_path: String = "res://assets/characters/npc_%s.png" % String(npc.get("id", "xuanwuzi"))
		center.add_child(_npc_portrait_view(portrait_path, String(npc.get("name", "人物"))))
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
	right.add_child(_warning_line("低信任人物会拒绝、抬价、散布谣言，甚至在你战后虚弱时制造袭击窗口。"))
	if _has_person_ambush_event():
		right.add_child(_button("迎击人物袭击", Callable(self, "_start_person_ambush_combat"), true))

func _sync_selected_npc() -> void:
	if _selected_npc_index() >= 0:
		return
	var known_people := _known_people()
	if known_people.is_empty():
		selected_npc_id = ""
		return
	var npc: Dictionary = known_people[0]
	selected_npc_id = String(npc.get("id", ""))

func _selected_npc_index() -> int:
	for i in range(state.npcs.size()):
		var npc: Dictionary = state.npcs[i]
		if String(npc.get("id", "")) == selected_npc_id and bool(npc.get("alive", true)) and bool(npc.get("met", false)):
			return i
	return -1

func _npc_select(npc_id: String) -> void:
	for raw_npc in _known_people():
		var npc: Dictionary = raw_npc
		if String(npc.get("id", "")) == npc_id:
			selected_npc_id = npc_id
			_show_npc()
			return
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
		state.add_log("%s收下情报，交出炼蛊材料 x2。" % String(npc.get("name", "人物")))
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
		state.add_log("临时结盟达成：%s提供一条遗迹情报。" % String(npc.get("name", "人物")))
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
		state.add_log("打探成功：你从%s处套出“%s”。" % [String(npc.get("name", "人物")), clue])
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
		state.add_log("威胁奏效：%s交出高价值线索，但仇怨加深。" % String(npc.get("name", "人物")))
	else:
		state.character["hp"] = max(1, int(state.character.get("hp", 100)) - 24)
		_add_world_event("反噬伏击", String(npc.get("id", "")), "player", 72)
		npc["last_action"] = "反制玩家威胁"
		state.add_log("威胁失败：%s暗中反击，你受伤撤退。" % String(npc.get("name", "人物")))
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
	state.add_log("你将%s标记为仇敌，后续可能触发袭击或悬赏。" % String(npc.get("name", "人物")))
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

func _lifespan_status_color(status: String) -> Color:
	if status == LongevityDefs.STATUS_DEAD or status == LongevityDefs.STATUS_DYING or status == LongevityDefs.STATUS_CRITICAL:
		return COLOR_RED
	if status == LongevityDefs.STATUS_WARNING:
		return COLOR_GOLD
	return COLOR_CYAN

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
	if _redirect_if_death_locked("market"):
		return
	if not _can_use_market():
		_show_locked_feature("宝黄天未通", "宝黄天需要六转蛊仙后才能稳定沟通；当前只能通过剧情、人物或线索间接接触订单。", "market", String(SCREEN_BACKGROUND_PATHS["market"]))
		return
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
	if _redirect_if_death_locked("npc"):
		return
	if _known_people_count() == 0:
		_show_locked_feature("人物未遇", "你还没有在探索中真正遇到可交互人物。人物会随地点事件、交易和敌对事件出现，也可能死亡。", "npc", String(SCREEN_BACKGROUND_PATHS["npc"]))
		return
	_show_dynamic_npc()
	return
	var shell := _build_shell("人物利益交互", "res://assets/reference/npc_dialogue.png", "npc")
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
	right.add_child(_warning_line("人物行动以自身利益最大化为准，关系不足时可能背叛。"))

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
	if _redirect_if_death_locked("combat"):
		return
	_clear()
	if encounter.is_empty():
		state.add_log("战斗必须由剧情、副本、人物事件、夺寿追杀或灾劫触发。")
		_show_exploration()
		return
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
	_build_header(top, "事件战斗")

	var left_panel := _floating_panel("战斗信息", Rect2(18, 112, 312, 800))
	var left := _panel_body(left_panel)
	var first_combat_move: Dictionary = _combat_move_for_slot(0)
	left.add_child(_text_line("遭遇", CombatService.combat_title(combat_encounter)))
	left.add_child(_text_line("出战杀招", "%d / 5" % state.get_combat_killer_moves().size()))
	left.add_child(_text_line("灵气", _format_number(state.get_resource("spirit_qi"))))
	combat_hp_bar = ProgressBar.new()
	combat_hp_bar.max_value = int(state.character.get("max_hp", 100))
	combat_hp_bar.value = int(state.character.get("hp", 100))
	combat_hp_bar.show_percentage = false
	_apply_progress_skin(combat_hp_bar, String(PROGRESS_UI_PATHS["fill_red"]))
	left.add_child(_labeled_control("生命", combat_hp_bar))
	combat_cd_bar = ProgressBar.new()
	combat_cd_bar.max_value = max(0.1, float(first_combat_move.get("cooldown", 2.0)))
	combat_cd_bar.value = 0
	combat_cd_bar.show_percentage = false
	_apply_progress_skin(combat_cd_bar, String(PROGRESS_UI_PATHS["fill_cyan"]))
	left.add_child(_labeled_control("冷却", combat_cd_bar))
	left.add_child(_section_label("操作"))
	left.add_child(_text_line("移动", "W / A / S / D"))
	left.add_child(_text_line("释放杀招", "Space 或 1-5"))
	left.add_child(_button("释放1号杀招", Callable(self, "_cast_killer_move").bind(0)))
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
	bottom.offset_left = 160
	bottom.offset_right = -160
	bottom.offset_top = -126
	bottom.offset_bottom = -18
	bottom.add_theme_constant_override("separation", 10)
	add_child(bottom)
	var combat_moves: Array = state.get_combat_killer_moves()
	for slot in range(5):
		var hotbar_move: Dictionary = combat_moves[slot] if slot < combat_moves.size() else {}
		if hotbar_move.is_empty():
			bottom.add_child(_hotbar_card(str(slot + 1), "未装配", "在杀招页选择出战杀招"))
		else:
			bottom.add_child(_hotbar_card(str(slot + 1), String(hotbar_move.get("name", "杀招")), "威力 %d / 稳定 %d%%" % [int(hotbar_move.get("power", 0)), int(hotbar_move.get("stability", 0))]))

	if combat_message != "":
		var overlay := _floating_panel("战斗结算", Rect2(650, 350, 620, 280))
		var box := _panel_body(overlay)
		var result := Label.new()
		result.text = combat_message
		result.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		result.add_theme_font_size_override("font_size", 30)
		result.add_theme_color_override("font_color", COLOR_GOLD)
		box.add_child(result)
		if LongevityService.is_death_locked(state):
			box.add_child(_button("查看终局", Callable(self, "_show_longevity"), true))
		else:
			box.add_child(_button("返回仙窍", Callable(self, "_show_aperture")))
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
	for slot in range(5):
		if Input.is_action_just_pressed("cast_%d" % (slot + 1)):
			_cast_killer_move(slot)
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

func _combat_move_for_slot(slot_index: int) -> Dictionary:
	var moves: Array = state.get_combat_killer_moves()
	if slot_index >= 0 and slot_index < moves.size():
		return moves[slot_index]
	return {}

func _cast_killer_move(slot_index: int = 0) -> void:
	if current_screen != "combat" or not combat_active:
		return
	var move: Dictionary = _combat_move_for_slot(slot_index)
	if move.is_empty():
		_combat_log("第 %d 个战斗槽未装配杀招。" % (slot_index + 1))
		return
	var cost: int = int(move.get("spirit_cost", 100))
	if combat_cooldown > 0.0:
		_combat_log("杀招冷却中。")
		return
	if state.get_resource("spirit_qi") < cost:
		_combat_log("灵气不足，杀招编译中断。")
		return
	state.add_resource("spirit_qi", -cost)
	combat_cooldown = float(move.get("cooldown", 2.0))
	if combat_cd_bar != null:
		combat_cd_bar.max_value = max(0.1, combat_cooldown)
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
		_combat_log("释放 %d号：%s。" % [slot_index + 1, move.get("name", "杀招")])
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
	if victory:
		var result_text: String = DungeonService.apply_result(state, combat_encounter, true)
		WorldClock.advance_months(state, 1, "战斗胜利")
		state.add_log("战斗胜利：%s。" % result_text)
		combat_message = "战斗胜利\n%s" % result_text
	else:
		var death_text: String = LongevityService.handle_combat_death(state, combat_encounter)
		state.add_log("战斗终局：%s。" % death_text)
		combat_message = "战斗死亡\n%s" % death_text
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
		var projectile_frame := Vector2i(256, 256)
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
	var source_frame_size := _actor_sheet_frame_size(sheet_path)
	if _is_compact_actor_sheet(texture, source_frame_size):
		var compact_frame := int(floor(combat_elapsed * 8.0)) % SPRITE_COMPACT_COLUMNS
		var compact_row := _compact_sprite_direction_row(facing)
		var compact_src := Rect2(Vector2(compact_frame * source_frame_size.x, compact_row * source_frame_size.y), Vector2(source_frame_size.x, source_frame_size.y))
		var compact_scale := draw_size.x / float(source_frame_size.x)
		var compact_size := Vector2(source_frame_size.x, source_frame_size.y) * compact_scale
		var compact_foot_anchor := Vector2(float(source_frame_size.x) * 0.5, float(source_frame_size.y) * (SPRITE_FOOT_ANCHOR.y / float(SPRITE_FRAME_SIZE.y)))
		var compact_top_left := foot_center - compact_foot_anchor * compact_scale
		draw_texture_rect_region(texture, Rect2(compact_top_left, compact_size), compact_src, color)
		return true
	var action_name := action
	if not SPRITE_ACTION_ROW_OFFSET.has(action_name):
		action_name = "idle"
	var frame_count := 4 if action_name == "hit" else 8
	var frame := int(floor(combat_elapsed * 8.0)) % frame_count
	var direction_index := _sprite_direction_index(facing)
	var row := int(SPRITE_ACTION_ROW_OFFSET[action_name]) + direction_index
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

func _is_compact_actor_sheet(texture: Texture2D, frame_size: Vector2i) -> bool:
	var texture_size := texture.get_size()
	return int(texture_size.x) == frame_size.x * SPRITE_COMPACT_COLUMNS and int(texture_size.y) == frame_size.y * SPRITE_COMPACT_ROWS

func _compact_sprite_direction_row(direction: Vector2) -> int:
	if absf(direction.x) > absf(direction.y):
		return 2 if direction.x >= 0.0 else 1
	return 0 if direction.y >= 0.0 else 3

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
	var texture_size := texture.get_size()
	var effective_frame_size := frame_size
	if texture_size.y > 0.0:
		var inferred_side := int(round(texture_size.y))
		if inferred_side > 0 and int(texture_size.x) >= inferred_side:
			effective_frame_size = Vector2i(inferred_side, inferred_side)
	var available_frames := int(floor(texture_size.x / float(effective_frame_size.x)))
	if available_frames <= 0:
		return false
	var count: int = max(1, min(frame_count, available_frames))
	var frame := int(floor(combat_elapsed * 14.0)) % count
	var src := Rect2(Vector2(frame * effective_frame_size.x, 0), Vector2(effective_frame_size.x, effective_frame_size.y))
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
		"exploration":
			_show_exploration()
		"aperture":
			_show_aperture()
		"cultivation":
			_show_cultivation()
		"longevity", "death":
			_show_longevity()
		"refining":
			_show_refining()
		"killer":
			_show_killer_move()
		"market":
			_show_market()
		"npc":
			_show_npc()
		"story", "dungeon":
			_show_exploration()
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

func _scroll_box(parent: VBoxContainer, min_size: Vector2 = Vector2.ZERO) -> VBoxContainer:
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.follow_focus = true
	if min_size != Vector2.ZERO:
		scroll.custom_minimum_size = min_size
	parent.add_child(scroll)
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 8)
	scroll.add_child(box)
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
			box.add_child(_gu_info_row(String(id), state.get_gu_status_text(String(id))))
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
	var panel := _panel_container(Vector2(0, 78), String(LOG_UI_PATHS["item"]), 10)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var box := _panel_body(panel)
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.clip_text = false
	label.custom_minimum_size = Vector2(0, 42)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", Color(0.96, 0.91, 0.78, 1.0))
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.92))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	_apply_font(label)
	box.add_child(label)
	return panel

func _hotbar_card(key: String, title: String, desc: String) -> PanelContainer:
	var panel := _panel_container(Vector2(200, 96), String(COMBAT_UI_PATHS["hotbar_slot"]), 12)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
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

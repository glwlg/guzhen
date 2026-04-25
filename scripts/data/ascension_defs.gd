extends RefCounted

const STAGE_IDS := ["low", "mid", "high", "peak"]
const STAGE_NAMES := ["初阶", "中阶", "高阶", "巅峰"]

const ASCENSION_PHASES := [
	{
		"id": "qi_balance",
		"name": "天地二气平衡",
		"description": "以灵气与仙窍稳定承接天地倒灌，失衡会直接引爆灾劫压力。",
		"difficulty": 96,
		"success_hint": "天地二气暂时归流，仙窍承压上限提高。"
	},
	{
		"id": "dao_pressure",
		"name": "道痕承压",
		"description": "以主修道痕为骨架重塑仙窍，互斥率越高越容易崩解。",
		"difficulty": 108,
		"success_hint": "道痕重新排布，仙窍底蕴开始蜕变。"
	},
	{
		"id": "inner_demon",
		"name": "心魔抉择",
		"description": "心魔会放大寿元焦虑与杀伐因果，成败会让命数暗流偏移。",
		"difficulty": 102,
		"success_hint": "心魔退散，你以本心压住升仙反噬。"
	}
]

static func breakthrough_threshold(rank: int, stage: int) -> int:
	rank = clampi(rank, 1, 9)
	stage = clampi(stage, 0, STAGE_NAMES.size() - 1)
	if rank >= 6:
		return 720 + (rank - 6) * 380 + stage * 120
	if rank == 5 and stage == 3:
		return 0
	return 160 + (rank - 1) * 210 + stage * 90

static func breakthrough_cost(rank: int, stage: int) -> Dictionary:
	rank = clampi(rank, 1, 9)
	stage = clampi(stage, 0, STAGE_NAMES.size() - 1)
	return {
		"spirit_qi": 520 + rank * 260 + stage * 120,
		"immortal_stone": 60 + rank * 34 + stage * 18,
		"intel": 8 + rank * 5 + stage * 3
	}

static func breakthrough_base_chance(rank: int, stage: int) -> int:
	rank = clampi(rank, 1, 9)
	stage = clampi(stage, 0, STAGE_NAMES.size() - 1)
	return clampi(78 - rank * 4 - stage * 3, 38, 82)

static func retreat_cost(months: int) -> Dictionary:
	months = max(1, months)
	return {
		"spirit_qi": 420 * months,
		"immortal_stone": 32 * months
	}

static func retreat_gain(rank: int, months: int) -> int:
	months = max(1, months)
	rank = clampi(rank, 1, 9)
	return (72 + rank * 14) * months

static func passive_gain(rank: int, stability: int, qi_balance: int, food: int, months: int) -> int:
	months = max(1, months)
	rank = clampi(rank, 1, 9)
	var infrastructure_bonus: int = int(round(float(stability + qi_balance + food) / 12.0))
	return max(4, (8 + infrastructure_bonus - rank) * months)

static func ascension_cost() -> Dictionary:
	return {
		"spirit_qi": 18000,
		"immortal_stone": 1800,
		"intel": 420,
		"materials": 6
	}

static func ascension_phases() -> Array:
	return ASCENSION_PHASES.duplicate(true)

static func stage_name(stage: int) -> String:
	return String(STAGE_NAMES[clampi(stage, 0, STAGE_NAMES.size() - 1)])

static func stage_id(stage: int) -> String:
	return String(STAGE_IDS[clampi(stage, 0, STAGE_IDS.size() - 1)])

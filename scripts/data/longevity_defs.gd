extends RefCounted

const STATUS_STABLE := "stable"
const STATUS_WARNING := "warning"
const STATUS_CRITICAL := "critical"
const STATUS_DYING := "dying"
const STATUS_DEAD := "dead"

const STATUS_LABELS := {
	STATUS_STABLE: "稳定",
	STATUS_WARNING: "预警",
	STATUS_CRITICAL: "危急",
	STATUS_DYING: "濒死",
	STATUS_DEAD: "死亡锁定"
}

const STATUS_THRESHOLDS := {
	STATUS_WARNING: 720,
	STATUS_CRITICAL: 180,
	STATUS_DYING: 30
}

const GU_TIERS := {
	"mortal": {
		"name": "凡品寿蛊",
		"days": 180,
		"side_effect_risk": 8,
		"description": "延寿半年，副作用较轻。"
	},
	"earth": {
		"name": "地品寿蛊",
		"days": 360,
		"side_effect_risk": 14,
		"description": "延寿一年，会轻微扰动仙窍。"
	},
	"heaven": {
		"name": "天品寿蛊",
		"days": 1080,
		"side_effect_risk": 24,
		"description": "延寿三年，消息泄露后极易引发争夺。"
	}
}

const LEAD_STATUS_LABELS := {
	"rumor": "谣言",
	"suspicious": "可疑",
	"verified": "已确认",
	"fake": "假情报",
	"expired": "过期",
	"resolved": "已结算"
}

const LEAD_TEMPLATES := [
	{
		"title": "北原冰缝传来寿道虫鸣",
		"region": "northern_plains",
		"source": "雪线散修",
		"body": "有散修在极北冰缝听到类似寿蛊振翅的声响，但同路人已经失踪。",
		"tier": "mortal",
		"risk": 48,
		"truthfulness": 72
	},
	{
		"title": "南疆腐木洞天现青白命火",
		"region": "southern_border",
		"source": "幽泉宗暗线",
		"body": "腐木洞天深处有命火反复明灭，疑似寿蛊蜕壳留下的残痕。",
		"tier": "earth",
		"risk": 64,
		"truthfulness": 62
	},
	{
		"title": "东海虚市有人匿名竞拍寿蛊壳",
		"region": "eastern_sea",
		"source": "宝黄天拍卖影像",
		"body": "匿名卖家只接受仙元石和高阶情报，真假尚未确认。",
		"tier": "earth",
		"risk": 58,
		"truthfulness": 56
	},
	{
		"title": "西漠古井倒映破碎沙漏",
		"region": "western_desert",
		"source": "归墟子旧帖",
		"body": "古井倒影被反复转卖，可能是寿蛊线索，也可能是钓鱼陷阱。",
		"tier": "mortal",
		"risk": 72,
		"truthfulness": 38
	},
	{
		"title": "中洲禁阵封存天品寿蛊残息",
		"region": "central_continent",
		"source": "天庭余脉密报",
		"body": "密报声称禁阵中仍有天品寿蛊残息，但进入者会被多方势力追踪。",
		"tier": "heaven",
		"risk": 86,
		"truthfulness": 48
	}
]

const AUCTION_EVENTS := [
	{"title": "宝黄天匿名寿蛊竞拍", "tier": "mortal", "base_price": 900, "risk": 46},
	{"title": "虚空市集寿道残蛊竞拍", "tier": "earth", "base_price": 1800, "risk": 62},
	{"title": "五域暗线争夺天品寿蛊", "tier": "heaven", "base_price": 4200, "risk": 84}
]

static func status_for_days(days: int) -> String:
	if days <= 0:
		return STATUS_DEAD
	if days <= int(STATUS_THRESHOLDS[STATUS_DYING]):
		return STATUS_DYING
	if days <= int(STATUS_THRESHOLDS[STATUS_CRITICAL]):
		return STATUS_CRITICAL
	if days <= int(STATUS_THRESHOLDS[STATUS_WARNING]):
		return STATUS_WARNING
	return STATUS_STABLE

static func status_label(status: String) -> String:
	return String(STATUS_LABELS.get(status, status))

static func lead_status_label(status: String) -> String:
	return String(LEAD_STATUS_LABELS.get(status, status))

static func gu_tier_ids() -> Array:
	return ["mortal", "earth", "heaven"]

static func gu_tier(tier_id: String) -> Dictionary:
	return GU_TIERS.get(tier_id, GU_TIERS["mortal"]).duplicate(true)

static func random_lead_template() -> Dictionary:
	return LEAD_TEMPLATES[randi_range(0, LEAD_TEMPLATES.size() - 1)].duplicate(true)

static func random_auction(days_left: int) -> Dictionary:
	if days_left <= int(STATUS_THRESHOLDS[STATUS_DYING]):
		return AUCTION_EVENTS[2].duplicate(true)
	if days_left <= int(STATUS_THRESHOLDS[STATUS_CRITICAL]):
		return AUCTION_EVENTS[randi_range(1, 2)].duplicate(true)
	return AUCTION_EVENTS[randi_range(0, AUCTION_EVENTS.size() - 1)].duplicate(true)

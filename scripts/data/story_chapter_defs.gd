extends RefCounted

const CHAPTER_ORDER := [
	"origin_humble",
	"origin_clan",
	"origin_orphan",
	"origin_exile",
	"origin_reborn",
	"gu_yue_village",
	"qingmao_crisis",
	"bai_gu_mountain",
	"shang_clan_city",
	"three_kings_mountain",
	"hu_immortal_blessed_land",
	"northern_plains_imperial_court",
	"zombie_langya",
	"yi_tian_mountain",
	"southern_border_dream",
	"reverse_flow_shadow_sect",
	"fate_war_heavenly_court"
]

const CHAPTERS := {
	"origin_humble": {
		"name": "山脚寒门",
		"act": "出身线",
		"kind": "choice",
		"default_unlocked": false,
		"background": "res://assets/backgrounds/story/origin_humble.png",
		"summary": "你不是古月山寨嫡系，只是青茅山脚被卷进修行风暴的寒门子弟。先活下去，再决定是否靠近山寨。",
		"unlocks": ["gu_yue_village"],
		"choices": [
			{"id": "work_for_school", "title": "替族学跑腿", "body": "以杂役身份接近族学，换取低阶情报和旁听机会。", "costs": {"spirit_qi": 300}, "rewards": {"intel": 120}, "cultivation_exp": 90, "meet_npcs": ["branch_clansman"], "morality_delta": 1, "log": "出身线：你从族学杂役做起，摸到青茅山修行圈的边。"},
			{"id": "black_market_seed", "title": "投向黑市牙人", "body": "避开族规，先拿资源，但会被黑市记住气味。", "costs": {"intel": 60}, "rewards": {"materials": 2, "immortal_stone": 160}, "morality_delta": -3, "log": "出身线：你与黑市牙人交易，资源到手，债也到手。"},
			{"id": "save_village_child", "title": "救下采药孩童", "body": "冒险救人，得到一条山寨内部线索。", "costs": {"spirit_qi": 500}, "rewards": {"intel": 180}, "meet_npcs": ["branch_clansman"], "morality_delta": 4, "log": "出身线：你救下采药孩童，旁支中有人开始信你。"},
			{"id": "steal_first_gu", "title": "偷取第一只凡蛊", "body": "从供奉残龛中偷走残蛊，风险高，但立刻能补强杀招链。", "costs": {"intel": 90}, "rewards": {"materials": 1}, "gu_rewards": ["liquor_worm"], "morality_delta": -5, "log": "出身线：你偷得一只残蛊，青茅山的规矩从此与你为敌。"}
		]
	},
	"origin_clan": {
		"name": "世家嫡系",
		"act": "出身线",
		"kind": "choice",
		"default_unlocked": false,
		"background": "res://assets/backgrounds/story/origin_clan.png",
		"summary": "你出生在地方世家，资源不缺，束缚也不缺。族老、旁支和同辈都在看你第一步怎么走。",
		"unlocks": ["gu_yue_village"],
		"choices": [
			{"id": "family_resources", "title": "动用嫡系资源", "body": "正面接受家族供养，短期最稳，但会欠下家族因果。", "costs": {}, "rewards": {"immortal_stone": 260, "intel": 80}, "cultivation_exp": 80, "meet_npcs": ["gu_yue_elder"], "morality_delta": 0, "log": "出身线：你接过家族资源，也接过家族的目光。"},
			{"id": "protect_branch", "title": "庇护旁支", "body": "压住嫡系傲慢，换来旁支支持。", "costs": {"immortal_stone": 160}, "rewards": {"intel": 180}, "meet_npcs": ["branch_clansman"], "morality_delta": 3, "log": "出身线：你庇护旁支，家族内部的天平偏了一点。"},
			{"id": "suppress_rival", "title": "打压同辈", "body": "用资源和流言抢占族学名额。", "costs": {"intel": 100}, "rewards": {"materials": 2}, "morality_delta": -4, "log": "出身线：你打压同辈，名额到手，仇怨也到手。"},
			{"id": "secret_formula", "title": "私藏残方", "body": "截留家族炼蛊残方，为后续合炼仙蛊铺路。", "costs": {"intel": 140}, "rewards": {"materials": 2}, "gu_rewards": ["time_anchor_gu"], "morality_delta": -2, "log": "出身线：你私藏残方，未来炼蛊链多了一条岔路。"}
		]
	},
	"origin_orphan": {
		"name": "流浪孤儿",
		"act": "出身线",
		"kind": "choice",
		"default_unlocked": false,
		"background": "res://assets/backgrounds/story/origin_orphan.png",
		"summary": "你没有山寨身份，也没有宗门庇护。你听闻青茅山将乱，第一步是选择靠近、绕开，还是趁乱下注。",
		"unlocks": ["qingmao_crisis"],
		"choices": [
			{"id": "join_caravan", "title": "混入商队", "body": "借商队靠近青茅山外围，获得交易线索。", "costs": {"immortal_stone": 100}, "rewards": {"intel": 160, "materials": 1}, "meet_npcs": ["qingluan"], "morality_delta": 0, "log": "出身线：你混入商队，学会用价格衡量危险。"},
			{"id": "beggar_network", "title": "经营乞儿情报网", "body": "从底层消息里拼出青茅山风向。", "costs": {"spirit_qi": 300}, "rewards": {"intel": 220}, "morality_delta": 2, "log": "出身线：你用几顿饭换来许多人的耳朵。"},
			{"id": "rob_bandits", "title": "黑吃黑夺蛊材", "body": "袭击山匪仓点，拿到材料但留下追杀隐患。", "costs": {"spirit_qi": 700}, "rewards": {"materials": 3, "immortal_stone": 120}, "morality_delta": -4, "log": "出身线：你黑吃黑得手，荒野记住了你的味道。"},
			{"id": "avoid_clan", "title": "绕开山寨", "body": "暂不接触古月一族，转而盯上变局后的遗留资源。", "costs": {"intel": 80}, "rewards": {"spirit_qi": 900}, "morality_delta": 0, "log": "出身线：你没有入局山寨，却盯上了山寨崩裂后的碎片。"}
		]
	},
	"origin_exile": {
		"name": "宗门弃徒",
		"act": "出身线",
		"kind": "choice",
		"default_unlocked": false,
		"background": "res://assets/backgrounds/story/origin_exile.png",
		"summary": "你被宗门逐出，旧关系仍在追索。青茅山只是一个可利用的避风口。",
		"unlocks": ["qingmao_crisis"],
		"choices": [
			{"id": "hide_identity", "title": "隐姓埋名", "body": "压住旧日功法痕迹，换取更低追查风险。", "costs": {"intel": 100}, "rewards": {"spirit_qi": 700}, "cultivation_exp": 100, "morality_delta": 0, "log": "出身线：你抹去宗门痕迹，换来短暂安静。"},
			{"id": "sell_sect_secret", "title": "贩卖宗门秘闻", "body": "把旧宗门情报卖给黑市，立刻换资源。", "costs": {}, "rewards": {"immortal_stone": 320, "intel": 120}, "meet_npcs": ["xuanwuzi"], "morality_delta": -5, "log": "出身线：你卖掉旧宗秘闻，从此回头路更窄。"},
			{"id": "hunt_tracker", "title": "反杀追踪者", "body": "主动解决追踪者，可能触发战斗。", "costs": {"spirit_qi": 600}, "rewards": {"materials": 2}, "morality_delta": -3, "log": "出身线：你主动反猎，追踪者不再只是猎人。"},
			{"id": "seek_refuge", "title": "寻找临时庇护", "body": "向散修市盟低头，换取人物关系起点。", "costs": {"immortal_stone": 160}, "rewards": {"intel": 180}, "meet_npcs": ["qingluan"], "morality_delta": 2, "log": "出身线：你买到一张临时护身符，也买到一份人情。"}
		]
	},
	"origin_reborn": {
		"name": "蛊虫转世",
		"act": "出身线",
		"kind": "choice",
		"default_unlocked": false,
		"background": "res://assets/backgrounds/story/origin_reborn.png",
		"summary": "你带着异样的本能醒来。人身、虫性、旧梦和现实互相撕扯。",
		"unlocks": ["qingmao_crisis"],
		"choices": [
			{"id": "suppress_instinct", "title": "压制虫性", "body": "以痛苦换稳定，避免早期暴露异常。", "costs": {"spirit_qi": 600}, "rewards": {"intel": 140}, "cultivation_exp": 120, "morality_delta": 2, "log": "出身线：你压住虫性，至少现在还像一个人。"},
			{"id": "follow_hunger", "title": "顺从吞噬本能", "body": "快速补足蛊虫饱食，但会让命数偏恶。", "costs": {}, "rewards": {"spirit_qi": 1600, "materials": 1}, "morality_delta": -6, "log": "出身线：你顺从饥饿，力量上涨，心也更冷。"},
			{"id": "seek_wisdom_trace", "title": "追索旧梦痕迹", "body": "用智道方式拆解转世残梦。", "costs": {"intel": 120}, "rewards": {"intel": 240}, "gu_rewards": ["time_anchor_gu"], "morality_delta": 0, "log": "出身线：你在旧梦里摸到一丝宙道锚点。"},
			{"id": "contact_shadow_broker", "title": "接触影中掮客", "body": "让懂行的人替你遮掩异常，但他们会索价。", "costs": {"immortal_stone": 220}, "rewards": {"materials": 2}, "meet_npcs": ["guixin"], "morality_delta": -2, "log": "出身线：影中掮客认出你的异常，也递来了交易。"}
		]
	},
	"gu_yue_village": {
		"name": "古月山寨",
		"act": "第一章",
		"kind": "choice",
		"default_unlocked": false,
		"background": "res://assets/backgrounds/story/gu_yue_village.png",
		"summary": "青茅山古月一族暗流涌动。你必须先决定如何在寨中立足，而不是直接拔刀。",
		"unlocks": ["qingmao_crisis"],
		"choices": [
			{
				"id": "endure_and_cultivate",
				"title": "隐忍修行",
				"body": "压下锋芒，借学堂和家族资源稳住修为。",
				"costs": {"spirit_qi": 500},
				"rewards": {"intel": 90},
				"cultivation_exp": 120,
				"morality_delta": 0,
				"log": "古月山寨：你选择隐忍修行，换来更稳的开局。"
			},
			{
				"id": "seize_liquor_worm",
				"title": "夜探酒窖夺酒虫",
				"body": "趁夜潜入旧窖夺取酒虫，短期收益高，但会在暗处结怨。",
				"costs": {"intel": 80},
				"rewards": {"materials": 1},
				"gu_rewards": ["liquor_worm"],
				"morality_delta": -3,
				"log": "古月山寨：你夺得酒虫，山寨暗处有人记下了这笔账。"
			},
			{
				"id": "aid_branch_clansman",
				"title": "救下旁支少年",
				"body": "放弃一部分资源，换取旁支人脉和更干净的名声。",
				"costs": {"immortal_stone": 120},
				"rewards": {"intel": 120, "spirit_qi": 600},
				"meet_npcs": ["branch_clansman"],
				"morality_delta": 4,
				"log": "古月山寨：你救下一名旁支少年，善名在小范围流传。"
			},
			{
				"id": "trade_with_elder",
				"title": "向族老献上情报",
				"body": "承认自己需要靠山，用情报交换族老的临时庇护。",
				"costs": {"intel": 160},
				"rewards": {"immortal_stone": 180, "materials": 1},
				"meet_npcs": ["gu_yue_elder"],
				"morality_delta": 0,
				"log": "古月山寨：族老收下情报，也把你纳入可利用名单。"
			},
			{
				"id": "leave_before_storm",
				"title": "提前离寨",
				"body": "不争眼前小利，避开即将到来的山寨风暴。",
				"costs": {"spirit_qi": 700},
				"rewards": {"intel": 220},
				"morality_delta": 1,
				"log": "古月山寨：你提前离寨，错过部分资源，也避开一部分杀机。"
			}
		]
	},
	"qingmao_crisis": {
		"name": "青茅山变局",
		"act": "第二章",
		"kind": "choice",
		"default_unlocked": false,
		"background": "res://assets/backgrounds/story/qingmao_crisis.png",
		"summary": "山寨格局崩裂，外敌、族规和传承争夺同时压来。",
		"unlocks": ["bai_gu_mountain"],
		"choices": [
			{
				"id": "cover_and_escape",
				"title": "伪装身份突围",
				"body": "制造混乱后脱离青茅山，保留实力但牺牲部分声望。",
				"costs": {"intel": 120},
				"rewards": {"materials": 2, "intel": 80},
				"morality_delta": -2,
				"encounter": {
					"id": "story_qingmao_escape",
					"name": "青茅山突围",
					"objective": "击退追兵，脱离青茅山",
					"background": "res://assets/backgrounds/story/qingmao_crisis.png",
					"branch_id": "story_qingmao_crisis",
					"story_chapter_id": "qingmao_crisis",
					"difficulty_id": "normal",
					"rewards": {"immortal_stone": 260, "intel": 120, "materials": 2},
					"failure": {"lifespan_loss": 0, "months": 0},
					"morality_delta": -2,
					"risk": 42,
					"enemies": [
						{"name": "古月追兵", "sheet": "enemy", "hp": 360, "max_hp": 360, "speed": 122, "damage_min": 6, "damage_max": 13, "pos_ratio": Vector2(0.72, 0.35)},
						{"name": "家族执法蛊师", "sheet": "enemy_elite", "hp": 540, "max_hp": 540, "speed": 94, "damage_min": 9, "damage_max": 18, "pos_ratio": Vector2(0.82, 0.56)}
					]
				},
				"log": "青茅山变局：你以伪装和杀招冲开追兵。"
			},
			{
				"id": "rescue_survivors",
				"title": "救援幸存者",
				"body": "冒险救人并泄露部分行踪，换来后续人物关系的缓和。",
				"costs": {"immortal_stone": 180, "spirit_qi": 900},
				"rewards": {"intel": 260},
				"morality_delta": 5,
				"log": "青茅山变局：你救下一批幸存者，未来会有人认得这份因果。"
			},
			{
				"id": "take_inheritance_and_leave",
				"title": "夺蛊后远遁",
				"body": "放弃救援，集中夺取可用蛊虫和材料。",
				"costs": {"spirit_qi": 1200},
				"rewards": {"materials": 4, "intel": 60},
				"gu_rewards": ["substitute_life_gu"],
				"morality_delta": -6,
				"log": "青茅山变局：你夺蛊远遁，活下来的人未必会原谅。"
			},
			{
				"id": "trade_disaster_intel",
				"title": "贩卖灾后情报",
				"body": "不亲自冒险救援，而是把灾后路线卖给需要的人。",
				"costs": {"intel": 60},
				"rewards": {"immortal_stone": 360, "materials": 1},
				"meet_npcs": ["guixin"],
				"morality_delta": -2,
				"log": "青茅山变局：你把灾后路线卖给了归墟子，换来钱，也换来不安。"
			}
		]
	},
	"bai_gu_mountain": {
		"name": "白骨山逃亡",
		"act": "第三章",
		"kind": "planned",
		"default_unlocked": false,
		"background": "res://assets/backgrounds/story/bai_gu_mountain.png",
		"summary": "逃亡、伪装、夺取白骨传承。后续实现。"
	},
	"shang_clan_city": {
		"name": "商家城",
		"act": "第四章",
		"kind": "planned",
		"default_unlocked": false,
		"background": "res://assets/backgrounds/story/shang_clan_city.png",
		"summary": "交易、赌石、人物结盟与名声经营。后续实现。"
	},
	"three_kings_mountain": {
		"name": "三王山 / 三叉山",
		"act": "第五章",
		"kind": "dungeon",
		"default_unlocked": false,
		"prerequisites": ["shang_clan_city"],
		"background": "res://assets/backgrounds/story_three_kings_mountain.png",
		"summary": "犬王、信王、爆王三条传承线在三叉山同时现世。"
	},
	"hu_immortal_blessed_land": {
		"name": "狐仙福地",
		"act": "第六章",
		"kind": "planned",
		"default_unlocked": false,
		"background": "res://assets/backgrounds/story/hu_immortal_blessed_land.png",
		"summary": "福地争夺、地灵互动和经营扩张。后续实现。"
	},
	"northern_plains_imperial_court": {
		"name": "北原王庭",
		"act": "第七章",
		"kind": "planned",
		"default_unlocked": false,
		"background": "res://assets/backgrounds/story/northern_plains_imperial_court.png",
		"summary": "身份伪装、战争路线和王庭福地。后续实现。"
	},
	"zombie_langya": {
		"name": "仙僵与琅琊",
		"act": "第八章",
		"kind": "planned",
		"default_unlocked": false,
		"background": "res://assets/backgrounds/story/zombie_langya.png",
		"summary": "仙僵代价、琅琊合作和炼道扩展。后续实现。"
	},
	"yi_tian_mountain": {
		"name": "义天山与至尊仙胎",
		"act": "第九章",
		"kind": "planned",
		"default_unlocked": false,
		"background": "res://assets/backgrounds/story/yi_tian_mountain.png",
		"summary": "多方博弈、超级棋局和至尊仙胎。后续实现。"
	},
	"southern_border_dream": {
		"name": "南疆梦境与身份伪装",
		"act": "第十章",
		"kind": "planned",
		"default_unlocked": false,
		"background": "res://assets/backgrounds/story/southern_border_dream.png",
		"summary": "梦境探索、身份伪装和人物关系重排。后续实现。"
	},
	"reverse_flow_shadow_sect": {
		"name": "逆流河与影宗整合",
		"act": "第十一章",
		"kind": "planned",
		"default_unlocked": false,
		"background": "res://assets/backgrounds/story/reverse_flow_shadow_sect.png",
		"summary": "逆流河试炼、影宗资源整合和后期路线分化。后续实现。"
	},
	"fate_war_heavenly_court": {
		"name": "宿命大战 / 攻打天庭",
		"act": "第十二章",
		"kind": "planned",
		"default_unlocked": false,
		"background": "res://assets/backgrounds/story/fate_war_heavenly_court.png",
		"summary": "宿命蛊、天庭大战和最终路线分支。后续实现。"
	}
}

static func chapter_ids() -> Array:
	return CHAPTER_ORDER.duplicate()

static func start_chapter_for_origin(origin: String) -> String:
	match origin:
		"世家嫡系":
			return "origin_clan"
		"流浪孤儿":
			return "origin_orphan"
		"宗门弃徒":
			return "origin_exile"
		"蛊虫转世":
			return "origin_reborn"
	return "origin_humble"

static func chapter(chapter_id: String) -> Dictionary:
	return CHAPTERS.get(chapter_id, CHAPTERS["gu_yue_village"]).duplicate(true)

static func choices(chapter_id: String) -> Array:
	return chapter(chapter_id).get("choices", []).duplicate(true)

static func choice(chapter_id: String, choice_id: String) -> Dictionary:
	for raw_choice in choices(chapter_id):
		var item: Dictionary = raw_choice
		if String(item.get("id", "")) == choice_id:
			return item.duplicate(true)
	return {}

extends RefCounted

static func upgrade_cost(rank: int, school_focus: bool) -> Dictionary:
	rank = clampi(rank, 1, 5)
	var focus_discount := 0.86 if school_focus else 1.0
	return {
		"immortal_stone": int(round(float(90 * rank * rank) * focus_discount)),
		"spirit_qi": int(round(float(520 * rank * rank) * focus_discount)),
		"intel": 18 * rank,
		"materials": max(1, rank)
	}

static func upgrade_success_base(rank: int, school_focus: bool) -> float:
	var base := 0.82 - float(max(0, rank - 1)) * 0.09
	if school_focus:
		base += 0.08
	return clampf(base, 0.22, 0.92)

static func duplicate_required(rank: int) -> int:
	return 1 if rank >= 2 else 0

static func immortal_chain_hint(result_id: String) -> String:
	match result_id:
		"blood_sword":
			return "剑光蛊与穿透、追踪类凡蛊为合炼骨架，剑道道痕越高越稳。"
		"taixu_immortal":
			return "星念蛊、隐匿和追踪凡蛊构成推演链，智道道痕与情报会明显影响结果。"
		"spring_autumn_cicada":
			return "宙锚、运道机缘与智道推演缺一不可，失败时命数反噬极重。"
		_:
			return "需以前置蛊虫、配方、环境和机缘合炼。"

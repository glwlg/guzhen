# 资源需求清单 2：三王山剧情副本与深化玩法

本阶段代码会先使用现有相近素材复制占位，保证玩法可跑；下列素材用于替换占位图。所有 UI 底板不要画入中文、数字或固定图标，文字继续由 Godot 控件绘制。

## P0：三王山章节与副本背景

| 目标路径 | 素材描述 | 建议规格 | 生成要求 |
|---|---|---:|---|
| `res://assets/backgrounds/story_three_kings_mountain.png` | 南疆三叉山/三王山章节远景，群山、雾气、三道传承光柱或秘境入口 | 1920x1080 PNG | 16:9 横图，暗黑修仙风，中央偏下留出章节卡片区域；不要文字、Logo、UI 边框 |
| `res://assets/backgrounds/dungeons/dog_king_trial.png` | 犬王传承副本场景，灰白荒野、骨石、犬群魂影、奴道阵纹 | 1920x1080 PNG | 可用于实时战斗背景，地面可读性高，中间 70% 不要强遮挡，四周可有犬魂轮廓 |
| `res://assets/backgrounds/dungeons/xin_king_trial.png` | 信王传承副本场景，炼道机关、炉鼎、阵盘、毛民试炼感 | 1920x1080 PNG | 暗金机关和青绿炉火，中央留战斗移动区域，不要出现清晰文字 |
| `res://assets/backgrounds/dungeons/bao_king_trial.png` | 爆王传承副本场景，赤黑火山遗迹、爆炎裂纹、危险阵地 | 1920x1080 PNG | 中央地形不要过亮，火光集中在边缘或远景，适合叠加角色和弹道 |

## P0：Boss 精灵图

这些文件统一走 compact boss sheet 工作流，透明底，不要白底。当前代码按 `320x320` 单帧读取，整表为 `4 列 x 4 行` 的 `1280x1280` PNG；行顺序为 `down, left, right, up`，列顺序为 `neutral, left_step, neutral, right_step`。用一张高辨识度的 2.5D 拟 3D 朝向表承载基础移动、站立和施法表现，不再回到超大动作整表。

| 目标路径 | 素材描述 | 建议规格 | 生成要求 |
|---|---|---:|---|
| `res://assets/characters/boss/dog_king_will_sheet.png` | 犬王残念 Boss，半人半魂影，身侧有犬魂或兽骨旗影 | 单帧 320x320；4方向 x 4帧；总图 1280x1280 PNG 透明底 | 脚底锚点统一，轮廓比普通敌人更大；做出犬魂拖尾和残念压迫感 |
| `res://assets/characters/boss/xin_king_construct_sheet.png` | 信王机关灵 Boss，炼道机关傀/炉阵灵体，青金机关核心 | 单帧 320x320；4方向 x 4帧；总图 1280x1280 PNG 透明底 | 体块偏机关和炉阵，不要像普通人形；轮廓要有展开感和法阵附件 |
| `res://assets/characters/boss/bao_king_flame_sheet.png` | 爆王火魄 Boss，赤黑炎魂、破碎铠甲、爆裂法焰 | 单帧 320x320；4方向 x 4帧；总图 1280x1280 PNG 透明底 | 火焰体块要明显，朝向切换时保持同一主体，蓄爆姿态在四方向上都可读 |

## P1：新增流派核心蛊图标

| 目标路径 | 素材描述 | 建议规格 | 生成要求 |
|---|---|---:|---|
| `res://assets/ui/gu/wisdom_core.png` | 智道开局核心“推演星蛊”图标，星盘、棋路、青蓝推演光 | 256x256 PNG 透明底 | 居中完整图标，边缘留 16px 透明边；不要白底、不要文字 |
| `res://assets/ui/gu/luck_core.png` | 运道开局核心“转运金蛊”图标，金色轮盘、气运丝线、玉符 | 256x256 PNG 透明底 | 和现有蛊图标同视角同光感，缩到 54x54 仍能识别 |

## P1：章节 UI 与难度徽章

| 目标路径 | 素材描述 | 建议规格 | 生成要求 |
|---|---|---:|---|
| `res://assets/ui/story/three_kings_chapter_card_9slice.png` | 三王山章节/传承卡片底板，暗金边框、轻微青绿灵光 | 720x180 PNG 透明底，36px 切片边距 | 中央大面积安全区，不能带文字；四角纹样不要压进文字区 |
| `res://assets/ui/dungeon/difficulty_badge_normal.png` | 普通难度徽章，青绿色安全感 | 96x96 PNG 透明底 | 正方形图标，无文字，缩到 24x24 可读 |
| `res://assets/ui/dungeon/difficulty_badge_danger.png` | 凶险难度徽章，旧金/橙色警示 | 96x96 PNG 透明底 | 正方形图标，无文字，和普通难度形状可区分 |
| `res://assets/ui/dungeon/difficulty_badge_desperate.png` | 绝境难度徽章，暗红危险感 | 96x96 PNG 透明底 | 正方形图标，无文字，边缘透明，不要黑底方块 |

## P1：三王传承特效帧图

| 目标路径 | 素材描述 | 建议规格 | 生成要求 |
|---|---|---:|---|
| `res://assets/effects/sheets/fire_burst_sheet.png` | 爆王线火焰弹道/小范围爆裂特效 | 512x512 单帧；4 帧横向 strip；总 2048x512 PNG 透明底 | 由小火核到爆裂扩散，立体火焰体积要清晰，适合代码直接按 0 度绘制 |
| `res://assets/effects/sheets/beast_command_aura_sheet.png` | 犬王线奴道魂影/兽令弹道特效 | 256x256 单帧；4 帧横向 strip；总 1024x256 PNG 透明底 | 青绿/灰白魂影，既能当弹道也能当召唤光环 |
| `res://assets/effects/sheets/refine_seal_sheet.png` | 信王线炼道印记/机关封印弹道特效 | 256x256 单帧；4 帧横向 strip；总 1024x256 PNG 透明底 | 炉火印、阵纹展开，中心不要太暗，适合叠在敌人位置 |

## P2：后续可选剧情立绘

| 目标路径 | 素材描述 | 建议规格 | 生成要求 |
|---|---|---:|---|
| `res://assets/characters/story/dog_king_portrait.png` | 犬王残念剧情立绘 | 768x1024 PNG 透明底 | 半身像，面向镜头 3/4 角度，带犬魂或兽骨元素 |
| `res://assets/characters/story/xin_king_portrait.png` | 信王残念剧情立绘 | 768x1024 PNG 透明底 | 炼道/机关气质，手持炉印或阵盘 |
| `res://assets/characters/story/bao_king_portrait.png` | 爆王残念剧情立绘 | 768x1024 PNG 透明底 | 赤黑火焰气质，爆裂但不要遮脸 |

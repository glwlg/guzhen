# 剧情扩展素材需求（白骨山 / 商家城）

最后更新：2026-04-27

说明：
- 本轮剧情开发已直接复用现有 `story/` 背景和通用敌人精灵，功能可运行。
- 以下素材不是运行阻塞项，但会显著提升第三章“白骨山逃亡”和第四章“商家城”的辨识度与表现力。
- 若文件暂缺，可继续沿用当前占位资源。

| 目标路径 | 素材描述 | 建议规格 | 参考/备注 |
|---|---|---:|---|
| `res://assets/backgrounds/combat/bai_gu_bone_hall.png` | 白骨殿夺方战斗背景：骨殿、残阵、尸骨祭台，中部留 16:9 战斗空间 | 1920x1080 PNG | 替换当前直接复用 `bai_gu_mountain.png` 的战斗背景 |
| `res://assets/backgrounds/combat/shang_city_arena.png` | 商家城斗场背景：环形斗场、观战席、金灯与阵纹，中部留战斗空间 | 1920x1080 PNG | 替换当前直接复用 `shang_clan_city.png` 的战斗背景 |
| `res://assets/characters/story/bone_route_companion_portrait.png` | 白骨山冷面同路人半身像，偏冷色、警惕感强、非正派英雄脸 | 768x1024 PNG 透明底 | 第三章“立毒誓”分支人物立绘 |
| `res://assets/characters/story/wounded_refiner_portrait.png` | 负伤炼道师半身像：衣袍破损、手持残炉或符匣、偏文士气质 | 768x1024 PNG 透明底 | 第三章“护送负伤炼道师出山”分支 |
| `res://assets/characters/story/shang_arena_champion_portrait.png` | 商家城斗场守擂者半身像：压迫感强、擂台系战斗修士 | 768x1024 PNG 透明底 | 第四章斗场分支详情页可用 |
| `res://assets/characters/story/shang_broker_portrait.png` | 商家城黑市掮客半身像：神秘、精明、偏暗金/暗紫配色 | 768x1024 PNG 透明底 | 第四章黑市残方分支可用 |
| `res://assets/ui/story/chapter_choice_card_9slice.png` | 剧情抉择卡片底板，比普通按钮更像事件卡，不自带文字 | 920x220 PNG 透明底 | 9-slice 边距建议 48px |
| `res://assets/ui/story/story_outcome_panel_9slice.png` | 剧情结果面板：适合展示代价、奖励、死亡警告 | 760x420 PNG 透明底 | 右侧“剧情结果”区域可替换现有通用面板 |
| `res://assets/effects/sheets/bone_dust_burst_sheet.png` | 白骨山战斗命中特效：骨粉、灰白碎屑扩散，1x4 条带 | 1024x256 PNG 透明底 | 每帧 256x256 |
| `res://assets/effects/sheets/arena_seal_flash_sheet.png` | 商家城斗场开战特效：金色阵纹闪烁、斗场封盘，1x4 条带 | 1024x256 PNG 透明底 | 每帧 256x256 |

# 第六阶段素材需求：剧情驱动、蛊虫转数与真实死亡

本阶段代码已先接入占位路径；缺失素材按下列目标路径补齐即可。所有带文字内容请不要烘焙进图片，文字由 Godot UI 渲染。

| 目标路径 | 素材描述 | 建议规格 | 参考/备注 |
|---|---|---:|---|
| `res://assets/backgrounds/story/gu_yue_village.png` | 古月山寨剧情背景：青茅山寨、竹楼、月夜或晨雾，中央留 UI 空间 | 1920x1080 PNG | 第一章剧情页 |
| `res://assets/backgrounds/story/qingmao_crisis.png` | 青茅山变局背景：山寨崩塌、雾雨、追兵火光，适合剧情和战斗 | 1920x1080 PNG | 第二章剧情与突围战 |
| `res://assets/backgrounds/story/bai_gu_mountain.png` | 白骨山逃亡远景：白骨山道、阴冷洞窟入口 | 1920x1080 PNG | 后续篇章占位 |
| `res://assets/backgrounds/story/shang_clan_city.png` | 商家城背景：大型山城、商铺、拍卖楼与人流 | 1920x1080 PNG | 后续篇章占位 |
| `res://assets/backgrounds/story/hu_immortal_blessed_land.png` | 狐仙福地背景：福地山谷、狐群灵气、地灵空间感 | 1920x1080 PNG | 后续篇章占位 |
| `res://assets/backgrounds/story/northern_plains_imperial_court.png` | 北原王庭背景：草原、王庭营地、风雪压迫 | 1920x1080 PNG | 后续篇章占位 |
| `res://assets/backgrounds/story/zombie_langya.png` | 仙僵与琅琊背景：灰败仙僵洞府、云阁炼道空间 | 1920x1080 PNG | 后续篇章占位 |
| `res://assets/backgrounds/story/yi_tian_mountain.png` | 义天山背景：大战棋局、山巅阵线、远处光柱 | 1920x1080 PNG | 后续篇章占位 |
| `res://assets/backgrounds/story/southern_border_dream.png` | 南疆梦境背景：梦道雾光、山林、伪装身份氛围 | 1920x1080 PNG | 后续篇章占位 |
| `res://assets/backgrounds/story/reverse_flow_shadow_sect.png` | 逆流河与影宗背景：逆流河水、黑白棋局、影宗残阵 | 1920x1080 PNG | 后续篇章占位 |
| `res://assets/backgrounds/story/fate_war_heavenly_court.png` | 宿命大战/天庭背景：白金天庭、宿命光柱、宏大战场 | 1920x1080 PNG | 后续篇章占位 |
| `res://assets/ui/story/story_choice_card_9slice.png` | 剧情抉择卡片：暗金边框、可承载标题/说明/成本 | 760x150 PNG 透明底 | 9-slice 边距 40px |
| `res://assets/ui/story/chapter_timeline_item_9slice.png` | 剧情篇章列表条目：可区分未解锁/可触发/已触发 | 520x96 PNG 透明底 | 9-slice 边距 36px |
| `res://assets/ui/story/chapter_locked_badge.png` | 未解锁篇章徽章，不带文字 | 160x64 PNG 透明底 | 可叠加在章节条目 |
| `res://assets/ui/gu/liquor_worm.png` | 酒虫图标：一转凡蛊，白胖虫身、酒气或月光纹 | 256x256 PNG 透明底 | 古月山寨奖励 |
| `res://assets/ui/gu/substitute_life_gu.png` | 替命蛊图标：五转凡蛊，裂纹人偶/命灯虫意象 | 256x256 PNG 透明底 | 战斗死亡替死判定 |
| `res://assets/ui/gu/time_anchor_gu.png` | 宙锚蛊图标：五转凡蛊，青铜锚点、时轮纹路 | 256x256 PNG 透明底 | 春秋蝉合炼前置 |
| `res://assets/ui/gu/spring_autumn_cicada.png` | 春秋蝉图标：六转唯一仙蛊，蝉翼、春秋双色、时间涟漪 | 256x256 PNG 透明底 | 死亡回档例外 |
| `res://assets/ui/gu/rank_badge_1_9.png` | 蛊虫转数徽章系列：一转到九转，不带蛊名 | 9 张，每张 96x48 PNG 透明底 | 库存和炼蛊详情后续接入 |
| `res://assets/characters/story/gu_yue_pursuer_sheet.png` | 古月追兵精灵表，白靛战袍、锐利剑势与冷色符片要清晰 | 1024x1024 PNG 透明底 | 每帧 256x256；4 行 x 4 列 compact sheet，行顺序 `down/left/right/up` |
| `res://assets/characters/story/gu_yue_elder_portrait.png` | 古月山寨长老半身像，暗色写实/国风奇幻 | 768x1024 PNG 透明底 | 剧情人物详情后续接入 |
| `res://assets/characters/story/branch_clansman_portrait.png` | 旁支少年/幸存者半身像 | 768x1024 PNG 透明底 | 善恶抉择反馈 |
| `res://assets/effects/sheets/substitute_life_break_sheet.png` | 替命蛊破碎挡死特效，1x4 条带 | 1024x256 PNG 透明底 | 每帧 256x256 |
| `res://assets/effects/sheets/spring_autumn_rebirth_sheet.png` | 春秋蝉逆流特效，青绿/金色时间涡旋，1x4 条带 | 2048x512 PNG 透明底 | 每帧 512x512 |
| `res://assets/audio/sfx/combat_true_death.ogg` | 战斗真实死亡音效，低沉断裂感 | 3-5 秒 OGG | 后续接入 |
| `res://assets/audio/sfx/spring_autumn_rebirth.ogg` | 春秋蝉逆流音效，时间倒卷后骤停 | 4-6 秒 OGG | 后续接入 |

## 本次追加：剧情可见规则、人物遭遇、杀招模拟

| 目标路径 | 素材描述 | 建议规格 | 参考/备注 |
|---|---|---:|---|
| `res://assets/backgrounds/story/origin_humble.png` | 寒门子弟出身线背景：青茅山脚、破旧村落、远处山寨轮廓，中心留 UI 空间 | 1920x1080 PNG | 创建角色选择“寒门子弟”后的第一条剧情 |
| `res://assets/backgrounds/story/origin_clan.png` | 世家嫡系出身线背景：地方世家宅院、族学、暗金灯火，中心留 UI 空间 | 1920x1080 PNG | 创建角色选择“世家嫡系”后的第一条剧情 |
| `res://assets/backgrounds/story/origin_orphan.png` | 流浪孤儿出身线背景：荒路、商队边缘、雨夜破庙，中心留 UI 空间 | 1920x1080 PNG | 创建角色选择“流浪孤儿”后的第一条剧情 |
| `res://assets/backgrounds/story/origin_exile.png` | 宗门弃徒出身线背景：残破山门、追踪符光、夜色逃亡，中心留 UI 空间 | 1920x1080 PNG | 创建角色选择“宗门弃徒”后的第一条剧情 |
| `res://assets/backgrounds/story/origin_reborn.png` | 蛊虫转世出身线背景：人身与虫影重叠、旧梦碎片、青黑灵光，中心留 UI 空间 | 1920x1080 PNG | 创建角色选择“蛊虫转世”后的第一条剧情 |
| `res://assets/ui/story/story_known_clue_item_9slice.png` | “已知线索”列表条目，暗金边框，支持可抉择/已发生/传承线索三种状态叠色，不带文字 | 520x108 PNG 透明底 | 后续替换当前按钮皮肤 |
| `res://assets/ui/story/story_resolved_stamp.png` | 剧情已发生印记，不带文字，红金印章感 | 160x160 PNG 透明底 | 叠加在已触发剧情条目 |
| `res://assets/ui/story/story_route_fog.png` | 未知剧情遮罩：雾状暗纹，不带文字 | 512x512 PNG 透明底 | 未来做有限分支可见性 |
| `res://assets/ui/people/dead_badge.png` | 人物死亡徽记：断裂命灯/灰金印记，不带文字 | 160x160 PNG 透明底 | 人物死亡历史或剧情回顾 |
| `res://assets/ui/killer/compile_result_success_9slice.png` | 杀招模拟成功结果框，青金灵光，能放日志文字 | 560x140 PNG 透明底 | 9-slice 边距 40px |
| `res://assets/ui/killer/compile_result_failure_9slice.png` | 杀招模拟失败结果框，暗红反噬裂纹，能放日志文字 | 560x140 PNG 透明底 | 9-slice 边距 40px |
| `res://assets/ui/killer/combat_loadout_slot_9slice.png` | 出战杀招槽位：用于 1-5 战斗热键，暗金框，不带文字 | 240x110 PNG 透明底 | 9-slice 边距 32px |
| `res://assets/ui/killer/gu_damaged_overlay.png` | 蛊虫受创叠层：裂纹/暗红噪声，透明底 | 256x256 PNG 透明底 | 杀招模拟失败时提示仙蛊受伤 |
| `res://assets/effects/sheets/killer_compile_success_sheet.png` | 杀招矩阵模拟成功特效，青金线路点亮，1x4 条带 | 1024x256 PNG 透明底 | 每帧 256x256 |
| `res://assets/effects/sheets/killer_compile_backlash_sheet.png` | 杀招矩阵反噬特效，黑红裂光爆开，1x4 条带 | 1024x256 PNG 透明底 | 每帧 256x256 |
| `res://assets/audio/sfx/killer_compile_success.ogg` | 杀招模拟成功音效，短促灵光连通 | 1-2 秒 OGG | 后续接入 |
| `res://assets/audio/sfx/killer_compile_failure.ogg` | 杀招模拟失败/凡蛊损毁音效 | 1-3 秒 OGG | 后续接入 |

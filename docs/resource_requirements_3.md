# 第三阶段资源需求：灾劫压测、蛊虫生态与运行时注入

本阶段代码已经接入以下路径。当前可先用占位图运行，后续替换同名文件即可。所有 PNG 建议保持透明底或 9-slice 安全边距，避免 UI 再次错位。

## 背景

| 目标路径 | 素材描述 | 建议规格 | 参考/备注 |
|---|---|---:|---|
| `res://assets/backgrounds/tribulations/heavenly_tribulation_sky.png` | 青雷天劫背景：仙窍上空黑云、青白雷柱压向灵泉，画面中心留出 UI 可读区域 | 1920x1080 PNG | 用于灾劫压测与后续专门战斗背景 |
| `res://assets/backgrounds/tribulations/earth_fire_pressure.png` | 地火焚窍背景：矿脉裂开、暗红地火从下方反冲，不能过亮 | 1920x1080 PNG | 炼道/矿脉灾劫 |
| `res://assets/backgrounds/tribulations/qi_collapse.png` | 二气坍缩背景：仙窍核心旋涡、青金二气互相撕裂 | 1920x1080 PNG | 高压核心灾劫 |
| `res://assets/backgrounds/tribulations/beast_hunger_swarm.png` | 虫巢饥劫背景：暗色虫巢、蛊群互噬、奴道气息 | 1920x1080 PNG | 蛊虫生态灾劫 |

## 仙窍生态 UI

| 目标路径 | 素材描述 | 建议规格 | 参考/备注 |
|---|---|---:|---|
| `res://assets/ui/ecology/gu_ecology_row_9slice.png` | 蛊虫生态行背景，左侧预留 54x54 图标位，中部文字，右侧两条短进度条 | 720x96 PNG 透明底，9-slice 边距 32px | 需适配饱食/健康双条 |
| `res://assets/ui/ecology/gu_food_chain_connector.png` | 食物链依赖连接线，青色微光，可横向拉伸 | 512x32 PNG 透明底 | 后续生态拓扑用 |
| `res://assets/ui/ecology/gu_status_badge_9slice.png` | 稳定/告警/危险状态小徽章底框 | 220x56 PNG 透明底，9-slice 边距 24px | 颜色由代码调制 |
| `res://assets/ui/ecology/critical_gu_badge.png` | 核心蛊/关键服务角标，金色或红金小印记 | 64x64 PNG 透明底 | 叠在生态行图标角上 |

## 灾劫 UI

| 目标路径 | 素材描述 | 建议规格 | 参考/备注 |
|---|---|---:|---|
| `res://assets/ui/tribulation/pressure_gauge_frame.png` | 灾劫压力仪表外框，横向长条，左侧可放灾劫图标 | 760x96 PNG 透明底 | 可复用进度条填充 |
| `res://assets/ui/tribulation/disaster_card_9slice.png` | 灾劫详情卡片，适合放名称、目标节点、说明 | 720x240 PNG 透明底，9-slice 边距 48px | 仙窍页右侧使用 |
| `res://assets/ui/tribulation/defense_script_slot_9slice.png` | 防御脚本槽位，突出“已装载/未装载”状态 | 640x88 PNG 透明底，9-slice 边距 36px | 杀招页/仙窍页后续细化 |
| `res://assets/ui/tribulation/tribulation_history_item_9slice.png` | 渡劫历史列表项，能容纳成功/失败文本 | 720x86 PNG 透明底，9-slice 边距 32px | 后续历史面板使用 |

## 战斗运行时注入 UI

| 目标路径 | 素材描述 | 建议规格 | 参考/备注 |
|---|---|---:|---|
| `res://assets/ui/combat/injection_hotkey_slot_9slice.png` | Q/E/R 注入热键槽，比普通 hotbar 更强调“临时注入” | 420x132 PNG 透明底，9-slice 边距 36px | 底部热键栏 |
| `res://assets/ui/combat/runtime_injection_panel_9slice.png` | 运行时注入状态面板，可显示候选凡蛊、冷却、过载 | 560x220 PNG 透明底，9-slice 边距 44px | 后续战斗侧栏 |
| `res://assets/ui/combat/overload_warning_frame.png` | 矩阵过载警告框，红金破碎纹理 | 520x116 PNG 透明底，9-slice 边距 40px | 过载大于阈值时使用 |

## 特效帧图

| 目标路径 | 素材描述 | 建议规格 | 参考/备注 |
|---|---|---:|---|
| `res://assets/effects/sheets/runtime_injection_sheet.png` | 注入凡蛊时的青色环形数据/符文闪光，8 帧横排 | 2048x256 PNG 透明底，每帧 256x256 | Q/E/R 注入反馈 |
| `res://assets/effects/sheets/matrix_overload_sheet.png` | 杀招矩阵过载反噬，红色裂纹爆闪，10 帧横排 | 5120x512 PNG 透明底，每帧 512x512 | 过载伤害 |
| `res://assets/effects/sheets/defense_barrier_sheet.png` | 稳固凡蛊/防御脚本屏障，青金护罩，8 帧横排 | 2048x256 PNG 透明底，每帧 256x256 | guard 注入与渡劫防御 |
| `res://assets/effects/sheets/tribulation_lightning_sheet.png` | 青雷天劫劈落，8 帧横排 | 4096x512 PNG 透明底，每帧 512x512 | 灾劫战斗/结算 |
| `res://assets/effects/sheets/earth_fire_burst_sheet.png` | 地火喷发，8 帧横排 | 4096x512 PNG 透明底，每帧 512x512 | 地火焚窍 |
| `res://assets/effects/sheets/qi_collapse_wave_sheet.png` | 二气坍缩冲击波，8 帧横排 | 4096x512 PNG 透明底，每帧 512x512 | 仙窍核心压测 |

## 音效

| 目标路径 | 素材描述 | 建议规格 | 参考/备注 |
|---|---|---:|---|
| `res://assets/audio/sfx/tribulation_warning.ogg` | 灾劫预警，低频钟鸣加雷声，短促不刺耳 | 2-4 秒 OGG | 后续接入 |
| `res://assets/audio/sfx/runtime_injection.ogg` | 注入成功，清脆符文启动声 | 0.5-1 秒 OGG | 后续接入 |
| `res://assets/audio/sfx/matrix_overload.ogg` | 矩阵过载，破裂反噬声 | 1-2 秒 OGG | 后续接入 |

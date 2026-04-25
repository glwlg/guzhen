# 资源需求清单

当前项目已经能跑基本玩法，但视觉效果和设计图差距主要来自“UI 皮肤资产”缺失，而不是逻辑功能缺失。现有 Godot 控件只能画出简单边框和按钮，无法还原设计图里的暗金九宫格面板、符箓边角、杀招阵盘、插槽徽章、连接流光、属性图标、标题字体和战斗预览框。

生成建议：

- UI 底板、按钮、插槽、边框尽量做成透明底 PNG，不要把中文文字画进图片里。
- 需要拉伸的素材按九宫格思路生成，四角和边框要足够厚，方便 Godot 做 StyleBoxTexture。
- 风格统一为暗黑修仙、旧金描边、青绿色法力光、轻微磨损纹理。
- 蛊虫、人物、特效继续透明底；背景图可以不透明。

## P0：全局 UI 皮肤

| 目标路径 | 素材描述 | 建议规格 | 参考来源 |
|---|---|---:|---|
| `res://assets/ui/skin/panel_dark_gold_9slice.png` | 主面板九宫格底板：暗黑半透明、细暗金描边、四角中式纹样，可拉伸 | 512x512 PNG 透明底，48px 切片边距 | `杀招配置.png` 全部大面板 |
| `res://assets/ui/skin/panel_inner_9slice.png` | 内层列表/详情框底板：更暗、更细边框，用于列表、详情、日志 | 512x512 PNG 透明底，36px 切片边距 | `杀招配置.png` 蛊虫库、编译诊断 |
| `res://assets/ui/skin/header_plate_9slice.png` | 标题条底板，用于“杀招矩阵”“编译结果”等面板标题 | 640x96 PNG 透明底 | `杀招配置.png` 面板标题条 |
| `res://assets/ui/skin/button_default_9slice.png` | 普通按钮底板：暗底金边，未选中态 | 512x160 PNG 透明底，40px 切片边距 | `杀招配置.png` 底部按钮、导航按钮 |
| `res://assets/ui/skin/button_hover_9slice.png` | 按钮悬停态：金边略亮、轻微内发光 | 512x160 PNG 透明底 | `杀招配置.png` 底部按钮 |
| `res://assets/ui/skin/button_active_9slice.png` | 选中按钮底板：青绿色内发光、暗金边 | 512x160 PNG 透明底 | `杀招配置.png` 左侧选中蛊虫、当前页签 |
| `res://assets/ui/skin/button_danger_9slice.png` | 危险/反噬按钮底板：暗红内发光、金红边 | 512x160 PNG 透明底 | `杀招配置.png` 红色诊断风格 |
| `res://assets/ui/skin/resource_card_9slice.png` | 顶部资源卡片底板，包含图标位和加号按钮位，不带文字 | 420x150 PNG 透明底 | `杀招配置.png` 顶部资源卡 |
| `res://assets/ui/skin/lifespan_bar_frame.png` | 顶部寿元长条框：沙漏图标位、阶段刻度、暗金边框 | 900x140 PNG 透明底 | `杀招配置.png` 顶部寿元条 |
| `res://assets/ui/skin/nav_tab_9slice.png` | 顶部/二级导航页签底板 | 420x120 PNG 透明底 | 当前项目顶部导航、设计图底部按钮 |
| `res://assets/ui/skin/ornament_corner_gold.png` | 面板四角装饰角花，可旋转复用 | 128x128 PNG 透明底 | `杀招配置.png` 面板边角 |
| `res://assets/ui/skin/divider_gold.png` | 暗金分割线、列表横线 | 512x16 PNG 透明底 | `杀招配置.png` 左侧列表分组线 |
| `res://assets/ui/skin/noise_scratches_overlay.png` | 旧纸、刮痕、尘点覆盖纹理，用于面板表面 | 1024x1024 PNG 透明底 | `杀招配置.png` 所有暗面板质感 |

## P0：杀招配置页专用

| 目标路径 | 素材描述 | 建议规格 | 参考来源 |
|---|---|---:|---|
| `res://assets/ui/killer/matrix_bg.png` | 杀招矩阵主底图：圆形阵盘、暗纹、罗盘/符箓线条，中心留给核心蛊 | 1200x900 PNG 透明底或深色底 | `杀招配置.png` 中央“杀招矩阵” |
| `res://assets/ui/killer/matrix_core_slot_frame.png` | 中央核心蛊六边形插槽框：青色内发光、暗金金属外框 | 360x360 PNG 透明底 | `杀招配置.png` 中央剑道仙蛊插槽 |
| `res://assets/ui/killer/matrix_plugin_slot_frame.png` | 周围辅助蛊插槽框：六边形/徽章框，带小等级角标位 | 260x260 PNG 透明底 | `杀招配置.png` 上下左右插件插槽 |
| `res://assets/ui/killer/matrix_empty_slot_frame.png` | 空插件位：虚线金框、加号占位，不带文字 | 220x220 PNG 透明底 | `杀招配置.png` 右下“可选插件位” |
| `res://assets/ui/killer/matrix_slot_selected_glow.png` | 插槽选中高亮：青绿色光圈/辉光，可叠在插槽下方 | 360x360 PNG 透明底 | `杀招配置.png` 选中追踪凡蛊 |
| `res://assets/ui/killer/matrix_connection_line.png` | 插槽连接线：青色发光直线，中心有小节点，可旋转/拉伸 | 1024x64 PNG 透明底 | `杀招配置.png` 中心到四向插件线 |
| `res://assets/ui/killer/matrix_connection_arrow.png` | 连接线箭头/流光节点，可沿线移动做轻动画 | 128x64 PNG 透明底 | `杀招配置.png` 插槽之间箭头 |
| `res://assets/ui/killer/gu_tile_default_9slice.png` | 左侧蛊虫格子底板：未选中，适合放图标和名称 | 260x300 PNG 透明底 | `杀招配置.png` 左侧蛊虫库 |
| `res://assets/ui/killer/gu_tile_selected_9slice.png` | 左侧蛊虫格子选中态：青色描边和暗青底 | 260x300 PNG 透明底 | `杀招配置.png` 选中追踪凡蛊 |
| `res://assets/ui/killer/gu_tile_locked_9slice.png` | 不可用/数量不足蛊虫格子：灰暗蒙版、破损边框 | 260x300 PNG 透明底 | `杀招配置.png` 未装配格子 |
| `res://assets/ui/killer/gu_info_plate_9slice.png` | 左下蛊虫说明卡片底板：图标、名称、描述、兼容图标区域 | 640x280 PNG 透明底 | `杀招配置.png` 左下追踪凡蛊说明 |
| `res://assets/ui/killer/result_row_9slice.png` | 右侧编译结果属性行底板：图标、进度条、数值、评级 | 620x72 PNG 透明底 | `杀招配置.png` 右侧威力/消耗/稳定度 |
| `res://assets/ui/killer/diagnosis_ok_9slice.png` | 编译诊断提示框：蓝绿色安全提示 | 620x120 PNG 透明底 | `杀招配置.png` 蓝色诊断框 |
| `res://assets/ui/killer/diagnosis_warning_9slice.png` | 编译诊断提示框：黄橙警告 | 620x120 PNG 透明底 | `杀招配置.png` 黄色诊断框 |
| `res://assets/ui/killer/diagnosis_danger_9slice.png` | 编译诊断提示框：红色危险 | 620x120 PNG 透明底 | `杀招配置.png` 红色诊断框 |
| `res://assets/ui/killer/combat_preview_frame.png` | 右下战斗预览视频/图片框：暗金边，右下播放按钮位 | 620x260 PNG 透明底 | `杀招配置.png` 右下预览区域 |
| `res://assets/ui/killer/shortcut_bar_9slice.png` | 底部快捷键提示栏底板 | 780x110 PNG 透明底 | `杀招配置.png` 左下快捷键提示 |
| `res://assets/ui/killer/action_bar_button_save.png` | 底部大按钮“保存杀招”专用底板，不带文字，金色强调态 | 280x110 PNG 透明底 | `杀招配置.png` 底部保存杀招按钮 |
| `res://assets/ui/killer/action_bar_button_default.png` | 底部大按钮默认底板，不带文字 | 280x110 PNG 透明底 | `杀招配置.png` 模拟运行/注入凡蛊/回滚 |

## P1：属性与操作图标

| 目标路径 | 素材描述 | 建议规格 | 参考来源 |
|---|---|---:|---|
| `res://assets/ui/icons/search_magnifier.png` | 搜索图标 | 96x96 PNG 透明底 | `杀招配置.png` 蛊虫库搜索框 |
| `res://assets/ui/icons/help_question.png` | 问号帮助图标 | 96x96 PNG 透明底 | `杀招配置.png` 面板标题旁问号 |
| `res://assets/ui/icons/settings_gear.png` | 设置齿轮图标 | 128x128 PNG 透明底 | `杀招配置.png` 右上设置 |
| `res://assets/ui/icons/plus_square.png` | 加号方框图标 | 96x96 PNG 透明底 | `杀招配置.png` 资源卡加号、空插槽 |
| `res://assets/ui/icons/clear_matrix.png` | 清空矩阵图标 | 96x96 PNG 透明底 | `杀招配置.png` 清空矩阵按钮 |
| `res://assets/ui/icons/attr_power.png` | 威力属性图标 | 96x96 PNG 透明底 | `杀招配置.png` 编译结果 |
| `res://assets/ui/icons/attr_spirit_cost.png` | 仙元/灵气消耗属性图标 | 96x96 PNG 透明底 | `杀招配置.png` 编译结果 |
| `res://assets/ui/icons/attr_stability.png` | 稳定度属性图标 | 96x96 PNG 透明底 | `杀招配置.png` 编译结果 |
| `res://assets/ui/icons/attr_range.png` | 覆盖范围属性图标 | 96x96 PNG 透明底 | `杀招配置.png` 编译结果 |
| `res://assets/ui/icons/attr_homing.png` | 自动寻敌属性图标 | 96x96 PNG 透明底 | `杀招配置.png` 编译结果 |
| `res://assets/ui/icons/attr_risk.png` | 异常风险属性图标 | 96x96 PNG 透明底 | `杀招配置.png` 编译结果 |
| `res://assets/ui/icons/warning_red.png` | 红色诊断警告图标 | 96x96 PNG 透明底 | `杀招配置.png` 编译诊断 |
| `res://assets/ui/icons/warning_yellow.png` | 黄色诊断警告图标 | 96x96 PNG 透明底 | `杀招配置.png` 编译诊断 |
| `res://assets/ui/icons/info_blue.png` | 蓝色信息提示图标 | 96x96 PNG 透明底 | `杀招配置.png` 编译诊断 |
| `res://assets/ui/icons/play_preview.png` | 播放预览三角按钮 | 128x128 PNG 透明底 | `杀招配置.png` 右下预览 |

## P1：字体与标识

| 目标路径 | 素材描述 | 建议规格 | 参考来源 |
|---|---|---:|---|
| `res://assets/fonts/title_calligraphy.ttf` | 标题书法字体，用于“蛊真：大道唯我”和大标题 | TTF/OTF，需可商用或自有授权 | `杀招配置.png` 左上标题 |
| `res://assets/fonts/ui_serif_cn.ttf` | 正文宋体/仿宋风 UI 字体，用于数值、按钮、列表 | TTF/OTF，需可商用或自有授权 | `杀招配置.png` 全界面正文 |
| `res://assets/ui/logo/main_title_brush.png` | 游戏主标题书法字图，可替代字体渲染，透明底 | 900x180 PNG 透明底 | `杀招配置.png` 左上 logo |
| `res://assets/ui/logo/red_seal.png` | 标题旁红色印章，不带复杂小字也可 | 96x128 PNG 透明底 | `杀招配置.png` 左上红印 |

## P2：其他页面复用素材

| 目标路径 | 素材描述 | 建议规格 | 参考来源 |
|---|---|---:|---|
| `res://assets/ui/refining/cauldron_idle.png` | 炼蛊炉鼎待启状态，不是成功特效 | 512x512 PNG 透明底 | `仙蛊炼制.png` |
| `res://assets/ui/refining/recipe_card_9slice.png` | 炼蛊配方卡片底板 | 520x140 PNG 透明底 | `仙蛊炼制.png`、当前炼蛊页 |
| `res://assets/ui/market/post_card_9slice.png` | 宝黄天订单卡片底板，支持风险/可信度小标 | 720x150 PNG 透明底 | `宝黄天.png` |
| `res://assets/ui/npc/relation_bar_frame.png` | NPC 关系/信任/紧迫度条框 | 520x72 PNG 透明底 | `npc对话.png` |
| `res://assets/ui/combat/hotbar_slot_9slice.png` | 战斗快捷栏槽位底板 | 360x110 PNG 透明底 | `战斗.png` |

## P3：截图复盘新增缺口

这些不是阻塞玩法的素材，但会直接影响“是否像设计图”。当前 P0/P1/P2 已经能把大框架换成暗金皮肤；截图里还明显缺少的是可程序化组合的小部件，尤其是进度条轨道/填充、顶部 HUD 内部分件、仙窍地图节点标记和 NPC 列表/关系条细分件。建议优先生成这一批，后续代码可以逐个替换 Godot 默认控件。

| 目标路径 | 素材描述 | 建议规格 | 参考来源 |
|---|---|---:|---|
| `res://assets/ui/progress/progress_track_9slice.png` | 通用进度条空轨道：暗金细边、内部深黑槽，不带填充值 | 640x48 PNG 透明底，18px 切片边距 | 当前仙窍监控、NPC 关系条、杀招编译结果红框 |
| `res://assets/ui/progress/progress_fill_cyan_9slice.png` | 青绿色进度条填充：法力光、可横向拉伸 | 640x32 PNG 透明底，16px 切片边距 | 寿元条、稳定/平衡类数值 |
| `res://assets/ui/progress/progress_fill_gold_9slice.png` | 金色进度条填充：资源、寿元阶段、普通收益用 | 640x32 PNG 透明底，16px 切片边距 | 顶部寿元条、仙窍产出 |
| `res://assets/ui/progress/progress_fill_red_9slice.png` | 红色进度条填充：危险、反噬、压力、紧迫度用 | 640x32 PNG 透明底，16px 切片边距 | 仙窍压力、NPC 紧迫度 |
| `res://assets/ui/progress/progress_thumb_glow.png` | 进度条端点光标/灵石滑块，可叠在填充末端 | 96x96 PNG 透明底 | 顶部寿元条的发光节点 |
| `res://assets/ui/hud/lifespan_meter_track.png` | 顶部寿元条内部专用轨道：只包含刻度、阶段节点和轨道，不含文字 | 760x72 PNG 透明底 | 顶部寿元红框 |
| `res://assets/ui/hud/lifespan_stage_tick.png` | 寿元/境界阶段小刻度徽记，单个菱形或符箓节点 | 96x96 PNG 透明底 | 顶部寿元条阶段节点 |
| `res://assets/ui/hud/resource_icon_slot.png` | 顶部资源卡左侧图标槽框，独立于资源卡底板 | 128x128 PNG 透明底 | 顶部资源卡红框 |
| `res://assets/ui/hud/resource_plus_button.png` | 顶部资源卡右侧加号小按钮，不带文字 | 96x96 PNG 透明底 | 顶部资源卡加号 |
| `res://assets/ui/hud/resource_value_plate_9slice.png` | 资源数字的小内框/铭牌，用于让数字不直接浮在大卡背景上 | 220x80 PNG 透明底，24px 切片边距 | 顶部资源卡数字区 |
| `res://assets/ui/hud/settings_button_frame.png` | 右上设置按钮独立外框，齿轮图标放在中心 | 112x112 PNG 透明底 | 顶部导航右侧设置位 |
| `res://assets/ui/aperture/aperture_metric_row_9slice.png` | 仙窍监控单行指标底板：左侧指标名、右侧百分比、下方进度槽 | 560x96 PNG 透明底，32px 切片边距 | 仙窍监控红框 |
| `res://assets/ui/aperture/node_marker_stable_9slice.png` | 仙窍地图节点标记：稳定状态，小型铭牌/地图 pin，不遮挡地图 | 280x120 PNG 透明底，32px 切片边距 | 仙窍节点拓扑红框 |
| `res://assets/ui/aperture/node_marker_warning_9slice.png` | 仙窍地图节点标记：压力/危险状态，金红强调 | 280x120 PNG 透明底，32px 切片边距 | 仙窍节点拓扑红框 |
| `res://assets/ui/aperture/node_marker_danger_9slice.png` | 仙窍地图节点标记：危急状态，红色边与暗红内光 | 280x120 PNG 透明底，32px 切片边距 | 仙窍节点拓扑红框 |
| `res://assets/ui/aperture/node_beacon_ring.png` | 仙窍地图节点落点光圈，放在背景预设节点上，用于替代大矩形卡片的定位感 | 220x220 PNG 透明底 | `仙窍.png` 地图节点 |
| `res://assets/ui/aperture/node_connector_line.png` | 仙窍地图节点间青色灵脉连线，可旋转/拉伸 | 1024x48 PNG 透明底 | `仙窍.png` 灵脉网络 |
| `res://assets/ui/npc/npc_list_item_default_9slice.png` | NPC 列表条目底板：适合姓名、势力、关系/信任/紧迫三项短文本 | 520x108 PNG 透明底，36px 切片边距 | NPC 页面左侧列表 |
| `res://assets/ui/npc/npc_list_item_selected_9slice.png` | NPC 列表条目选中态：青绿色内发光 | 520x108 PNG 透明底，36px 切片边距 | NPC 页面左侧选中条目 |
| `res://assets/ui/npc/npc_portrait_frame_9slice.png` | NPC 立绘相框/人物详情头像框，不带人物 | 360x360 PNG 透明底，48px 切片边距 | NPC 页面人物详情 |
| `res://assets/ui/npc/relation_track_9slice.png` | NPC 关系条内部轨道，独立于外框 | 520x36 PNG 透明底，16px 切片边距 | NPC 关系/信任/紧迫红框 |
| `res://assets/ui/npc/relation_fill_cyan_9slice.png` | NPC 正向关系/信任填充条，青绿色 | 520x28 PNG 透明底，14px 切片边距 | NPC 关系/信任红框 |
| `res://assets/ui/npc/relation_fill_red_9slice.png` | NPC 负向关系/紧迫填充条，红色 | 520x28 PNG 透明底，14px 切片边距 | NPC 紧迫红框 |
| `res://assets/ui/log/log_item_9slice.png` | 日志单条底板：细暗金横条，让日志不直接贴在面板背景上 | 720x64 PNG 透明底，24px 切片边距 | 仙窍/NPC 右侧日志 |

## P4：角色与战斗精灵图

当前战斗里玩家和敌人仍是静态 PNG。要做出移动、追击、施放杀招、受击和死亡反馈，需要生成可切帧的 sprite sheet。下面这批素材不是普通立绘，而是 Godot 战斗场景直接使用的 2D 精灵图。

### 统一精灵图规范

- 视角：斜俯视 2.5D，约 45° 俯角，匹配当前战斗地图 `res://assets/backgrounds/battle_ruins.png`。不要正面半身立绘，不要纯横版侧视。
- 画幅：透明底 PNG，单帧建议 `256x256`。角色完整身体高度控制在 150-190px，脚底留在画面下方中心，四周至少 24px 透明安全边。
- 锚点：每帧脚底中心对齐到单元格坐标 `(128, 198)` 附近。所有动作和方向必须保持同一个脚底锚点，避免动画播放时角色跳动。
- 光影：左上或正上冷光，脚下可以带很淡的软阴影，但阴影必须在同一帧透明底内，不要画死在不透明背景上。
- 风格：暗黑修仙、破损法袍、旧金/青绿法力纹路，细节清晰但不要过度写实到缩小后糊成一团。
- 动作速度：每个动作循环首尾要能自然衔接。`idle` 不要大幅位移；`walk` 脚步要有明显重心变化；`cast` 要有起手、蓄力、出手三个阶段。
- 方向：优先 8 方向：`down`、`down_right`、`right`、`up_right`、`up`、`up_left`、`left`、`down_left`。如果生成成本高，最低可交付 4 方向：`down`、`right`、`up`、`down_right`，代码后续可镜像补左向。
- 文件布局：推荐大图按“动作 + 方向”分行，每行固定帧数。列数不足的动作也要补透明帧或重复末帧，保持整张表规则。

推荐 sheet 排布：

| 动作 | 行顺序 | 每方向帧数 | 用途 |
|---|---:|---:|---|
| `idle` | 0-7 | 6 帧 | 站立呼吸、衣摆轻动 |
| `walk` | 8-15 | 8 帧 | WASD 移动、敌人追击 |
| `cast` | 16-23 | 8 帧 | 释放杀招/法术 |
| `hit` | 24-31 | 4 帧，后 4 格可重复末帧或透明 | 受击硬直 |
| `death` | 32-39 | 8 帧 | 倒地/消散 |

如果严格使用上面的 8 方向和固定 8 列，整张图规格为 `2048x10240`：每帧 `256x256`，8 列，40 行。也可以拆成多个较小文件，路径按下表。

| 目标路径 | 素材要求 | 帧规格与排布 | 参考来源 |
|---|---|---:|---|
| `res://assets/characters/sheets/player_male_sheet.png` | 男主战斗精灵图。黑金法袍、剑道/散修气质，手持或背负剑形蛊器，动作清晰。必须包含 idle、walk、cast、hit、death。 | 256x256 单帧；8方向；每方向 8 列；推荐 2048x10240 PNG 透明底 | `创建角色.png`、`战斗.png`、当前男主静态图 |
| `res://assets/characters/sheets/player_female_sheet.png` | 女主战斗精灵图。与男主同一体型比例和锚点规范，可有发带/长袖/轻甲差异。必须包含 idle、walk、cast、hit、death。 | 256x256 单帧；8方向；每方向 8 列；推荐 2048x10240 PNG 透明底 | `创建角色.png`、`战斗.png`、当前女主静态图 |
| `res://assets/characters/sheets/enemy_cultivator_sheet.png` | 通用敌方蛊师/蛊仙精灵图。暗紫黑法袍、敌意法力光，轮廓要和玩家明显区分。必须包含 idle、walk、cast、hit、death。 | 256x256 单帧；8方向；每方向 8 列；推荐 2048x10240 PNG 透明底 | `战斗.png`、当前敌人静态图 |
| `res://assets/characters/sheets/enemy_elite_sheet.png` | 精英敌人精灵图。比通用敌人更高阶，带更明显魂影、披风或法阵碎片。用于后续 Boss/高境界 NPC 袭击。 | 320x320 单帧；8方向；每方向 8 列；推荐 2560x12800 PNG 透明底 | `战斗.png`、NPC 利益博弈 |
| `res://assets/characters/sheets/npc_cultivator_sheet.png` | 中立/盟友 NPC 战斗精灵图。不要太像敌人，可用灰金/青色法袍。用于联合作战或 NPC 事件。 | 256x256 单帧；8方向；每方向 8 列；推荐 2048x10240 PNG 透明底 | `npc对话.png`、`战斗.png` |
| `res://assets/characters/sheets/summoned_soul_sheet.png` | 奴道/魂影召唤物精灵图。半透明魂影、无实体脚步，适合漂浮移动。包含 idle、move、attack、hit、dismiss。 | 256x256 单帧；8方向；每方向 8 列；推荐 2048x10240 PNG 透明底 | 奴道杀招、战斗召唤物 |

如果图片生成工具无法稳定输出超大 sheet，可以改用拆分文件，命名规则如下：

```text
res://assets/characters/sheets/player_male/idle_down.png
res://assets/characters/sheets/player_male/idle_down_right.png
res://assets/characters/sheets/player_male/walk_down.png
res://assets/characters/sheets/player_male/cast_down.png
...
```

拆分文件规范：每个 PNG 为横向 strip，单帧 `256x256`，例如 `walk_down.png` 是 `2048x256`，包含 8 帧；`hit_down.png` 可以是 `1024x256`，包含 4 帧。拆分方案更容易人工检查，也更方便后续 Godot 导入 `SpriteFrames`。

### 战斗特效帧图

杀招和角色动作最好同步补一些帧图，否则角色动起来后特效仍会显得静态。

| 目标路径 | 素材要求 | 帧规格与排布 | 参考来源 |
|---|---|---:|---|
| `res://assets/effects/sheets/sword_qi_projectile_sheet.png` | 剑气飞行弹道循环帧。青白剑气，尾部流光，方向默认朝右，代码可旋转。 | 512x128 单帧；8 帧横向 strip，总 4096x128 PNG 透明底 | `战斗.png`、杀招配置预览 |
| `res://assets/effects/sheets/cast_charge_sheet.png` | 施法蓄力光效。脚下小型法阵、手部法力聚集，适合叠在角色身上。 | 256x256 单帧；8 帧横向 strip，总 2048x256 PNG 透明底 | `杀招配置.png`、战斗施法 |
| `res://assets/effects/sheets/hit_spark_sheet.png` | 命中爆点。短促青白/金色冲击光，用于敌人受击。 | 256x256 单帧；6 帧横向 strip，总 1536x256 PNG 透明底 | `战斗.png` |
| `res://assets/effects/sheets/backlash_burst_sheet.png` | 反噬爆发帧图。暗红裂纹、黑气回卷，用于失败/异常风险触发。 | 512x512 单帧；10 帧横向 strip，总 5120x512 PNG 透明底 | `仙蛊炼制.png`、`战斗.png` |

## P5：需要重生成/校准的 UI 素材

这批素材已经能被代码加载，但从当前截图看，部分纹理的“装饰区”和“内容安全区”混在一起，导致文字、数字、进度填充和加号看起来压线或错位。下面不是新增功能素材，而是建议覆盖同名文件的重生成规范。重生成时请不要把中文、数字、百分比或具体图标画进底板，只保留框、槽、角花、暗纹和发光。

### 通用重生成规则

- 九宫格素材必须四角清晰、边框厚度稳定，中间区域尽量纯暗纹，不要有会穿过文字的亮线。
- 底板不能自带中文、数字、百分号、资源数量，也不要画固定图标；文字和图标都由 Godot 节点绘制。
- 内容安全区要比装饰区更暗、更平，避免文字落在高亮花纹上。
- 透明底 PNG；边框外不要有不透明黑块，否则叠在背景上会出现方形底。
- 需要放文字的控件，请在素材说明里预留“文字安全区”，不要让角花和中线进入该区域。

| 目标路径 | 当前问题 | 重生成要求 | 建议规格 |
|---|---|---|---:|
| `res://assets/ui/skin/resource_card_9slice.png` | 顶部资源卡内部图标槽、数字框、加号位置偏拥挤；装饰线会贴近数字。 | 资源卡底板只做外框和暗纹，内部预留三块安全区：左侧图标槽中心约 25%，中部文字/数字区从 44%-78%，右侧加号区从 84%-96%。不要在数字区画横穿亮线。 | 420x150 PNG 透明底，40px 切片边距 |
| `res://assets/ui/hud/resource_value_plate_9slice.png` | 数字铭牌过宽且装饰边进入数字区域，长数字容易压住加号。 | 铭牌只覆盖数字区，中心 70% 保持平整暗底；左右边框各不超过 18px；不要自带加号或资源图标。适合被缩放到约 88x32。 | 220x80 PNG 透明底，18px 切片边距 |
| `res://assets/ui/hud/resource_plus_button.png` | 加号装饰容易和资源卡边框混在一起。 | 独立小按钮，正方形透明底；加号位于正中，外圈不要超过 80% 画幅；四周至少 8px 透明边，缩放到 30x30 仍清楚。 | 96x96 PNG 透明底 |
| `res://assets/ui/skin/lifespan_bar_frame.png` | 寿元外框和内部轨道重复，叠加后显得拥挤。 | 只保留外框、沙漏图标位和标题装饰；不要画内部进度轨道、不要画多个阶段刻度，内部轨道交给 `lifespan_meter_track.png`。文字区上半部保持平整暗底。 | 900x140 PNG 透明底，48px 切片边距 |
| `res://assets/ui/hud/lifespan_meter_track.png` | 内部轨道和填充层对齐难，刻度/轨道装饰太满。 | 只画寿元内部轨道：一条水平槽、少量固定刻度、槽内暗底。轨道有效填充区需从 x=10% 到 x=90%，y=40%-62%；上下不要有会遮住文字的装饰。 | 760x72 PNG 透明底 |
| `res://assets/ui/hud/lifespan_stage_tick.png` | 阶段刻度在缩小后容易压住填充条。 | 单个菱形/符箓刻度，中心对称；透明边至少 20%；不要带长横线。缩放到 20x20 仍可识别。 | 96x96 PNG 透明底 |
| `res://assets/ui/progress/progress_track_9slice.png` | 通用进度条轨道装饰太厚时，填充会像偏离中心。 | 只画空槽和很细外边；有效槽区必须在高度中心，槽高约 35%-45%；上下透明/暗底充足，便于 12-18px 高度缩放。 | 640x48 PNG 透明底，18px 切片边距 |
| `res://assets/ui/progress/progress_fill_cyan_9slice.png` | 填充如果自带轨道或边框，会和 track 重影。 | 只画发光填充本体，不要外框、不要端点装饰；左右可有很轻渐变，但必须可横向拉伸。有效高度约 60%。 | 640x32 PNG 透明底，16px 切片边距 |
| `res://assets/ui/progress/progress_fill_gold_9slice.png` | 同上。 | 同 `progress_fill_cyan_9slice.png`，颜色改为旧金/琥珀光。不要画外框。 | 640x32 PNG 透明底，16px 切片边距 |
| `res://assets/ui/progress/progress_fill_red_9slice.png` | 同上。 | 同 `progress_fill_cyan_9slice.png`，颜色改为暗红/血光。不要画外框。 | 640x32 PNG 透明底，16px 切片边距 |
| `res://assets/ui/npc/relation_bar_frame.png` | 当前关系条外框、左侧标签位和进度轨道容易互相抢空间。 | 只保留整行外框、左侧标签铭牌和右侧数值铭牌；中间轨道区域留空透明/暗底，不要自带进度填充。中间轨道安全区 x=28%-78%，y=42%-62%。 | 520x72 PNG 透明底，24px 切片边距 |
| `res://assets/ui/npc/relation_track_9slice.png` | 如果包含左侧铭牌或右侧铭牌，会和外框重复。 | 只画中间空轨道，不能包含左侧标签框和右侧数值框；轨道两端不要太复杂，便于缩放到 330x18。 | 520x36 PNG 透明底，16px 切片边距 |
| `res://assets/ui/npc/relation_fill_cyan_9slice.png` | 填充层如果带长装饰，百分比低时端点会怪。 | 只画青色填充体，左端可有微光，右端不要固定尖角；0%-100% 任意宽度都要自然。 | 520x28 PNG 透明底，14px 切片边距 |
| `res://assets/ui/npc/relation_fill_red_9slice.png` | 同上。 | 只画红色填充体，适合紧迫/危险；不要自带轨道和边框。 | 520x28 PNG 透明底，14px 切片边距 |
| `res://assets/ui/npc/npc_portrait_frame_9slice.png` | 人物详情头像框被拉伸时变成长横框，装饰过强。 | 改为真正的头像相框：方形构图，中央安全区至少 68% 宽高，边框不进入人物脸部。不要做成长横幅；代码会按 360x240 容器居中使用，素材中心必须适配人物半身/立绘。 | 360x360 PNG 透明底，48px 切片边距 |
| `res://assets/ui/log/log_item_9slice.png` | 日志条目边框太重时，多条堆叠会显得拥挤。 | 单条日志底板要轻：暗底、细金边、上下装饰很薄；中间文字安全区从 x=8%-94%、y=22%-78%。不要画粗分割线穿过文字。 | 720x64 PNG 透明底，24px 切片边距 |
| `res://assets/ui/skin/nav_tab_9slice.png` | 顶部导航按钮在缩放后文字容易贴边。 | 页签内部文字安全区 x=18%-82%、y=30%-70%；左右角花不要超过 16% 宽度。选中效果仍交给 `button_active_9slice.png`。 | 420x120 PNG 透明底，40px 切片边距 |
| `res://assets/ui/hud/settings_button_frame.png` | 设置按钮必须是小方形，不能生成横向按钮底板。 | 正方形独立框，只放齿轮按钮外框，不带齿轮图标。中心留 56%-65% 安全区放 `settings_gear.png`。 | 112x112 PNG 透明底 |

## 已有但可按同一风格重绘的素材

这些路径当前已经有文件，功能可用；如果要统一成设计图风格，可以覆盖同名文件。

| 目标路径 | 素材描述 | 建议规格 | 参考来源 |
|---|---|---:|---|
| `res://assets/ui/icons/lifespan_hourglass.png` | 顶部寿元沙漏图标 | 128x128 PNG 透明底 | `核心玩法.png`、`战斗.png` |
| `res://assets/ui/icons/immortal_stone.png` | 仙元石资源图标 | 128x128 PNG 透明底 | `宝黄天.png` |
| `res://assets/ui/icons/spirit_qi.png` | 灵气资源图标 | 128x128 PNG 透明底 | `仙窍.png` |
| `res://assets/ui/icons/intel_scroll.png` | 情报值资源图标 | 128x128 PNG 透明底 | `宝黄天.png` |
| `res://assets/ui/icons/material_bundle.png` | 炼蛊材料资源图标 | 128x128 PNG 透明底 | `仙蛊炼制.png` |
| `res://assets/ui/gu/*.png` | 各流派蛊虫/仙蛊图标，建议全部统一成六边形徽章构图 | 256x256 或 512x512 PNG 透明底 | `杀招配置.png`、`创建角色.png` |
| `res://assets/effects/refine_success.png` | 炼蛊成功爆发特效，只在成功后显示 | 1024x1024 PNG 透明底 | `仙蛊炼制.png` |
| `res://assets/effects/backlash.png` | 炼蛊/杀招反噬特效 | 1024x1024 PNG 透明底 | `战斗.png`、`仙蛊炼制.png` |
| `res://assets/backgrounds/refining_chamber.png` | 炼蛊/杀招配置背景 | 1920x1080 PNG | `仙蛊炼制.png`、`杀招配置.png` |
| `res://assets/backgrounds/aperture_map.png` | 仙窍节点地图背景 | 1920x1080 PNG | `仙窍.png` |
| `res://assets/backgrounds/market_baohuangtian.png` | 宝黄天交易背景 | 1920x1080 PNG | `宝黄天.png` |
| `res://assets/backgrounds/battle_ruins.png` | 战斗地图背景 | 1920x1080 PNG | `战斗.png` |

## 已导入参考图

| Godot 路径 | 来源 |
|---|---|
| `res://assets/reference/core_overview.png` | `核心玩法.png` |
| `res://assets/reference/core_flow.png` | `核心玩法2.png` |
| `res://assets/reference/character_create.png` | `界面/创建角色.png` |
| `res://assets/reference/combat.png` | `界面/战斗.png` |
| `res://assets/reference/ascension.png` | `界面/升仙.png` |
| `res://assets/reference/gu_refining.png` | `界面/仙蛊炼制.png` |
| `res://assets/reference/aperture.png` | `界面/仙窍.png` |
| `res://assets/reference/killer_move.png` | `界面/杀招配置.png` |
| `res://assets/reference/market.png` | `界面/宝黄天.png` |
| `res://assets/reference/npc_dialogue.png` | `界面/npc对话.png` |

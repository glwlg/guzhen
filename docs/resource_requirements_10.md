# Resource Requirements 10 - 探索地图返工规格

本文件用于返工当前不合格的 2.5D 探索地图素材。上一版地图需求写得过粗，导致生成结果容易变成“单张氛围插画”“黑色遮挡蒙版”或“不可行走的抽象场景”。这一版按可直接放进 Godot 地图系统的规格描述。

## 当前问题

| 问题 | 影响 | 处理 |
|---|---|---|
| `foreground` 前景遮挡层出现大面积黑色/深色半透明底 | 在游戏里会压黑或遮住基础地图，玩家看到黑屏和几块灰色形状 | 必须重新生成，除遮挡物外 Alpha 必须为 0 |
| 地图分块没有严格按世界坐标布置关键地点 | 玩家出生点、剧情点、资源点会落在空地、黑区或非预期位置 | 重新按下方“局部坐标锚点”生成 |
| 素材说明缺少负面约束 | 生图容易带 UI、文字、角色、图标、单张海报构图 | 所有地图图层严禁文字、UI、按钮、人物、浮标 |
| 仙窍图层需要可走空间，但前景/光影层像整图蒙版 | 代码加载后无法形成清晰的可探索地图 | 前景只做遮挡物，光影只做透明叠加 |

## 全局硬性规格

- 视角：2.5D 斜俯视 RPG 地图，类似等距/斜俯视可行走场景，不是正俯视地图，也不是横版背景。
- 分辨率：每块 `2048x1152 PNG`，不要放大、不要裁切、不要带黑边。
- 画面内容：只画环境，不画 UI、按钮、文字、角色、名字、光标、地图标记。
- 可行走性：每张基础层必须有清晰道路、平台、坡道或空地。角色尺寸按单帧 `256x256`，实际显示约 140-160px 高，需要能在道路上站立。
- 拼接：相邻边缘必须自然连续，边缘 80px 内的道路、山体、雾气、光线方向要对得上。
- 透视：所有建筑、石台、树木、洞口、桥梁使用同一消失方向，避免每块像不同插画。
- 色调：暗金、青黑、冷雾、南疆山林，和现有 UI 的暗金青绿色统一。
- 禁止：大面积纯黑地面、抽象黑洞、随机漂浮碎片、科幻城市、现代建筑、可读文字、图标化符号、UI 边框、角色立绘。

## 图层规则

### base 基础层

- 必须是不透明完整场景，Alpha 全部为 255。
- 包含地面、道路、建筑底部、山体、平台、水面、洞口、主要地形。
- 不能包含只用于遮挡角色的树冠/屋檐大前景，如果这类物体会挡住角色，应拆到 foreground。

### foreground 前景遮挡层

- 必须是透明底 PNG。
- 只有树冠、屋檐、牌坊上沿、悬崖前沿、洞口上唇、近景岩石等“角色经过时应被遮住上半身”的部分有 Alpha。
- 透明区域 Alpha 必须为 0，不能用黑色半透明铺底。
- 不要整张黑色蒙版，不要整图雾层，不要整图暗角。
- 建议平均 Alpha 小于 20%，不透明区域不要超过整图 15%。

### light 光影层

- 必须是透明底 PNG。
- 只放青金灵光、火把暖光、雾气柔光、水面反光、阵纹微光。
- 不要黑色阴影。阴影应该画在 base，不应该用 light 层压黑。
- 建议最大 Alpha 不超过 130，平均 Alpha 小于 15%。

## 青茅山外域 2x2 返工

总地图尺寸 `4096x2304`，每块 `2048x1152`。以下坐标为每块内部局部坐标，生成时请把关键地点安排到附近，不需要画文字标记。

### r0_c0 左上：古月山寨外门 / 族学

| 目标路径 | 必须包含 | 局部坐标锚点 | 生成要求 |
|---|---|---:|---|
| `res://assets/backgrounds/maps/qingmao_outer/base/qingmao_outer_base_r0_c0.png` | 古月山寨外门、木墙、族学入口、石阶山路、旧酒窖入口 | 外门 `(650,360)`；族学 `(720,420)`；旧酒窖 `(1210,720)` | 左侧偏上有山寨门楼，右侧和下方有可通向其他分块的山路。道路宽度至少 260px，适合角色行走。 |
| `res://assets/backgrounds/maps/qingmao_outer/foreground/qingmao_outer_fg_r0_c0.png` | 门楼上沿、屋檐、树冠、近景旗杆上半部 | 对齐 base | 只保留会遮挡角色的上层物件。透明底，不要黑底。 |
| `res://assets/backgrounds/maps/qingmao_outer/light/qingmao_outer_light_r0_c0.png` | 山寨灯火、清晨薄雾、木门暖光 | 对齐 base | 透明青金/暖金柔光，不要阴影蒙版。 |

提示词建议：
`2.5D isometric dark xianxia RPG exploration map tile, Gu Yue mountain village outer gate, wooden palisade, clan school entrance, stone stairs, mountain path, ancient southern border village, dark teal mist, warm lantern gold, walkable road, no characters, no text, no UI, seamless right and bottom edges`

### r0_c1 右上：雾林 / 废亭 / 黑市残坛

| 目标路径 | 必须包含 | 局部坐标锚点 | 生成要求 |
|---|---|---:|---|
| `res://assets/backgrounds/maps/qingmao_outer/base/qingmao_outer_base_r0_c1.png` | 雾林、废亭、黑市残坛、幽暗山路 | 废亭 `(990,470)`；黑市残坛 `(1172,690)` | 左边缘接 r0_c0 山路，下边缘接荒坟溪谷。黑市残坛要有可站立圆形空地。 |
| `res://assets/backgrounds/maps/qingmao_outer/foreground/qingmao_outer_fg_r0_c1.png` | 雾林树冠、废亭屋檐、残坛立柱前沿 | 对齐 base | 只保留遮挡物，不要整图黑雾。 |
| `res://assets/backgrounds/maps/qingmao_outer/light/qingmao_outer_light_r0_c1.png` | 冷雾、残坛暗红烛光、林间青光 | 对齐 base | 透明柔光，不能降低整体亮度。 |

提示词建议：
`2.5D isometric dark fantasy southern mountain mist forest tile, ruined pavilion, hidden black market altar, winding walkable mountain path, teal fog, dim candle gold, mysterious but readable ground, no character, no text, no UI, seamless left and bottom edges`

### r1_c0 左下：山脚村 / 采药坡 / 商队营地

| 目标路径 | 必须包含 | 局部坐标锚点 | 生成要求 |
|---|---|---:|---|
| `res://assets/backgrounds/maps/qingmao_outer/base/qingmao_outer_base_r1_c0.png` | 山脚村、采药坡、商队营地、通向中央的山道 | 山脚村 `(700,608)`；采药坡 `(880,558)`；商队营地 `(1280,733)` | 上边缘接山寨坡道，右边缘接入定石台区域。商队营地要有帐篷但不画人物。 |
| `res://assets/backgrounds/maps/qingmao_outer/foreground/qingmao_outer_fg_r1_c0.png` | 村屋屋檐、草药坡树枝、商队旗帜上半部 | 对齐 base | 透明底，遮挡面积小。 |
| `res://assets/backgrounds/maps/qingmao_outer/light/qingmao_outer_light_r1_c0.png` | 村落火光、帐篷灯笼、清晨雾光 | 对齐 base | 透明暖金柔光。 |

提示词建议：
`2.5D isometric xianxia RPG map tile, mountain foot village, herb gathering slope, caravan camp tents, walkable dirt road to the center seam, southern border mountains, dark teal and muted gold palette, no people, no text, no UI, seamless top and right edges`

### r1_c1 右下：荒坟溪谷 / 虫巢残洞 / 狼潮山脊

| 目标路径 | 必须包含 | 局部坐标锚点 | 生成要求 |
|---|---|---:|---|
| `res://assets/backgrounds/maps/qingmao_outer/base/qingmao_outer_base_r1_c1.png` | 荒坟溪谷、虫巢残洞、狼潮山脊、入定石台右半部分 | 入定石台靠左边缘 `(2,278)`；虫巢残洞 `(1012,628)`；狼潮山脊 `(1362,758)` | 左边缘必须和 r1_c0 的中央道路/石台衔接。右下可更危险但仍要有道路。 |
| `res://assets/backgrounds/maps/qingmao_outer/foreground/qingmao_outer_fg_r1_c1.png` | 枯树、洞口上沿、断柱、坟碑近景 | 对齐 base | 不要整图黑色遮罩。 |
| `res://assets/backgrounds/maps/qingmao_outer/light/qingmao_outer_light_r1_c1.png` | 阴火、虫巢幽光、冷月边光 | 对齐 base | 透明冷光/幽绿光。 |

提示词建议：
`2.5D isometric dark xianxia RPG tile, desolate grave creek valley, insect nest cave, wolf tide ridge, broken stone pillars, walkable path, ominous teal moonlight and faint ghost fire, no character, no text, no UI, seamless top and left edges`

## 空窍内景 2x1 返工

总地图尺寸 `4096x1152`。空窍是一至五转阶段的“真元海/窍壁/蛊虫生态”空间，不是外部仙侠宫殿，也不是纯黑虚空。

### r0_c0 左区：入口 / 真元海

| 目标路径 | 必须包含 | 局部坐标锚点 | 生成要求 |
|---|---|---:|---|
| `res://assets/backgrounds/maps/aperture_inner/base/aperture_inner_base_r0_c0.png` | 空窍入口、窍壁、真元海边缘、灵泉、入定落点、可行走石台 | 入口 `(420,610)`；真元海 `(1160,610)`；灵泉 `(1780,420)` | 中央必须有可行走平台和道路。真元海可在左下或中部，但不要把整张图画成深渊。右边缘要接 r0_c1 的石径。 |
| `res://assets/backgrounds/maps/aperture_inner/foreground/aperture_inner_fg_r0_c0.png` | 灵雾薄层、悬浮岩前沿、窍壁碎影 | 对齐 base | 必须透明底。不要黑色背景、不要整图蒙版、不要巨大黑块。 |
| `res://assets/backgrounds/maps/aperture_inner/light/aperture_inner_light_r0_c0.png` | 真元海潮光、窍壁反光、灵气流线 | 对齐 base | 透明青金柔光。不要黑色阴影。 |

提示词建议：
`2.5D isometric inner aperture RPG exploration tile, small dark mystical void cave inside a Gu master's aperture, primeval essence sea, walkable stone platform, qi mist, teal and gold spiritual light, clear floor paths, no character, no text, no UI, no black mask, seamless right edge`

### r0_c1 右区：虫巢 / 矿脉 / 道痕裂隙

| 目标路径 | 必须包含 | 局部坐标锚点 | 生成要求 |
|---|---|---:|---|
| `res://assets/backgrounds/maps/aperture_inner/base/aperture_inner_base_r0_c1.png` | 虫巢、矿脉、道痕裂隙、可行走石径 | 虫巢 `(532,610)`；矿脉 `(1152,770)`；道痕裂隙 `(1480,420)` | 左边缘接 r0_c0 真元海平台。每个节点周围至少留 220px 可站立空间。 |
| `res://assets/backgrounds/maps/aperture_inner/foreground/aperture_inner_fg_r0_c1.png` | 矿脉晶簇前沿、虫巢外壳上沿、窍壁碎影 | 对齐 base | 透明底，不能盖住整图。 |
| `res://assets/backgrounds/maps/aperture_inner/light/aperture_inner_light_r0_c1.png` | 矿脉晶光、虫巢幽光、道痕裂隙微光 | 对齐 base | 透明发光层。 |

提示词建议：
`2.5D isometric inner aperture RPG map tile, spiritual spring, Gu insect nest, mineral vein, dao mark cracks, walkable stone paths, teal-gold mystical light, dark but readable ground, no character, no text, no UI, transparent layers for foreground and light, seamless left edge`

## 碰撞参考图

| 目标路径 | 规格 | 生成要求 |
|---|---:|---|
| `res://assets/backgrounds/maps/qingmao_outer/qingmao_outer_collision_guide.png` | 4096x2304 PNG | 白色可走，黑色阻挡，灰色减速。不要美术图，不进游戏显示。道路、平台、村口、营地、石台为白色。山体、树干、墙、洞壁为黑色。 |
| `res://assets/backgrounds/maps/aperture_inner/aperture_inner_collision_guide.png` | 4096x1152 PNG | 白色为石台和道路，黑色为虚空/深水/窍壁，灰色为灵雾减速区。 |

## 小地图

| 目标路径 | 规格 | 生成要求 |
|---|---:|---|
| `res://assets/backgrounds/maps/qingmao_outer/qingmao_outer_minimap.png` | 1024x576 PNG | 简化地形色块，不带文字。只画道路、区域轮廓、节点小点。 |
| `res://assets/backgrounds/maps/aperture_inner/aperture_inner_minimap.png` | 1024x288 PNG | 简化空窍结构，不带文字。 |

## 角色精灵表约定

代码已经改为优先加载：

| 性别 | 优先路径 | 备用路径 |
|---|---|---|
| 男 | `res://assets/characters/sheets/player_male_sheet.png` | `res://assets/characters/exploration/player_male_explore_sheet.png` |
| 女 | `res://assets/characters/sheets/player_female_sheet.png` | `res://assets/characters/exploration/player_female_explore_sheet.png` |

精灵表如果后续返工，统一为：

- `1024x1024 PNG`，透明底。
- `4x4` 网格，单帧 `256x256`。
- 行顺序：第 1 行向下/正面，第 2 行向左，第 3 行向右，第 4 行向上/背面。
- 列顺序：第 1 列站立，第 2-4 列行走循环。
- 每帧脚底锚点在单帧底部中心附近，角色不要顶满整帧，四周留 20-30px 安全边。
- 不要阴影烘在透明图里，游戏内会单独绘制脚下阴影。

## 快速验收标准

- 打开任意 base：应该是一张完整可探索地图，不是海报，不是纯黑，不带 UI。
- 打开任意 foreground：透明背景中只看到少量树冠/屋檐/岩石上沿；如果看到黑底，就是不合格。
- 打开任意 light：透明背景中只有发光雾气和光斑；如果会压暗整张图，就是不合格。
- 把 base 四块按 `r0_c0 r0_c1 / r1_c0 r1_c1` 拼起来后，道路和地形边缘必须自然连续。
- 玩家出生点和触发点附近必须有可站立的道路或平台。

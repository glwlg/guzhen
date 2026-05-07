# Resource Requirements 9 - 2.5D 初始探索地图

本阶段把剧情触发改为地图探索。素材按“2K 分块拼接 + 前景遮挡 + 光影叠加 + 动态特效”的伪 3D 路线准备。所有地图图层不要包含 UI、文字、按钮、角色名字或提示文案。

## 青茅山外域分块

| 目标路径 | 素材描述 | 建议规格 | 生成要求 |
|---|---|---:|---|
| `res://assets/backgrounds/maps/qingmao_outer/base/qingmao_outer_base_r0_c0.png` | 左上区域：古月山寨外门、族学入口、山寨木墙和山道 | 2048x1152 PNG | 斜俯视 2.5D，右边缘和下边缘能与相邻块自然衔接 |
| `res://assets/backgrounds/maps/qingmao_outer/base/qingmao_outer_base_r0_c1.png` | 右上区域：雾林、废亭、黑市残坛、幽暗山路 | 2048x1152 PNG | 左边缘接山寨山路，下边缘接荒坟溪谷 |
| `res://assets/backgrounds/maps/qingmao_outer/base/qingmao_outer_base_r1_c0.png` | 左下区域：山脚村、采药坡、商队营地 | 2048x1152 PNG | 上边缘接山寨坡道，右边缘接中央入定石台 |
| `res://assets/backgrounds/maps/qingmao_outer/base/qingmao_outer_base_r1_c1.png` | 右下区域：荒坟溪谷、虫巢残洞、狼潮山脊 | 2048x1152 PNG | 上边缘接雾林，左边缘接商队营地和入定石台 |
| `res://assets/backgrounds/maps/qingmao_outer/foreground/qingmao_outer_fg_r0_c0.png` | 左上前景遮挡：树冠、屋檐、牌坊、山石 | 2048x1152 PNG 透明底 | 只保留会遮挡角色上半身的物件，不要带底图 |
| `res://assets/backgrounds/maps/qingmao_outer/foreground/qingmao_outer_fg_r0_c1.png` | 右上前景遮挡：雾林树冠、废亭屋檐、残坛立柱 | 2048x1152 PNG 透明底 | 与基础图完全对齐 |
| `res://assets/backgrounds/maps/qingmao_outer/foreground/qingmao_outer_fg_r1_c0.png` | 左下前景遮挡：村屋屋檐、商队旗帜、药坡树枝 | 2048x1152 PNG 透明底 | 与基础图完全对齐 |
| `res://assets/backgrounds/maps/qingmao_outer/foreground/qingmao_outer_fg_r1_c1.png` | 右下前景遮挡：枯树、虫巢洞口岩石、狼潮山脊断柱 | 2048x1152 PNG 透明底 | 与基础图完全对齐 |
| `res://assets/backgrounds/maps/qingmao_outer/light/qingmao_outer_light_r0_c0.png` | 左上光影叠加层：山寨灯火、清晨薄雾光 | 2048x1152 PNG 透明底 | 用柔光/屏幕叠加风格，不要压黑主体 |
| `res://assets/backgrounds/maps/qingmao_outer/light/qingmao_outer_light_r0_c1.png` | 右上光影叠加层：雾林冷光、黑市残坛烛光 | 2048x1152 PNG 透明底 | 透明底，对齐基础图 |
| `res://assets/backgrounds/maps/qingmao_outer/light/qingmao_outer_light_r1_c0.png` | 左下光影叠加层：村落火光、商队灯笼 | 2048x1152 PNG 透明底 | 透明底，对齐基础图 |
| `res://assets/backgrounds/maps/qingmao_outer/light/qingmao_outer_light_r1_c1.png` | 右下光影叠加层：荒坟阴火、虫巢幽光、狼潮冷月光 | 2048x1152 PNG 透明底 | 透明底，对齐基础图 |
| `res://assets/backgrounds/maps/qingmao_outer/qingmao_outer_collision_guide.png` | 碰撞参考图：白色可走，黑色阻挡，灰色可站但减速 | 4096x2304 PNG | 只给开发参考，不进游戏显示 |
| `res://assets/backgrounds/maps/qingmao_outer/qingmao_outer_minimap.png` | 青茅山外域小地图 | 1024x576 PNG | 简化地形和关键地点，不带文字 |

## 仙窍内景分块

| 目标路径 | 素材描述 | 建议规格 | 生成要求 |
|---|---|---:|---|
| `res://assets/backgrounds/maps/aperture_inner/base/aperture_inner_base_r0_c0.png` | 空窍内景左区：入口、窍壁、真元海边缘 | 2048x1152 PNG | 斜俯视，暗色洞天，灵气流动，中央留行走空间 |
| `res://assets/backgrounds/maps/aperture_inner/base/aperture_inner_base_r0_c1.png` | 空窍内景右区：灵泉、虫巢、矿脉、道痕裂隙 | 2048x1152 PNG | 左边缘接真元海，节点位置清晰 |
| `res://assets/backgrounds/maps/aperture_inner/foreground/aperture_inner_fg_r0_c0.png` | 空窍左区前景遮挡：灵雾、窍壁碎影、悬浮岩 | 2048x1152 PNG 透明底 | 与基础图完全对齐 |
| `res://assets/backgrounds/maps/aperture_inner/foreground/aperture_inner_fg_r0_c1.png` | 空窍右区前景遮挡：灵泉雾幕、矿脉晶簇、虫巢外壳 | 2048x1152 PNG 透明底 | 与基础图完全对齐 |
| `res://assets/backgrounds/maps/aperture_inner/light/aperture_inner_light_r0_c0.png` | 空窍左区光影：真元海潮光、窍壁反光 | 2048x1152 PNG 透明底 | 青金色，柔光 |
| `res://assets/backgrounds/maps/aperture_inner/light/aperture_inner_light_r0_c1.png` | 空窍右区光影：灵泉光、虫巢幽光、矿脉晶光 | 2048x1152 PNG 透明底 | 青金色，柔光 |
| `res://assets/backgrounds/maps/aperture_inner/aperture_inner_collision_guide.png` | 仙窍碰撞参考图 | 4096x1152 PNG | 白色可走，黑色阻挡，灰色减速 |
| `res://assets/backgrounds/maps/aperture_inner/aperture_inner_minimap.png` | 仙窍小地图 | 1024x288 PNG | 简化节点布局，不带文字 |

## 探索 UI 与特效

| 目标路径 | 素材描述 | 建议规格 | 生成要求 |
|---|---|---:|---|
| `res://assets/ui/exploration/location_marker_story.png` | 剧情地点标记 | 128x128 PNG 透明底 | 青金/暗金，中心可发光，不带文字 |
| `res://assets/ui/exploration/location_marker_resource.png` | 资源点标记 | 128x128 PNG 透明底 | 绿金色，适合药田、灵泉、矿脉 |
| `res://assets/ui/exploration/location_marker_person.png` | 人物地点标记 | 128x128 PNG 透明底 | 紫金或暗金，适合可交谈人物 |
| `res://assets/ui/exploration/location_marker_aperture.png` | 仙窍入口/地图出口标记 | 128x128 PNG 透明底 | 青金旋涡或入定符印 |
| `res://assets/effects/sheets/map_fog_loop_sheet.png` | 青茅山地图薄雾循环 | 1024x256 PNG 透明底 | `1x4` 紧凑条带，每帧 256x256，轻雾循环 |
| `res://assets/effects/sheets/aperture_qi_loop_sheet.png` | 仙窍灵气循环 | 1024x256 PNG 透明底 | `1x4` 紧凑条带，每帧 256x256，青金灵气呼吸循环 |
| `res://assets/effects/sheets/location_trigger_glow_sheet.png` | 靠近触发点时的地面光圈 | 1024x256 PNG 透明底 | `1x4` 紧凑条带，每帧 256x256，触发点地面符印渐亮 |

## 角色精灵补充

角色精灵必须使用透明底，脚底锚点保持在每帧底部中心附近，方便 Y 轴深度排序。探索阶段先使用紧凑 `4x4` 探索循环表，统一为斜俯视拟 3D 小比例角色，用于地图内行走/站立表现。

| 目标路径 | 素材描述 | 建议规格 | 生成要求 |
|---|---|---:|---|
| `res://assets/characters/exploration/player_male_explore_sheet.png` | 男主探索精灵表 | 1024x1024 PNG 透明底 | `4x4` 探索循环，单帧 256x256，脚底锚点统一 |
| `res://assets/characters/exploration/player_female_explore_sheet.png` | 女主探索精灵表 | 1024x1024 PNG 透明底 | 同男主规格，保持拟 3D 斜俯视比例 |
| `res://assets/characters/exploration/gu_yue_elder_explore_sheet.png` | 古月族老探索精灵 | 1024x1024 PNG 透明底 | `4x4` 探索循环，老年蛊师，族袍风格 |
| `res://assets/characters/exploration/branch_clansman_explore_sheet.png` | 旁支少年探索精灵 | 1024x1024 PNG 透明底 | `4x4` 探索循环，少年蛊师，低阶装备 |
| `res://assets/characters/exploration/qingluan_merchant_explore_sheet.png` | 青鸾仙子/商队人物探索精灵 | 1024x1024 PNG 透明底 | `4x4` 探索循环，商队人物，交易气质明确 |
| `res://assets/characters/exploration/guixin_broker_explore_sheet.png` | 归墟子/黑市人物探索精灵 | 1024x1024 PNG 透明底 | `4x4` 探索循环，阴暗情报贩子，兜帽或面具 |

## 当前占位策略

- 如果青茅山分块未放入目标路径，代码会用 `res://assets/backgrounds/story/qingmao_crisis.png` 作为整图兜底背景。
- 如果仙窍分块未放入目标路径，代码会用 `res://assets/backgrounds/aperture_map.png` 作为整图兜底背景。
- 如果探索地点标记未放入目标路径，代码会用程序绘制的菱形标记兜底。

# 第五阶段资源需求：寿蛊生存主线与死亡压力闭环

本阶段代码已接入以下路径。当前使用现有近似素材占位，后续生成同名文件替换即可。寿元页 UI 需要暗金/青绿/警戒红三组视觉层级；素材不要自带正文文字，避免和程序化文本错位。

| 目标路径 | 素材描述 | 建议规格 | 参考/备注 |
|---|---|---:|---|
| `res://assets/backgrounds/longevity_search.png` | 寿蛊线索调查背景：幽暗洞天、古老残阵、隐约寿道纹路，中部留 UI 可读空间 | 1920x1080 PNG | 寿元页/调查态 |
| `res://assets/backgrounds/lifespan_auction.png` | 宝黄天寿蛊竞拍背景：虚空市集、光幕拍卖、匿名买家剪影，氛围紧张但不要过亮 | 1920x1080 PNG | 竞拍事件 |
| `res://assets/backgrounds/lifespan_hunt.png` | 夺寿追杀遭遇背景：荒野/废墟夜战，中心 60% 区域适合俯视战斗 | 1920x1080 PNG | 战斗背景 |
| `res://assets/backgrounds/death_realm.png` | 濒死/死亡界面背景：黑金沙漏破碎、命火将熄、四周暗边 | 1920x1080 PNG | 死亡锁定页 |
| `res://assets/ui/longevity/lifespan_crisis_panel_9slice.png` | 寿元危机面板，暗金边、红色警戒纹，不带文字，中心深色低噪声 | 720x260 PNG 透明底 | 9-slice 48px |
| `res://assets/ui/longevity/lead_card_9slice.png` | 寿蛊线索卡片，可放标题、可信度、风险、过期时间，左右不要有强装饰遮挡文字 | 760x180 PNG 透明底 | 9-slice 40px |
| `res://assets/ui/longevity/auction_card_9slice.png` | 寿蛊竞拍订单卡片，含出价区与倒计时区留白，不自带数字 | 760x220 PNG 透明底 | 9-slice 40px |
| `res://assets/ui/longevity/death_choice_card_9slice.png` | 死亡选择卡片：续命/转世按钮容器，边框可更重，中心留 70% 深色内容区 | 880x320 PNG 透明底 | 9-slice 56px |
| `res://assets/ui/longevity/lead_status_badge_rumor.png` | “谣言”状态徽章，青灰暗金，小尺寸可读但不带文字也可 | 180x64 PNG 透明底 | 同系列 |
| `res://assets/ui/longevity/lead_status_badge_verified.png` | “已确认”状态徽章，青绿高亮，边缘发光克制 | 180x64 PNG 透明底 | 同系列 |
| `res://assets/ui/longevity/lead_status_badge_fake.png` | “假情报”状态徽章，暗红/裂纹警告样式 | 180x64 PNG 透明底 | 同系列 |
| `res://assets/ui/icons/longevity_gu.png` | 寿蛊图标：白金/翠绿小虫或沙漏虫，透明底，轮廓清晰 | 256x256 PNG | 库存/奖励 |
| `res://assets/ui/icons/death_warning.png` | 濒死警告图标：破碎沙漏或熄灭命火，透明底 | 256x256 PNG | HUD 告警 |
| `res://assets/characters/enemies/lifespan_hunter_sheet.png` | 夺寿追杀者精灵表，俯视/斜俯视，8方向，idle/walk/cast/hit/death 五行动关键帧 | 2048x1280 PNG 透明底 | 每帧 256x256，行顺序保持项目现有 sheet 规范 |
| `res://assets/effects/sheets/longevity_gu_use_sheet.png` | 使用寿蛊续命特效，青金命火回流，8帧横排 | 2048x256 PNG 透明底 | 每帧 256x256 |
| `res://assets/effects/sheets/death_fade_sheet.png` | 寿元归零黑红消散特效，10帧横排 | 2560x256 PNG 透明底 | 每帧 256x256 |
| `res://assets/audio/sfx/lifespan_warning.ogg` | 寿元危机短促警告音，低频沙漏/心跳质感 | 1-2 秒 OGG | 后续接入 |
| `res://assets/audio/sfx/longevity_gu_use.ogg` | 寿蛊续命音效，低沉后回升，有“命火复燃”的爆点 | 2-4 秒 OGG | 后续接入 |
| `res://assets/audio/sfx/death_state.ogg` | 进入死亡状态音效，压迫、空旷、不可逆 | 3-5 秒 OGG | 后续接入 |

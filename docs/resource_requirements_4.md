# 第四阶段资源需求：升仙成长与修为突破

本阶段代码已接入以下路径。当前可用占位图运行，后续替换同名文件即可。UI 素材建议透明底、保留 9-slice 安全边距，避免文字区和边框错位。

| 目标路径 | 素材描述 | 建议规格 | 参考/备注 |
|---|---|---:|---|
| `res://assets/backgrounds/cultivation_retreat.png` | 闭关修行背景：暗色洞府、蒲团、灵气流转，中心留 UI 空间 | 1920x1080 PNG | 修行页背景 |
| `res://assets/backgrounds/ascension_trial.png` | 升仙试炼背景：天地二气倒灌、仙窍虚影、雷云压顶 | 1920x1080 PNG | 升仙主界面 |
| `res://assets/ui/cultivation/rank_progress_frame_9slice.png` | 境界进度条外框，适配顶部 HUD 和修行页 | 760x96 PNG 透明底 | 9-slice 边距 32px |
| `res://assets/ui/cultivation/stage_badge_low.png` | 初阶小阶徽章，暗金底、青色小字，不能自带大段说明 | 180x72 PNG 透明底 | 与按钮字号兼容 |
| `res://assets/ui/cultivation/stage_badge_mid.png` | 中阶小阶徽章，样式同系列 | 180x72 PNG 透明底 | 与 `stage_badge_low` 同构 |
| `res://assets/ui/cultivation/stage_badge_high.png` | 高阶小阶徽章，样式同系列 | 180x72 PNG 透明底 | 与 `stage_badge_low` 同构 |
| `res://assets/ui/cultivation/stage_badge_peak.png` | 巅峰小阶徽章，金色更强但文字区保持清晰 | 180x72 PNG 透明底 | 五转巅峰提示用 |
| `res://assets/ui/cultivation/breakthrough_card_9slice.png` | 突破操作卡片，可放成本、成功率、风险 | 720x260 PNG 透明底 | 9-slice 边距 48px |
| `res://assets/ui/cultivation/ascension_phase_card_9slice.png` | 升仙三段试炼卡片 | 680x180 PNG 透明底 | 天地二气/道痕承压/心魔抉择 |
| `res://assets/effects/sheets/breakthrough_pulse_sheet.png` | 小阶突破成功特效，青金灵光扩散，1x4 条带 | 1024x256 PNG 透明底 | 每帧 256x256 |
| `res://assets/effects/sheets/ascension_qi_surge_sheet.png` | 升仙天地二气倒灌特效，1x4 条带 | 2048x512 PNG 透明底 | 每帧 512x512 |
| `res://assets/effects/sheets/inner_demon_sheet.png` | 心魔试炼黑红幻影冲击，1x4 条带 | 2048x512 PNG 透明底 | 每帧 512x512 |
| `res://assets/audio/sfx/breakthrough_success.ogg` | 小阶突破成功音效 | 1-2 秒 OGG | 后续接入 |
| `res://assets/audio/sfx/ascension_success.ogg` | 升仙成功音效，压迫后爆发 | 3-5 秒 OGG | 后续接入 |
| `res://assets/audio/sfx/ascension_failure.ogg` | 升仙失败/反噬音效 | 2-4 秒 OGG | 后续接入 |

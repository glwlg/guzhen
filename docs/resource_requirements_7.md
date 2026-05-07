# 第七阶段素材需求：蛊虫升转与仙蛊合炼链

本阶段已先接入占位路径与程序化 UI。以下素材用于替换占位资源，重点服务“蛊虫实例、转数、升转、合炼链、状态反馈”。

| 目标路径 | 素材描述 | 建议规格 | 参考/备注 |
|---|---|---:|---|
| `res://assets/ui/gu/rank_badges/rank_1.png` 至 `rank_9.png` | 蛊虫一转至九转徽章，暗金底、青色高亮，不带文字以外的复杂装饰 | 128x128 PNG 透明底 | 可叠在蛊虫图标左上角 |
| `res://assets/ui/gu/frame_mortal_9slice.png` | 凡蛊库存格边框，适配一至五转 | 320x96 PNG 透明底 | 9-slice 边距 32px |
| `res://assets/ui/gu/frame_immortal_9slice.png` | 仙蛊库存格边框，适配六至九转，视觉更重、更稀有 | 320x96 PNG 透明底 | 9-slice 边距 32px |
| `res://assets/ui/gu/status_hungry.png` | 蛊虫饥饿状态角标，黄色/暗红小图标 | 96x96 PNG 透明底 | 用于库存、杀招组件 |
| `res://assets/ui/gu/status_wounded.png` | 蛊虫受损状态角标，裂纹或血色灵光 | 96x96 PNG 透明底 | 用于库存、杀招组件 |
| `res://assets/ui/gu/status_bound.png` | 已绑定杀招状态角标，锁链/阵纹 | 96x96 PNG 透明底 | 后续杀招依赖显示 |
| `res://assets/backgrounds/refine_upgrade_chamber.png` | 凡蛊升转炉鼎背景，炼蛊室内有升转阵、炉火和材料台，中部留 UI 空间 | 1920x1080 PNG | 可复用炼蛊页背景风格 |
| `res://assets/backgrounds/immortal_refine_array.png` | 仙蛊合炼阵背景，巨大阵图、道痕流光、中央炉鼎或蛊影 | 1920x1080 PNG | 用于仙蛊合炼模式 |
| `res://assets/ui/refine/upgrade_card_9slice.png` | 升转目标卡片，展示当前转数、下阶段、成功率、同类引子 | 760x220 PNG 透明底 | 9-slice 边距 48px |
| `res://assets/ui/refine/refine_chain_card_9slice.png` | 仙蛊合炼链卡片，展示前置蛊、配方、环境、机缘缺口 | 760x260 PNG 透明底 | 9-slice 边距 48px |
| `res://assets/effects/sheets/gu_upgrade_success_sheet.png` | 凡蛊升转成功特效：蛊虫外壳蜕变，青金光环扩散 | 1024x256 PNG 透明底 | 1x4 条带，每帧 256x256 |
| `res://assets/effects/sheets/gu_upgrade_fail_sheet.png` | 凡蛊升转失败反噬：炉火炸裂、蛊虫裂纹 | 1024x256 PNG 透明底 | 1x4 条带，每帧 256x256 |
| `res://assets/effects/sheets/immortal_refine_success_sheet.png` | 仙蛊合炼成功特效：阵图收束成唯一仙蛊虚影 | 2048x512 PNG 透明底 | 1x4 条带，每帧 512x512 |
| `res://assets/effects/sheets/immortal_refine_backlash_sheet.png` | 仙蛊合炼反噬特效：黑金裂缝、血色灵火倒卷 | 2048x512 PNG 透明底 | 1x4 条带，每帧 512x512 |
| `res://assets/backgrounds/story/shang_clan_city.png` | 商家城剧情背景：南疆大城、斗场、商铺与炼蛊坊暗线 | 1920x1080 PNG | 下一阶段剧情会用作蛊虫升转交易中心 |
| `res://assets/backgrounds/story/shang_arena.png` | 商家城斗场背景，圆形斗场、观众暗影、中央留战斗空间 | 1920x1080 PNG | 斗场剧情战斗 |
| `res://assets/backgrounds/story/black_market_refiner.png` | 黑市炼蛊铺背景，昏暗货架、炉鼎、蛊虫罐和契约灯牌 | 1920x1080 PNG | 合炼/交易剧情 |
| `res://assets/audio/sfx/gu_upgrade_success.ogg` | 凡蛊升转成功音效，清脆蜕壳与灵光上扬 | 1-2 秒 OGG | 后续音频系统接入 |
| `res://assets/audio/sfx/gu_upgrade_fail.ogg` | 凡蛊升转失败音效，炉火爆裂和低沉反噬 | 1-3 秒 OGG | 后续音频系统接入 |
| `res://assets/audio/sfx/immortal_refine_unique_lock.ogg` | 唯一仙蛊互斥锁触发音效，沉重钟鸣/锁链断裂 | 2-4 秒 OGG | 重复炼制唯一仙蛊时播放 |

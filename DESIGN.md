# DESIGN.md · 综合备忘录 (Memo PWA)

> 单文件 HTML PWA，本地 AES-GCM 加密，GitHub Pages 部署。
> 本文件固化当前视觉规范与动效标准，供后续模块开发与 AI 编程代理参考。
> 参考风格：Stripe 的克制配色 + Apple 的极简留白 + Linear 的微交互。

---

## 1. Visual Theme & Atmosphere
- 哲学：柔和的「现代笔记」基调，主色蓝传达信任与专注，圆角与轻阴影营造纸感。
- 氛围关键词：清爽 / 安静 / 精致 / 日常可用。
- 质感：轻投影（shadow-xs 起）、1px 细边框、锁屏与问候卡用低饱和渐变点缀。
- 明暗双主题：浅色为默认，深色自动适配（同套 token 换值，不换结构）。

## 2. Color Palette & Roles
```
--bg:#f3f3fb                     页面背景（浅）
--bg-deco: 135° 浅紫渐变          锁屏/装饰底
--surface:#ffffff                卡片表面
--surface-2:#f7f8fc              次级表面（输入/悬停）
--surface-3:#eef0f7              三级表面
--line:#edeff6                   边框
--line-strong:#e2e5ef            强边框（输入焦点前）
--text:#2b2d44                   主文字
--text-2:#6c7088                 次文字
--text-3:#a6abbf                 弱文字/占位
--primary:#2563EB                主色（蓝）
--primary-strong:#1E3A8A         主色深（标题/强调）
--primary-soft:#E8EEFB           主色浅（标签/选中底）
--primary-softer:#F4F8FE         主色更浅（渐变）
--danger:#f1789c / --danger-strong:#e35f87 / --danger-soft:#ffeaf1   危险/错误/超时
--warning:#f0b35a …              提醒/临近
--success:#54c2a0 …              完成/已办
```
语义色用途：danger=输错密码/待办超时；warning=账单临近；success=已完成项。
深色主题同名字换值（背景转 `#14151c` 系，主色转 `#5B8DEF`），阴影转暗。

## 3. Typography Rules
- 字体栈：`--font:-apple-system,BlinkMacSystemFont,"PingFang SC","Microsoft YaHei",sans-serif`。
- 层级（实用优先，非严格 scale）：
  - 标题 h1：19px / 800 / -0.4px 字距（问候卡）
  - 区块标题：14.5px / 700
  - 正文：13px / 1.55 行高
  - 次要：11–12.5px / 600
  - 数字统计：18px / 800（问候卡与待办统计）
- 原则：中文用系统字体保证清晰；强调靠字重与 `--primary-strong` 而非大字号。

## 4. Component Stylings
- **Button(.btn-primary)**：主色渐变 `135° #2563EB→#5B8DEF`，圆角 `--r`，按压 `scale(.92)`。
- **Card(.card)**：白底、`--r` 圆角、`shadow-xs`，左侧 4px 渐变强调条（hover 显）；按压 `scale(.98)`（Phase 1 新增）。
- **Todo Item(.todo-item)**：白底、`--r-sm`、左彩色时间竖条（超时红/今天橙/未来灰/已完成绿，待 Phase 2 接入）；按压 `scale(.98)`；done 态 0.5 透明 + 划线。
- **PIN 键盘(.pin-key)**：圆角 18px、surface-2 底、`shadow-sm`；按压 `scale(.9)` + 主色浅底。
- **PIN 圆点(.pin-dot)**：未填 `--line-strong`，已填 `--primary` 并 `pinPop` 弹出动画（Phase 1）；错误态变 `--danger`。
- **顶栏(.topbar)**：主色浅底，滚动超 10px 加 `.scrolled` → 半透明 + `backdrop-filter:blur(14px)`（Phase 1）。
- **FAB(.fab)**：主色渐变圆，滚动下滑隐藏(`.hidden`)、上滑显现（Phase 1）。
- **Modal/Sheet**：白底、`--r-lg`、大阴影，底部 sheet 上滑入场。

## 5. Layout Principles
- 容器：`.phone` 移动端满屏；≥780px 呈 460px 设备框、38px 圆角、大阴影。
- 内容区 `.scroll` 竖向滚动，底部留 90px 防 FAB 遮挡；`.main` 最大 780px 居中，左右 14px 内边距。
- 间距基数：`--space:4px`；卡片间距 12px，区块间距 16px。
- 留白：列表项 9–12px 内边距，呼吸感来自浅背景与细边框而非粗分隔线。

## 6. Depth & Elevation
```
--shadow-xs:0 1px 2px rgba(48,50,90,.04)
--shadow-sm:0 2px 10px rgba(48,50,90,.05)
--shadow-md:0 8px 24px rgba(48,50,90,.08)
--shadow-lg:0 18px 48px rgba(48,50,90,.13)
```
层级：表面=shadow-xs；键盘/待办=shadow-sm；hover 抬升=shadow-md；浮层/锁屏=shadow-lg。
圆角 token：`--r-xs:12px --r-sm:16px --r:20px --r-lg:26px --r-pill:999px`。
缓动：`--ease:cubic-bezier(.22,1,.36,1)` 全局统一。

## 7. Motion & Micro-interaction (Phase 1 新增)
- `pinPop`：圆点填充时 `scale(0)→1.3→1.15`，0.22s，逐个点亮不重播。
- `lockShake`：输错密码时锁框左右抖动 0.5s；同时圆点转 `--danger` 红。
- 卡片按压：`.card / .todo-item :active` → `scale(.98)` + 阴影变浅，0.12s。
- 顶栏滚动：>10px 切 `.scrolled`，背景转半透明 + 毛玻璃模糊 14px。
- FAB 滚动：下滑 >140px 隐藏，上滑显现（`translateY/scale` 过渡）。
- 问候卡：时间感知文案（早/午/晚/夜）+ 实时待办/超时统计。

## 8. Do's and Don'ts
- ✅ 统一用 token（`--primary*`/`--r*`/`--shadow*`/`--ease`），勿写死色值与像素。
- ✅ 新模块沿用 `.card`/`.todo-item` 结构与按压反馈。
- ✅ 动效统一 `--ease`，时长 ≤0.35s，克制不花哨。
- ❌ 勿新增独立配色，保持蓝主色体系。
- ❌ 勿在 `--shadow-lg` 以上再加更重阴影。
- ❌ 锁屏/顶栏勿用不透明纯色盖住毛玻璃层次。

## 9. Responsive Behavior
- 断点：手机（默认满屏）/ ≥780px（设备框预览）。
- 触控目标：PIN 键与 FAB ≥56px；列表项整行可点。
- 安全区：`env(safe-area-inset-*)` 已用于顶栏与底部导航/FAB。
- 字体：随系统，不强制缩放。

## 10. Agent Prompt Guide
- 快速参考：主色 `#2563EB`；圆角用 `--r*`；阴影用 `--shadow-*`；缓动 `--ease`；按压 `scale(.98)`。
- 组件生成 Prompt 示例：
  - “生成一个 `.card` 风格列表项，圆角 `--r`、左侧 4px 强调条、`:active` 时 `scale(.98)`。”
  - “新增一个模态框，白底 `--r-lg`、用 `--shadow-lg`、入场用 `fadeUp`。”
  - “锁屏错误时给 `#lockBox` 加 `.shake` 并让 `#pinDots` 圆点变 `--danger`。"
- 迭代建议：
  1. 先改 `:root` token，勿逐处改色。
  2. 动效时长统一 ≤0.35s，避免卡顿。
  3. 新字段（如 priority/pinned）必须在 `normalizeState()` 设默认值，保证老保险库兼容。
  4. 改动后单文件自测：JS 语法 + 浏览器解锁流程。

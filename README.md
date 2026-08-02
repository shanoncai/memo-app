# 综合备忘录 (Memo PWA)

一个本地加密存储的综合备忘录网页应用，支持 PWA 安装到手机/桌面。

## 功能模块

- **普通备忘** — 标题 + 内容，支持标签分类筛选
- **银行卡** — 卡号/卡种/有效期/CVC/账单日/归属银行/归属人/备注，按银行分组、可筛选，到期与账单日提醒
- **炒股笔记** — 自定义分类（纪律 / 分析 / 个股… 全自由）+ 标签体系，组合筛选
- **全局搜索** — 跨模块关键词搜索
- **安全** — 主密码 AES-GCM 加密，数据存浏览器本地 IndexedDB，不上传服务器
- **备份** — JSON 导出 / 导入合并、修改主密码、清空
- **PWA** — 可安装到手机主屏，离线可用（sw.js）

## 部署到 GitHub Pages

沙箱环境无法直连 GitHub，请在**自己电脑的终端**执行：

```bash
# 进入本目录
cd <本文件夹路径>

# 方式一：已有 gh CLI 并登录
gh auth login            # 若未登录
./deploy.sh             # 默认仓库名 memo-app

# 方式二：仅用 Token（不需要 gh 登录）
GH_TOKEN=ghp_你的Token ./deploy.sh my-repo
```

部署后访问 `https://<你的用户名>.github.io/<仓库名>/`

> 若脚本无法自动开启 Pages，到 GitHub → 仓库 Settings → Pages → Source 选 **main** 分支，保存即可。

## 本地预览

直接用浏览器打开 `index.html` 即可使用（数据存在本机浏览器）。

## 文件说明

| 文件 | 作用 |
|------|------|
| `index.html` | 应用主页面（HTML+CSS+JS 内联） |
| `sw.js` | Service Worker，负责离线缓存 |
| `manifest.webmanifest` | PWA 配置 |
| `icon-*.png` / `apple-touch-icon.png` | 应用图标 |
| `deploy.sh` | 一键部署脚本 |

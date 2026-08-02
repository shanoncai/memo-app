#!/usr/bin/env bash
# ============================================================
#  综合备忘录 · 一键部署到 GitHub Pages
#  用法:
#    GH_TOKEN=ghp_你的Token ./deploy.sh            # 仓库名默认 memo-app
#    GH_TOKEN=ghp_你的Token ./deploy.sh my-repo    # 指定仓库名
#  依赖: gh CLI（已登录）或仅用 token 走 git
# ============================================================
set -e

REPO_NAME="${1:-memo-app}"
TOKEN="${GH_TOKEN:-$2}"

if [ -z "$TOKEN" ] && ! gh auth status >/dev/null 2>&1; then
  echo "✗ 未检测到 GitHub 登录或 Token"
  echo "  方式一: 先运行  gh auth login"
  echo "  方式二: GH_TOKEN=ghp_xxx ./deploy.sh"
  exit 1
fi

USER=$(gh api user --jq .login 2>/dev/null || echo "")

# 创建仓库并推送（gh 方式）
if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  echo "▶ 创建仓库 $REPO_NAME ..."
  gh repo create "$REPO_NAME" --public --source=. --push --description "综合备忘录 PWA" 2>/dev/null \
    || { git remote remove origin 2>/dev/null || true; git remote add origin "https://github.com/$USER/$REPO_NAME.git"; git branch -M main; git push -u origin main; }
else
  # 纯 git + token 方式
  echo "▶ 使用 token 推送（需先手动创建空仓库 $REPO_NAME）..."
  git remote remove origin 2>/dev/null || true
  git remote add origin "https://$TOKEN@github.com/$USER/$REPO_NAME.git"
  git branch -M main
  git push -u origin main
fi

# 开启 GitHub Pages
echo "▶ 开启 GitHub Pages ..."
gh api -X POST "/repos/$USER/$REPO_NAME/pages" \
  --field source='{"branch":"main","path":"/"}' >/dev/null 2>&1 \
  && echo "✓ Pages 已开启" \
  || echo "⚠ 请到 GitHub → Settings → Pages → Source 选 main 分支，保存"

echo ""
echo "🎉 部署完成！"
echo "   网站地址: https://$USER.github.io/$REPO_NAME/"
echo "   （Pages 首次部署需等 1~2 分钟生效）"

#!/bin/zsh

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR"

echo "== Quick Git Push =="
echo "Repo: $REPO_DIR"
echo ""

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "錯誤：這裡不是 git repository。"
  read -r "?按 Enter 結束..."
  exit 1
fi

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ -z "$BRANCH" || "$BRANCH" == "HEAD" ]]; then
  BRANCH="main"
fi

echo "目前分支：$BRANCH"
echo ""

STATUS="$(git status --short)"
if [[ -z "$STATUS" ]]; then
  echo "沒有變更可推送。"
  read -r "?按 Enter 結束..."
  exit 0
fi

echo "偵測到以下變更："
git status --short
echo ""

read -r "?請輸入 commit 訊息（留空則用預設訊息）: " COMMIT_MSG
if [[ -z "$COMMIT_MSG" ]]; then
  COMMIT_MSG="chore: quick update"
fi

git add .
git commit -m "$COMMIT_MSG"
git push origin "$BRANCH"

echo ""
echo "完成：已推送到 origin/$BRANCH"
read -r "?按 Enter 關閉視窗..."

#!/usr/bin/env bash
# git-commit スキル用: gh アクティブアカウントとリポジトリ所有者を安全に取得する。
# GitHub 解決に失敗してもコミット作業を止めないよう、常に終了コード0で返す。
set +e

echo "=== Git のアクティブアカウント ==="
gh auth status 2>&1 || echo "(gh 未認証または取得失敗)"
echo
echo "=== リポジトリ所有者 ==="
owner="$(gh repo view --json owner -q .owner.login 2>/dev/null)"
if [ -n "$owner" ]; then
  echo "$owner"
else
  echo "(未解決: リモートが GitHub 上に存在しない／権限なし。アカウント切替は不要としてスキップする)"
fi
exit 0

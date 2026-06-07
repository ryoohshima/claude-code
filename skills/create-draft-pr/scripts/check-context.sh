#!/usr/bin/env bash
# create-draft-pr スキル用コンテキスト収集。GitHub 解決(アカウント依存)に失敗しても
# スキル起動を止めないよう常に終了コード0で返す。owner は remote URL から導出し、
# アクティブアカウントに依存せず確定する（切替先の判定に使う）。
set +e

echo "=== gh アクティブアカウント ==="
gh auth status 2>&1 || echo "(gh 未認証または取得失敗)"

echo
echo "=== リポジトリ所有者 (remote URL から導出) ==="
url="$(git remote get-url origin 2>/dev/null)"
if [ -n "$url" ]; then
  path="${url%.git}"; rest="${path%/*}"; owner="${rest##*[:/]}"
  echo "${owner:-(導出不可)}"
else
  echo "(remote 未設定: ローカル専用。push/PR は不可)"
fi

echo
echo "=== デフォルトブランチ ==="
def="$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null)"; def="${def#origin/}"
echo "${def:-main}"

exit 0

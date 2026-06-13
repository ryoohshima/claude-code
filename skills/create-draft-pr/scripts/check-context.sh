#!/usr/bin/env bash
# create-draft-pr スキル用コンテキスト収集。取得に失敗してもスキル起動を止めないよう
# 常に終了コード0で返す。
set +e

echo "=== デフォルトブランチ ==="
def="$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null)"; def="${def#origin/}"
echo "${def:-main}"

exit 0

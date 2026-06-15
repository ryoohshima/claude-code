#!/bin/bash
# Read JSON input from stdin
input=$(cat)

# Extract values using jq
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')

# Show git branch if in a git repo
GIT_BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        GIT_BRANCH=" | 🌿 $BRANCH"
    fi
fi

echo -n "📁 ${CURRENT_DIR##*/}$GIT_BRANCH"

# used_percentage(0〜100) を 10 セルのバーゲージに変換する
make_bar() {
    local pct=${1%.*}                    # 小数を切り捨て整数部のみ取得（"18.4" -> "18"）
    local filled=$(( (pct + 5) / 10 ))   # 0〜10 に四捨五入
    [ "$filled" -gt 10 ] && filled=10
    [ "$filled" -lt 0 ] && filled=0
    local i bar=""
    for ((i = 0; i < 10; i++)); do
        if [ "$i" -lt "$filled" ]; then bar="${bar}█"; else bar="${bar}░"; fi
    done
    printf '%s' "$bar"
}

# 利用枠（rate limit）の使用率を表示する。Pro/Max かつ初回 API 応答後のみ JSON に含まれる。
FIVE_HOUR=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
SEVEN_DAY=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

if [ -n "$FIVE_HOUR" ]; then
    printf '\n📊 5h [%s] %s%%' "$(make_bar "$FIVE_HOUR")" "$(printf '%.0f' "$FIVE_HOUR")"
fi
if [ -n "$SEVEN_DAY" ]; then
    printf '\n📊 7d [%s] %s%%' "$(make_bar "$SEVEN_DAY")" "$(printf '%.0f' "$SEVEN_DAY")"
fi

#!/bin/zsh
# UserPromptSubmit hook: 利用可能なローカルスキルを動的に列挙し、
# forced eval プロトコル(YES/NO 評価 → Skill() 起動 → 実装)を強制注入する。
# 参考: https://scottspence.com/posts/how-to-make-claude-code-skills-activate-reliably
set -u

SKILLS_DIR="${HOME}/.claude/skills"
[[ ! -d "$SKILLS_DIR" ]] && exit 0

SKILL_LIST=""
for skill_dir in "$SKILLS_DIR"/*/; do
  skill_name=$(basename "$skill_dir")
  [[ "$skill_name" == .* ]] && continue
  skill_md="${skill_dir}SKILL.md"
  [[ ! -f "$skill_md" ]] && continue

  # frontmatter の description: 行を抽出。なければ先頭の非空行を fallback。
  desc=$(awk '
    /^---[[:space:]]*$/ { fm = !fm; next }
    fm && /^description:/ {
      sub(/^description:[[:space:]]*/, "")
      print
      exit
    }
  ' "$skill_md")
  if [[ -z "$desc" ]]; then
    # frontmatter / H1〜H6 / 空行をスキップして最初の本文行を採用
    desc=$(awk '
      /^---[[:space:]]*$/ { fm = !fm; next }
      fm { next }
      /^[[:space:]]*$/ { next }
      /^#+[[:space:]]/ { next }
      { print; exit }
    ' "$skill_md")
  fi

  SKILL_LIST="${SKILL_LIST}- **${skill_name}**: ${desc}
"
done

[[ -z "$SKILL_LIST" ]] && exit 0

cat <<EOF
[MANDATORY SKILL EVALUATION PROTOCOL]

Before writing ANY implementation, you MUST execute the following 3-step protocol in order. Skipping any step is a FAILURE.

## Step 1 — EVALUATE (show your work)
For EACH skill listed below, state YES or NO followed by a one-sentence reason. Do NOT skip skills. Do NOT batch.

${SKILL_LIST}

## Step 2 — ACTIVATE (commit)
For EVERY skill you marked YES in Step 1, invoke the Skill() tool NOW, before any further action. One Skill() call per YES skill.

## Step 3 — IMPLEMENT (follow through)
Only AFTER all Step 2 activations complete may you proceed to actual implementation work.

CRITICAL: The Step 1 evaluation is WORTHLESS unless you ACTIVATE every matched skill in Step 2. Jumping to implementation without explicit YES/NO and corresponding Skill() calls violates this protocol and produces unreliable output.
EOF

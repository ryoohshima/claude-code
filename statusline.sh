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

echo "📁 ${CURRENT_DIR##*/}$GIT_BRANCH"

# Get ccusage statusline
ccusage_output=$(echo "$input" | npx -y ccusage statusline --no-offline 2>/dev/null | tr -d '\n')
echo -n $ccusage_output

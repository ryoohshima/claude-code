---
allowed-tools: Bash(git checkout:*), Bash(git branch:*), Bash(git switch:*), Bash(git diff:*), Bash(git status:*), Bash(git stash:*), Bash(git pull:*), Bash(gh repo:*)
description: 差分を分析してブランチを自動作成
---

# create branch

## コンテキスト

- 現在のブランチ: !`git branch --show-current`
- デフォルトブランチ: !`gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'`
- 既存のブランチ一覧: !`git branch -a`
- Git ステータス: !`git status`
- 現在の差分: !`git diff`
- ステージ済みの差分: !`git diff --staged`

## 規約

Git ワークフローの規約は @~/.claude/CLAUDE.md を参照してください。

## タスク

**重要**: 既にブランチが存在する場合でも、この手順を省略せず、ユーザーに確認を取ること。

1. 差分を分析し、変更内容を理解する
2. 変更の種類を判断（新機能、バグ修正、リファクタリングなど）
3. 規約に従った適切なブランチ名を生成
4. **作成予定のブランチ名と理由をユーザーに提示し、確認を取る**
5. デフォルトブランチを確認する
6. 確認が取れたら、変更を `git stash` で一時退避
7. **必ずデフォルトブランチに移動する** (`git checkout <デフォルトブランチ名>`)
   - 現在どのブランチにいても、必ずデフォルトブランチに移動すること
8. デフォルトブランチを最新化 (`git pull origin <デフォルトブランチ名>`)
9. デフォルトブランチから新しいブランチを作成して切り替え (`git checkout -b <ブランチ名>`)
10. `git stash pop` で変更を復元
11. 完了を報告

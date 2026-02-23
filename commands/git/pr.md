---
allowed-tools: Bash(gh pr:*), Bash(gh repo:*), Bash(git log:*), Bash(git diff:*), Bash(git branch:*)
description: Pull Request を作成
---

# create PR

## コンテキスト

- 現在のブランチ: !`git branch --show-current`
- デフォルトブランチ: !`gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'`
- コミット一覧: !`git log --oneline`
- 変更ファイル: !`git diff --name-only HEAD~1`

## PRテンプレート

@.github/PULL_REQUEST_TEMPLATE.md

## 規約

Git ワークフローとPRの規約は @~/.claude/CLAUDE.md を参照してください。

## タスク

1. コミット一覧と変更ファイルを分析
2. デフォルトブランチを確認する
3. 変更内容に基づいて適切なPRタイトルとボディを生成
4. `gh pr create` でPRを作成（`--base` オプションは省略し、GitHubのデフォルトブランチを自動使用）
5. 作成されたPRのURLを表示

## ポイント

- 必ずデフォルトブランチに向けてPRを作成してください。
- main ブランチに向けてPRを出すことを禁止します。

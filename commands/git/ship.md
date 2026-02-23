---
allowed-tools: Bash(gh repo:*), Read
denyed-tools: Bash(git -C:*)
description: ブランチ作成 → コミット → プッシュ → PR作成を一括実行
---

# ship

## コンテキスト

- デフォルトブランチ: !`gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'`
- 各コマンド
  - branch: `@~/.claude/commands/git/branch.md`
  - commit: `@~/.claude/commands/git/commit.md`
  - push: `@~/.claude/commands/git/push.md`
  - pr: `@~/.claude/commands/git/pr.md`

## 規約

Git ワークフローの規約は @~/.claude/CLAUDE.md を参照してください。

**注意**

- 必ずすべてのコマンドの手順を確認し、全ステップを実行すること。
- 最初にデフォルトブランチを確認すること

## タスク

以下のコマンドを順番に実行してください：

### 1. ブランチ作成

/branch を実行して、差分に基づいたブランチを作成

### 2. コミット

/commit を実行して、変更をステージング＆コミット

### 3. プッシュ

/push を実行して、リモートにプッシュ

### 4. PR作成

/pr を実行して、Pull Request を作成

## 注意事項

- 各ステップが成功したことを確認してから次に進む
- エラーが発生した場合は停止して報告
- 最後に作成されたPRのURLを表示

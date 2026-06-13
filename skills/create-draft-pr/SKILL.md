---
description: 実装差分を検知して PR 作成を実行するスキル
allowed-tools: Bash(gh auth status), Bash(gh auth switch:*), Bash(git remote:*), Bash(git status), Bash(git diff:*), Bash(git push -u origin:*), Bash(git log:*), Bash(gh pr:*), Bash(gh repo:*), Bash(bash:*)
---

## Context

- 収集情報（アクティブアカウント・所有者・デフォルトブランチ）: !`bash ${CLAUDE_SKILL_DIR}/scripts/check-context.sh`
- git ステータス: !`git status`

## Additional resources

- Git 規約は [git-guideline.md](@~/.claude/rules/git-guideline.md) を参照してください

## Task

1. Git のアクティブアカウントとリポジトリの所有者を確認し、もし異なるようであればアクティブアカウントをリポジトリの所有者に変更する
   - 所有者は remote URL から導出した値（アカウント権限に依存せず確定する）
   - 変更コマンド: `gh auth switch --user [owner]`
   - 所有者が「導出不可 / remote 未設定」と表示された場合のみ切替をスキップし、push/PR は実行できない旨をユーザーに伝えて判断を仰ぐ

2. デフォルトブランチと現在のブランチの変更差分を確認する
   - 確認コマンド: `git diff [default branch]...`
   - コミットログの確認コマンド: `git log --oneline [default branch]..HEAD`

3. 現在のブランチを確認する。以下のブランチの場合は必ず別のブランチを作成する。ブランチ作成の際にはデフォルトブランチと現在のブランチの差分を元に規約に沿った適切な命名をする
   - master, main, develop

4. git ステータスを確認する。もしコミットされていないファイルが存在している場合は この Skills の終了と Skills: git-commit の利用をユーザーにレコメンドする

5. 必要な差分がすべて commit されていることを確認したら push する
   - push コマンド: `git push -u origin [branch name]`

6. 変更差分を元にタイトルを本文を考え、ドラフトPRを作成する。もしリポジトリ内にPRテンプレートがある場合はそれに沿って作成をする。
   - PR作成コマンド: `gh pr create --draft  --title "[title]"  --body "[description]"`
   - テンプレート: `[リポジトリルート]/.github/PULL_REQUEST_TEMPLATE.md`

7. PR 作成後に PR の URL を表示する

## User Input

$ARGUMENTS

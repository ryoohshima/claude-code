---
allowed-tools: Bash(gh auth status), Bash(gh auth switch:*), Bash(git remote get-url:*), Bash(git branch:*), Bash(git diff:*), Bash(git add:*), Bash(git commit:*), Bash(gh repo:*)
description: 変更をチェックして内容ごとに細かくコミットする
---

## コンテキスト

- Git のアクティブアカウント: !`gh auth status`
- Git リポジトリの所有者: !`gh repo view --json owner -q .owner.login`
- 現在のブランチ: !`git branch --show-current`
- コード差分: !`git diff`

## Additional resources

- Git 規約は [CLAUDE.md](@~/.claude/rules/git-guideline.md) を参照してください
- For usage examples, see [sample.md](examples.md)

## Task

1. Git のアクティブアカウントとリポジトリの所有者を確認し、もし異なるようであればアクティブアカウントをリポジトリの所有者に変更する
   - 変更コマンド: `gh auth switch --user [username]`

2. 現在のブランチを確認する。以下のブランチの場合は必ず別のブランチを作成する。その際にブランチ元が現在のブランチのままで問題ないかユーザーに確認する
   - master
   - main
   - develop

3. コード差分を確認して全体の差分を分析し、論理的なグループに分類する
   - 機能追加、バグ修正、リファクタリングなど種類ごと
   - 関連するファイル同士でグループ化
   - 独立した変更は別コミットに

4. 各グループごとに以下を繰り返す：
   - 該当ファイルのみをステージング: `git add [file]`
   - 適切なコミットメッセージを生成
   - コミット実行: `git commit -m [commit message]`

5. 完了後、作成したコミット一覧を表示

6. Skills: create-draft-pr の使用をユーザーにレコメンドする

## 規約

- `.env` や認証情報を含むファイルはコミットしない
- commit は可能な限り細かく、1コミットに対して1つの関連する変更になるようにする
- コミットメッセージは「How」に焦点を当てた簡潔なメッセージにする
- コミットメッセージには prefix をつける

## User Input

$ARGUMENTS

---
name: git-commit
allowed-tools: Bash(gh auth status), Bash(gh auth switch:*), Bash(git remote get-url:*), Bash(git branch:*), Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(git add:*), Bash(git commit:*), Bash(gh repo:*)
description: 変更をチェックして内容ごとに細かくコミットする
---

## コンテキスト

起動時に以下を先回りで収集しているため、追加のコマンド実行なしで分析へ進めること。
俯瞰情報（状態・stat・log）→ 詳細差分の順に並べてある。

- Git のアクティブアカウント: !`gh auth status`
- Git リポジトリの所有者: !`gh repo view --json owner -q .owner.login`
- 現在のブランチ: !`git branch --show-current`
- 作業ツリーの状態（追跡外ファイル含む）: !`git status --short`
- 変更ファイルの概要: !`git diff --stat HEAD`
- ステージ済み差分: !`git diff --staged`
- 未ステージ差分: !`git diff`
- 直近コミット（メッセージ様式の参考）: !`git log --oneline -15`

`git diff` は新規（追跡外）ファイルを映さないため、`git status --short` に出た未追跡ファイルは中身を別途 `git diff --no-index /dev/null [file]` 等で確認してから分類する。

## Additional resources

- Git 規約は [git-guideline.md](@~/.claude/rules/git-guideline.md) を参照してください
- 分類の具体例は [examples.md](examples.md) を参照してください

## Task

1. Git のアクティブアカウントとリポジトリの所有者を確認し、もし異なるようであればアクティブアカウントをリポジトリの所有者に変更する
   - 変更コマンド: `gh auth switch --user [username]`

2. 現在のブランチを確認する。以下のブランチの場合は必ず別のブランチを作成する。その際にブランチ元が現在のブランチのままで問題ないかユーザーに確認する
   - master
   - main
   - develop

3. 収集済みの状態・stat・差分を使い、追跡外ファイルも含めて全体の変更を分析し、論理的なグループに分類する
   - 機能追加、バグ修正、リファクタリングなど種類ごと
   - 関連するファイル同士でグループ化
   - 独立した変更は別コミットに
   - 直近コミットの log を見て、既存の prefix・書式・粒度に揃える

4. 各グループごとに以下を繰り返す：
   - 該当ファイルのみをステージング: `git add [file]`
   - 適切なコミットメッセージを生成
   - コミット実行: `git commit -m [commit message]`

5. 完了後、作成したコミット一覧を表示

6. Skills: create-draft-pr の使用をユーザーにレコメンドする

## 規約

- `.env` や認証情報を含むファイルはコミットしない
- commit は可能な限り細かく、1コミットに対して1つの関連する変更になるようにする
- コミットメッセージは「How（どう変えたか）」に焦点を当てた簡潔なメッセージにする。What（何を）はコード自体で表現する
- コミットメッセージには prefix をつける
- ユーザーへの確認が必要な場面（ブランチ作成の可否、判断が割れる分類など）では AskUserQuestion を使う

## User Input

$ARGUMENTS

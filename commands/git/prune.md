---
allowed-tools: Bash(git fetch --prune), Bash(git branch:*)
description: リモートブランチで削除されているブランチを確認してローカルブランチから削除する
---

# delete local branch

## context

- 最新の状態を反映: !`git fetch --prune`
- ローカルブランチの状態を確認: !`git branch -vv`
- ブランチの削除: `git branch -D`

## 規約

- 以下のブランチは絶対に削除してはならない
  - develop
  - main
- 未マージの変更がある場合は差分を示したうえで削除して問題ないかユーザーに確認を求めること

## タスク

1. リモートブランチの最新状態を反映する
2. ローカルブランチの状態を確認し、`[origin/xxx: gone]`となっているものを特定する(リモートブランチで削除済みと判断できる)
3. 特定したブランチを削除する

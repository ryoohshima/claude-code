---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git diff:*), Bash(git log:*), Bash(git restore:*), Bash(gh auth status), Bash(gh auth switch:*)
description: 変更を内容ごとに細かくコミット
---

# git commit

## コンテキスト

- Git のアクティブアカウントの確認: !`gh auth status`
- Git のアクティブアカウントの変更: `gh auth switch --user [username]`
- 現在のブランチ: !`git branch --show-current`
- Git ステータス: !`git status`
- ステージ済みの差分: !`git diff --staged`
- 未ステージの差分: !`git diff`
- 直近のコミット: !`git log --oneline -5`

## 規約

Git ワークフローの規約は @~/.claude/CLAUDE.md を参照してください。

## タスク

1. アクティブアカウントを確認する
   - リポジトリのオーナーとアクティブアカウントを確認し、異なるようであればアクティブアカウントを変更する

2. 全体の差分を分析し、論理的なグループに分類する
   - 機能追加、バグ修正、リファクタリングなど種類ごと
   - 関連するファイル同士でグループ化
   - 独立した変更は別コミットに

3. 各グループごとに以下を繰り返す：
   - 該当ファイルのみをステージング（`git add <file>`）
   - 適切なコミットメッセージを生成
   - コミット実行

4. コミットメッセージは「How」に焦点を当てた簡潔なメッセージにする

5. `.env` や認証情報を含むファイルはコミットしない

6. 完了後、作成したコミット一覧を表示

## 分類の例

```txt
変更ファイル:
- src/auth/login.ts      → fix: ログインバリデーション修正
- src/auth/logout.ts     → fix: ログインバリデーション修正（同じグループ）
- src/components/Button.tsx → feat: ボタンコンポーネント追加
- README.md              → docs: README更新
```

上記の場合、3つのコミットに分ける

## ポイント

- commit は可能な限り細かく、1コミットに対して1つの関連する変更になるようにしてください

---
name: create-issue
description: GitHub のイシューを作成するスキル。会話・作業文脈やユーザーの簡潔な一言から、「背景→現状→やりたいこと→受け入れ基準」の単一テンプレートでイシュー本文を起草し、ドラフトを提示して承認を得てから gh issue create で起票する。「イシューを作って」「issue 化して」「これをチケットにして」「起票して」「バグを報告したい」「TODO を issue にまとめて」「issue 立てて」など、GitHub のイシュー/チケット/起票に関わる依頼では明示の指示が無くても必ずこのスキルを使うこと。なお本スキルは issue 専用であり、PR 作成は create-draft-pr、コミットは git-commit に委ねる（混同しないこと）。
allowed-tools: Bash(git remote:*), Bash(git branch:*), Bash(gh repo view:*), Bash(gh issue create:*), Bash(gh issue list:*), Bash(gh label list:*)
---

## Context

- 起票先リポジトリ: !`gh repo view --json nameWithOwner -q .nameWithOwner`
- 現在のブランチ: !`git branch --show-current`

## Additional resources

- タイトルの prefix 規約は [git-guideline.md](@~/.claude/rules/git-guideline.md) を参照してください

## Task

イシューは「誰かが後で読んで動ける」ことが価値の源泉です。書いた本人にしか分からない一言メモではなく、
背景・現状・狙い・完了条件が揃った状態まで引き上げることがこのスキルの仕事です。

1. 起票先リポジトリ(nameWithOwner)をユーザーに明示し、ここで合っているか確認する
   - 別リポジトリへ起票したい場合は `--repo [owner/name]` を後続コマンドに付ける

2. 入力源を統合してタイトルと本文を起草する
   - `$ARGUMENTS` があればそれを主軸に、無ければ直近の会話・作業文脈（調査結果・発見したバグ・決定事項）を要約して素材にする
   - 素材が薄く「現状」や「受け入れ基準」が埋められない場合は、AskUserQuestion で不足だけを補完質問する。
     全部を訊き直すのではなく、テンプレートの空欄を埋めるために本当に足りない情報に絞ること
   - タイトルは git-guideline の prefix（`feat:` / `fix:` / `docs:` / `refactor:` / `chore:` など）を内容から推論して付け、
     prefix 以降は日本語で簡潔に書く。本文はすべて日本語

3. 既存ラベルを `gh label list` で確認し、内容に合うものがあれば候補として提示する
   - リポジトリに存在しないラベルは指定しない（`gh issue create` が失敗するため）。該当が無ければラベル無しでよい

4. 起草したドラフト（タイトル + 本文 + ラベル候補）をユーザーに提示し、承認を得る
   - **承認を得るまで `gh issue create` を実行しないこと**。確認を挟むのがこのスキルの約束である
   - 修正要望があれば反映して再提示する

5. 承認後にイシューを作成する
   - 作成コマンド: `gh issue create --title "[title]" --body "[body]"` （ラベルがあれば `--label "[label]"` を付与）

6. 作成後にイシューの URL を表示する

## 本文テンプレート（単一・汎用）

本文は必ず以下の構造で組み立てる。該当が無いセクションは「特になし」と明記し、勝手に省略しないこと
（読み手が「書き忘れ」か「本当に無い」かを判別できるようにするため）。

```
## 背景 / Why
なぜこの issue が必要か。困りごと・きっかけ・関連する経緯

## 現状 / Current
今どうなっているか。現在の挙動・制約・関連ファイルやコミット

## やりたいこと / What
何を実現したいか。あるべき姿・対応の方向性

## 受け入れ基準 / Acceptance Criteria
- [ ] 完了と判断できる条件を箇条書きで（テスト・観測可能な振る舞いで書く）

## 補足 / Notes（任意）
参考リンク・スクショ・代替案など
```

## 規約

- 機密情報（`.env` の値、API キー、トークン、認証情報）を本文・タイトルに含めない
- 承認を得るまで `gh issue create` を実行しない
- タイトルの prefix 以外は日本語で記述する

## Example

入力（$ARGUMENTS）が「health gate を手動リセットする手段が欲しい」の一言だった場合の起草例：

**タイトル:**
```
feat: health gate の手動リセット手段を追加
```

**本文:**
```
## 背景 / Why
X API のクレジット枯渇でサーキットブレーカー(health.json)が trip した後、
チャージ完了後に状態を戻す手段が workflow_dispatch の手動実行のみで分かりづらい。

## 現状 / Current
data/health.json が tripped のままだと cron が no-op を続ける。
復帰には GitHub Actions の Run workflow から reset_health を手動指定する必要がある。

## やりたいこと / What
クレジット復旧後に health 状態を安全にリセットできる、分かりやすい導線を用意する。

## 受け入れ基準 / Acceptance Criteria
- [ ] tripped 状態を 1 アクションでリセットできる
- [ ] リセット後の最初の cron で通常投稿が再開する
- [ ] 誤操作で tripped 中に課金 API を叩かない

## 補足 / Notes（任意）
関連: tasks/lessons.md 2026-05-05 / 2026-05-10 のサーキットブレーカー経緯
```

## User Input

$ARGUMENTS

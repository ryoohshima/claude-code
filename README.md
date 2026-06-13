# claude-code

Claude Code の設定（`~/.claude`）を管理するリポジトリです。

## セットアップ

`install.sh` を実行すると、`~/.claude` をこのリポジトリへのシンボリックリンクとして作成します。これにより、リポジトリ内のファイルを編集するとそのまま `~/.claude` に反映され、git で設定の履歴を管理できます。

```sh
# まず dry-run で動作内容を確認
./install.sh -n

# 問題なければ実行
./install.sh
```

### 既に `~/.claude` がある場合

`install.sh` は安全のため、既存の `~/.claude` がディレクトリやファイルとして存在する場合はエラーで停止します。先に内容をバックアップしてから削除し、再実行してください。

```sh
# 既存設定のバックアップ例
mv ~/.claude ~/.claude.bak

./install.sh
```

なお、既に正しいリンクが張られている場合は、そのまま正常終了します（冪等）。

## settings.json の管理について

`settings.json` は Git 管理対象だが、Superset アプリの `agent-setup` が起動時に `~/.claude/settings.json` へ通知フック（`$SUPERSET_HOME_DIR/hooks/notify.sh` 系）を**自動マージ注入**する。この注入は出力先がハードコードされており、`settings.local.json` へ逃がす設定も注入を止めるトグルも存在しない。

そのため、注入を Git から不可視化しつつ意図的な設定だけを追跡できるよう、`settings.json` には `skip-worktree` を設定している。

```sh
# 封印（初回のみ。注入をGitから不可視化）
git update-index --skip-worktree settings.json
```

### settings.json を意図的に変更してコミットするとき

`skip-worktree` 中はローカル変更が `git status` に出ないため、一時的に解除する。

```sh
git update-index --no-skip-worktree settings.json   # 1. 解除
#    ここで意図する設定だけを残し、Superset 注入分は取り除いて編集する
git add settings.json && git commit -m "chore: ..."  # 2. コミット
git update-index --skip-worktree settings.json       # 3. 再封印
```

### マシン固有・ローカル専用の設定

個人マシンだけで効かせたい設定は `settings.local.json`（gitignore 済み）に書く。Claude Code は hooks / permissions を全スコープでマージ実行するため、追跡対象の `settings.json` を汚さずに反映できる。

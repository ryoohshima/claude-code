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

## マシン固有・ローカル専用の設定

個人マシンだけで効かせたい設定は `settings.local.json`（gitignore 済み）に書く。Claude Code は hooks / permissions を全スコープでマージ実行するため、追跡対象の `settings.json` を汚さずに反映できる。

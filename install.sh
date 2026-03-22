#!/bin/bash
set -euo pipefail

# --- 設定 ---
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${HOME}/.claude"
DRY_RUN=false

# --- オプション解析 ---
for arg in "$@"; do
  case "$arg" in
    -n) DRY_RUN=true ;;
    *)
      echo "Usage: $0 [-n]"
      echo "  -n  dry-run: 変更を行わず確認のみ"
      exit 1
      ;;
  esac
done

# --- 冪等性チェック ---
if [ -L "$TARGET" ]; then
  current_link="$(readlink "$TARGET")"
  if [ "$current_link" = "$REPO_DIR" ]; then
    echo "✓ 既にリンク済みでござる: $TARGET -> $REPO_DIR"
    exit 0
  else
    echo "エラー: $TARGET は別の場所を指しているでござる: $current_link"
    exit 1
  fi
fi

# --- 既存ファイル/ディレクトリの確認 ---
if [ -e "$TARGET" ]; then
  echo "エラー: $TARGET が既に存在するでござる。"
  echo "先に手動で削除してから再実行してほしいでござる:"
  echo "  rm -rf $TARGET"
  exit 1
fi

# --- dry-run の場合は内容を表示して終了 ---
if $DRY_RUN; then
  echo "[dry-run] 以下の操作を行うでござる:"
  echo "  ln -s $REPO_DIR $TARGET"
  exit 0
fi

# --- シンボリックリンク作成 ---
ln -s "$REPO_DIR" "$TARGET"
echo "✓ リンクを作成したでござる: $TARGET -> $REPO_DIR"

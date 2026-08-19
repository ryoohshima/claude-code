#!/bin/bash
set -euo pipefail

# --- 設定 ---
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${HOME}/.claude"
USER_CONFIG="${HOME}/.claude.json"
MCP_SRC="${REPO_DIR}/mcp-servers.json"
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

# --- 1. ~/.claude をリポジトリへリンク ---
link_repo() {
  if [ -L "$TARGET" ]; then
    local current_link
    current_link="$(readlink "$TARGET")"
    if [ "$current_link" = "$REPO_DIR" ]; then
      echo "✓ 既にリンク済みでござる: $TARGET -> $REPO_DIR"
      return 0
    fi
    echo "エラー: $TARGET は別の場所を指しているでござる: $current_link" >&2
    exit 1
  fi

  if [ -e "$TARGET" ]; then
    echo "エラー: $TARGET が既に存在するでござる。" >&2
    echo "先に手動で削除してから再実行してほしいでござる:" >&2
    echo "  rm -rf $TARGET" >&2
    exit 1
  fi

  if $DRY_RUN; then
    echo "[dry-run] ln -s $REPO_DIR $TARGET"
    return 0
  fi

  ln -s "$REPO_DIR" "$TARGET"
  echo "✓ リンクを作成したでござる: $TARGET -> $REPO_DIR"
}

# --- 2. MCP サーバー定義を user scope へ反映 ---
# user scope の実体は ~/.claude.json の mcpServers キーのみ（~/.claude/ 配下に
# 置いても読まれない）。このファイルは会話履歴や認証情報を含むため git 管理でき
# ない。よって git 管理下の mcp-servers.json を正とし、mcpServers だけを毎回
# 上書きマージする。トークンを含むサーバー（kitesurf 等）は ~/.claude.json 側に
# のみ置き、ここでは触らない（このリポジトリは public のため）。
sync_mcp() {
  if [ ! -f "$MCP_SRC" ]; then
    echo "エラー: $MCP_SRC が見つからぬでござる" >&2
    exit 1
  fi

  DRY_RUN="$DRY_RUN" MCP_SRC="$MCP_SRC" USER_CONFIG="$USER_CONFIG" python3 <<'PY'
import json, os, shutil

dry = os.environ["DRY_RUN"] == "true"
src_path, cfg_path = os.environ["MCP_SRC"], os.environ["USER_CONFIG"]

src = json.load(open(src_path))["mcpServers"]
cfg = json.load(open(cfg_path)) if os.path.exists(cfg_path) else {}
current = cfg.get("mcpServers", {})

changed = sorted(n for n, v in src.items() if current.get(n) != v)
if not changed:
    print(f"✓ MCP サーバー定義は同期済みでござる（{len(src)} 件）")
    raise SystemExit(0)

if dry:
    print(f"[dry-run] 以下を {cfg_path} へ反映するでござる: {', '.join(changed)}")
    raise SystemExit(0)

if os.path.exists(cfg_path):
    shutil.copy2(cfg_path, cfg_path + ".bak")
cfg.setdefault("mcpServers", {}).update(src)
with open(cfg_path, "w") as f:
    json.dump(cfg, f, indent=2, ensure_ascii=False)
print(f"✓ MCP サーバー定義を反映したでござる: {', '.join(changed)}")
print(f"  （バックアップ: {cfg_path}.bak）")
PY
}

link_repo
sync_mcp

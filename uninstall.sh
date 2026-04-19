#!/bin/zsh
# uninstall.sh: cmux-claude-skills 심볼릭 링크를 제거합니다.
# 사용법: ./uninstall.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/bin"
BIN_SRC="$SCRIPT_DIR/bin"

echo "=== cmux-claude-skills uninstall ==="

REMOVED=0
NOT_FOUND=0

for src in "$BIN_SRC"/cmux-*; do
  name="$(basename "$src")"
  [[ "$name" == *.example ]] && continue

  dest="$BIN_DIR/$name"
  if [[ -L "$dest" ]]; then
    rm "$dest"
    echo "  removed: $dest"
    REMOVED=$((REMOVED + 1))
  else
    NOT_FOUND=$((NOT_FOUND + 1))
  fi
done

echo ""
echo "✓ 제거 완료: ${REMOVED}개 제거, ${NOT_FOUND}개 없음"

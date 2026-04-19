#!/bin/zsh
# install.sh: cmux-claude-skills 실행 파일을 ~/.local/bin 에 설치합니다.
# 사용법: ./install.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/bin"
BIN_SRC="$SCRIPT_DIR/bin"

echo "=== cmux-claude-skills install ==="

# cmux CLI 확인
if ! command -v cmux &>/dev/null; then
  echo ""
  echo "⚠️  Warning: cmux CLI를 찾을 수 없습니다."
  echo "   cmux.app을 설치하고 PATH에 cmux CLI가 있는지 확인하세요."
  echo "   https://cmux.app"
  echo ""
fi

# ~/.local/bin 생성
if [[ ! -d "$BIN_DIR" ]]; then
  mkdir -p "$BIN_DIR"
  echo "→ 생성: $BIN_DIR"
fi

# PATH 확인
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo ""
  echo "⚠️  '$BIN_DIR' 이 PATH에 없습니다."
  echo "   ~/.zshrc 또는 ~/.bashrc 에 다음을 추가하세요:"
  echo '   export PATH="$HOME/.local/bin:$PATH"'
  echo ""
fi

# 심볼릭 링크 설치
INSTALLED=0
SKIPPED=0

for src in "$BIN_SRC"/cmux-*; do
  name="$(basename "$src")"

  # .example 파일은 건너뜀 (사용자가 직접 커스터마이즈)
  if [[ "$name" == *.example ]]; then
    echo "  skip (template): $name"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  dest="$BIN_DIR/$name"
  chmod +x "$src"

  if [[ -L "$dest" ]]; then
    ln -sfn "$src" "$dest"
    echo "  update: $name → $dest"
  elif [[ -e "$dest" ]]; then
    echo "  skip (exists, not a symlink): $dest"
    SKIPPED=$((SKIPPED + 1))
    continue
  else
    ln -sfn "$src" "$dest"
    echo "  install: $name → $dest"
  fi
  INSTALLED=$((INSTALLED + 1))
done

echo ""
echo "✓ 설치 완료: ${INSTALLED}개 설치, ${SKIPPED}개 건너뜀"
echo ""
echo "다음 단계:"
echo "  1. cmux-day-start 커스터마이즈:"
echo "     cp $BIN_SRC/cmux-day-start.example $BIN_DIR/cmux-day-start"
echo "     chmod +x $BIN_DIR/cmux-day-start"
echo "     \$EDITOR $BIN_DIR/cmux-day-start"
echo ""
echo "  2. Claude Code 플러그인으로 설치 (선택):"
echo "     /plugin marketplace add sanghun0724/cmux-claude-skills"
echo "     /plugin install cmux-kit"

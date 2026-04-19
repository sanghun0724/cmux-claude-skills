# cmux-claude-skills

> **macOS 전용** · [cmux.app](https://cmux.app) + [Claude Code](https://claude.ai/code) 필요

cmux 터미널과 Claude Code를 연결하는 자동화 스크립트 모음입니다.  
워크스페이스 레이아웃 설정, surface 자동 분류, Claude 세션 스냅샷/복원, 마크다운 실시간 미리보기를 제공합니다.

[English README →](README.md)

---

## 요구사항

- macOS 12+
- [cmux.app](https://cmux.app) 설치 및 `cmux` CLI가 PATH에 있을 것
- [Claude Code](https://claude.ai/code) CLI (`claude`)
- Python 3.9+ (`cmux-snapshot`, `cmux-restore` 사용 시)

---

## 설치

### 1. 실행 파일 설치

```bash
git clone https://github.com/sanghun0724/cmux-claude-skills.git
cd cmux-claude-skills
./install.sh
```

`~/.local/bin`이 PATH에 없다면:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### 2. Claude Code 플러그인으로 설치 (선택)

슬래시 커맨드(`/cmux-kit:organize` 등)로 사용하려면:

```
/plugin marketplace add sanghun0724/cmux-claude-skills
/plugin install cmux-kit
```

> **주의:** 플러그인 설치만으로는 CLI 도구가 설치되지 않습니다. 반드시 `./install.sh`도 실행하세요.

### 3. day-start 커스터마이즈

```bash
cp bin/cmux-day-start.example ~/.local/bin/cmux-day-start
chmod +x ~/.local/bin/cmux-day-start
$EDITOR ~/.local/bin/cmux-day-start  # PROJECTS_ROOT와 워크스페이스 목록 수정
```

---

## 커맨드

| 커맨드 | 설명 | 슬래시 커맨드 |
|--------|------|--------------|
| `cmux-organize [ws]` | surface를 주제별로 자동 분류 | `/cmux-kit:organize` |
| `cmux-snapshot [name]` | 현재 레이아웃 스냅샷 저장 | `/cmux-kit:snapshot` |
| `cmux-restore [name]` | 스냅샷에서 레이아웃 복원 | `/cmux-kit:restore` |
| `cmux-preview <file.md>` | 마크다운 사이드 미리보기 | `/cmux-kit:preview` |
| `cmux-day-start` | 하루 시작 워크스페이스 일괄 생성 | `/cmux-kit:day-start` |
| `cmux-skills [dir]` | 스킬 개발 + 파일 탐색 레이아웃 | `/cmux-kit:layout-skills` |
| `cmux-web [dir] [cmd]` | Claude + dev 서버 레이아웃 | `/cmux-kit:layout-web` |

---

## cmux-organize: 자동 분류 규칙

| 그룹 | 키워드 패턴 |
|------|------------|
| **research** | 리서치, research, deep.dive, 지식, 조사, survey |
| **tools** | skill, plugin, hook, claude, n8n, obsidian, kaizen |
| **work** | 그 외 모두 (메인 pane 유지) |

---

## cmux-snapshot / cmux-restore: 세션 복원

cmux가 종료되어도 Claude 세션을 복구할 수 있습니다.

**자동 스냅샷 설정** (`~/.claude/settings.json`):

```json
{
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "cmux-snapshot latest 2>/dev/null || true"
      }]
    }]
  }
}
```

**복원:**

```bash
cmux-restore          # 최신 스냅샷 사용
cmux-restore mywork   # ~/.cmux-snapshots/mywork.json 사용
CMUX_RESTORE_DELAY=1.0 cmux-restore  # 느린 머신용
```

---

## 제거

```bash
./uninstall.sh
```

---

## 라이선스

MIT © [sanghun0724](https://github.com/sanghun0724)

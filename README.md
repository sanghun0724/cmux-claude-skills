# cmux-claude-skills

> **macOS only** · Requires [cmux.app](https://cmux.app) + [Claude Code](https://claude.ai/code)

cmux 터미널과 Claude Code를 연결하는 자동화 스크립트 모음입니다.  
워크스페이스 레이아웃 자동 생성, surface 자동 분류, Claude 세션 스냅샷/복원, 마크다운 미리보기를 제공합니다.

---

## Requirements

- macOS 12+
- [cmux.app](https://cmux.app) 설치 및 `cmux` CLI가 PATH에 있을 것
- [Claude Code](https://claude.ai/code) CLI (`claude`)
- Python 3.9+ (`cmux-snapshot`, `cmux-restore` 사용 시)

---

## Install

### 1. 실행 파일 설치

```bash
git clone https://github.com/sanghun0724/cmux-claude-skills.git
cd cmux-claude-skills
./install.sh
```

`~/.local/bin` 이 PATH에 없다면 셸 설정 파일에 추가하세요:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### 2. Claude Code 플러그인으로 설치 (선택)

Claude Code 안에서 슬래시 커맨드(`/cmux-kit:organize` 등)로 사용하려면:

```
/plugin marketplace add sanghun0724/cmux-claude-skills
/plugin install cmux-kit
```

### 3. day-start 커스터마이즈

`cmux-day-start`는 본인 프로젝트 경로에 맞게 수정해야 합니다:

```bash
cp bin/cmux-day-start.example ~/.local/bin/cmux-day-start
chmod +x ~/.local/bin/cmux-day-start
$EDITOR ~/.local/bin/cmux-day-start  # PROJECTS_ROOT 와 워크스페이스 목록 수정
```

---

## Commands

| 커맨드 | 설명 | 슬래시 커맨드 |
|--------|------|--------------|
| `cmux-organize [ws]` | surface를 주제별로 자동 분류 | `/cmux-kit:organize` |
| `cmux-snapshot [name]` | 현재 레이아웃 스냅샷 저장 | `/cmux-kit:snapshot` |
| `cmux-restore [name]` | 스냅샷에서 레이아웃 복원 | `/cmux-kit:restore` |
| `cmux-preview <file.md>` | 마크다운 사이드 미리보기 | `/cmux-kit:preview` |
| `cmux-day-start` | 하루 시작 워크스페이스 일괄 생성 | `/cmux-kit:day-start` |
| `cmux-ios [dir]` | iOS 3-pane 레이아웃 | `/cmux-kit:layout-ios` |
| `cmux-n8n [port]` | n8n 브라우저 + Claude 레이아웃 | `/cmux-kit:layout-n8n` |
| `cmux-data` | Claude + Python REPL 레이아웃 | `/cmux-kit:layout-data` |
| `cmux-skills [dir]` | 스킬 개발 + 파일 탐색 레이아웃 | `/cmux-kit:layout-skills` |
| `cmux-web [dir] [cmd]` | Claude + dev 서버 레이아웃 | `/cmux-kit:layout-web` |

---

## cmux-organize: 자동 분류 규칙

| 그룹 | 키워드 패턴 |
|------|------------|
| **research** | 리서치, research, deep.dive, 지식, 조사, survey |
| **tools** | skill, plugin, hook, claude, n8n, obsidian, kaizen |
| **work** | 그 외 모두 (메인 pane 유지) |

```
Before                  After
┌────────────────┐      ┌──────────┬──────────┐
│ work-1         │      │ work-1   │research-1│
│ work-2         │  →   │ work-2   ├──────────┤
│ research-1     │      │          │ tools-1  │
│ tools-1        │      │          │          │
└────────────────┘      └──────────┴──────────┘
```

---

## cmux-snapshot / cmux-restore: 세션 복원

cmux가 예상치 못하게 종료되어도 Claude 세션을 복구할 수 있습니다.

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

**복원**:

```bash
cmux-restore          # 최신 스냅샷 사용
cmux-restore mywork   # ~/.cmux-snapshots/mywork.json 사용
```

> **한계**: 세션 ID 매칭은 surface 제목과 `~/.claude/projects/` 인덱스 기반 fuzzy 검색입니다.  
> cmux CLI 출력 포맷 변경 시 파싱이 실패할 수 있습니다.  
> 느린 머신에서 복원이 불안정하면 `CMUX_RESTORE_DELAY=1.0 cmux-restore`로 대기 시간을 늘리세요.

---

## Notification Hook

Claude 작업 완료 시 cmux 사이드바에 알림을 표시합니다.

```bash
cp hooks/cmux-notify.mjs ~/.claude/hooks/cmux-notify.mjs
```

`~/.claude/settings.json` 에 추가:

```json
{
  "hooks": {
    "Notification": [{
      "hooks": [{
        "type": "command",
        "command": "node \"$HOME/.claude/hooks/cmux-notify.mjs\""
      }]
    }]
  }
}
```

---

## Uninstall

```bash
./uninstall.sh
```

---

## License

MIT © [sanghun0724](https://github.com/sanghun0724)

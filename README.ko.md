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
| `cmux-snapshot-track` | Claude `SessionStart` hook — panel↔session 매핑 적립 | — |
| `cmux-claude-resume-all` | cmux 재시작 후 모든 panel에 자동 resume 전송 | — |
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

### Self-healing 세션 매핑

기존에는 `cmux-snapshot`이 `sessions-index.json`의 surface 제목 매칭으로
sessionId를 추측했기 때문에, Claude Code가 세션을 이어받으면서 새로운
`*.jsonl`을 만들면 인덱스가 stale 상태가 되어 복원 시
`claude --resume <stale-id>`가 모두 "No conversation found"로 실패했습니다.

이번 PR은 3단계 self-healing 파이프라인을 도입합니다:

1. **Live 캡처** — snapshot 시점에 `ps -eo pid,command` + `ps -E -p <pid>`로
   살아있는 claude 프로세스의 `--session-id`와 `CMUX_SURFACE_ID`를 추출해
   panel UUID ↔ sessionId를 100% 정확하게 매핑합니다.
2. **영구 적립** — `cmux-snapshot-track`을 Claude `SessionStart` hook으로
   등록하면, 세션이 시작될 때마다 `~/.cmux-snapshots/session-map.jsonl`에
   `{ts, panel, session, cwd, ws}` 기록이 누적됩니다. 이후 claude 프로세스가
   죽어도 매핑이 살아남습니다.
3. **Stale 감지 → 자동 폴백** — `cmux-restore`가 `full_path` 실존을 검증하고,
   파일이 없으면 저장된 `first_prompt`로 프로젝트 디렉토리 안의 jsonl을
   재탐색합니다. 모두 실패할 때만 `claude -c`로 폴백합니다.

`~/.claude/settings.json`에 hook을 한번만 등록하면 됩니다:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "",
        "hooks": [
          { "type": "command", "command": "cmux-snapshot-track" }
        ]
      }
    ]
  }
}
```

cmux 재시작 후 `cmux-restore`로 layout이 복원되면, 한 번에 모든 panel에
`claude --resume <sid>`를 자동 전송할 수 있습니다:

```bash
cmux-claude-resume-all            # 모든 panel에 send
cmux-claude-resume-all --dry-run  # 실제 send 없이 미리보기
```

스냅샷 파일에 surface마다 `full_path`, `first_prompt` 두 필드가 추가됐고,
restore 분기 로직에서 사용합니다. 옛 스냅샷에는 이 필드가 없을 수 있으나
graceful하게 legacy resume 경로로 폴백합니다.

---

## 환경변수

파일을 직접 수정하지 않고도 환경변수로 동작을 커스터마이즈할 수 있습니다.

| 변수 | 기본값 | 사용 스크립트 |
|------|--------|--------------|
| `CMUX_SNAPSHOT_DIR` | `~/.cmux-snapshots` | `cmux-snapshot`, `cmux-restore` |
| `CMUX_SESSION_FILE` | `~/Library/Application Support/cmux/session-com.cmuxterm.app.json` | `cmux-snapshot` |
| `CMUX_CLAUDE_PROJECTS` | `~/.claude/projects` | `cmux-snapshot` |
| `CMUX_RESTORE_DELAY` | `0.3` | `cmux-restore` (cmux 명령 간 대기 시간, 초) |
| `CMUX_RESEARCH_KEYWORDS` | 기본 목록 | `cmux-organize` (파이프 구분 정규식) |
| `CMUX_TOOLS_KEYWORDS` | 기본 목록 | `cmux-organize` (파이프 구분 정규식) |
| `CMUX_WEB_DEV_CMD` | `npm run dev` | `cmux-web` |
| `CMUX_INIT_DELAY` | `0.4` | `cmux-day-start` (워크스페이스 생성 후 대기, 초) |
| `CMUX_BIN_DIR` | `~/.local/bin` | `install.sh`, `uninstall.sh` |

**예시 — 분류 키워드 커스터마이즈:**

```bash
export CMUX_RESEARCH_KEYWORDS="research|deep.dive|survey|docs"
export CMUX_TOOLS_KEYWORDS="plugin|hook|claude|obsidian|n8n"
cmux-organize workspace:1
```

---

## 제거

```bash
./uninstall.sh
```

---

## 라이선스

MIT © [sanghun0724](https://github.com/sanghun0724)

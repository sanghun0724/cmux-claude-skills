---
name: restore
description: cmux-snapshot으로 저장한 스냅샷을 복원합니다. 워크스페이스 레이아웃과 Claude 세션을 재구성합니다.
argument-hint: "[snapshot-name-or-path]  기본: 최신 스냅샷"
---

저장된 스냅샷에서 cmux 레이아웃과 Claude 세션을 복원합니다.

인자: {{ARGUMENTS}}

## 실행

```
cmux-restore {{ARGUMENTS}}
```

## 복원 순서

1. 스냅샷 파일 로드 (기본: `~/.cmux-snapshots/latest.json`)
2. 각 워크스페이스를 `cmux new-workspace`로 생성
3. pane 트리를 재귀적으로 `cmux new-split`으로 재구성
4. 각 surface에 `cd <dir>` 전송
5. Claude surface는:
   - 세션 ID 있으면: `claude --resume <id>` 로 정확한 세션 복원
   - 없으면: `claude -c` 로 최근 세션 복원

## 타이밍 조정

머신이 느리거나 복원 중 실패가 생기면 대기 시간을 늘리세요:

```bash
CMUX_RESTORE_DELAY=1.0 cmux-restore
```

## 주의사항

- cmux.app이 실행 중이어야 합니다.
- 세션 ID 매칭은 베스트에포트 방식입니다. Claude 세션 인덱스(`~/.claude/projects/`)가 없으면 `claude -c` fallback을 사용합니다.

---
name: snapshot
description: 현재 cmux 레이아웃과 Claude 세션 ID를 JSON 스냅샷으로 저장합니다. cmux 재시작 시 복원에 사용됩니다.
argument-hint: "[snapshot-name]  기본: latest"
---

현재 cmux 레이아웃 트리와 각 surface에 연결된 Claude 세션 ID를 저장합니다.

인자: {{ARGUMENTS}}

## 실행

```
cmux-snapshot {{ARGUMENTS}}
```

인자가 없으면 `~/.cmux-snapshots/latest.json`에 저장합니다 (항상 덮어씀).

## 저장 내용

- 워크스페이스별 pane 트리 구조 (split 방향/비율 포함)
- 각 surface의 제목, 작업 디렉토리, Claude 세션 여부
- Claude 세션이면 `~/.claude/projects/` 에서 세션 ID 매칭 (CWD 기반 우선, 전체 검색 fallback)

## 실행 후 보고

저장된 워크스페이스 수와 Claude 세션 매칭 결과를 요약합니다.

## 자동화

Claude Code의 Stop 훅에 등록하면 세션 종료 시마다 자동 저장됩니다:

```json
"hooks": {
  "Stop": [{
    "hooks": [{
      "type": "command",
      "command": "cmux-snapshot latest 2>/dev/null || true"
    }]
  }]
}
```

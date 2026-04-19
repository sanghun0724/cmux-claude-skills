---
name: day-start
description: 하루 시작 시 미리 정의된 cmux 워크스페이스들을 일괄 생성합니다. 이미 존재하는 워크스페이스는 건너뜁니다.
argument-hint: ""
---

`cmux-day-start`를 실행해 하루 작업 환경을 한 번에 세팅합니다.

## 실행

```
cmux-day-start
```

## 설정 방법

`bin/cmux-day-start.example`을 복사해 `~/.local/bin/cmux-day-start`로 저장한 뒤,
파일 안의 워크스페이스 목록을 본인 프로젝트에 맞게 수정하세요.

```bash
cp /path/to/cmux-claude-skills/bin/cmux-day-start.example ~/.local/bin/cmux-day-start
chmod +x ~/.local/bin/cmux-day-start
# 파일을 열어 PROJECTS_ROOT와 create_ws 목록 수정
```

## 기본 제공 레이아웃 커맨드

| 커맨드 | 설명 |
|--------|------|
| `cmux-skills` | Claude + 파일 탐색 |
| `cmux-web [dir] [cmd]` | Claude + dev 서버 |

## 실행 후 보고

생성된 워크스페이스 목록과 건너뛴 항목을 요약합니다.

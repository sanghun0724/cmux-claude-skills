---
name: organize
description: cmux 워크스페이스의 기존 surface들을 주제별(work/research/tools)로 자동 분류하고 pane으로 재배치합니다.
argument-hint: "[workspace-ref]  예: workspace:1"
---

cmux 워크스페이스의 surface(탭)들을 제목 키워드 기반으로 자동 분류합니다.

인자: {{ARGUMENTS}}

## 실행 순서

1. 인자가 비어있으면 `$CMUX_WORKSPACE_ID` 환경변수를 확인합니다.
   둘 다 없으면 사용자에게 workspace 참조값(예: `workspace:1`)을 물어봅니다.

2. 다음 명령을 실행합니다:
   ```
   cmux-organize {{ARGUMENTS}}
   ```

3. 결과를 사용자에게 요약해 보고합니다:
   - 각 그룹(work/research/tools)에 몇 개의 surface가 배치됐는지
   - 새로 만들어진 pane 수

## 분류 규칙

| 그룹 | 키워드 패턴 |
|------|------------|
| research | 리서치, research, deep.dive, 지식, 조사, survey |
| tools | skill, plugin, hook, claude, n8n, obsidian, kaizen |
| work | 그 외 모두 (메인 pane 유지) |

## 주의사항

- 이미 2개 이상의 pane이 있으면 "이미 정리됨"으로 종료합니다.
- 모든 surface가 'work'로 분류되면 분류 없이 종료합니다.
- `cmux-organize`가 PATH에 없으면 `install.sh`를 먼저 실행하세요.

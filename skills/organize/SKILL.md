---
name: organize
description: cmux 워크스페이스의 surface(탭)를 AI가 맥락 기반으로 분류하고 pane으로 재배치합니다. 하드코딩 없이 탭 제목과 내용을 탐색해 지능적으로 분류합니다.
argument-hint: "[workspace-ref]  예: workspace:1"
---

cmux 워크스페이스의 탭들을 탐색하고 Claude가 직접 맥락을 파악해 분류합니다.

인자: {{ARGUMENTS}}

## 실행 순서

### 1단계: workspace 파악

인자가 없으면 `$CMUX_WORKSPACE_ID`를 먼저 확인합니다.
둘 다 없으면 사용자에게 workspace 참조값을 물어봅니다.

```bash
WORKSPACE={{ARGUMENTS}}  # 또는 $CMUX_WORKSPACE_ID
```

### 2단계: 현재 구조 탐색

```bash
# pane 목록 확인
cmux list-panes --workspace $WORKSPACE

# 이미 2개 이상의 pane이면 "이미 정리된 상태"로 종료
# pane이 1개이면 계속 진행

# surface(탭) 목록 수집
FIRST_PANE=$(cmux list-panes --workspace $WORKSPACE | grep -oE "pane:[0-9]+" | head -1)
cmux list-pane-surfaces --workspace $WORKSPACE --pane $FIRST_PANE
```

수집된 surface ID와 제목 목록을 정리합니다.

### 3단계: AI 분류 (Claude가 직접 판단)

각 탭 제목을 읽고 다음 기준으로 분류합니다:

| 그룹 | 판단 기준 |
|------|----------|
| **research** | 정보 수집, 학습, 레퍼런스, 문서 탐색 목적의 탭 |
| **tools** | 개발 도구, 스킬, 플러그인, 설정 관련 탭 |
| **work** | 실제 작업 중인 코드, 태스크, 프로젝트 탭 (메인 pane 유지) |

> 키워드가 아닌 **맥락**으로 판단합니다.
> 예: "Claude API 문서" → research, "claude 스킬 작업 중" → work

분류 결과를 사용자에게 표로 보여주고 확인을 받습니다:

```
surface:1  [work]     "hoian-ios 빌드 디버깅"
surface:2  [research] "SwiftUI 레이아웃 레퍼런스"
surface:3  [tools]    "cmux 스킬 개발"
surface:4  [work]     "PR 리뷰"
```

분류가 맞는지 확인 후 진행합니다. 사용자가 수정을 요청하면 반영합니다.

### 4단계: 재배치 실행

확인이 완료되면 `cmux-reorganize`를 호출합니다:

```bash
cmux-reorganize \
  --research "surface:2" \
  --tools "surface:3" \
  $WORKSPACE
```

### 5단계: 결과 보고

- 생성된 pane 수와 각 그룹의 surface 배치 결과를 요약합니다.
- `cmux tree --workspace $WORKSPACE`로 최종 레이아웃을 확인합니다.

## 주의사항

- `cmux-reorganize`가 PATH에 없으면 `install.sh`를 먼저 실행하세요.
- 분류 결과를 실행 전 반드시 사용자에게 보여주고 확인받습니다.
- surface 제목이 비어있거나 알 수 없는 경우 work로 분류합니다.

---
name: layout-ios
description: iOS 개발용 3-pane 레이아웃을 설정합니다. 메인(좌 60%) + 우상단 + 우하단, 각 pane에서 Claude 자동 시작.
argument-hint: "[프로젝트-디렉토리]"
---

현재 cmux 워크스페이스를 iOS 개발에 최적화된 3-pane 구조로 설정합니다.

```
+-------------------+----------+
| main (현재)       | sub-top  | ← claude 자동시작
|   Claude 유지     +----------+
|                   | sub-bot  | ← claude 자동시작
+-------------------+----------+
```

인자: {{ARGUMENTS}}

## 실행

```
cmux-ios {{ARGUMENTS}}
```

인자가 없으면 현재 디렉토리(`$PWD`)를 기준으로 Claude가 시작됩니다.

## 조건

- cmux 워크스페이스 터미널 안에서 실행해야 합니다 (`CMUX_WORKSPACE_ID` 필요).
- 현재 pane이 1개일 때만 실행됩니다. 이미 분할되어 있으면 종료합니다.

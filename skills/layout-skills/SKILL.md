---
name: layout-skills
description: Claude 스킬/플러그인 개발 레이아웃을 설정합니다. Claude(좌 70%) + 파일 탐색(우 30%).
argument-hint: "[스킬-디렉토리]  기본: ~/.claude"
---

현재 cmux 워크스페이스를 Claude 스킬 개발 레이아웃으로 설정합니다.

```
+-------------------+----------+
| Claude (70%)      | ls / grep|
|  스킬 설계        | 파일확인 |
+-------------------+----------+
```

인자: {{ARGUMENTS}}

## 실행

```
cmux-skills {{ARGUMENTS}}
```

인자가 없으면 `~/.claude`를 기준으로 파일 탐색 pane이 열립니다.

## 조건

- cmux 워크스페이스 터미널 안에서 실행해야 합니다.
- 현재 pane이 1개일 때만 실행됩니다.

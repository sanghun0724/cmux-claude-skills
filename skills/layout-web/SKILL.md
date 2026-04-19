---
name: layout-web
description: 웹뷰/프론트엔드 개발 레이아웃을 설정합니다. Claude(좌 70%) + dev 서버 로그(우 30%, 자동 시작).
argument-hint: "[프로젝트-디렉토리] [dev-커맨드]"
---

현재 cmux 워크스페이스를 프론트엔드 개발 레이아웃으로 설정합니다.

```
+-------------------+----------+
| Claude (70%)      | dev 서버 |
|                   | 로그     |
+-------------------+----------+
```

인자: {{ARGUMENTS}}

## 실행

```
cmux-web {{ARGUMENTS}}
```

인자 예시:
- `cmux-web` → 현재 디렉토리, `flew dev` 실행
- `cmux-web ~/myproject` → `~/myproject` 디렉토리, `flew dev` 실행
- `cmux-web ~/myproject "npm run dev"` → 커스텀 dev 커맨드

## 조건

- cmux 워크스페이스 터미널 안에서 실행해야 합니다.
- 현재 pane이 1개일 때만 실행됩니다.

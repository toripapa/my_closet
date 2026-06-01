## Context

`avatar-setup` 변경에서 아바타 생성(카메라 촬영 → 서버 배경 제거 → DALL-E 생성)까지 구현했다. 그러나 생성 결과 화면이 없고, 신체 정보 입력 폼이 없으며, 모든 상태가 인메모리(Riverpod)에만 존재해 앱 재시작 시 소멸된다. 이번 변경은 결과 확인 페이지 추가, 신체 정보 입력 및 서버 DB 영구 저장, 삭제 기능, 아바타 페이지 전체 프로필 표시를 완성하는 것이다.

## Goals / Non-Goals

**Goals:**
- 아바타 생성 완료 후 결과 이미지 + 신체 정보 입력 폼을 한 화면(`/home/avatar/result`)에서 처리
- 신체 정보 5종(키, 몸무게, 상의 사이즈, 하의 사이즈, 신발 사이즈)을 서버 SQLite DB에 영구 저장
- 앱 시작 시 서버에서 저장된 프로필을 불러와 `avatarProvider`에 복원
- 아바타 삭제: Flutter UI 확인 다이얼로그 → 서버 DELETE API → Provider 초기화
- `/home/avatar` 페이지에서 등록 완료 상태일 때 전체 프로필(이미지 + 신체 정보) + "아바타 수정"/"아바타 삭제" 버튼 표시

**Non-Goals:**
- 사용자 인증 토큰 기반 다중 사용자 분리 (1차는 단일 사용자 가정)
- 클라우드 DB 연동 (SQLite 로컬 파일로 충분)
- 아바타 이미지 파일 서버 영구 저장 (URL/Base64 문자열만 DB 저장)
- 신체 정보 히스토리/이력 관리

## Decisions

### 1. DB: SQLite + SQLAlchemy (비동기)

**결정**: `aiosqlite` + `SQLAlchemy 2.x async` 엔진  
**이유**: FastAPI의 비동기 특성에 맞는 async DB 드라이버 필요. SQLite는 별도 DB 서버 없이 파일 하나로 운영 가능하여 로컬 개발/배포에 최적. SQLAlchemy ORM으로 모델 정의가 명확하고 향후 PostgreSQL 전환 시 코드 변경 최소화.  
**대안 검토**: `databases` 라이브러리 — 가볍지만 ORM 없음, 복잡 쿼리에 불리  

### 2. 아바타 프로필 DB 스키마

```
avatar_profiles 테이블
├── id          INTEGER PK AUTOINCREMENT
├── user_id     TEXT NOT NULL (현재는 "default_user" 고정, 향후 확장)
├── avatar_url  TEXT              (생성된 아바타 이미지 URL 또는 Base64)
├── height      REAL              (cm)
├── weight      REAL              (kg)
├── top_size    TEXT              (예: "M / 95")
├── bottom_size TEXT              (예: "30 / 32")
├── shoe_size   TEXT              (예: "265 mm")
└── created_at  DATETIME DEFAULT now
```

**결정**: 단일 테이블, `user_id` 기준 upsert (등록/수정 단일 엔드포인트)  
**이유**: 1차에서 단순성 우선. `user_id`를 고정값으로 두어도 나중에 실제 인증 연동 시 교체만 하면 됨.

### 3. Flutter 결과 페이지 흐름

```
가이드 페이지 → 카메라 촬영 → (로딩) → 결과 페이지(/home/avatar/result)
    ↓
결과 페이지: 아바타 이미지 표시 + 신체 정보 입력 폼
    ↓ "저장" 버튼
서버 POST /api/avatar/profile
    ↓ 성공
avatarProvider 업데이트 → /home/avatar 이동 (pop to root)
```

**결정**: 결과 페이지를 별도 라우트(`/home/avatar/result`)로 분리  
**이유**: 이미지 촬영 결과(URL)를 extra 파라미터로 전달하고, 뒤로가기 시 아바타 페이지로 돌아오는 자연스러운 UX. `context.go()`로 스택 초기화하여 결과 페이지 → 아바타 페이지 전환.

### 4. 앱 시작 시 프로필 로드

**결정**: `avatarProvider`를 `AsyncNotifier`로 전환, 초기화 시 `GET /api/avatar/profile` 호출  
**이유**: 앱 시작 시 서버에서 프로필을 불러와야 "아바타 등록/수정" 버튼 상태가 올바르게 표시됨.  
**트레이드오프**: 서버가 꺼져 있으면 로드 실패 → `hasAvatar=false`로 폴백 처리

### 5. 아바타 삭제 UX

**결정**: 삭제 버튼 클릭 → 확인 다이얼로그("정말 삭제하시겠습니까?") → 서버 DELETE → Provider 초기화 → 아바타 페이지 갱신  
**이유**: 실수 삭제 방지를 위한 확인 단계 필수

## Risks / Trade-offs

- **[리스크] 서버 미실행 상태에서 앱 시작** → 프로필 로드 실패 시 `hasAvatar=false` 폴백, 스낵바로 서버 연결 오류 안내
- **[리스크] Base64 이미지 DB 저장 시 용량** → 1차는 허용(단일 사용자), 향후 파일 시스템 저장 + URL 참조로 전환
- **[트레이드오프] SQLite 단일 파일** → 동시 쓰기 제한 있으나 단일 사용자 환경에서 문제 없음
- **[리스크] 신체 정보 입력 검증 미흡** → 서버에서 키(50-250cm), 몸무게(10-300kg) 범위 검증 추가

## Migration Plan

1. `requirements.txt`에 `sqlalchemy[asyncio]`, `aiosqlite` 추가
2. DB 초기화 코드 작성(`app/db/database.py`) — 테이블 자동 생성 (`create_all`)
3. 기존 `avatar-setup` 구현 코드와 충돌 없이 확장 (라우터 신규 엔드포인트 추가, 기존 엔드포인트 유지)
4. Flutter `avatarProvider`를 `AsyncNotifier`로 교체 (기존 UI는 `ref.watch` 패턴 유지로 영향 최소화)

## Open Questions

- `sqlalchemy`, `aiosqlite` 패키지 추가 승인: **사용자 확인 필요** (본 설계에서 사전 명시)
- 향후 실제 사용자 인증 연동 시 `user_id` 컬럼 → JWT 토큰에서 추출로 교체 예정


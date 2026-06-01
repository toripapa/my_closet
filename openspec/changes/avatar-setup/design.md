## Context

현재 `/home/avatar` 페이지(`lib/pages/avatar/avatar_page.dart`)는 정적 플레이스홀더 UI로만 구성되어 있다. "아바타 수정" 버튼이 항상 표시되지만 실제 동작이 없으며, 아바타 등록 여부를 구분하지 않는다. 아바타 생성은 사진 촬영 → 배경 제거(누끼) → LLM 이미지 생성 순서로 외부 AI API를 호출해야 하며, API 키 보안을 위해 반드시 별도 서버를 경유해야 한다.

## Goals / Non-Goals

**Goals:**
- 아바타 미등록 / 등록 완료 상태를 구분하여 적절한 버튼(등록/수정)을 표시한다
- 아바타 등록 가이드 페이지를 통해 사용자에게 올바른 촬영 방법을 안내한다
- Flutter `image_picker`를 통해 카메라 촬영 기능을 제공한다 (Android/iOS 공통)
- 촬영된 이미지를 `my_closet_server`(FastAPI)로 전송하고 아바타 결과를 수신·표시한다
- 서버에서 배경 제거 → LLM 아바타 생성 파이프라인을 구현하고 API 키를 서버 `.env`로 관리한다

**Non-Goals:**
- 소셜 로그인, 별도 인증 시스템 (기존 auth 유지)
- 아바타 스타일 커스터마이징 (1차 범위 외)
- 아바타 이미지 서버 영구 저장 (1차는 응답 URL/Base64 표시만)
- 실제 DB 연동 (1차는 Riverpod 인메모리 상태로 대체)

## Decisions

### 1. 백엔드 언어: Python + FastAPI

**결정**: Python FastAPI  
**이유**: AI/ML 라이브러리 생태계가 가장 풍부하고, `rembg`(배경 제거), `openai` SDK 등 핵심 패키지가 Python 우선 지원된다. 비동기 처리가 기본 지원되고 코드가 간결하여 유지보수가 쉽다.  
**대안 검토**:
- Node.js: AI 라이브러리 지원 미흡, 별도 Python 연동 필요
- Go: 성능은 우수하나 AI SDK 부재, 구현 복잡도 높음

### 2. 배경 제거 방식: 서버 사이드 `rembg` 라이브러리

**결정**: `rembg` (U2Net 모델 기반, 로컬 실행)  
**이유**: Remove.bg 등 외부 유료 API 대비 비용 없이 로컬 처리 가능. API 키 불필요.  
**대안 검토**: Remove.bg API — 편리하지만 유료, 별도 키 관리 필요  
**트레이드오프**: 최초 모델 다운로드(~170MB), 처리 시간 증가 (GPU 없는 환경에서 5-15초)

### 3. LLM 아바타 생성: OpenAI DALL-E 3

**결정**: OpenAI DALL-E 3 API (이미지 편집/생성)  
**이유**: 품질이 검증된 업계 표준, 간단한 REST API, Python SDK 지원  
**현재 상태**: API 키 미발급 — 플레이스홀더(`PLACEHOLDER_OPENAI_KEY`)로 구조만 구현, 실제 키 발급 후 `.env`에 설정  
**대안 검토**: Stable Diffusion 로컬 — 비용 없지만 GPU 필수, 운영 환경 설정 복잡

### 4. Flutter ↔ 서버 통신: multipart/form-data + HTTP

**결정**: Flutter `http` 패키지 (기존 사용 가능) + `image_picker` 패키지 신규 추가  
**이유**: `image_picker`는 Flutter 공식 팀이 관리하는 first-party 패키지로 Android/iOS 공통 지원 및 안정성이 검증됨  
**하네스 규칙 준수**: `image_picker` 패키지 추가 전 사용자 승인 필요 (본 설계에서 사전 명시)

### 5. 아바타 상태 관리: Riverpod `StateNotifierProvider`

**결정**: `avatarProvider` (StateNotifier, 인메모리)  
**이유**: 기존 프로젝트가 Riverpod을 사용 중이므로 일관성 유지. 1차에서 DB 연동 없이 앱 세션 내 상태만 유지  
**향후 확장**: 서버 API에서 아바타 URL을 응답받으면 Provider에 저장, 앱 재시작 시 SharedPreferences 또는 서버에서 조회

## Risks / Trade-offs

- **[리스크] 카메라 권한 거부** → 권한 거부 시 안내 다이얼로그 표시, 설정 앱으로 유도
- **[리스크] rembg 처리 시간 (CPU 환경 5-15초)** → 로딩 인디케이터 + 타임아웃(30초) 처리
- **[리스크] DALL-E 3 API 키 미발급 상태** → 플레이스홀더로 서버 구조만 구현, 키 발급 후 `.env`만 교체하면 즉시 동작
- **[리스크] 이미지 크기/형식 미검증** → 서버에서 5MB 이하, JPEG/PNG 형식 검증 후 거부
- **[트레이드오프] 인메모리 상태** → 앱 재시작 시 아바타 등록 여부 초기화. 1차 범위 외이므로 허용

## Migration Plan

1. `my_closet_server` 프로젝트 신규 생성 (기존 `my_closet` Flutter 프로젝트 무관)
2. Flutter `pubspec.yaml`에 `image_picker` 추가 (사용자 승인 후)
3. 기존 `avatar_page.dart` 수정 — 상태 분기 UI 추가 (기존 신체정보/스타일 섹션 유지)
4. `app_router.dart`에 `/home/avatar/guide` 라우트 추가
5. 서버 로컬 실행(`uvicorn`) → Flutter 앱에서 `http://localhost:8000` 호출로 통합 테스트

## Open Questions

- `image_picker` 패키지 추가 승인: **사용자 확인 필요** (본 proposal에서 사전 명시)
- 실제 OpenAI API 키 발급: 구현 완료 후 사용자에게 안내 예정
- 아바타 이미지 영구 저장 방식(S3, Firebase Storage 등): 2차 범위로 결정 필요


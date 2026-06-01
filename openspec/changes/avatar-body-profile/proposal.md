## Why

`avatar-setup`에서 구현한 아바타 생성 플로우는 이미지 생성까지만 처리한다. 생성된 아바타를 확인하고 신체 정보(키, 몸무게, 사이즈 등)를 함께 입력·저장하는 과정이 빠져 있으며, DB 영구 저장 없이 인메모리 상태만 유지되어 앱 재시작 시 모든 정보가 사라진다. 아바타 등록 완료 후 결과 확인 → 신체 정보 입력 → DB 저장 → 전체 프로필 조회 흐름을 완성해야 한다.

## What Changes

- 아바타 생성 완료 후 결과 확인 및 신체 정보 입력 페이지(`/home/avatar/result`) 신규 추가
- 신체 정보 입력 폼: 키, 몸무게, 상의 사이즈, 하의 사이즈, 신발 사이즈
- `my_closet_server`에 신체 정보 저장 API(`POST /api/avatar/profile`) 및 조회 API(`GET /api/avatar/profile`) 추가
- `my_closet_server`에 DB(SQLite) 연동 추가 — 아바타 이미지 URL + 신체 정보 영구 저장
- 아바타 삭제 API(`DELETE /api/avatar/profile`) 추가
- `/home/avatar` 페이지에 "아바타 수정" / "아바타 삭제" 버튼 및 전체 프로필 정보 표시로 변경
- **BREAKING**: `avatar-registration` spec의 등록 완료 후 버튼이 "아바타 수정" 단독 → "아바타 수정" + "아바타 삭제" 두 버튼으로 변경
- **BREAKING**: `avatar-state` spec의 Provider 상태 모델이 `hasAvatar`, `avatarImageUrl` 에서 `AvatarProfile`(이미지 URL + 신체 정보 포함) 구조로 확장

## Capabilities

### New Capabilities

- `avatar-result-page`: 아바타 생성 완료 후 결과 이미지 확인 + 신체 정보 입력 폼 표시 페이지 (`/home/avatar/result`)
- `avatar-body-persist`: `my_closet_server`의 신체 정보 저장/조회/삭제 API 및 SQLite DB 연동
- `avatar-delete`: 아바타 및 신체 정보 삭제 기능 (Flutter UI + 서버 API)

### Modified Capabilities

- `avatar-registration`: 등록 완료 후 버튼이 "아바타 수정" 단독 → "아바타 수정" + "아바타 삭제" 두 버튼으로 변경; `/home/avatar` 페이지에 신체 정보 전체 표시 추가
- `avatar-state`: `avatarProvider` 상태 모델이 `AvatarProfile`(avatarImageUrl, height, weight, topSize, bottomSize, shoeSize, hasAvatar) 구조로 확장; 앱 시작 시 서버에서 프로필 로드

## Impact

- **Flutter 앱**: `lib/pages/avatar/avatar_result_page.dart` 신규, `avatar_page.dart` 수정, `avatar_provider.dart` 상태 모델 확장, `avatar_api_service.dart` API 메서드 추가
- **my_closet_server**: `app/routers/avatar_router.py` 엔드포인트 추가, `app/services/avatar_service.py` DB 저장 로직 추가, `app/db/` 디렉터리 신규 (SQLite + SQLAlchemy)
- **의존성 추가**: 서버에 `sqlalchemy`, `aiosqlite` 추가 필요 (사용자 승인 필요)
- **기존 코드 영향**: `app_router.dart`에 `/home/avatar/result` 라우트 추가 (최소 범위)


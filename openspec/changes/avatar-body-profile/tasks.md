## 1. 백엔드 서버 — DB 의존성 추가

- [x] 1.1 `my_closet_server/requirements.txt`에 `sqlalchemy[asyncio]`, `aiosqlite` 추가 (사용자 승인 완료 전제)
- [x] 1.2 `app/db/` 디렉터리 생성 및 `app/db/__init__.py` 빈 파일 생성

## 2. 백엔드 서버 — DB 모델 및 초기화

- [x] 2.1 `app/db/database.py` 생성 — async SQLAlchemy 엔진, `AsyncSession` 팩토리, `Base` 선언
- [x] 2.2 `app/db/models.py` 생성 — `AvatarProfile` ORM 모델 (`id`, `user_id`, `avatar_url`, `height`, `weight`, `top_size`, `bottom_size`, `shoe_size`, `created_at`)
- [x] 2.3 `app/main.py` 수정 — 앱 시작 시 `create_all()`로 DB 테이블 자동 생성 (`on_event("startup")`)

## 3. 백엔드 서버 — 프로필 API 엔드포인트

- [x] 3.1 `app/models/avatar_models.py` 수정 — `AvatarProfileRequest`, `AvatarProfileResponse` Pydantic 스키마 추가 (키 범위 50-250, 몸무게 범위 10-300 validator 포함)
- [x] 3.2 `app/services/avatar_service.py` 수정 — `save_profile(session, data)` 메서드 추가 (upsert 로직)
- [x] 3.3 `app/services/avatar_service.py` 수정 — `get_profile(session)` 메서드 추가
- [x] 3.4 `app/services/avatar_service.py` 수정 — `delete_profile(session)` 메서드 추가
- [x] 3.5 `app/routers/avatar_router.py` 수정 — `POST /api/avatar/profile` 엔드포인트 추가 (입력 검증 → `save_profile` 호출 → 응답)
- [x] 3.6 `app/routers/avatar_router.py` 수정 — `GET /api/avatar/profile` 엔드포인트 추가 (`get_profile` 호출 → 없으면 HTTP 404)
- [x] 3.7 `app/routers/avatar_router.py` 수정 — `DELETE /api/avatar/profile` 엔드포인트 추가 (`delete_profile` 호출 → 없으면 HTTP 404)

## 4. Flutter — AvatarProfile 모델 및 Provider 확장

- [x] 4.1 `lib/providers/avatar_provider.dart` 수정 — `AvatarState` → `AvatarProfile` 데이터 클래스로 확장 (`avatarImageUrl`, `height`, `weight`, `topSize`, `bottomSize`, `shoeSize`, `hasAvatar` 필드)
- [x] 4.2 `lib/providers/avatar_provider.dart` 수정 — `AvatarNotifier`를 `AsyncNotifier`로 전환
- [x] 4.3 `lib/providers/avatar_provider.dart` 수정 — `build()` 메서드에서 `GET /api/avatar/profile` 호출 후 상태 초기화 (실패 시 `hasAvatar=false` 폴백)
- [x] 4.4 `lib/providers/avatar_provider.dart` 수정 — `updateProfile(AvatarProfile)` 메서드 추가
- [x] 4.5 `lib/providers/avatar_provider.dart` 수정 — `clearProfile()` 메서드 추가 (삭제 후 초기화용)

## 5. Flutter — 아바타 API 서비스 확장

- [x] 5.1 `lib/services/avatar_api_service.dart` 수정 — `saveProfile(AvatarProfile profile)` 메서드 추가 (`POST /api/avatar/profile` 호출)
- [x] 5.2 `lib/services/avatar_api_service.dart` 수정 — `fetchProfile()` 메서드 추가 (`GET /api/avatar/profile` 호출, 404 시 null 반환)
- [x] 5.3 `lib/services/avatar_api_service.dart` 수정 — `deleteProfile()` 메서드 추가 (`DELETE /api/avatar/profile` 호출)

## 6. Flutter — 아바타 결과 페이지 신규 생성

- [x] 6.1 `lib/pages/avatar/avatar_result_page.dart` 생성 — `ConsumerStatefulWidget` 기반 페이지 스캐폴드 생성
- [x] 6.2 `avatar_result_page.dart` — 페이지 상단에 전달받은 아바타 이미지 URL/Base64 표시 위젯 구현
- [x] 6.3 `avatar_result_page.dart` — 신체 정보 입력 폼 구현 (키, 몸무게, 상의 사이즈, 하의 사이즈, 신발 사이즈 `TextFormField`)
- [x] 6.4 `avatar_result_page.dart` — "저장" 버튼 구현: 로딩 상태 관리, `saveProfile()` 호출, 성공 시 `avatarProvider.updateProfile()` 후 `context.go('/home/avatar')`, 실패 시 스낵바 표시

## 7. Flutter — 아바타 메인 페이지 수정

- [x] 7.1 `lib/pages/avatar/avatar_page.dart` 수정 — `AsyncValue` 패턴으로 `avatarProvider` 상태 구독 (`loading`, `error`, `data` 분기)
- [x] 7.2 `avatar_page.dart` 수정 — `hasAvatar=true` 시 아바타 이미지 표시, 신체 정보 5종 목록 표시
- [x] 7.3 `avatar_page.dart` 수정 — `hasAvatar=true` 시 "아바타 수정" + "아바타 삭제" 두 버튼 표시
- [x] 7.4 `avatar_page.dart` 수정 — "아바타 삭제" 버튼 클릭 시 확인 다이얼로그 표시 구현 ("정말 삭제하시겠습니까?" + "취소"/"삭제" 버튼)
- [x] 7.5 `avatar_page.dart` 수정 — 삭제 확인 시 `deleteProfile()` 호출 → 성공 시 `avatarProvider.clearProfile()` 후 UI 갱신, 실패 시 스낵바 표시

## 8. Flutter — 라우터 및 가이드 페이지 연결 수정

- [x] 8.1 `lib/routes/app_router.dart` 수정 — `/home/avatar/result` 라우트 추가 (`AvatarResultPage` 연결, `extra` 파라미터로 아바타 URL 수신)
- [x] 8.2 `lib/pages/avatar/avatar_guide_page.dart` 수정 — 서버 아바타 생성 성공 후 `/home/avatar/guide`가 아닌 `/home/avatar/result`로 이동하도록 수정 (아바타 URL을 `extra`로 전달)

## 9. 통합 검증

- [x] 9.1 서버 재시작 후 DB 테이블 자동 생성 확인 (`my_closet_server.db` 파일 생성)
- [x] 9.2 `POST /api/avatar/profile` 동작 확인 (curl 또는 서버 로그)
- [x] 9.3 `GET /api/avatar/profile` 동작 확인 (저장 전 404, 저장 후 200)
- [x] 9.4 `DELETE /api/avatar/profile` 동작 확인
- [x] 9.5 Flutter — 아바타 등록 완료 후 결과 페이지 이동 및 신체 정보 입력 폼 표시 확인
- [x] 9.6 Flutter — "저장" 후 `/home/avatar` 페이지에서 신체 정보 + "아바타 수정"/"아바타 삭제" 버튼 표시 확인
- [x] 9.7 Flutter — 앱 재시작 후 서버에서 프로필 복원되어 아바타 등록 상태 유지 확인
- [x] 9.8 Flutter — "아바타 삭제" → 다이얼로그 확인 → 삭제 후 "아바타 등록" 버튼 상태로 초기화 확인
- [x] 9.9 `flutter analyze` 실행 — 경고/오류 없음 확인


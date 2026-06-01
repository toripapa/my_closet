## 1. 백엔드 서버 프로젝트 초기화 (my_closet_server)

- [x] 1.1 `/Users/1004787/Documents/WORK/mjkim_workspace/my_closet_server/` 디렉터리 생성 및 Python 가상환경 설정 (`python -m venv venv`)
- [x] 1.2 `requirements.txt` 작성 — `fastapi`, `uvicorn[standard]`, `python-multipart`, `rembg`, `openai`, `python-dotenv`, `pillow`
- [x] 1.3 `.env.example` 파일 생성 — `OPENAI_API_KEY=PLACEHOLDER_OPENAI_KEY`, `REMBG_MODEL=u2net` 등 필수 환경변수 문서화
- [x] 1.4 `.env` 파일 생성 (`.gitignore`에 추가) — 플레이스홀더 키로 초기 설정
- [x] 1.5 `README.md` 작성 — 로컬 실행 방법, 필요 API 키 목록, 발급처 안내 포함

## 2. 백엔드 서버 앱 구조 생성

- [x] 2.1 `app/main.py` 생성 — FastAPI 앱 초기화, CORS 설정, 환경변수 필수값 검증 (미설정 시 시작 거부)
- [x] 2.2 `app/routers/avatar_router.py` 생성 — `POST /api/avatar/generate` 라우터 (입력 검증, 응답 직렬화만 담당)
- [x] 2.3 `app/services/avatar_service.py` 생성 — `AvatarService` 클래스: 배경 제거(`rembg`) 로직 구현
- [x] 2.4 `app/services/avatar_service.py` 수정 — `AvatarService`에 LLM 아바타 생성(`openai` DALL-E 3) 로직 추가
- [x] 2.5 `app/models/avatar_models.py` 생성 — 요청/응답 Pydantic 스키마 정의 (`AvatarResponse`)
- [x] 2.6 파일 크기(5MB) 및 형식(JPEG/PNG) 검증 로직을 `avatar_router.py`에 추가

## 3. Flutter — 의존성 및 상태 관리

- [x] 3.1 `pubspec.yaml`에 `image_picker: ^1.1.2` 추가 (사용자 승인 완료 전제)
- [x] 3.2 `lib/providers/avatar_provider.dart` 생성 — `AvatarState` 모델 및 `AvatarNotifier` (`hasAvatar`, `avatarImageUrl` 상태 관리)
- [x] 3.3 `lib/core/config/env.dart` 수정 — 서버 베이스 URL 상수 추가 (`avatarServerBaseUrl`)

## 4. Flutter — 아바타 페이지 UI 수정

- [x] 4.1 `lib/pages/avatar/avatar_page.dart` 수정 — `StatelessWidget` → `ConsumerWidget`으로 전환, `avatarProvider` 구독
- [x] 4.2 `lib/pages/avatar/avatar_page.dart` 수정 — `hasAvatar` 상태에 따라 "아바타 등록" / "아바타 수정" 버튼 분기 렌더링
- [x] 4.3 `lib/pages/avatar/avatar_page.dart` 수정 — "아바타 등록" 버튼 클릭 시 `/home/avatar/guide`로 이동하는 `context.go()` 연결
- [x] 4.4 `lib/pages/avatar/avatar_page.dart` 수정 — 아바타 이미지 표시 영역에 `avatarImageUrl` 있을 경우 이미지 렌더링 추가

## 5. Flutter — 아바타 가이드 페이지 신규 생성

- [x] 5.1 `lib/pages/avatar/avatar_guide_page.dart` 생성 — 가이드 UI 구성 (안내 문구 2개, "확인" 버튼)
- [x] 5.2 `avatar_guide_page.dart` — "본인 전체 모습을 카메라로 촬영 해주세요" 문구 적용
- [x] 5.3 `avatar_guide_page.dart` — "정면에서 정확하게 찍어야 아바타 생성이 잘 됩니다" 문구 적용
- [x] 5.4 `avatar_guide_page.dart` — "확인" 버튼 클릭 시 `image_picker` 카메라 실행 호출 연결

## 6. Flutter — 카메라 촬영 및 서버 연동

- [x] 6.1 `lib/pages/avatar/avatar_guide_page.dart` — `ImagePicker().pickImage(source: ImageSource.camera)` 호출 구현
- [x] 6.2 `lib/pages/avatar/avatar_guide_page.dart` — 카메라 권한 거부 시 안내 다이얼로그 표시 처리
- [x] 6.3 `lib/pages/avatar/avatar_guide_page.dart` — 카메라 취소 시 현재 페이지(가이드) 유지 처리
- [x] 6.4 `lib/services/avatar_api_service.dart` 생성 — `uploadImageForAvatar(File image)` 함수: multipart/form-data로 서버 `POST /api/avatar/generate` 호출
- [x] 6.5 `avatar_guide_page.dart` — 촬영 완료 후 로딩 인디케이터 표시 및 `avatar_api_service.dart` 호출 연동
- [x] 6.6 `avatar_guide_page.dart` — 서버 응답 성공 시 `avatarProvider` 상태 업데이트 후 `/home/avatar`로 이동
- [x] 6.7 `avatar_guide_page.dart` — 서버 응답 실패 시 오류 스낵바 표시 후 아바타 페이지로 이동

## 7. Flutter — 라우터 등록

- [x] 7.1 `lib/routes/app_router.dart` 수정 — `/home/avatar/guide` 라우트 추가 (`AvatarGuidePage` 연결)
- [x] 7.2 `lib/pages/all_dummy_pages.dart` 수정 — `AvatarGuidePage` 임포트 등록 (필요 시)

## 8. iOS/Android 권한 설정

- [x] 8.1 `ios/Runner/Info.plist` — `NSCameraUsageDescription` 키 추가 (카메라 권한 안내 문구)
- [x] 8.2 `android/app/src/main/AndroidManifest.xml` — `CAMERA` 권한 선언 추가

## 9. 통합 검증

- [x] 9.1 서버 로컬 실행 확인 (`uvicorn app.main:app --reload --port 8000`)
- [x] 9.2 Flutter Web에서 아바타 페이지 진입 → "아바타 등록" 버튼 표시 확인
- [x] 9.3 "아바타 등록" 클릭 → 가이드 페이지 이동 확인
- [x] 9.4 가이드 페이지 문구 2개 표시 확인
- [x] 9.5 "확인" 버튼 클릭 → 카메라 실행 확인 (모바일 에뮬레이터 또는 실기기)
- [x] 9.6 촬영 후 서버 API 호출 → 플레이스홀더 응답 수신 확인
- [x] 9.7 아바타 등록 완료 후 "아바타 수정" 버튼으로 전환 확인
- [x] 9.8 `flutter analyze` 실행 — 경고/오류 없음 확인

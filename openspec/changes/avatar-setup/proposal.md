## Why

현재 `/home/avatar` 페이지는 UI만 존재하고 실제 아바타 등록·관리 기능이 없어 사용자가 자신의 아바타를 만들 수 없다. 사진 한 장으로 본인의 디지털 아바타를 생성하는 핵심 기능을 제공하여 앱의 핵심 가치(내 옷장을 아바타로 코디)를 실현해야 한다.

## What Changes

- `/home/avatar` 페이지에 아바타 등록/수정 상태에 따른 분기 UI 추가
- 아바타 미등록 시 "아바타 등록" 버튼 노출, 등록 완료 시 "아바타 수정" 버튼으로 전환
- 아바타 등록 가이드 페이지(`/home/avatar/guide`) 신규 추가
- 카메라 촬영 기능 연동 (Flutter `image_picker` 패키지 사용 승인 필요)
- `my_closet_server` 신규 백엔드 서버 프로젝트 생성 (FastAPI, Python)
- 서버에서 배경 제거(누끼) + LLM 기반 아바타 생성 API 구현
- Flutter 앱 → 서버 이미지 업로드 및 아바타 결과 수신 연동

## Capabilities

### New Capabilities

- `avatar-registration`: 아바타 미등록 상태에서 "아바타 등록" 버튼을 통해 가이드 → 카메라 → 서버 업로드 → 아바타 생성 결과 표시까지의 전체 등록 플로우
- `avatar-guide`: 카메라 촬영 전 가이드 안내 페이지 (문구, 확인 버튼, 카메라 앱 실행)
- `avatar-camera`: 카메라 촬영 및 이미지 선택 기능 (image_picker 활용)
- `avatar-server`: `my_closet_server` FastAPI 백엔드 — 이미지 수신, 배경 제거, LLM 아바타 생성, 결과 반환 API
- `avatar-state`: 사용자별 아바타 등록 여부 상태 관리 (Riverpod Provider)

### Modified Capabilities

_(기존 스펙 변경 없음)_

## Impact

- **Flutter 앱**: `lib/pages/avatar/` 하위 파일 추가, `lib/providers/avatar_provider.dart` 신규, `pubspec.yaml`에 `image_picker` 패키지 추가 필요 (승인 필요)
- **신규 서버 프로젝트**: `/Users/1004787/Documents/WORK/mjkim_workspace/my_closet_server/` 생성 (FastAPI + Python)
- **외부 API 의존**: 배경 제거 API(Remove.bg 또는 동등 서비스), LLM 이미지 생성 API(OpenAI DALL-E 또는 동등 서비스) — API 키는 서버 `.env`로 관리, 현재는 플레이스홀더 사용
- **기존 코드 영향**: `go_router` 라우트에 `/home/avatar/guide` 경로 추가 필요 (최소 범위 수정)


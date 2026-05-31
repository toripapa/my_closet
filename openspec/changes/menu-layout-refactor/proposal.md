## Why

현재 앱의 상단 메뉴가 AppBar 우측(actions)에 배치되어 타이틀과 분리된 느낌을 주며, 메뉴바와 서브메뉴 영역이 흰색 배경으로 메인 콘텐츠 영역과 구분되지 않아 시각적 계층이 불명확합니다. 또한 서브메뉴가 없는 1단계 메뉴(예: 내 아바타, 커뮤니티) 클릭 시 즉시 본문이 전환되지 않는 UX 문제가 있습니다.

## What Changes

- **메뉴 정렬 변경**: 상단 AppBar에서 우측(actions)에 배치된 1단계 메뉴 버튼들을 타이틀 옆(좌측)으로 이동하여 좌측 정렬로 구성합니다.
- **영역 배경색 변경**: TopMenuBar와 SideMenuPanel의 배경색을 다크 계열(예: #1A1A2E 또는 #212121)로 변경하여 흰색 메인 콘텐츠 영역과 명확히 구분합니다.
- **서브메뉴 라우팅 확인**: 서브메뉴 클릭 시 본문 영역이 해당 페이지로 동적 전환되도록 라우팅을 확인 및 보완합니다.
- **단독 메뉴 즉시 이동**: 서브메뉴가 없는 1단계 메뉴(홈, 내 아바타, 커뮤니티) 클릭 시 즉시 본문이 해당 페이지로 전환되도록 예외 처리를 추가합니다.

## Capabilities

### New Capabilities

- `top-menu-alignment`: 상단 메뉴 버튼을 타이틀 우측(Row 좌측 정렬)에 배치하는 레이아웃 구조
- `dark-menu-theme`: TopMenuBar와 SideMenuPanel에 다크 배경/라이트 텍스트 스타일 적용
- `direct-route-on-leaf-menu`: 서브메뉴 없는 1단계 메뉴 클릭 시 즉시 본문 라우팅 처리

### Modified Capabilities

- `global-layout`: TopMenuBar 메뉴 정렬 구조 변경 (actions → title 영역 Row 배치)
- `menu-navigation`: 단독 메뉴 클릭 시 즉시 라우팅 예외 처리 추가

## Impact

- `lib/pages/layout/app_layout.dart`: TopMenuBar 위젯 구조 변경 (Row 레이아웃, 다크 스타일), SideMenuPanel 배경색 변경
- `lib/theme/app_theme.dart`: 다크 메뉴 색상 상수 추가 (AppColors)
- `lib/routes/app_router.dart`: 단독 메뉴 라우팅 경로 확인 (변경 불필요 또는 소폭 수정)
- 기존 페이지 파일 변경 없음 — 레이아웃/스타일/라우팅 레이어만 수정


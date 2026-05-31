## Why

상단 메뉴바(TopMenuBar)와 좌측 서브메뉴 패널(SideMenuPanel)이 동일한 배경색(`#1A1A2E`)을 사용하여 두 영역이 시각적으로 구분되지 않는 문제가 있습니다. 또한 현재 서브메뉴 항목을 클릭해도 중앙 콘텐츠 영역이 해당 페이지로 전환되지 않는 라우팅 문제가 있어, 사용자가 메뉴를 클릭해도 화면이 바뀌지 않는 UX 결함이 발생합니다.

## What Changes

- **상단/좌측 영역 색상 구분**: SideMenuPanel 배경색을 TopMenuBar와 구별되는 별도 색상(`sideBackground`)으로 변경하고, AppBar 하단에 구분 경계선을 추가합니다.
- **라우팅 정비 — menuMap 경로 통일**: `menuMap`의 서브메뉴 `route` 값을 GoRouter에 등록된 경로와 완전히 일치하도록 정비합니다. (예: `/wardrobe/all` → `app_router`의 `/home/wardrobe/all`과 매핑)
- **SideMenuPanel 라우팅 수정**: 서브메뉴 `onTap` 시 `context.go`가 올바른 전체 경로로 이동하도록 수정합니다.
- **1단계 단독 메뉴 라우팅 확인**: 서브메뉴 없는 메뉴(홈, 내 아바타, 커뮤니티)도 클릭 시 즉시 해당 페이지로 이동함을 보장합니다.
- **selectedMenuProvider 라우트 동기화**: URL 변경 시 `selectedMenuProvider`가 현재 경로를 기준으로 동기화되도록 GoRouter의 `redirect`/`routerDelegate`에서 메뉴 상태를 갱신합니다.

## Capabilities

### New Capabilities

- `menu-area-visual-distinction`: 상단 메뉴바와 좌측 서브메뉴 패널의 배경색을 다르게 하여 시각적 경계 구분
- `leaf-menu-routing`: 가장 하위(leaf) 메뉴 클릭 시 중앙 콘텐츠 영역이 해당 라우트의 페이지로 동적 전환

### Modified Capabilities

(없음 — 기존 스펙 변경 없음, 신규 기능 추가)

## Impact

- `lib/theme/app_theme.dart`: `AppColors.sideBackground` 색상 상수 추가
- `lib/pages/layout/app_layout.dart`: SideMenuPanel 배경색 변경, AppBar 하단 구분선 추가, SideMenuPanel `onTap` 라우팅 경로 수정
- `lib/models/menu_model.dart`: 서브메뉴 `route` 값이 GoRouter 경로와 일치하는지 확인 및 정비
- `lib/routes/app_router.dart`: 모든 leaf 라우트가 등록되어 있는지 검증 (현재 등록된 경로 유지)
- 기타 페이지 파일 변경 없음


## Why

이전 버그픽스(leaf-menu-routing-fix)에서 `selectedLeafRouteProvider`로 위젯만 교체하는 방식을 도입했으나, 이로 인해 GoRouter 실제 라우팅이 동작하지 않아 URL이 `/home/dashboard`에 고정됩니다. 또한 모든 페이지가 텍스트 한 줄만 표시하는 더미 상태로, 사용자가 화면 전환을 인지할 수 없습니다.

## What Changes

- **라우팅 복원**: `AppLayout`을 `widget.child`(GoRouter ShellRoute의 Navigator) 기반으로 복원하여 실제 URL 네비게이션이 동작하도록 합니다.
- **`selectedLeafRouteProvider` 제거**: 위젯 교체 방식 제거, GoRouter 네이티브 라우팅으로 완전 대체
- **각 라우트별 전용 페이지 구현**: 12개 라우트에 대해 각각 시각적으로 구분되는 의미 있는 페이지 레이아웃 구현
- **pages 폴더 구조 정리**: 각 섹션별 페이지 파일을 전용 폴더(`dashboard/`, `avatar/`, `wardrobe/`, `house/`, `weather/`, `community/`, `settings/`)로 분리

## Capabilities

### New Capabilities

- `section-pages`: 각 라우트별 시각적으로 구분되는 전용 페이지 레이아웃 (대시보드, 아바타, 옷장, 집, 날씨, 커뮤니티, 설정)

### Modified Capabilities

- `global-layout`: `AppLayout`을 GoRouter `child`(Navigator) 기반으로 복원
- `leaf-menu-routing`: `selectedLeafRouteProvider` 제거 후 GoRouter 네이티브 라우팅으로 대체

## Impact

- `lib/pages/layout/app_layout.dart`: `AppLayout(child:)` 복원, `selectedLeafRouteProvider` 의존성 제거
- `lib/routes/app_router.dart`: `AppLayout(child: child)` 복원
- `lib/providers/menu_provider.dart`: `selectedLeafRouteProvider`, `LeafRouteNotifier`, `buildPageForRoute` 제거
- `lib/pages/dashboard/dashboard_page.dart` 신규
- `lib/pages/avatar/avatar_page.dart` 신규
- `lib/pages/wardrobe/wardrobe_all_page.dart`, `wardrobe_recent_page.dart`, `wardrobe_manage_page.dart` 신규
- `lib/pages/house/house_structure_page.dart`, `house_furniture_page.dart` 신규
- `lib/pages/weather/weather_today_page.dart`, `weather_week_page.dart` 신규
- `lib/pages/community/community_page.dart` 신규
- `lib/pages/settings/settings_profile_page.dart`, `settings_notification_page.dart` 신규
- `lib/pages/all_dummy_pages.dart` 각 파일로 분리 후 re-export로 교체


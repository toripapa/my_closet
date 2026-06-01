## Why

GoRouter 17.x의 `ShellRoute`에서 `builder`의 `child` 파라미터(내부 Navigator)는 leaf 라우트가 변경되어도 `AppLayout`의 rebuild를 보장하지 않습니다. 결과적으로 좌측 서브메뉴(leaf 메뉴)를 클릭해도 중앙 본문 영역이 해당 페이지로 전환되지 않는 버그가 발생합니다.

## What Changes

- **`selectedLeafRouteProvider` 신규 추가**: 현재 본문에 표시할 leaf 라우트 경로를 Riverpod 상태로 직접 관리합니다.
- **`AppLayout` 본문 렌더링 방식 변경**: `widget.child`(GoRouter Navigator) 대신 `selectedLeafRouteProvider`를 watch하여 해당 라우트의 페이지 위젯을 직접 렌더링합니다.
- **`SideMenuPanel.onTap` 수정**: `context.go()` 외에 `selectedLeafRouteProvider`도 함께 업데이트합니다.
- **`TopMenuBar` 버튼 수정**: 1단계 메뉴 클릭 시 `selectedLeafRouteProvider`를 기본 라우트로 업데이트합니다.
- **`didChangeDependencies` 동기화 확장**: URL 변경(딥링크 등) 시 `selectedLeafRouteProvider`도 함께 동기화합니다.

## Capabilities

### New Capabilities

- `provider-driven-content`: GoRouter Navigator에 의존하지 않고 Riverpod 상태(`selectedLeafRouteProvider`)로 본문 페이지를 결정하는 렌더링 구조

### Modified Capabilities

(없음 — 기존 라우팅 스펙 변경 없음, 렌더링 구현 방식만 교체)

## Impact

- `lib/providers/menu_provider.dart`: `selectedLeafRouteProvider` 추가 및 라우트→페이지 위젯 매핑 헬퍼
- `lib/pages/layout/app_layout.dart`: `AppLayout` 본문 렌더링을 provider 기반으로 교체, SideMenuPanel onTap 수정, TopMenuBar 버튼 수정, didChangeDependencies 동기화 확장
- `lib/routes/app_router.dart`: ShellRoute 구조 유지, AppLayout의 `child` 파라미터 제거 가능 (ShellRoute는 auth guard 목적으로 유지)
- 페이지 파일(`all_dummy_pages.dart`) 변경 없음


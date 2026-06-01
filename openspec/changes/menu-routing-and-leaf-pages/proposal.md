## Why

각 상단/사이드 메뉴 클릭 시 설정된 route 주소로 이동해야 하며, leaf 메뉴에 해당하는 실제 페이지 컨텐츠가 표시되어야 합니다. 기존 `all_dummy_pages.dart`에 인라인 더미 클래스와 동명의 실제 페이지 export가 동시에 존재해 컴파일 충돌이 발생하고 있었고, 사이드 메뉴의 활성 항목 표시가 누락되어 있었습니다.

## What Changes

- `all_dummy_pages.dart`에서 중복 인라인 더미 클래스 제거 → export-only 파일로 전환
- `app_layout.dart`의 `SideMenuPanel`에 현재 URL 기반 활성 항목 하이라이팅 추가
- 각 leaf 메뉴 route(`/home/wardrobe/all`, `/home/wardrobe/recent`, 등)는 이미 구현된 실제 페이지 클래스와 연결 확인

## Capabilities

### New Capabilities

- `menu-active-highlight`: 사이드 메뉴에서 현재 활성 route에 해당하는 항목을 시각적으로 강조 표시하는 기능

### Modified Capabilities

- `menu-routing`: 기존 메뉴 클릭 시 route 이동은 구현되어 있었으나, 더미 클래스 충돌로 실제 페이지가 렌더링되지 않던 문제를 수정

## Impact

- `lib/pages/all_dummy_pages.dart`: 인라인 더미 클래스 전체 제거, export 구문만 유지
- `lib/pages/layout/app_layout.dart`: `SideMenuPanel.build`에 `GoRouterState.of(context).uri` 기반 활성 상태 비교 로직 추가
- 기타 파일 영향 없음 (라우터, 실제 페이지 파일 변경 없음)


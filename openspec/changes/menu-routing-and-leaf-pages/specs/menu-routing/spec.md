## MODIFIED Requirements

### Requirement: 메뉴 클릭 시 라우트 이동
메뉴 항목 클릭 시 해당 MenuItem의 route 값으로 `context.go(route)`를 호출하여 GoRouter 기반 페이지 이동이 이루어져야 합니다(SHALL). `all_dummy_pages.dart`는 중복 인라인 클래스 없이 실제 페이지 파일의 export 구문만 포함해야 합니다.

#### Scenario: 상단 메뉴 클릭 시 첫 번째 서브 페이지로 이동
- **WHEN** 사용자가 상단 메뉴의 "내 옷장"을 클릭할 때
- **THEN** GoRouter가 `/home/wardrobe/all`로 이동하고 `WardrobeAllPage`가 렌더링되어야 함

#### Scenario: 서브 메뉴 클릭 시 해당 leaf 페이지로 이동
- **WHEN** 사용자가 사이드 메뉴의 "관리 필요"를 클릭할 때
- **THEN** GoRouter가 `/home/wardrobe/manage`로 이동하고 `WardrobeManagePage`가 렌더링되어야 함

#### Scenario: 컴파일 충돌 없이 정상 빌드
- **WHEN** 앱을 빌드할 때
- **THEN** `all_dummy_pages.dart`의 export로 인한 ambiguous 에러 없이 빌드가 성공해야 함


## ADDED Requirements

### Requirement: 메뉴의 가장 하위(leaf) 항목 클릭 시 중앙 콘텐츠 영역이 해당 페이지로 전환된다
서브메뉴가 있는 1단계 메뉴(내 옷장, 나의 집, 날씨, 설정)의 서브메뉴 항목을 클릭하면 중앙 콘텐츠 영역이 해당 페이지로 즉시 전환되어야 한다. 서브메뉴가 없는 1단계 메뉴(홈, 내 아바타, 커뮤니티)는 클릭 즉시 해당 페이지로 전환된다.

#### Scenario: 초기 진입 시 대시보드 페이지가 표시된다
- **WHEN** 사용자가 로그인에 성공한다
- **THEN** 중앙 콘텐츠 영역에 대시보드 페이지(`/home/dashboard`)가 표시된다

#### Scenario: '내 아바타' 클릭 시 즉시 아바타 페이지로 전환된다
- **WHEN** 사용자가 상단 메뉴에서 '내 아바타'를 클릭한다
- **THEN** 중앙 콘텐츠 영역이 아바타 페이지(`/home/avatar`)로 전환된다

#### Scenario: '날씨' → '오늘의 날씨' 클릭 시 날씨 페이지로 전환된다
- **WHEN** 사용자가 상단 '날씨' 메뉴를 클릭하고 좌측 서브메뉴에서 '오늘의 날씨'를 클릭한다
- **THEN** 중앙 콘텐츠 영역이 오늘의 날씨 페이지(`/home/weather/today`)로 전환된다

#### Scenario: '날씨' → '이번주 날씨' 클릭 시 이번주 날씨 페이지로 전환된다
- **WHEN** 사용자가 좌측 서브메뉴에서 '이번주 날씨'를 클릭한다
- **THEN** 중앙 콘텐츠 영역이 이번주 날씨 페이지(`/home/weather/week`)로 전환된다

#### Scenario: '내 옷장' → '전체' 클릭 시 전체 옷장 페이지로 전환된다
- **WHEN** 사용자가 상단 '내 옷장' 메뉴 후 좌측 '전체'를 클릭한다
- **THEN** 중앙 콘텐츠 영역이 전체 옷장 페이지(`/home/wardrobe/all`)로 전환된다

#### Scenario: '설정' → '회원정보' 클릭 시 회원정보 페이지로 전환된다
- **WHEN** 사용자가 상단 '설정' 메뉴 후 좌측 '회원정보'를 클릭한다
- **THEN** 중앙 콘텐츠 영역이 회원정보 설정 페이지(`/home/settings/profile`)로 전환된다

### Requirement: menuMap의 route 값은 GoRouter에 등록된 전체 경로와 동일해야 한다
`menuMap`에 정의된 각 서브메뉴의 `route` 필드는 `/home/` 접두사를 포함한 GoRouter 전체 경로 형식이어야 한다. `SideMenuPanel.onTap`은 `item.route` 값을 그대로 `context.go()`에 전달한다.

#### Scenario: 서브메뉴 route가 전체 경로 형식임을 확인한다
- **WHEN** `menuMap`의 서브메뉴 항목 route를 조회한다
- **THEN** 모든 route 값이 `/home/`으로 시작하는 전체 경로 형식이다 (예: `/home/weather/today`, `/home/wardrobe/all`)

### Requirement: URL 이동 시 selectedMenuProvider 상태가 현재 경로와 동기화된다
사용자가 직접 URL을 변경하거나 서브메뉴를 클릭해 이동했을 때, `selectedMenuProvider`는 현재 URL이 속한 1단계 메뉴 키를 반영해야 한다.

#### Scenario: '/home/weather/today'로 이동 시 selectedMenu가 'weather'로 갱신된다
- **WHEN** 라우터가 `/home/weather/today`로 이동한다
- **THEN** `selectedMenuProvider`의 값이 `'weather'`로 갱신되어 상단 메뉴에서 '날씨'가 선택 상태로 표시된다

#### Scenario: '/home/avatar'로 이동 시 selectedMenu가 'avatar'로 갱신된다
- **WHEN** 라우터가 `/home/avatar`로 이동한다
- **THEN** `selectedMenuProvider`의 값이 `'avatar'`로 갱신되어 상단 메뉴에서 '내 아바타'가 선택 상태로 표시된다


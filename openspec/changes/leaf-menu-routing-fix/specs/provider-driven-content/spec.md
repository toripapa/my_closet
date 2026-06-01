## ADDED Requirements

### Requirement: selectedLeafRouteProvider가 현재 본문 페이지 경로를 추적한다
`selectedLeafRouteProvider`(StateProvider<String>)는 초기값 `/home/dashboard`를 가지며, 상단 메뉴 또는 서브메뉴 클릭 시 해당 leaf 경로로 업데이트되어야 한다.

#### Scenario: 초기 진입 시 대시보드 경로가 설정된다
- **WHEN** 앱이 로그인 후 메인 레이아웃에 진입한다
- **THEN** `selectedLeafRouteProvider` 값이 `/home/dashboard`이고 본문에 DashboardPage가 표시된다

#### Scenario: 서브메뉴 클릭 시 provider가 해당 경로로 업데이트된다
- **WHEN** 사용자가 좌측 서브메뉴에서 '오늘의 날씨'를 클릭한다
- **THEN** `selectedLeafRouteProvider` 값이 `/home/weather/today`로 변경된다

### Requirement: 서브메뉴(leaf) 클릭 시 본문 영역이 해당 페이지로 즉시 전환된다
`SideMenuPanel`의 `onTap`은 `selectedLeafRouteProvider`를 업데이트하고 `context.go()`로 URL도 함께 변경해야 한다. 본문 영역은 provider 변경에 반응하여 즉시 해당 페이지 위젯을 렌더링해야 한다.

#### Scenario: '날씨' → '이번주 날씨' 클릭 시 WeatherWeekPage가 표시된다
- **WHEN** 사용자가 '날씨' 메뉴 선택 후 '이번주 날씨'를 클릭한다
- **THEN** 본문 영역이 WeatherWeekPage로 즉시 전환된다

#### Scenario: '내 옷장' → '관리 필요' 클릭 시 WardrobeManagePage가 표시된다
- **WHEN** 사용자가 '내 옷장' 선택 후 '관리 필요'를 클릭한다
- **THEN** 본문 영역이 WardrobeManagePage로 즉시 전환된다

### Requirement: 상단 메뉴 클릭 시 해당 기본 페이지로 본문이 전환된다
상단 1단계 메뉴 클릭 시 `selectedLeafRouteProvider`가 해당 메뉴의 기본 경로로 업데이트되어 본문이 즉시 전환되어야 한다.

#### Scenario: '내 아바타' 클릭 시 AvatarPage가 표시된다
- **WHEN** 사용자가 상단 메뉴에서 '내 아바타'를 클릭한다
- **THEN** 본문 영역이 AvatarPage로 즉시 전환된다

#### Scenario: '홈' 클릭 시 DashboardPage가 표시된다
- **WHEN** 사용자가 상단 메뉴에서 '홈'을 클릭한다
- **THEN** 본문 영역이 DashboardPage로 즉시 전환된다

### Requirement: URL 변경(딥링크) 시 본문 페이지가 URL과 동기화된다
`didChangeDependencies`에서 GoRouterState URL을 감지하여 `selectedLeafRouteProvider`를 동기화해야 한다.

#### Scenario: 브라우저에서 /home/settings/profile URL 진입 시 SettingsProfilePage가 표시된다
- **WHEN** 사용자가 브라우저에서 `/home/settings/profile`로 직접 진입한다
- **THEN** 본문 영역이 SettingsProfilePage를 표시하고 '설정' 상단 메뉴가 선택 상태로 표시된다


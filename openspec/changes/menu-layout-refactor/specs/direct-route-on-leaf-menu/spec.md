## ADDED Requirements

### Requirement: 서브메뉴가 없는 1단계 메뉴는 클릭 시 즉시 본문 페이지로 이동한다
menuMap에서 서브메뉴가 null인 1단계 메뉴(홈, 내 아바타, 커뮤니티)를 클릭하면, SideMenuPanel 갱신 없이 즉시 해당 메뉴의 기본 라우트로 본문 영역이 전환되어야 한다.

#### Scenario: '내 아바타' 메뉴 클릭 시 즉시 아바타 페이지로 이동한다
- **WHEN** 사용자가 상단 메뉴에서 '내 아바타'를 클릭한다
- **THEN** 좌측 서브메뉴 패널 없이 본문 영역이 AvatarPage로 즉시 전환된다

#### Scenario: '커뮤니티' 메뉴 클릭 시 즉시 커뮤니티 페이지로 이동한다
- **WHEN** 사용자가 상단 메뉴에서 '커뮤니티'를 클릭한다
- **THEN** 좌측 서브메뉴 패널 없이 본문 영역이 CommunityPage로 즉시 전환된다

#### Scenario: '홈' 메뉴 클릭 시 즉시 대시보드 페이지로 이동한다
- **WHEN** 사용자가 상단 메뉴에서 '홈'을 클릭한다
- **THEN** 본문 영역이 DashboardPage로 즉시 전환되고, 이전에 표시되던 서브메뉴 패널이 숨겨진다

### Requirement: 서브메뉴가 있는 1단계 메뉴는 클릭 시 첫 번째 서브메뉴 페이지로 이동하고 SideMenuPanel을 표시한다
menuMap에서 서브메뉴가 있는 메뉴(내 옷장, 나의 집, 날씨, 설정)를 클릭하면 해당 메뉴의 첫 번째 서브메뉴 라우트로 이동하고, SideMenuPanel에 서브메뉴 목록이 표시되어야 한다.

#### Scenario: '내 옷장' 메뉴 클릭 시 첫 서브메뉴와 SideMenuPanel이 표시된다
- **WHEN** 사용자가 상단 메뉴에서 '내 옷장'을 클릭한다
- **THEN** 본문 영역이 WardrobeAllPage로 이동하고, 좌측에 '전체', '최근 등록', '관리 필요' 서브메뉴 패널이 표시된다

#### Scenario: SideMenuPanel의 서브메뉴 클릭 시 해당 페이지로 이동한다
- **WHEN** 사용자가 SideMenuPanel에서 '오늘의 날씨'를 클릭한다
- **THEN** 본문 영역이 WeatherTodayPage로 전환된다


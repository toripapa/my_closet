## ADDED Requirements

### Requirement: 상단 메뉴바와 좌측 서브메뉴 패널은 서로 다른 배경색을 사용한다
TopMenuBar(AppBar)의 배경색(`#1A1A2E`)과 SideMenuPanel의 배경색(`#16213E`)은 서로 달라야 하며, AppBar 하단에 1px 구분선이 표시되어야 한다.

#### Scenario: 메인 레이아웃 진입 시 상단/좌측 영역이 색상으로 구분된다
- **WHEN** 사용자가 로그인하여 메인 레이아웃에 진입한다
- **THEN** 상단 AppBar는 `#1A1A2E` 배경으로, 좌측 SideMenuPanel(서브메뉴가 있을 때)은 `#16213E` 배경으로 표시되어 두 영역이 시각적으로 구분된다

#### Scenario: AppBar 하단에 구분선이 표시된다
- **WHEN** 상단 메뉴바가 렌더링된다
- **THEN** AppBar 하단에 1px 두께의 구분선(`#2D2D44`)이 표시되어 AppBar와 본문 영역(body)의 경계가 명확히 보인다


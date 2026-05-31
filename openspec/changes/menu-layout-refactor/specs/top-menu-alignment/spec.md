## ADDED Requirements

### Requirement: 상단 메뉴 버튼을 타이틀 옆(좌측)에 배치한다
TopMenuBar는 앱 타이틀과 1단계 메뉴 버튼을 하나의 Row로 구성하여 AppBar의 title 영역에 배치해야 한다. 메뉴 버튼들은 타이틀 우측에 수평으로 나열되며, 로그아웃 버튼은 AppBar의 actions 영역(우측 끝)에 유지된다.

#### Scenario: 앱 실행 시 상단 메뉴 버튼이 타이틀 옆에 표시된다
- **WHEN** 사용자가 로그인하여 메인 레이아웃에 진입한다
- **THEN** AppBar에 타이틀('My Smart Closet')이 표시되고, 그 우측에 홈·내 아바타·내 옷장·나의 집·날씨·커뮤니티·설정 버튼이 수평으로 배치된다

#### Scenario: 로그아웃 버튼은 항상 AppBar 우측 끝에 위치한다
- **WHEN** 상단 메뉴가 렌더링된다
- **THEN** 로그아웃 아이콘 버튼은 AppBar의 actions 영역(가장 우측)에 표시된다


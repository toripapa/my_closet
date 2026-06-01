## ADDED Requirements

### Requirement: 각 라우트는 시각적으로 구분되는 전용 페이지를 렌더링한다
12개 leaf 라우트 각각에 대해 해당 섹션의 기능을 반영하는 전용 페이지가 존재해야 한다.

#### Scenario: /home/dashboard 진입 시 대시보드 페이지가 표시된다
- **WHEN** 사용자가 상단 '홈' 메뉴를 클릭한다
- **THEN** 통계 카드와 환영 메시지가 포함된 대시보드 페이지가 렌더링된다

#### Scenario: /home/weather/today와 /home/weather/week는 시각적으로 다르다
- **WHEN** 사용자가 '오늘의 날씨'와 '이번주 날씨'를 번갈아 클릭한다
- **THEN** 각각 다른 레이아웃과 콘텐츠를 가진 별도 페이지가 표시된다

### Requirement: leaf 메뉴 클릭 시 실제 URL이 해당 라우트로 변경된다
SideMenuPanel 또는 TopMenuBar 클릭 시 브라우저 URL이 해당 라우트 경로로 변경되어야 한다.

#### Scenario: '이번주 날씨' 클릭 시 URL이 /home/weather/week로 변경된다
- **WHEN** 사용자가 좌측 서브메뉴에서 '이번주 날씨'를 클릭한다
- **THEN** 브라우저 URL이 `#/home/weather/week`로 변경되고 WeatherWeekPage가 표시된다


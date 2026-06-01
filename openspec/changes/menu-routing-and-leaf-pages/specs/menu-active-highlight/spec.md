## ADDED Requirements

### Requirement: 사이드 메뉴 활성 항목 강조 표시
SideMenuPanel은 현재 URL(`GoRouterState.of(context).uri`)과 각 MenuItem의 route 값을 비교하여, 일치하는 항목을 시각적으로 강조 표시해야 합니다(SHALL). 강조 스타일은 배경색 `menuSelected`, 텍스트 색 흰색, 폰트 굵기 w600을 적용합니다.

#### Scenario: 현재 URL과 일치하는 서브메뉴 항목 강조
- **WHEN** 사용자가 `/home/wardrobe/all` 경로에 있을 때
- **THEN** 사이드 메뉴의 "전체" 항목이 `menuSelected` 배경과 흰색 텍스트로 강조 표시되어야 함

#### Scenario: 일치하지 않는 항목은 기본 스타일 유지
- **WHEN** 사용자가 `/home/wardrobe/all` 경로에 있을 때
- **THEN** "최근 등록", "관리 필요" 항목은 기본 텍스트 색과 투명 배경을 유지해야 함

#### Scenario: 페이지 이동 후 강조 상태 업데이트
- **WHEN** 사용자가 사이드 메뉴의 "최근 등록"을 클릭하여 `/home/wardrobe/recent`로 이동할 때
- **THEN** "최근 등록" 항목이 강조 표시되고, 이전에 강조되었던 "전체" 항목의 강조가 해제되어야 함


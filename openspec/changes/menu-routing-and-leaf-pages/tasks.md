## 1. 중복 클래스 충돌 제거

- [x] 1.1 `lib/pages/all_dummy_pages.dart`에서 인라인 더미 클래스(`SimplePage`, `DashboardPage`, `AvatarPage`, `CommunityPage`, `WardrobeAllPage`, `WardrobeRecentPage`, `WardrobeManagePage`, `HouseStructurePage`, `HouseFurniturePage`, `WeatherTodayPage`, `WeatherWeekPage`, `SettingsProfilePage`, `SettingsNotificationPage`) 전체 삭제
- [x] 1.2 `all_dummy_pages.dart`를 실제 페이지 파일 export 구문만 남긴 export-only 파일로 전환
- [x] 1.3 `flutter analyze`로 ambiguous export 에러 없음 확인

## 2. 사이드 메뉴 활성 항목 하이라이팅

- [x] 2.1 `lib/pages/layout/app_layout.dart`의 `SideMenuPanel.build`에서 `GoRouterState.of(context).uri.toString()` 조회
- [x] 2.2 각 `ListTile` 렌더 시 `item.route == currentLocation` 비교로 `isActive` 플래그 산출
- [x] 2.3 활성 항목에 `tileColor: AppColors.menuSelected`, 텍스트 색 흰색, `fontWeight: FontWeight.w600` 적용
- [x] 2.4 비활성 항목은 기존 `AppColors.menuText` 스타일 유지

## 3. 검증

- [x] 3.1 IDE 정적 분석 에러 없음 확인 (`get_errors` 도구)
- [x] 3.2 라우터 파일(`app_router.dart`) 변경 없이 기존 route 연결이 정상 동작함을 확인


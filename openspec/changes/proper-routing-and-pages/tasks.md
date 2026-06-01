## 1. 라우팅 복원 — AppLayout / app_router / menu_provider

- [ ] 1.1 `menu_provider.dart`에서 `LeafRouteNotifier`, `selectedLeafRouteProvider`, `buildPageForRoute` 제거 및 page import 제거
- [ ] 1.2 `app_layout.dart`의 `AppLayout`에 `final Widget child` 파라미터 복원, `build`에서 `widget.child`로 본문 렌더링
- [ ] 1.3 `app_layout.dart`의 `_AppLayoutState.didChangeDependencies`에서 `selectedLeafRouteProvider` 동기화 코드 제거, `selectedMenuProvider` 동기화만 유지
- [ ] 1.4 `app_layout.dart`의 `TopMenuBar._buildNavBtn.onPressed`에서 `selectedLeafRouteProvider.notifier.setRoute()` 호출 제거
- [ ] 1.5 `app_layout.dart`의 `SideMenuPanel.onTap`에서 `selectedLeafRouteProvider.notifier.setRoute()` 호출 제거
- [ ] 1.6 `app_router.dart`의 ShellRoute builder에서 `AppLayout(child: child)` 복원

## 2. 대시보드 페이지 — lib/pages/dashboard/dashboard_page.dart

- [ ] 2.1 `DashboardPage` 구현: 환영 헤더 + 통계 카드 3개(옷장 아이템 수/집 가구 수/오늘 날씨) + 빠른 액세스 버튼

## 3. 아바타 페이지 — lib/pages/avatar/avatar_page.dart

- [ ] 3.1 `AvatarPage` 구현: 대형 아바타 플레이스홀더(CircleAvatar + 아이콘) + 신체정보 카드(키/몸무게/사이즈) + 스타일 태그

## 4. 옷장 페이지들 — lib/pages/wardrobe/

- [ ] 4.1 `WardrobeAllPage`: 검색바 + 카테고리 필터 칩(전체/상의/하의/아우터) + 옷 아이템 그리드(6개 카드)
- [ ] 4.2 `WardrobeRecentPage`: "최근 7일 추가된 항목" 헤더 + 아이템 리스트 타일 (날짜/카테고리/이름)
- [ ] 4.3 `WardrobeManagePage`: 관리 필요 항목 경고 카드 (세탁 필요 N개, 수선 필요 N개) + 항목 리스트

## 5. 집 페이지들 — lib/pages/house/

- [ ] 5.1 `HouseStructurePage`: 방 구조 카드 그리드(거실/침실/주방/욕실/베란다 아이콘+이름)
- [ ] 5.2 `HouseFurniturePage`: 가구 카테고리 리스트 + 각 카테고리별 아이템 수 배지

## 6. 날씨 페이지들 — lib/pages/weather/

- [ ] 6.1 `WeatherTodayPage`: 날씨 아이콘(☀) + 온도(24°C) + 날씨 상세(습도/바람/체감) + 오늘의 옷차림 추천 카드
- [ ] 6.2 `WeatherWeekPage`: 7일 예보 리스트(요일/아이콘/최고·최저 온도)

## 7. 커뮤니티 페이지 — lib/pages/community/community_page.dart

- [ ] 7.1 `CommunityPage`: 피드 형태의 게시물 카드 리스트(아바타+닉네임+본문+좋아요·댓글 수)

## 8. 설정 페이지들 — lib/pages/settings/

- [ ] 8.1 `SettingsProfilePage`: 프로필 섹션(아바타+이름+이메일) + 정보 수정 폼 필드들
- [ ] 8.2 `SettingsNotificationPage`: 알림 항목 토글 리스트(앱 알림/날씨 알림/커뮤니티 알림/업데이트 알림)

## 9. all_dummy_pages.dart 업데이트

- [ ] 9.1 `all_dummy_pages.dart`를 각 신규 파일의 re-export 파일로 교체

## 10. 검증 및 정리

- [ ] 10.1 `flutter analyze`로 오류 없음 확인
- [ ] 10.2 `dart format lib/`으로 코드 포맷팅
- [ ] 10.3 웹 빌드 확인 (`flutter build web --no-pub`)


## 1. menu_provider.dart — selectedLeafRouteProvider 및 매핑 헬퍼 추가

- [x] 1.1 `LeafRouteNotifier` + `selectedLeafRouteProvider = NotifierProvider<LeafRouteNotifier, String>` 추가
- [x] 1.2 `buildPageForRoute(String route) → Widget` 헬퍼 함수 작성 — 모든 leaf 경로 매핑
- [x] 1.3 `menu_provider.dart`에 필요한 page import 추가 (`all_dummy_pages.dart`)

## 2. app_layout.dart — AppLayout 본문 렌더링 교체

- [x] 2.1 `AppLayout`에서 `child` 파라미터 제거
- [x] 2.2 `_AppLayoutState.build`에서 `ref.watch(selectedLeafRouteProvider)`로 본문 위젯 결정
- [x] 2.3 본문 영역을 `AnimatedSwitcher + KeyedSubtree` 로 래핑하여 페이드 전환 효과 적용
- [x] 2.4 `menu_provider.dart`에서 `buildPageForRoute` import

## 3. app_layout.dart — TopMenuBar 버튼 수정

- [x] 3.1 `_buildNavBtn.onPressed`에서 `selectedLeafRouteProvider.notifier.setRoute(defaultRoute)` 추가

## 4. app_layout.dart — SideMenuPanel onTap 수정

- [x] 4.1 `SideMenuPanel.onTap`에서 `selectedLeafRouteProvider.notifier.setRoute(item.route!)` 추가
- [x] 4.2 `SideMenuPanel`이 ConsumerWidget이므로 ref 사용 가능 확인

## 5. app_layout.dart — didChangeDependencies URL 동기화 확장

- [x] 5.1 `didChangeDependencies`에서 `selectedLeafRouteProvider`도 URL 기반 동기화

## 6. app_router.dart — AppLayout child 파라미터 제거

- [x] 6.1 `ShellRoute.builder`에서 `AppLayout(child: child)` → `const AppLayout()` 로 변경

## 7. 검증 및 정리

- [x] 7.1 `flutter analyze`로 오류 없음 확인
- [x] 7.2 `dart format lib/`으로 코드 포맷팅
- [x] 7.3 웹 빌드 확인 (`flutter build web --no-pub`)


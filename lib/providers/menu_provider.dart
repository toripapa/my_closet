import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_model.dart';
import '../pages/all_dummy_pages.dart';

class SelectedMenuNotifier extends Notifier<String> {
  @override
  String build() => 'home';
  void select(String menu) {
    state = menu;
  }
}

final selectedMenuProvider = NotifierProvider<SelectedMenuNotifier, String>(
  SelectedMenuNotifier.new,
);
final submenuProvider = Provider<List<MenuItem>?>((ref) {
  final selected = ref.watch(selectedMenuProvider);
  return menuMap[selected];
});

/// 현재 본문 영역에 표시할 leaf 라우트 경로를 추적하는 Notifier.
class LeafRouteNotifier extends Notifier<String> {
  @override
  String build() => '/home/dashboard';

  void setRoute(String route) {
    state = route;
  }
}

/// 현재 본문 영역에 표시할 leaf 라우트 경로를 추적하는 Provider.
/// GoRouter Navigator에 의존하지 않고 Riverpod 상태로 본문을 제어합니다.
final selectedLeafRouteProvider = NotifierProvider<LeafRouteNotifier, String>(
  LeafRouteNotifier.new,
);

/// leaf 라우트 경로 → 해당 페이지 위젯 매핑 헬퍼.
/// AppLayout의 본문 렌더링에서 사용합니다.
Widget buildPageForRoute(String route) {
  switch (route) {
    case '/home/dashboard':
      return const DashboardPage();
    case '/home/avatar':
      return const AvatarPage();
    case '/home/wardrobe/all':
      return const WardrobeAllPage();
    case '/home/wardrobe/recent':
      return const WardrobeRecentPage();
    case '/home/wardrobe/manage':
      return const WardrobeManagePage();
    case '/home/house/structure':
      return const HouseStructurePage();
    case '/home/house/furniture':
      return const HouseFurniturePage();
    case '/home/weather/today':
      return const WeatherTodayPage();
    case '/home/weather/week':
      return const WeatherWeekPage();
    case '/home/community':
      return const CommunityPage();
    case '/home/settings/profile':
      return const SettingsProfilePage();
    case '/home/settings/notification':
      return const SettingsNotificationPage();
    default:
      return const DashboardPage();
  }
}

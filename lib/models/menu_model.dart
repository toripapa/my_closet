// [Harness] 3. 코드 완전성 확인 - 생략 없이 100% 텍스트 작성 완료

class MenuItem {
  final String id;
  final String label;
  final String? route;
  final List<MenuItem>? submenu;

  const MenuItem({
    required this.id,
    required this.label,
    this.route,
    this.submenu,
  });
}

// 상단 메뉴 목록과 각각에 매칭되는 서브메뉴 트리
final Map<String, List<MenuItem>?> menuMap = {
  'home': null,
  'avatar': null,
  'wardrobe': [
    const MenuItem(id: 'all', label: '전체', route: '/wardrobe/all'),
    const MenuItem(id: 'recent', label: '최근 등록', route: '/wardrobe/recent'),
    const MenuItem(id: 'manage', label: '관리 필요', route: '/wardrobe/manage'),
  ],
  'house': [
    const MenuItem(
      id: 'structure',
      label: '현재 집 구조',
      route: '/house/structure',
    ),
    const MenuItem(id: 'furniture', label: '전체 가구', route: '/house/furniture'),
  ],
  'weather': [
    const MenuItem(id: 'today', label: '오늘의 날씨', route: '/weather/today'),
    const MenuItem(id: 'week', label: '이번주 날씨', route: '/weather/week'),
  ],
  'community': null,
  'settings': [
    const MenuItem(id: 'profile', label: '회원정보', route: '/settings/profile'),
    const MenuItem(
      id: 'notification',
      label: '알림',
      route: '/settings/notification',
    ),
  ],
};

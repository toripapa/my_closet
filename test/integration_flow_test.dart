import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_closet/providers/auth_provider.dart';
import 'package:my_closet/providers/menu_provider.dart';
import 'package:my_closet/models/menu_model.dart';

/// 통합 플로우 테스트 (단위 레벨)
/// 실제 라우팅/위젯 통합은 에뮬레이터 수동 테스트로 검증합니다.
void main() {
  group('로그인 → 메인 레이아웃 진입 플로우', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    // 12.1 로그인 → 메인 레이아웃 진입 플로우
    test('로그인 성공 시 isAuthenticated = true → 메인 레이아웃 접근 허용', () async {
      expect(container.read(authProvider).isAuthenticated, false);
      await container.read(authProvider.notifier).login('gagamel', '1234');
      expect(container.read(authProvider).isAuthenticated, true);
    });

    // 12.2 상단 메뉴 선택 → 좌측 메뉴 업데이트
    test('상단 메뉴 "wardrobe" 선택 시 submenu 업데이트', () {
      expect(container.read(selectedMenuProvider), 'home');
      expect(container.read(submenuProvider), null); // 홈은 서브메뉴 없음

      container.read(selectedMenuProvider.notifier).select('wardrobe');
      expect(container.read(selectedMenuProvider), 'wardrobe');

      final submenu = container.read(submenuProvider);
      expect(submenu, isNotNull);
      expect(submenu!.length, 3); // 전체, 최근 등록, 관리 필요
    });

    // 12.3 서브메뉴 항목별 라우트 경로 검증
    test('서브메뉴 항목이 올바른 route를 가짐', () {
      container.read(selectedMenuProvider.notifier).select('wardrobe');
      final submenu = container.read(submenuProvider)!;
      expect(submenu[0].route, '/wardrobe/all');
      expect(submenu[1].route, '/wardrobe/recent');
      expect(submenu[2].route, '/wardrobe/manage');
    });

    // 12.4 로그아웃 → 로그인 상태 초기화
    test('로그아웃 후 isAuthenticated = false → 로그인 페이지로 리다이렉트 필요 상태', () async {
      await container.read(authProvider.notifier).login('gagamel', '1234');
      expect(container.read(authProvider).isAuthenticated, true);

      container.read(authProvider.notifier).logout();
      expect(container.read(authProvider).isAuthenticated, false);
    });

    // 12.5 menuMap 전체 라우팅 경로 검증 (깊은 링킹)
    test('menuMap의 모든 서브메뉴가 올바른 route 경로를 가짐', () {
      final wardrobeSubmenus = menuMap['wardrobe']!;
      expect(wardrobeSubmenus.any((m) => m.route == '/wardrobe/all'), true);
      expect(wardrobeSubmenus.any((m) => m.route == '/wardrobe/recent'), true);
      expect(wardrobeSubmenus.any((m) => m.route == '/wardrobe/manage'), true);

      final houseSubmenus = menuMap['house']!;
      expect(houseSubmenus.any((m) => m.route == '/house/structure'), true);
      expect(houseSubmenus.any((m) => m.route == '/house/furniture'), true);

      final weatherSubmenus = menuMap['weather']!;
      expect(weatherSubmenus.any((m) => m.route == '/weather/today'), true);
      expect(weatherSubmenus.any((m) => m.route == '/weather/week'), true);

      final settingsSubmenus = menuMap['settings']!;
      expect(settingsSubmenus.any((m) => m.route == '/settings/profile'), true);
      expect(settingsSubmenus.any((m) => m.route == '/settings/notification'), true);
    });

    // 12.6 메뉴별 서브메뉴 null 여부 확인 (모바일 레이아웃 분기용)
    test('서브메뉴 없는 메뉴(홈, 아바타, 커뮤니티)는 null 반환', () {
      for (final menuId in ['home', 'avatar', 'community']) {
        container.read(selectedMenuProvider.notifier).select(menuId);
        expect(
          container.read(submenuProvider),
          null,
          reason: '$menuId 메뉴는 서브메뉴가 없어야 합니다',
        );
      }
    });
  });
}


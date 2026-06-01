import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../pages/auth/login_page.dart';
import '../pages/layout/app_layout.dart';
import '../pages/all_dummy_pages.dart';

// [Harness] 3. 미완성 텍스트 남기지 않고 온전한 위젯 구성 완결

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// 페이드 전환 애니메이션 빌더 (본문 영역 페이지 전환에 사용)
CustomTransitionPage<void> _fadeTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 180),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home/dashboard',
    redirect: (context, state) {
      final isAuth = ref.read(authProvider).isAuthenticated;
      final isGoingToLogin = state.fullPath == '/login';

      if (!isAuth && !isGoingToLogin) {
        return '/login';
      }
      if (isAuth && isGoingToLogin) {
        return '/home/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return const AppLayout();
        },
        routes: [
          GoRoute(
            path: '/home',
            redirect: (context, state) => '/home/dashboard',
            routes: [
              GoRoute(
                path: 'dashboard',
                pageBuilder: (context, state) => _fadeTransition(
                  context: context,
                  state: state,
                  child: const DashboardPage(),
                ),
              ),
              GoRoute(
                path: 'avatar',
                pageBuilder: (context, state) => _fadeTransition(
                  context: context,
                  state: state,
                  child: const AvatarPage(),
                ),
              ),
              GoRoute(
                path: 'community',
                pageBuilder: (context, state) => _fadeTransition(
                  context: context,
                  state: state,
                  child: const CommunityPage(),
                ),
              ),
              // 내 옷장
              GoRoute(
                path: 'wardrobe/all',
                pageBuilder: (context, state) => _fadeTransition(
                  context: context,
                  state: state,
                  child: const WardrobeAllPage(),
                ),
              ),
              GoRoute(
                path: 'wardrobe/recent',
                pageBuilder: (context, state) => _fadeTransition(
                  context: context,
                  state: state,
                  child: const WardrobeRecentPage(),
                ),
              ),
              GoRoute(
                path: 'wardrobe/manage',
                pageBuilder: (context, state) => _fadeTransition(
                  context: context,
                  state: state,
                  child: const WardrobeManagePage(),
                ),
              ),
              // 나의 집
              GoRoute(
                path: 'house/structure',
                pageBuilder: (context, state) => _fadeTransition(
                  context: context,
                  state: state,
                  child: const HouseStructurePage(),
                ),
              ),
              GoRoute(
                path: 'house/furniture',
                pageBuilder: (context, state) => _fadeTransition(
                  context: context,
                  state: state,
                  child: const HouseFurniturePage(),
                ),
              ),
              // 날씨
              GoRoute(
                path: 'weather/today',
                pageBuilder: (context, state) => _fadeTransition(
                  context: context,
                  state: state,
                  child: const WeatherTodayPage(),
                ),
              ),
              GoRoute(
                path: 'weather/week',
                pageBuilder: (context, state) => _fadeTransition(
                  context: context,
                  state: state,
                  child: const WeatherWeekPage(),
                ),
              ),
              // 설정
              GoRoute(
                path: 'settings/profile',
                pageBuilder: (context, state) => _fadeTransition(
                  context: context,
                  state: state,
                  child: const SettingsProfilePage(),
                ),
              ),
              GoRoute(
                path: 'settings/notification',
                pageBuilder: (context, state) => _fadeTransition(
                  context: context,
                  state: state,
                  child: const SettingsNotificationPage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

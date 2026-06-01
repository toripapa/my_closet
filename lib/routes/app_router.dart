import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../pages/auth/login_page.dart';
import '../pages/layout/app_layout.dart';
import '../pages/all_dummy_pages.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// authProvider 상태 변화를 GoRouter에 전달하는 ChangeNotifier.
/// refreshListenable로 등록하면 인증 상태가 바뀔 때마다 redirect가 재평가됩니다.
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen<AuthState>(authProvider, (_, _) => notifyListeners());
  }
}

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
    refreshListenable: _RouterNotifier(ref),
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
          return AppLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            redirect: (context, state) =>
                state.uri.path == '/home' || state.uri.path == '/home/'
                    ? '/home/dashboard'
                    : null,
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
                path: 'avatar/guide',
                pageBuilder: (context, state) => _fadeTransition(
                  context: context,
                  state: state,
                  child: const AvatarGuidePage(),
                ),
              ),
              GoRoute(
                path: 'avatar/result',
                pageBuilder: (context, state) {
                  final avatarUrl = (state.extra as String?) ?? '';
                  return _fadeTransition(
                    context: context,
                    state: state,
                    child: AvatarResultPage(avatarImageUrl: avatarUrl),
                  );
                },
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/menu_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

// [Harness] 3. 미완성 텍스트 남기지 않고 온전한 위젯 구성 완결

/// 현재 URL에서 1단계 메뉴 키를 추론합니다.
String? _resolveMenuKey(String location) {
  const prefixMap = {
    '/home/dashboard': 'home',
    '/home/avatar': 'avatar',
    '/home/wardrobe': 'wardrobe',
    '/home/house': 'house',
    '/home/weather': 'weather',
    '/home/community': 'community',
    '/home/settings': 'settings',
  };
  for (final entry in prefixMap.entries) {
    if (location.startsWith(entry.key)) return entry.value;
  }
  if (location == '/home' || location == '/home/') return 'home';
  return null;
}

/// leaf 경로를 정규화합니다. /home 단독이면 /home/dashboard로 변환합니다.
String _normalizeLeafRoute(String location) {
  if (location == '/home' || location == '/home/') return '/home/dashboard';
  return location;
}

/// 3단 전역 레이아웃: 상단 메뉴바 + 좌측 서브메뉴 + 본문 콘텐츠.
///
/// 본문 영역은 GoRouter의 child Navigator 대신 [selectedLeafRouteProvider]를
/// watch하여 직접 페이지 위젯을 렌더링합니다.
/// → GoRouter 17.x에서 ShellRoute child 업데이트가 보장되지 않는 문제 해결.
class AppLayout extends ConsumerStatefulWidget {
  const AppLayout({super.key});

  @override
  ConsumerState<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends ConsumerState<AppLayout> {
  String? _lastSyncedLocation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouterState.of(context).uri.toString();
    if (location == _lastSyncedLocation) return;
    _lastSyncedLocation = location;

    // 1단계 메뉴 키 동기화
    final resolvedKey = _resolveMenuKey(location);
    if (resolvedKey != null) {
      final currentMenu = ref.read(selectedMenuProvider);
      if (resolvedKey != currentMenu) {
        ref.read(selectedMenuProvider.notifier).select(resolvedKey);
      }
    }

    // leaf 라우트 동기화 (딥링크 지원)
    final normalizedRoute = _normalizeLeafRoute(location);
    final currentLeaf = ref.read(selectedLeafRouteProvider);
    if (normalizedRoute != currentLeaf) {
      ref.read(selectedLeafRouteProvider.notifier).setRoute(normalizedRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final submenu = ref.watch(submenuProvider);
    final hasSubmenu = submenu != null && submenu.isNotEmpty;

    // GoRouter Navigator 대신 provider로 본문 페이지 결정
    final leafRoute = ref.watch(selectedLeafRouteProvider);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TopMenuBar(),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SideMenuPanel(),
          if (hasSubmenu)
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: AppColors.menuBorder,
            ),
          Expanded(
            child: Container(
              color: AppColors.background,
              // AnimatedSwitcher로 페이드 전환 효과 적용
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: KeyedSubtree(
                  key: ValueKey(leafRoute),
                  child: buildPageForRoute(leafRoute),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 상단 메뉴바: 타이틀 + 1단계 메뉴 버튼(좌측 Row) + 로그아웃(우측 actions)
class TopMenuBar extends ConsumerWidget {
  const TopMenuBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMenu = ref.watch(selectedMenuProvider);

    return AppBar(
      backgroundColor: AppColors.menuBackground,
      foregroundColor: AppColors.menuText,
      elevation: 0,
      titleSpacing: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.menuBorder),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: AppSpacing.s2),
          const Text(
            'My Smart Closet',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.menuText,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          _buildNavBtn(
            context,
            ref,
            'home',
            '홈',
            selectedMenu,
            '/home/dashboard',
          ),
          _buildNavBtn(
            context,
            ref,
            'avatar',
            '내 아바타',
            selectedMenu,
            '/home/avatar',
          ),
          _buildNavBtn(
            context,
            ref,
            'wardrobe',
            '내 옷장',
            selectedMenu,
            '/home/wardrobe/all',
          ),
          _buildNavBtn(
            context,
            ref,
            'house',
            '나의 집',
            selectedMenu,
            '/home/house/structure',
          ),
          _buildNavBtn(
            context,
            ref,
            'weather',
            '날씨',
            selectedMenu,
            '/home/weather/today',
          ),
          _buildNavBtn(
            context,
            ref,
            'community',
            '커뮤니티',
            selectedMenu,
            '/home/community',
          ),
          _buildNavBtn(
            context,
            ref,
            'settings',
            '설정',
            selectedMenu,
            '/home/settings/profile',
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: AppColors.menuText),
          tooltip: '로그아웃',
          onPressed: () {
            ref.read(authProvider.notifier).logout();
            context.go('/login');
          },
        ),
        const SizedBox(width: AppSpacing.s1),
      ],
    );
  }

  Widget _buildNavBtn(
    BuildContext context,
    WidgetRef ref,
    String id,
    String label,
    String selected,
    String defaultRoute,
  ) {
    final isSelected = id == selected;
    return TextButton(
      style:
          TextButton.styleFrom(
            foregroundColor: isSelected ? Colors.white : AppColors.menuText,
            backgroundColor: isSelected
                ? AppColors.menuSelected
                : Colors.transparent,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s1,
              vertical: AppSpacing.s1,
            ),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.hovered)
                  ? AppColors.menuHover
                  : null,
            ),
          ),
      onPressed: () {
        // 1단계 메뉴 상태 업데이트
        ref.read(selectedMenuProvider.notifier).select(id);
        // 본문 페이지 즉시 전환 (provider 기반)
        ref.read(selectedLeafRouteProvider.notifier).setRoute(defaultRoute);
        // URL 동기화
        context.go(defaultRoute);
      },
      child: Text(label),
    );
  }
}

/// 좌측 서브메뉴 패널: 선택된 1단계 메뉴에 따라 동적 표시
class SideMenuPanel extends ConsumerWidget {
  const SideMenuPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submenu = ref.watch(submenuProvider);

    if (submenu == null || submenu.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 200,
      color: AppColors.sideBackground,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s1),
        itemCount: submenu.length,
        itemBuilder: (context, index) {
          final item = submenu[index];
          return ListTile(
            title: Text(
              item.label,
              style: const TextStyle(color: AppColors.menuText, fontSize: 14),
            ),
            hoverColor: AppColors.menuHover,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s2,
            ),
            dense: true,
            onTap: () {
              if (item.route != null) {
                // 본문 페이지 즉시 전환 (provider 기반) — GoRouter Navigator 불필요
                ref
                    .read(selectedLeafRouteProvider.notifier)
                    .setRoute(item.route!);
                // URL 동기화 (딥링크/브라우저 히스토리)
                context.go(item.route!);
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          );
        },
      ),
    );
  }
}

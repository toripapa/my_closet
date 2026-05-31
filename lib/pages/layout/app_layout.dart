import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/menu_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

// [Harness] 3. 미완성 텍스트 남기지 않고 온전한 위젯 구성 완결

/// 현재 URL에서 1단계 메뉴 키를 추론합니다.
/// 예) /home/weather/today → 'weather', /home/avatar → 'avatar'
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

/// 3단 전역 레이아웃: 상단 메뉴바 + 좌측 서브메뉴 + 본문 콘텐츠
///
/// ConsumerStatefulWidget을 사용하여 URL 변경 시 selectedMenuProvider를
/// didChangeDependencies에서 안전하게 동기화합니다.
/// (ConsumerWidget의 build 내 addPostFrameCallback 방식은 레이스 컨디션 유발)
class AppLayout extends ConsumerStatefulWidget {
  final Widget child;
  const AppLayout({super.key, required this.child});

  @override
  ConsumerState<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends ConsumerState<AppLayout> {
  /// 마지막으로 동기화된 URL — 중복 동기화 방지용
  String? _lastSyncedLocation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // GoRouterState가 변경(URL 변경)될 때만 호출됨
    final location = GoRouterState.of(context).uri.toString();

    // 같은 위치면 이미 동기화됨 — 중복 처리 방지
    if (location == _lastSyncedLocation) return;
    _lastSyncedLocation = location;

    final resolvedKey = _resolveMenuKey(location);
    if (resolvedKey == null) return;

    // selectedMenuProvider와 불일치할 때만 동기화
    // (대부분의 경우 메뉴 버튼 클릭 시 이미 select()가 호출되어 일치함 → 노옵)
    final currentMenu = ref.read(selectedMenuProvider);
    if (resolvedKey != currentMenu) {
      ref.read(selectedMenuProvider.notifier).select(resolvedKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final submenu = ref.watch(submenuProvider);
    final hasSubmenu = submenu != null && submenu.isNotEmpty;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TopMenuBar(),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SideMenuPanel(),
          // 서브메뉴가 있을 때만 우측 구분선 표시
          if (hasSubmenu)
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: AppColors.menuBorder,
            ),
          Expanded(
            child: Container(color: AppColors.background, child: widget.child),
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
      // AppBar 하단 구분선 — TopMenuBar와 본문 영역의 경계 명확화
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
        ref.read(selectedMenuProvider.notifier).select(id);
        context.go(defaultRoute);
      },
      child: Text(label),
    );
  }
}

/// 좌측 서브메뉴 패널: 선택된 1단계 메뉴에 따라 동적 표시
/// submenu가 null이면 SizedBox.shrink()로 숨김
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
      // SideMenuPanel 전용 배경색 — TopMenuBar와 시각적으로 구분
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
              // item.route는 전체 경로(/home/weather/today) — 직접 go() 호출
              if (item.route != null) {
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

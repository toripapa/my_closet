import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/menu_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

// [Harness] 3. 미완성 텍스트 남기지 않고 온전한 위젯 구성 완결

class AppLayout extends ConsumerWidget {
  final Widget child;
  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TopMenuBar(),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SideMenuPanel(),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: Container(color: AppColors.background, child: child),
          ),
        ],
      ),
    );
  }
}

class TopMenuBar extends ConsumerWidget {
  const TopMenuBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMenu = ref.watch(selectedMenuProvider);

    return AppBar(
      title: const Text(
        'My Smart Closet',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.divider, height: 1),
      ),
      actions: [
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
        const SizedBox(width: AppSpacing.s2),
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: '로그아웃',
          onPressed: () {
            ref.read(authProvider.notifier).logout();
            context.go('/login');
          },
        ),
        const SizedBox(width: AppSpacing.s2),
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
      style: TextButton.styleFrom(
        foregroundColor: isSelected ? AppColors.textMain : AppColors.textAccent,
        backgroundColor: isSelected ? AppColors.hover : Colors.transparent,
      ),
      onPressed: () {
        ref.read(selectedMenuProvider.notifier).select(id);
        context.go(defaultRoute);
      },
      child: Text(label),
    );
  }
}

class SideMenuPanel extends ConsumerWidget {
  const SideMenuPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submenu = ref.watch(submenuProvider);

    if (submenu == null || submenu.isEmpty) {
      return const SizedBox.shrink(); // 서브메뉴 없을 땐 숨김
    }

    return Container(
      width: 250,
      color: AppColors.background,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.s2),
        itemCount: submenu.length,
        itemBuilder: (context, index) {
          final item = submenu[index];
          return ListTile(
            title: Text(item.label),
            onTap: () {
              if (item.route != null) {
                context.go('/home${item.route}');
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            hoverColor: AppColors.hover,
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/menu_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

// [Harness] 3. 미완성 텍스트 남기지 않고 온전한 위젯 구성 완결

/// 3단 전역 레이아웃: 상단 메뉴바 + 좌측 서브메뉴 + 본문 콘텐츠
class AppLayout extends ConsumerWidget {
  final Widget child;
  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 서브메뉴 유무에 따라 VerticalDivider 조건부 렌더링
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
          // 서브메뉴가 있을 때만 구분선 표시
          if (hasSubmenu)
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: AppColors.menuSelected,
            ),
          Expanded(
            child: Container(color: AppColors.background, child: child),
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
      // 다크 배경 적용 (task 2.2, 2.3)
      backgroundColor: AppColors.menuBackground,
      foregroundColor: AppColors.menuText,
      elevation: 0,
      titleSpacing: 0,
      // 메뉴 버튼을 title Row 내 타이틀 옆(좌측)에 배치 (task 2.1)
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
      // 로그아웃 버튼은 우측 actions에 유지 (task 2.5)
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

  /// 1단계 메뉴 버튼 빌더
  /// - 선택 시: menuSelected 배경 + 흰색 텍스트 (task 2.4)
  /// - 미선택 시: 투명 배경 + menuText 텍스트
  /// - 단독 메뉴(서브메뉴 없음)도 동일하게 defaultRoute로 즉시 이동 (task 4.1)
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
            // 호버 색상을 다크 테마에 맞게 교체 (task 2.4)
            overlayColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.hovered)
                  ? AppColors.menuHover
                  : null,
            ),
          ),
      onPressed: () {
        // selectedMenuProvider 업데이트 → submenuProvider 자동 갱신 (task 4.2)
        ref.read(selectedMenuProvider.notifier).select(id);
        // 단독 메뉴든 서브메뉴 있는 메뉴든 항상 defaultRoute로 이동
        context.go(defaultRoute);
      },
      child: Text(label),
    );
  }
}

/// 좌측 서브메뉴 패널: 선택된 1단계 메뉴에 따라 동적 표시
/// submenu가 null이면 SizedBox.shrink()로 숨김 (task 4.2)
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
      // 다크 배경 적용 (task 3.1)
      color: AppColors.menuBackground,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s1),
        itemCount: submenu.length,
        itemBuilder: (context, index) {
          final item = submenu[index];
          return ListTile(
            // 다크 테마 텍스트 색상 (task 3.2)
            title: Text(
              item.label,
              style: const TextStyle(color: AppColors.menuText, fontSize: 14),
            ),
            // 다크 테마 호버 색상 (task 3.3)
            hoverColor: AppColors.menuHover,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s2,
            ),
            dense: true,
            onTap: () {
              if (item.route != null) {
                context.go('/home${item.route}');
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

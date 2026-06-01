import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/avatar_provider.dart';
import '../../services/avatar_api_service.dart';
import '../../theme/app_theme.dart';

/// 내 아바타 페이지
class AvatarPage extends ConsumerWidget {
  const AvatarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarAsync = ref.watch(avatarProvider);

    return avatarAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('오류: $e')),
      data: (profile) => _AvatarContent(profile: profile),
    );
  }
}

class _AvatarContent extends ConsumerWidget {
  final AvatarProfile profile;
  const _AvatarContent({required this.profile});

  Future<void> _onDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('아바타 삭제'),
        content: const Text('정말 삭제하시겠습니까?\n아바타와 신체 정보가 모두 삭제됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await AvatarApiService.deleteProfile();
      ref.read(avatarProvider.notifier).clearProfile();
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '내 아바타',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.s3),

          // 아바타 이미지 영역
          Center(
            child: Column(
              children: [
                Container(
                  width: 160,
                  height: 220,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider, width: 2),
                  ),
                  child: profile.hasAvatar && profile.avatarImageUrl != null
                      ? Image.network(
                          profile.avatarImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const _AvatarPlaceholder(),
                        )
                      : const _AvatarPlaceholder(),
                ),
                const SizedBox(height: AppSpacing.s2),

                // 등록 여부에 따라 버튼 분기
                if (!profile.hasAvatar)
                  OutlinedButton.icon(
                    onPressed: () => context.go('/home/avatar/guide'),
                    icon: const Icon(Icons.add_a_photo, size: 16),
                    label: const Text('아바타 등록'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textMain,
                      side: const BorderSide(color: AppColors.border),
                    ),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => context.go('/home/avatar/guide'),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('아바타 수정'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textMain,
                          side: const BorderSide(color: AppColors.border),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s2),
                      OutlinedButton.icon(
                        onPressed: () => _onDelete(context, ref),
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: const Text('아바타 삭제'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s4),

          // 신체 정보
          const Text(
            '신체 정보',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.s2),
          _BodyInfoTile(
            label: '키',
            value: profile.height != null ? '${profile.height} cm' : '-',
          ),
          const Divider(height: 1),
          _BodyInfoTile(
            label: '몸무게',
            value: profile.weight != null ? '${profile.weight} kg' : '-',
          ),
          const Divider(height: 1),
          _BodyInfoTile(label: '상의 사이즈', value: profile.topSize ?? '-'),
          const Divider(height: 1),
          _BodyInfoTile(label: '하의 사이즈', value: profile.bottomSize ?? '-'),
          const Divider(height: 1),
          _BodyInfoTile(label: '신발 사이즈', value: profile.shoeSize ?? '-'),
          const SizedBox(height: AppSpacing.s4),

          // 스타일 태그
          const Text(
            '나의 스타일',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.s2),
          Wrap(
            spacing: AppSpacing.s1,
            runSpacing: AppSpacing.s1,
            children: ['캐주얼', '미니멀', '스트리트', '포멀', '스포티']
                .map(
                  (tag) => Chip(
                    label: Text(tag, style: const TextStyle(fontSize: 12)),
                    backgroundColor: AppColors.hover,
                    side: const BorderSide(color: AppColors.border),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.person, size: 80, color: AppColors.textAccent),
        SizedBox(height: AppSpacing.s1),
        Text(
          '아바타 미리보기',
          style: TextStyle(fontSize: 12, color: AppColors.textAccent),
        ),
      ],
    );
  }
}

class _BodyInfoTile extends StatelessWidget {
  final String label;
  final String value;
  const _BodyInfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textAccent)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

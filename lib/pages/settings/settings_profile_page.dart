import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

/// 회원정보 설정 페이지
class SettingsProfilePage extends ConsumerWidget {
  const SettingsProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authProvider).userId ?? '';
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '회원정보',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.s3),

          // 프로필 이미지
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.textAccent,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(height: AppSpacing.s1),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    '프로필 사진 변경',
                    style: TextStyle(color: AppColors.textMain),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s3),

          // 정보 필드들
          _ProfileField(label: '이름', value: userId),
          const SizedBox(height: AppSpacing.s2),
          _ProfileField(label: '이메일', value: '$userId@example.com'),
          const SizedBox(height: AppSpacing.s2),
          _ProfileField(label: '닉네임', value: userId),
          const SizedBox(height: AppSpacing.s2),
          _ProfileField(label: '가입일', value: '2026년 1월 1일', readOnly: true),
          const SizedBox(height: AppSpacing.s4),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(onPressed: () {}, child: const Text('저장')),
          ),
          const SizedBox(height: AppSpacing.s2),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text('비밀번호 변경'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final bool readOnly;

  const _ProfileField({
    required this.label,
    required this.value,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textAccent),
        ),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          readOnly: readOnly,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            filled: readOnly,
            fillColor: readOnly ? AppColors.hover : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }
}

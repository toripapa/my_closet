import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 내 아바타 페이지
class AvatarPage extends StatelessWidget {
  const AvatarPage({super.key});

  @override
  Widget build(BuildContext context) {
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

          // 아바타 플레이스홀더
          Center(
            child: Column(
              children: [
                Container(
                  width: 160,
                  height: 220,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider, width: 2),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 80, color: AppColors.textAccent),
                      SizedBox(height: AppSpacing.s1),
                      Text(
                        '아바타 미리보기',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s2),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('아바타 수정'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textMain,
                    side: const BorderSide(color: AppColors.border),
                  ),
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
          _BodyInfoTile(label: '키', value: '175 cm'),
          const Divider(height: 1),
          _BodyInfoTile(label: '몸무게', value: '68 kg'),
          const Divider(height: 1),
          _BodyInfoTile(label: '상의 사이즈', value: 'M / 95'),
          const Divider(height: 1),
          _BodyInfoTile(label: '하의 사이즈', value: '30 / 32'),
          const Divider(height: 1),
          _BodyInfoTile(label: '신발 사이즈', value: '265 mm'),
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
            children: [
              '캐주얼', '미니멀', '스트리트', '포멀', '스포티',
            ]
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


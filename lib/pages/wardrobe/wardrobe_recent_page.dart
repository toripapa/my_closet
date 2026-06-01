import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 최근 등록 옷장 페이지
class WardrobeRecentPage extends StatelessWidget {
  const WardrobeRecentPage({super.key});

  static const _items = [
    ('블랙 터틀넥', '상의', '2026.06.01'),
    ('베이지 카디건', '아우터', '2026.05.30'),
    ('화이트 린넨 셔츠', '상의', '2026.05.28'),
    ('네이비 청바지', '하의', '2026.05.25'),
    ('그레이 스웨트팬츠', '하의', '2026.05.22'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.s3),
          child: Row(
            children: [
              const Icon(Icons.access_time, size: 20),
              const SizedBox(width: 8),
              const Text(
                '최근 7일 추가된 항목',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '총 ${_items.length}개',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textAccent,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            itemCount: _items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final item = _items[i];
              return ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: const Icon(Icons.checkroom, size: 28, color: AppColors.textAccent),
                ),
                title: Text(
                  item.$1,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  item.$2,
                  style: const TextStyle(fontSize: 12, color: AppColors.textAccent),
                ),
                trailing: Text(
                  item.$3,
                  style: const TextStyle(fontSize: 11, color: AppColors.textAccent),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


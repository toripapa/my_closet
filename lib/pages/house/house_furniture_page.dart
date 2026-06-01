import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 전체 가구 페이지
class HouseFurniturePage extends StatelessWidget {
  const HouseFurniturePage({super.key});

  static const _categories = [
    ('소파 & 거실', Icons.weekend, 4),
    ('침대 & 침실', Icons.bed, 3),
    ('테이블 & 의자', Icons.table_restaurant, 6),
    ('수납 & 정리', Icons.inventory_2, 8),
    ('조명', Icons.lightbulb, 5),
    ('기타 가구', Icons.chair, 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.s3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '전체 가구',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '총 ${_categories.fold(0, (sum, c) => sum + c.$3)}개 항목',
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
            itemCount: _categories.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final cat = _categories[i];
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Icon(cat.$2, size: 24),
                ),
                title: Text(
                  cat.$1,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.hover,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${cat.$3}개',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textAccent,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 현재 집 구조 페이지
class HouseStructurePage extends StatelessWidget {
  const HouseStructurePage({super.key});

  static const _rooms = [
    ('거실', Icons.weekend, '18평'),
    ('침실', Icons.bed, '12평'),
    ('주방', Icons.kitchen, '8평'),
    ('욕실', Icons.bathtub, '4평'),
    ('베란다', Icons.balcony, '6평'),
    ('서재', Icons.menu_book, '9평'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '현재 집 구조',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '총 ${_rooms.length}개 공간',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s1),
          const Text(
            '각 공간을 클릭하면 해당 공간의 수납 정보를 확인할 수 있습니다',
            style: TextStyle(fontSize: 12, color: AppColors.textAccent),
          ),
          const SizedBox(height: AppSpacing.s3),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppSpacing.s2,
              mainAxisSpacing: AppSpacing.s2,
              childAspectRatio: 1.1,
            ),
            itemCount: _rooms.length,
            itemBuilder: (context, i) {
              final room = _rooms[i];
              return InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(room.$2, size: 36, color: AppColors.textAccent),
                      const SizedBox(height: 8),
                      Text(
                        room.$1,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        room.$3,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

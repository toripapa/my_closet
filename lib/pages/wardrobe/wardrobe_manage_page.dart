import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 관리 필요 옷장 페이지
class WardrobeManagePage extends StatelessWidget {
  const WardrobeManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '관리 필요',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.s1),
          const Text(
            '세탁, 수선, 보관이 필요한 옷을 확인하세요',
            style: TextStyle(fontSize: 13, color: AppColors.textAccent),
          ),
          const SizedBox(height: AppSpacing.s3),

          // 요약 카드
          Row(
            children: [
              _SummaryCard(
                label: '세탁 필요',
                count: 3,
                icon: Icons.local_laundry_service,
              ),
              const SizedBox(width: AppSpacing.s2),
              _SummaryCard(label: '수선 필요', count: 1, icon: Icons.build),
              const SizedBox(width: AppSpacing.s2),
              _SummaryCard(label: '보관 정리', count: 5, icon: Icons.inventory_2),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),

          // 세탁 필요 항목
          _SectionHeader(
            title: '세탁 필요',
            icon: Icons.local_laundry_service,
            count: 3,
          ),
          const SizedBox(height: AppSpacing.s1),
          _ManageItem('블랙 코트', '드라이클리닝 필요'),
          _ManageItem('화이트 셔츠', '손세탁 권장'),
          _ManageItem('캐시미어 니트', '울 세탁 필요'),
          const SizedBox(height: AppSpacing.s3),

          // 수선 필요 항목
          _SectionHeader(title: '수선 필요', icon: Icons.build, count: 1),
          const SizedBox(height: AppSpacing.s1),
          _ManageItem('데님 재킷', '단추 교체 필요'),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  const _SummaryCard({
    required this.label,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s2),
        decoration: BoxDecoration(border: Border.all(color: AppColors.divider)),
        child: Column(
          children: [
            Icon(icon, size: 20),
            const SizedBox(height: 4),
            Text(
              '$count개',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.textAccent),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final int count;
  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 6),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.textMain,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
      ],
    );
  }
}

class _ManageItem extends StatelessWidget {
  final String name;
  final String note;
  const _ManageItem(this.name, this.note);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(AppSpacing.s2),
      decoration: BoxDecoration(border: Border.all(color: AppColors.divider)),
      child: Row(
        children: [
          const Icon(Icons.checkroom, size: 20, color: AppColors.textAccent),
          const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(
                  note,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

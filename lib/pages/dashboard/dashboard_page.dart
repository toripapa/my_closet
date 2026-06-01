import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 홈 대시보드 페이지
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 환영 헤더
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.textAccent,
                child: Icon(Icons.person, color: Colors.white, size: 32),
              ),
              const SizedBox(width: AppSpacing.s2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '안녕하세요, gagamel님',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '오늘도 스타일리시한 하루 보내세요',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s4),

          // 통계 카드
          const Text(
            '나의 현황',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.s2),
          Row(
            children: [
              _StatCard(icon: Icons.checkroom, label: '내 옷장', value: '24개', color: Colors.black),
              const SizedBox(width: AppSpacing.s2),
              _StatCard(icon: Icons.home, label: '가구', value: '12개', color: Colors.black),
              const SizedBox(width: AppSpacing.s2),
              _StatCard(icon: Icons.wb_sunny, label: '오늘 날씨', value: '24°C', color: Colors.black),
            ],
          ),
          const SizedBox(height: AppSpacing.s4),

          // 빠른 액세스
          const Text(
            '빠른 액세스',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.s2),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.s2,
            mainAxisSpacing: AppSpacing.s2,
            childAspectRatio: 1.4,
            children: const [
              _QuickMenuCard(icon: Icons.add, label: '옷 추가'),
              _QuickMenuCard(icon: Icons.style, label: '오늘의 코디'),
              _QuickMenuCard(icon: Icons.cloud, label: '날씨 확인'),
              _QuickMenuCard(icon: Icons.people, label: '커뮤니티'),
              _QuickMenuCard(icon: Icons.star, label: '즐겨찾기'),
              _QuickMenuCard(icon: Icons.settings, label: '설정'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s2),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: AppSpacing.s1),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickMenuCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickMenuCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 오늘의 날씨 페이지
class WeatherTodayPage extends StatelessWidget {
  const WeatherTodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '오늘의 날씨',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.s3),

          // 날씨 메인 카드
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.s3),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.wb_sunny, size: 60),
                    SizedBox(height: AppSpacing.s1),
                    Text(
                      '맑음',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      '24°C',
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '서울 · 2026년 6월 1일',
                      style: TextStyle(fontSize: 12, color: AppColors.textAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s2),

          // 날씨 상세 정보
          Row(
            children: [
              _WeatherDetail(icon: Icons.water_drop, label: '습도', value: '55%'),
              _WeatherDetail(icon: Icons.air, label: '바람', value: '3m/s'),
              _WeatherDetail(icon: Icons.thermostat, label: '체감', value: '22°C'),
              _WeatherDetail(icon: Icons.umbrella, label: '강수확률', value: '10%'),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),

          // 오늘의 옷차림 추천
          const Text(
            '오늘의 옷차림 추천',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.s2),
          Container(
            padding: const EdgeInsets.all(AppSpacing.s2),
            decoration: BoxDecoration(border: Border.all(color: AppColors.divider)),
            child: const Row(
              children: [
                Icon(Icons.style, size: 32),
                SizedBox(width: AppSpacing.s2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('가벼운 반소매 + 얇은 아우터', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 4),
                      Text(
                        '낮에는 따뜻하지만 저녁에는 쌀쌀할 수 있어요. 얇은 가디건이나 재킷을 챙기세요.',
                        style: TextStyle(fontSize: 12, color: AppColors.textAccent),
                      ),
                    ],
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

class _WeatherDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _WeatherDetail({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s1),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(border: Border.all(color: AppColors.divider)),
        child: Column(
          children: [
            Icon(icon, size: 18),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textAccent)),
          ],
        ),
      ),
    );
  }
}


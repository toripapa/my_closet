import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 이번주 날씨 페이지
class WeatherWeekPage extends StatelessWidget {
  const WeatherWeekPage({super.key});

  static const _forecast = [
    ('월', '맑음', Icons.wb_sunny, '26°', '14°'),
    ('화', '구름', Icons.cloud, '22°', '13°'),
    ('수', '비', Icons.umbrella, '18°', '12°'),
    ('목', '구름', Icons.cloud, '20°', '11°'),
    ('금', '맑음', Icons.wb_sunny, '24°', '13°'),
    ('토', '맑음', Icons.wb_sunny, '27°', '15°'),
    ('일', '흐림', Icons.cloud_queue, '21°', '14°'),
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
                '이번주 날씨',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                '2026년 6월 1일 ~ 7일 · 서울',
                style: TextStyle(fontSize: 13, color: AppColors.textAccent),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            itemCount: _forecast.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final day = _forecast[i];
              final isToday = i == 0;
              return Container(
                color: isToday ? AppColors.hover : null,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s3,
                  vertical: AppSpacing.s2,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 32,
                      child: Text(
                        day.$1,
                        style: TextStyle(
                          fontWeight: isToday
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (isToday)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textMain,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '오늘',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      )
                    else
                      const SizedBox(width: 42),
                    Icon(day.$3, size: 24),
                    const SizedBox(width: AppSpacing.s2),
                    Text(
                      day.$2,
                      style: const TextStyle(color: AppColors.textAccent),
                    ),
                    const Spacer(),
                    Text(
                      day.$4,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s2),
                    Text(
                      day.$5,
                      style: const TextStyle(
                        color: AppColors.textAccent,
                        fontSize: 14,
                      ),
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

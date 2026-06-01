import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 알림 설정 페이지
class SettingsNotificationPage extends StatefulWidget {
  const SettingsNotificationPage({super.key});

  @override
  State<SettingsNotificationPage> createState() =>
      _SettingsNotificationPageState();
}

class _SettingsNotificationPageState extends State<SettingsNotificationPage> {
  final _settings = {
    '앱 푸시 알림': true,
    '날씨 알림 (매일 오전 7시)': true,
    '커뮤니티 댓글 알림': false,
    '좋아요 알림': true,
    '업데이트 알림': false,
    '마케팅 정보 수신': false,
  };

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
                '알림 설정',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                '알림을 켜거나 끌 수 있습니다',
                style: TextStyle(fontSize: 13, color: AppColors.textAccent),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            children: [
              ..._settings.entries.map(
                (entry) => Column(
                  children: [
                    SwitchListTile(
                      title: Text(entry.key),
                      value: entry.value,
                      activeThumbColor: AppColors.textMain,
                      onChanged: (val) {
                        setState(() => _settings[entry.key] = val);
                      },
                    ),
                    const Divider(height: 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

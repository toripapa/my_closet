import 'package:flutter/material.dart';

// [Harness] 3. 미완성 텍스트 남기지 않고 온전한 위젯 구성 완결

class SimplePage extends StatelessWidget {
  final String title;
  const SimplePage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage('홈 페이지');
}

class AvatarPage extends StatelessWidget {
  const AvatarPage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage('내 아바타');
}

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage('커뮤니티 화면');
}

class WardrobeAllPage extends StatelessWidget {
  const WardrobeAllPage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage('전체 옷장');
}

class WardrobeRecentPage extends StatelessWidget {
  const WardrobeRecentPage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage('최근 등록 옷장');
}

class WardrobeManagePage extends StatelessWidget {
  const WardrobeManagePage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage('관리 필요 옷장');
}

class HouseStructurePage extends StatelessWidget {
  const HouseStructurePage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage('현재 집 구조');
}

class HouseFurniturePage extends StatelessWidget {
  const HouseFurniturePage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage('전체 가구');
}

class WeatherTodayPage extends StatelessWidget {
  const WeatherTodayPage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage('오늘의 날씨');
}

class WeatherWeekPage extends StatelessWidget {
  const WeatherWeekPage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage('이번주 날씨');
}

class SettingsProfilePage extends StatelessWidget {
  const SettingsProfilePage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage('회원정보 설정');
}

class SettingsNotificationPage extends StatelessWidget {
  const SettingsNotificationPage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage('알림 설정');
}

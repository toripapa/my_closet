import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 커뮤니티 페이지
class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  static const _posts = [
    ('스타일리스트', '오늘 코디 어때요?', '봄/여름 린넨 셔츠에 슬랙스 조합입니다. 가볍고 시원해서 좋아요!', 24, 8),
    ('패션러버', '미니멀 코디 공유', '화이트 티 + 블랙 팬츠의 영원한 조합. 어디서나 무난하게!', 18, 5),
    ('옷장정리', '계절별 수납 팁', '여름 옷으로 교체할 시즌이에요. 진공팩 활용하면 공간 절약!', 31, 12),
    ('패션인플루', '이번 주 OOTD', '오버핏 린넨 재킷 + 슬랙스 코디. 캐주얼하면서도 격식 있어요.', 45, 19),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Padding(
          padding: const EdgeInsets.all(AppSpacing.s3),
          child: Row(
            children: [
              const Text(
                '커뮤니티',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 14),
                label: const Text('글쓰기', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textMain,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // 피드
        Expanded(
          child: ListView.separated(
            itemCount: _posts.length,
            separatorBuilder: (_, __) => const Divider(height: 1, thickness: 4, color: AppColors.hover),
            itemBuilder: (context, i) {
              final post = _posts[i];
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.s2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 작성자
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.textAccent,
                          child: Text(
                            post.$1[0],
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(post.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
                        const Spacer(),
                        const Text('방금 전', style: TextStyle(fontSize: 11, color: AppColors.textAccent)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s1),
                    // 제목
                    Text(post.$2, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    // 본문
                    Text(post.$3, style: const TextStyle(fontSize: 13, color: AppColors.textAccent)),
                    const SizedBox(height: AppSpacing.s1),
                    // 좋아요/댓글
                    Row(
                      children: [
                        Icon(Icons.favorite_border, size: 16, color: AppColors.textAccent),
                        const SizedBox(width: 4),
                        Text('${post.$4}', style: const TextStyle(fontSize: 12, color: AppColors.textAccent)),
                        const SizedBox(width: AppSpacing.s2),
                        Icon(Icons.chat_bubble_outline, size: 16, color: AppColors.textAccent),
                        const SizedBox(width: 4),
                        Text('${post.$5}', style: const TextStyle(fontSize: 12, color: AppColors.textAccent)),
                      ],
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


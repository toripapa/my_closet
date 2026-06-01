import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/avatar_api_service.dart';
import '../../theme/app_theme.dart';

/// 아바타 등록 가이드 페이지
/// - 촬영 방법 안내 문구 표시
/// - "확인" 버튼 → 카메라 실행
/// - 촬영 완료 → 서버 업로드 → 아바타 등록 완료
class AvatarGuidePage extends ConsumerStatefulWidget {
  const AvatarGuidePage({super.key});

  @override
  ConsumerState<AvatarGuidePage> createState() => _AvatarGuidePageState();
}

class _AvatarGuidePageState extends ConsumerState<AvatarGuidePage> {
  bool _isLoading = false;
  final _picker = ImagePicker();

  Future<void> _onConfirmPressed() async {
    // 카메라 실행
    XFile? photo;
    try {
      photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1080,
      );
    } catch (e) {
      // 권한 거부 등 예외 처리
      if (mounted) await _showPermissionDeniedDialog();
      return;
    }

    // 촬영 취소 시 가이드 페이지 유지
    if (photo == null) return;

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final imageFile = File(photo.path);
      final avatarUrl = await AvatarApiService.uploadImageForAvatar(imageFile);

      if (!mounted) return;

      // 결과 페이지로 이동 (아바타 URL 전달)
      context.go('/home/avatar/result', extra: avatarUrl);
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
      context.go('/home/avatar');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// 카메라 권한 거부 안내 다이얼로그
  Future<void> _showPermissionDeniedDialog() async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('카메라 권한 필요'),
        content: const Text(
          '아바타 생성을 위해 카메라 권한이 필요합니다.\n'
          '설정에서 카메라 권한을 허용해 주세요.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // 설정 앱 이동은 permission_handler 패키지로 확장 가능
            },
            child: const Text('설정으로 이동'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아바타 등록 가이드'),
        leading: BackButton(onPressed: () => context.go('/home/avatar')),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.s4),

                // 가이드 일러스트 영역
                Center(
                  child: Container(
                    width: 140,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.hover,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_outline, size: 80, color: AppColors.textAccent),
                        SizedBox(height: AppSpacing.s1),
                        Icon(Icons.camera_alt_outlined, size: 28, color: AppColors.textAccent),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),

                // 가이드 문구 1
                _GuideItem(
                  icon: Icons.camera_alt,
                  text: '본인 전체 모습을 카메라로 촬영 해주세요',
                ),
                const SizedBox(height: AppSpacing.s2),

                // 가이드 문구 2
                _GuideItem(
                  icon: Icons.face,
                  text: '정면에서 정확하게 찍어야 아바타 생성이 잘 됩니다',
                ),
                const Spacer(),

                // 확인 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onConfirmPressed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.textMain,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('확인', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: AppSpacing.s3),
              ],
            ),
          ),

          // 로딩 오버레이
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      '아바타를 생성하고 있습니다...\n잠시만 기다려 주세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GuideItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _GuideItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.hover,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.textMain),
        ),
        const SizedBox(width: AppSpacing.s2),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}


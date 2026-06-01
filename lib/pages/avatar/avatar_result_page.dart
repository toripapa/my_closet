import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/avatar_provider.dart';
import '../../services/avatar_api_service.dart';
import '../../theme/app_theme.dart';

/// 아바타 생성 결과 확인 + 신체 정보 입력 페이지
class AvatarResultPage extends ConsumerStatefulWidget {
  /// 서버에서 받은 아바타 이미지 URL
  final String avatarImageUrl;

  const AvatarResultPage({super.key, required this.avatarImageUrl});

  @override
  ConsumerState<AvatarResultPage> createState() => _AvatarResultPageState();
}

class _AvatarResultPageState extends ConsumerState<AvatarResultPage> {
  final _formKey = GlobalKey<FormState>();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _topSizeCtrl = TextEditingController();
  final _bottomSizeCtrl = TextEditingController();
  final _shoeSizeCtrl = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _topSizeCtrl.dispose();
    _bottomSizeCtrl.dispose();
    _shoeSizeCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final profile = AvatarProfile(
      hasAvatar: true,
      avatarImageUrl: widget.avatarImageUrl,
      height: double.tryParse(_heightCtrl.text.trim()),
      weight: double.tryParse(_weightCtrl.text.trim()),
      topSize: _topSizeCtrl.text.trim().isEmpty ? null : _topSizeCtrl.text.trim(),
      bottomSize: _bottomSizeCtrl.text.trim().isEmpty ? null : _bottomSizeCtrl.text.trim(),
      shoeSize: _shoeSizeCtrl.text.trim().isEmpty ? null : _shoeSizeCtrl.text.trim(),
    );

    try {
      final saved = await AvatarApiService.saveProfile(profile);
      if (!mounted) return;
      ref.read(avatarProvider.notifier).updateProfile(saved);
      context.go('/home/avatar');
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아바타 등록'),
        leading: BackButton(onPressed: () => context.go('/home/avatar')),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s3),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 아바타 이미지 표시
                  Center(
                    child: Container(
                      width: 160,
                      height: 220,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.divider, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        widget.avatarImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(Icons.person, size: 80, color: AppColors.textAccent),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),

                  // 신체 정보 입력 폼
                  const Text(
                    '신체 정보 입력',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppSpacing.s1),
                  const Text(
                    '입력하지 않아도 저장이 가능합니다.',
                    style: TextStyle(fontSize: 12, color: AppColors.textAccent),
                  ),
                  const SizedBox(height: AppSpacing.s3),

                  _BodyInfoField(
                    controller: _heightCtrl,
                    label: '키',
                    hint: '예: 175',
                    suffix: 'cm',
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      final n = double.tryParse(v.trim());
                      if (n == null) return '숫자를 입력해 주세요.';
                      if (n < 50 || n > 250) return '키는 50~250cm 범위여야 합니다.';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.s2),
                  _BodyInfoField(
                    controller: _weightCtrl,
                    label: '몸무게',
                    hint: '예: 68',
                    suffix: 'kg',
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      final n = double.tryParse(v.trim());
                      if (n == null) return '숫자를 입력해 주세요.';
                      if (n < 10 || n > 300) return '몸무게는 10~300kg 범위여야 합니다.';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.s2),
                  _BodyInfoField(
                    controller: _topSizeCtrl,
                    label: '상의 사이즈',
                    hint: '예: M / 95',
                  ),
                  const SizedBox(height: AppSpacing.s2),
                  _BodyInfoField(
                    controller: _bottomSizeCtrl,
                    label: '하의 사이즈',
                    hint: '예: 30 / 32',
                  ),
                  const SizedBox(height: AppSpacing.s2),
                  _BodyInfoField(
                    controller: _shoeSizeCtrl,
                    label: '신발 사이즈',
                    hint: '예: 265 mm',
                  ),
                  const SizedBox(height: AppSpacing.s4),

                  // 저장 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onSave,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.textMain,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('저장', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s3),
                ],
              ),
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
                      '저장 중...',
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

class _BodyInfoField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? suffix;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _BodyInfoField({
    required this.controller,
    required this.label,
    required this.hint,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}


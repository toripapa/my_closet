import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/avatar_api_service.dart';

/// 아바타 전체 프로필 모델
class AvatarProfile {
  final bool hasAvatar;
  final String? avatarImageUrl;
  final double? height;
  final double? weight;
  final String? topSize;
  final String? bottomSize;
  final String? shoeSize;

  const AvatarProfile({
    this.hasAvatar = false,
    this.avatarImageUrl,
    this.height,
    this.weight,
    this.topSize,
    this.bottomSize,
    this.shoeSize,
  });

  AvatarProfile copyWith({
    bool? hasAvatar,
    String? avatarImageUrl,
    double? height,
    double? weight,
    String? topSize,
    String? bottomSize,
    String? shoeSize,
  }) {
    return AvatarProfile(
      hasAvatar: hasAvatar ?? this.hasAvatar,
      avatarImageUrl: avatarImageUrl ?? this.avatarImageUrl,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      topSize: topSize ?? this.topSize,
      bottomSize: bottomSize ?? this.bottomSize,
      shoeSize: shoeSize ?? this.shoeSize,
    );
  }

  factory AvatarProfile.fromJson(Map<String, dynamic> json) {
    return AvatarProfile(
      hasAvatar: true,
      avatarImageUrl: json['avatar_url'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      topSize: json['top_size'] as String?,
      bottomSize: json['bottom_size'] as String?,
      shoeSize: json['shoe_size'] as String?,
    );
  }
}

// AvatarState는 AvatarProfile의 별칭으로 유지 (기존 코드 호환)
typedef AvatarState = AvatarProfile;

/// 아바타 상태 관리 Notifier (Riverpod 3.x AsyncNotifier)
class AvatarNotifier extends AsyncNotifier<AvatarProfile> {
  @override
  Future<AvatarProfile> build() async {
    // 앱 시작 시 서버에서 프로필 로드
    try {
      final profile = await AvatarApiService.fetchProfile();
      return profile ?? const AvatarProfile();
    } catch (_) {
      // 서버 연결 실패 시 빈 상태로 폴백
      return const AvatarProfile();
    }
  }

  /// 아바타 생성 직후 URL만 임시 세팅 (result 페이지용)
  void setAvatarUrl(String avatarImageUrl) {
    final current = state.value ?? const AvatarProfile();
    state = AsyncData(current.copyWith(avatarImageUrl: avatarImageUrl));
  }

  /// 프로필 전체 업데이트 (저장 완료 후)
  void updateProfile(AvatarProfile profile) {
    state = AsyncData(profile);
  }

  /// 프로필 초기화 (삭제 후)
  void clearProfile() {
    state = const AsyncData(AvatarProfile());
  }
}

final avatarProvider = AsyncNotifierProvider<AvatarNotifier, AvatarProfile>(
  AvatarNotifier.new,
);

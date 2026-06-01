import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/env.dart';
import '../../providers/avatar_provider.dart';

/// my_closet_server 아바타 API 통신 서비스
class AvatarApiService {
  static final String _baseUrl = Env.avatarServerBaseUrl;

  /// 이미지 파일을 서버에 업로드하여 아바타 생성 요청
  static Future<String> uploadImageForAvatar(File imageFile) async {
    final uri = Uri.parse('$_baseUrl/api/avatar/generate');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 60),
      onTimeout: () => throw Exception('서버 응답 시간이 초과되었습니다. 잠시 후 다시 시도해 주세요.'),
    );
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final avatarUrl = body['avatar_url'] as String? ?? '';
      if (avatarUrl.isEmpty) throw Exception('서버에서 아바타 URL을 반환하지 않았습니다.');
      return avatarUrl;
    } else {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception('아바타 생성 실패 (${response.statusCode}): ${body['detail']}');
    }
  }

  /// 아바타 프로필(이미지 URL + 신체 정보) 저장
  static Future<AvatarProfile> saveProfile(AvatarProfile profile) async {
    final uri = Uri.parse('$_baseUrl/api/avatar/profile');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'avatar_url': profile.avatarImageUrl,
        'height': profile.height,
        'weight': profile.weight,
        'top_size': profile.topSize,
        'bottom_size': profile.bottomSize,
        'shoe_size': profile.shoeSize,
      }),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return AvatarProfile.fromJson(body);
    } else {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception('프로필 저장 실패 (${response.statusCode}): ${body['detail']}');
    }
  }

  /// 저장된 아바타 프로필 조회. 없으면 null 반환
  static Future<AvatarProfile?> fetchProfile() async {
    final uri = Uri.parse('$_baseUrl/api/avatar/profile');
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return AvatarProfile.fromJson(body);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('프로필 조회 실패 (${response.statusCode})');
    }
  }

  /// 아바타 프로필 삭제
  static Future<void> deleteProfile() async {
    final uri = Uri.parse('$_baseUrl/api/avatar/profile');
    final response = await http.delete(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception('프로필 삭제 실패 (${response.statusCode}): ${body['detail']}');
    }
  }
}

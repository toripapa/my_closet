import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/env.dart';

/// 인증 상태 데이터 클래스
class AuthState {
  /// 인증 여부
  final bool isAuthenticated;

  /// 로그인한 사용자 ID
  final String? userId;

  /// 로그인 실패 시 에러 메시지
  final String? errorMessage;

  const AuthState({
    this.isAuthenticated = false,
    this.userId,
    this.errorMessage,
  });
}

/// 인증 상태 관리 Notifier
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  /// Mock 로그인 처리 (Env 클래스에서 자격증명 주입)
  Future<void> login(String id, String password) async {
    if (id == Env.mockUserId && password == Env.mockUserPw) {
      state = AuthState(isAuthenticated: true, userId: id);
    } else {
      state = const AuthState(errorMessage: '아이디 또는 비밀번호가 올바르지 않습니다.');
    }
  }

  /// 로그아웃 - 상태 초기화
  void logout() {
    state = const AuthState();
  }

  /// 에러 메시지 초기화 (SnackBar 표시 후 호출)
  void clearError() {
    state = AuthState(
      isAuthenticated: state.isAuthenticated,
      userId: state.userId,
    );
  }
}

/// 전역 인증 상태 Provider
final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

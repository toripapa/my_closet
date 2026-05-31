import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_closet/providers/auth_provider.dart';

void main() {
  group('AuthNotifier 로그인 로직 테스트', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('초기 상태는 미인증 상태여야 한다', () {
      final authState = container.read(authProvider);
      expect(authState.isAuthenticated, false);
      expect(authState.userId, null);
      expect(authState.errorMessage, null);
    });

    test('올바른 자격증명으로 로그인 성공', () async {
      // Env.mockUserId = 'gagamel', Env.mockUserPw = '1234' (기본값)
      await container.read(authProvider.notifier).login('gagamel', '1234');
      final authState = container.read(authProvider);
      expect(authState.isAuthenticated, true);
      expect(authState.userId, 'gagamel');
      expect(authState.errorMessage, null);
    });

    test('잘못된 비밀번호로 로그인 실패', () async {
      await container.read(authProvider.notifier).login('gagamel', 'wrongpw');
      final authState = container.read(authProvider);
      expect(authState.isAuthenticated, false);
      expect(authState.errorMessage, isNotNull);
    });

    test('잘못된 아이디로 로그인 실패', () async {
      await container.read(authProvider.notifier).login('wrongid', '1234');
      final authState = container.read(authProvider);
      expect(authState.isAuthenticated, false);
      expect(authState.errorMessage, isNotNull);
    });

    test('빈 아이디/비밀번호로 로그인 실패', () async {
      await container.read(authProvider.notifier).login('', '');
      final authState = container.read(authProvider);
      expect(authState.isAuthenticated, false);
      expect(authState.errorMessage, isNotNull);
    });

    test('로그인 후 로그아웃 시 상태 초기화', () async {
      await container.read(authProvider.notifier).login('gagamel', '1234');
      container.read(authProvider.notifier).logout();
      final authState = container.read(authProvider);
      expect(authState.isAuthenticated, false);
      expect(authState.userId, null);
    });

    test('clearError 후 에러 메시지 제거', () async {
      await container.read(authProvider.notifier).login('wrong', 'wrong');
      expect(container.read(authProvider).errorMessage, isNotNull);
      container.read(authProvider.notifier).clearError();
      expect(container.read(authProvider).errorMessage, null);
    });
  });
}

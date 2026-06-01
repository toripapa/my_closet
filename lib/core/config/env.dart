class Env {
  // 컴파일 시점 주입(dart-define)을 지원하여 환경별 인증 정보를 다르게 관리할 수 있도록 설계
  // 하네스 룰(보안)에 의해 자격증명 하드코딩 대체 (현재는 Mock용 기본값 제공)
  static const String mockUserId = String.fromEnvironment(
    'MOCK_USER_ID',
    defaultValue: 'gagamel',
  );
  static const String mockUserPw = String.fromEnvironment(
    'MOCK_USER_PW',
    defaultValue: '1234',
  );

  /// my_closet_server 베이스 URL
  /// 실제 배포 환경에서는 --dart-define=AVATAR_SERVER_URL=https://your-server.com 으로 주입
  static const String avatarServerBaseUrl = String.fromEnvironment(
    'AVATAR_SERVER_URL',
    defaultValue: 'http://localhost:8000',
  );
}

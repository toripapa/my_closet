## Context

이 프로젝트는 Flutter/Dart 기반 AOS/iOS 크로스플랫폼 앱입니다. 초기 단계에서 사용자 인증 진입점과 기본 앱 아키텍처가 필요합니다. 설계는 상태관리, 라우팅, UI 레이아웃을 체계적으로 구성합니다.

**제약사항:**
- Flutter/Dart만 사용 (네이티브 코드 제외)
- Mock 로그인 (외부 인증 서버 없음)
- 미니멀리즘 UI/모노톤 디자인
- Android+iOS 공통 코드만 적용

## Goals / Non-Goals

**Goals:**
- 인증 진입점 구현 (Mock 로그인)
- 전역 인증 상태 관리
- 3단 레이아웃 렌더링 (상단/좌측/본문)
- 메뉴 기반 동적 라우팅
- Auth Guard를 통한 접근 제어
- 미니멀/모노톤 UI 기반 설계

**Non-Goals:**
- 실제 서버 인증 (Mock만 구현)
- 데이터베이스 영속화 (로그인 상태는 메모리에만 유지)
- 실시간 동기화
- 플랫폼별 특화 기능

## Decisions

### 1. 상태관리 패턴 → Riverpod 선택

**선택 이유:**
- 타입안전성: Riverpod은 compile-time 안전성 제공
- 테스트 용이성: ProviderContainer로 독립적 테스트 가능
- 비동기 지원: AsyncValue로 로딩/에러 상태 자연스럽게 처리

**인증 상태 구조:**
```dart
// lib/providers/auth_provider.dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isAuthenticated;
  final String? userId;
  final String? errorMessage;
  
  AuthState({
    this.isAuthenticated = false,
    this.userId,
    this.errorMessage,
  });
}

class AuthNotifier extends StateNotifier<AuthState> {
  static const VALID_ID = 'gagamel';
  static const VALID_PW = '1234';
  
  AuthNotifier() : super(AuthState());
  
  Future<void> login(String id, String password) async {
    if (id == VALID_ID && password == VALID_PW) {
      state = AuthState(isAuthenticated: true, userId: id);
    } else {
      state = AuthState(errorMessage: '아이디 또는 비밀번호가 없습니다');
    }
  }
  
  void logout() {
    state = AuthState();
  }
}
```

**대안 검토:**
- GetX: 더 간단하지만 보일러플레이트 코드 많음
- Provider: 기본적이지만 비동기 처리 복잡
- BLoC: 복잡한 상태 관리에는 과함

### 2. 라우팅 → GoRouter 선택

**선택 이유:**
- 선언적 라우팅: 모든 경로를 명확히 정의
- Auth Guard 쉬움: GoRoute에 redirect 콜백 내장
- 깊은 링킹 지원: 향후 확장 용이
- Material 3 권장

**라우터 구조:**
```dart
// lib/routes/app_router.dart
final appRouter = GoRouter(
  redirect: (context, state) {
    final isAuth = ref.watch(authProvider).isAuthenticated;
    if (!isAuth && state.location != '/login') {
      return '/login';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainLayout(),
      routes: [
        GoRoute(
          path: 'dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: 'avatar',
          builder: (context, state) => const AvatarPage(),
        ),
        // ... 다른 라우트
      ],
    ),
  ],
);
```

**대안 검토:**
- AutoRoute: 코드 제너레이션이 필요하지만 오버엔지니어링
- GetPages: Riverpod과 통합 복잡

### 3. 레이아웃 구조 → Scaffold + Row/Column 조합

**구조:**
```
Scaffold
├─ AppBar (상단 메뉴 1)
└─ Body
   └─ Row
      ├─ Column (좌측 서브메뉴 2)
      └─ Expanded
         └─ Navigator (본문 3)
```

**메뉴 상태 관리:**
```dart
final selectedMenuProvider = StateProvider<String>((ref) => 'home');
final submenuProvider = StateProvider<List<MenuItem>?>(
  (ref) {
    final selected = ref.watch(selectedMenuProvider);
    return menuMap[selected];
  },
);
```

### 4. UI 디자인 → 미니멀리즘/모노톤 강제

**색상 팔레트:**
- 배경: #FFFFFF (흰색)
- 텍스트: #000000 (검은색)
- 강조: #333333 (진회색)
- 구분선: #EEEEEE (밝은회색)
- 입력창 보더: #CCCCCC (중간회색)

**컴포넌트 규칙:**
- 버튼: 테두리만 (배경 없음) 또는 회색 배경
- 아이콘: 단색 검은색
- 타이포그래피: Roboto (기본), 경량 글꼴
- 패딩/마진: 8px, 16px 단계 (8의 배수)

## Risks / Trade-offs

| 리스크 | 완화 방법 |
|--------|----------|
| **Mock 로그인의 보안**: 고정 계정 정보가 앱에 포함됨 | 환경변수 관리, 향후 실제 인증으로 전환 시 쉽게 대체 가능하도록 구조화 |
| **메뉴 구조 변경**: 메뉴가 증가하면 라우트 복잡도 증가 | 라우트를 데이터로 정의 (menuMap) 하여 확장성 확보 |
| **성능**: 모든 서브메뉴를 미리 빌드하면 메모리 비효율 | 지연 로딩(Lazy Loading) 고려, 현재는 단순함 우선 |
| **모노톤 디자인의 단조로움**: 사용성 혼동 가능성 | 타이포그래피, 공백, 경계선으로 시각적 계층 강조 |

## Decisions: 메뉴 매핑 구조

**메뉴 데이터 구조:**
```dart
// lib/models/menu_model.dart
class MenuItem {
  final String id;
  final String label;
  final String? route;
  final List<MenuItem>? submenu;
  
  MenuItem({
    required this.id,
    required this.label,
    this.route,
    this.submenu,
  });
}

final menuMap = {
  'home': null, // 직접 라우팅
  'avatar': null,
  'wardrobe': [
    MenuItem(id: 'all', label: '전체', route: '/wardrobe/all'),
    MenuItem(id: 'recent', label: '최근 등록', route: '/wardrobe/recent'),
    MenuItem(id: 'manage', label: '관리 필요', route: '/wardrobe/manage'),
  ],
  'house': [
    MenuItem(id: 'structure', label: '현재 집 구조', route: '/house/structure'),
    MenuItem(id: 'furniture', label: '전체 가구', route: '/house/furniture'),
  ],
  'weather': [
    MenuItem(id: 'today', label: '오늘의 날씨', route: '/weather/today'),
    MenuItem(id: 'week', label: '이번주 날씨', route: '/weather/week'),
  ],
  'community': null,
  'settings': [
    MenuItem(id: 'profile', label: '회원정보', route: '/settings/profile'),
    MenuItem(id: 'notification', label: '알림', route: '/settings/notification'),
  ],
};
```

## Open Questions

- [ ] Mock 로그인 자격증명은 빌드 시간에 결정할지, 런타임 환경변수로 주입할지?
- [ ] 좌측 메뉴 너비는 고정(e.g., 250px) 또는 확장 가능할지?
- [ ] 모바일 기기에서 좌측 메뉴 숨김 (드로어) 처리 필요한지?
- [ ] 로그아웃 기능은 상단 우측에 배치할지, 설정 메뉴만 사용할지?


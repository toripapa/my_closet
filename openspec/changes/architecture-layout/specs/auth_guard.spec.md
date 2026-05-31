# Authentication Guard (Auth Guard)

## Overview

인증되지 않은 사용자가 로그인 후 레이아웃 (메인 앱)에 직접 접근하려는 것을 방지합니다. 모든 보호된 라우트는 GoRouter의 redirect 로직으로 /login으로 강제 리다이렉트됩니다.

## Requirements

- **비인증 사용자 차단**: isAuthenticated = false일 때 /login 강제 이동
- **로그인 페이지는 보호 제외**: /login은 누구나 접근 가능
- **라우트 전체 감시**: 모든 라우트 전환 시 인증 상태 확인
- **메모리 기반 상태**: 앱 재시작 시 상태 초기화 → /login 노출
- **원할한 로그아웃**: 로그아웃 시 authProvider 초기화 → /login 자동 리다이렉트

## Implementation Pattern

```dart
GoRouter(
  redirect: (context, state) {
    final isAuth = ref.watch(authProvider).isAuthenticated;
    
    if (!isAuth && state.location != '/login') {
      return '/login';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/login', ...), // 공개
    GoRoute(path: '/', ..., routes: [...]), // 보호됨
  ],
)
```

## Inputs

- 사용자 라우트 접근 시도
- 로그인 여부 (authProvider)

## Outputs

- 보호된 라우트 접근 차단
- /login으로 리다이렉트
- 비인증 상태에서 UIa 렌더링 금지

## Acceptance Criteria

- [ ] /home 직접 접속 시 /login으로 리다이렉트
- [ ] 로그아웃 후 메뉴 라우트 접근 불가
- [ ] 로그인 페이지는 누구나 접근 가능
- [ ] 로그인 성공 후 목표 페이지 라우팅 가능

## Notes

- Riverpod의 ref.watch를 통해 실시간 인증 상태 감시
- GoRouter의 redirect 콜백 활용
- 향후 token 기반 인증으로 확장 가능


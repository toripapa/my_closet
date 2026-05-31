## 1. 프로젝트 초기 설정

- [x] 1.1 pubspec.yaml 의존성 추가 (riverpod, go_router, flutter_riverpod)
- [x] 1.2 프로젝트 폴더 구조 생성 (lib/providers, lib/pages, lib/routes, lib/models)
- [x] 1.3 환경변수/debug 설정 파일 생성 (Mock 로그인 자격증명 관리)

## 2. 인증 상태관리 (Riverpod)

- [x] 2.1 AuthState 데이터 클래스 정의 (isAuthenticated, userId, errorMessage)
- [x] 2.2 AuthNotifier 클래스 작성 (login, logout 메서드 포함)
- [x] 2.3 authProvider 선언 (NotifierProvider)
- [x] 2.4 로그인 로직 테스트 (유효/무효 입력 케이스)

## 3. 라우터 설계 (GoRouter)

- [x] 3.1 menuMap 데이터 구조 정의 (메뉴 트리 구조화)
- [x] 3.2 AppRouter 클래스 작성 및 모든 라우트 등록
- [x] 3.3 Login 라우트 구현
- [x] 3.4 MainLayout 홈 라우트 구현
- [x] 3.5 Auth Guard redirect 로직 구현 (비인증 사용자 /login 강제)
- [x] 3.6 메뉴 기반 동적 라우팅 로직 구현

## 4. 로그인 페이지 UI

- [x] 4.1 LoginPage StatefulWidget 작성
- [x] 4.2 텍스트 입력 필드 2개 (ID, Password) - 모노톤 스타일
- [x] 4.3 로그인 버튼 구현 (authProvider.notifier.login() 호출)
- [x] 4.4 입력 유효성 검증 (공백 확인)
- [x] 4.5 실패 메시지 SnackBar/Dialog 표시
- [x] 4.6 성공 시 자동 라우팅 (/home으로 이동)
- [x] 4.7 전체 페이지 미니멀/모노톤 스타일 적용

## 5. 전역 레이아웃 (3단 구조)

- [x] 5.1 MainLayout StatelessWidget 작성
- [x] 5.2 Scaffold + AppBar (상단 메뉴 영역 1)
- [x] 5.3 TopMenuBar 위젯 작성 (홈, 내 아바타, 내 옷장, 나의 집, 날씨, 커뮤니티, 설정)
- [x] 5.4 Row 레이아웃 (좌측/본문 분할)
- [x] 5.5 SideMenuPanel 위젯 작성 (좌측 서브메뉴 영역 2)
- [x] 5.6 ContentArea 위젯 작성 (본문 렌더링 영역 3)

## 6. 상단 메뉴 (TopMenuBar)

- [x] 6.1 메뉴 항목별 버튼 생성
- [x] 6.2 선택된 메뉴 상태 표시 (selectedMenuProvider 연동)
- [x] 6.3 메뉴 클릭 시 selectedMenuProvider 업데이트
- [x] 6.4 로그아웃 버튼 (우측) 추가
- [x] 6.5 미니멀 스타일: 배경 흰색, 텍스트 검은색, 구분선 회색
- [x] 6.6 터치/호버 피드백 (회색 배경 변화)

## 7. 좌측 서브메뉴 (SideMenuPanel)

- [x] 7.1 selectedMenuProvider 감시하여 submenuProvider 업데이트
- [x] 7.2 submenu가 null이면 패널 숨김 또는 빈 상태 표시
- [x] 7.3 submenu 항목들을 Column으로 렌더링
- [x] 7.4 각 서브메뉴 클릭 시 route 기반 라우팅 실행
- [x] 7.5 선택된 항목 강조 표시 (배경색 변화)
- [x] 7.6 미니멀 스타일: 패딩, 경계선만 사용

## 8. 본문 영역 (ContentArea)

- [x] 8.1 RouterScaffold 또는 nested Navigator 구현
- [x] 8.2 라우트 변경에 따라 다른 페이지 렌더링 (지연 로딩)
- [x] 8.3 기본 착오 화면(404) 처리
- [x] 8.4 전환 애니메이션 추가 (슬라이드/페이드)

## 9. 더미 페이지 구현 (라우팅 검증)

- [x] 9.1 DashboardPage (홈 페이지)
- [x] 9.2 AvatarPage (내 아바타)
- [x] 9.3 WardrobePage/WardrobeAllPage/WardrobeRecentPage/WardrobeManagePage
- [x] 9.4 HousePage/HouseStructurePage/HouseFurniturePage
- [x] 9.5 WeatherPage/WeatherTodayPage/WeatherWeekPage
- [x] 9.6 CommunityPage
- [x] 9.7 SettingsPage/SettingsProfilePage/SettingsNotificationPage
- [x] 9.8 각 페이지 기본 텍스트/제목만 포함 (나중에 채우기)

## 10. 전역 색상/스타일 시스템

- [x] 10.1 colors.dart 파일 생성 (모노톤 팔레트)
- [x] 10.2 typography.dart 파일 생성 (텍스트 스타일)
- [x] 10.3 spacing_constants.dart 파일 생성 (8px 단계 패딩/마진)
- [x] 10.4 theme_data.dart 생성 (ThemeData 정의)
- [x] 10.5 전체 위젯에 적용

## 11. 에러 처리 및 엣지 케이스

- [x] 11.1 로그인 실패 메시지 표시
- [x] 11.2 인증 없이 메인 화면 접근 시도 → /login 강제 리다이렉트
- [x] 11.3 로그아웃 시 상태 초기화 및 /login 이동
- [x] 11.4 앱 재시작 후 인증 상태 복구 (현재는 메모리만, 향후 local storage)

## 12. 통합 테스트

- [x] 12.1 로그인 → 메인 레이아웃 진입 플로우 테스트
- [x] 12.2 상단 메뉴 선택 → 좌측 메뉴 업데이트 테스트
- [x] 12.3 서브메뉴 선택 → 본문 화면 변경 테스트
- [x] 12.4 로그아웃 → 로그인 페이지 리다이렉트 테스트
- [x] 12.5 각 페이지 라우팅 깊은 링킹 테스트
- [x] 12.6 모바일 화면 크기에서의 레이아웃 수정 (필요시)

## 13. 최종 정리

- [x] 13.1 모든 코드 주석 추가 (한글)
- [x] 13.2 미니멀/모노톤 디자인 일관성 검증
- [x] 13.3 Flutter 분석 도구 실행 (flutter analyze)
- [x] 13.4 코드 포맷팅 (flutter format)
- [x] 13.5 빌드 성공 확인 (flutter build apk --debug는 스킵, 에뮬레이터 테스트만)


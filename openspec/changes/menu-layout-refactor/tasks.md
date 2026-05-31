## 1. 다크 메뉴 색상 상수 추가 (app_theme.dart)

- [x] 1.1 `AppColors`에 `menuBackground(#1A1A2E)`, `menuText(#E0E0E0)`, `menuSelected(#2D2D44)`, `menuHover(#252540)` 상수 추가

## 2. TopMenuBar 레이아웃 수정 (app_layout.dart)

- [x] 2.1 `AppBar.actions`의 메뉴 버튼들을 제거하고, `AppBar.title`에 `Row(children: [타이틀, 메뉴버튼들])` 구조로 이동
- [x] 2.2 `AppBar.backgroundColor`를 `AppColors.menuBackground`로 변경
- [x] 2.3 `AppBar.foregroundColor` 및 텍스트 색상을 `AppColors.menuText`로 변경
- [x] 2.4 선택된 메뉴 버튼 강조 색상을 `AppColors.menuSelected` / `AppColors.menuHover`로 교체
- [x] 2.5 로그아웃 아이콘 버튼은 `AppBar.actions` 우측에 유지 (색상만 `AppColors.menuText`로 변경)

## 3. SideMenuPanel 다크 스타일 적용 (app_layout.dart)

- [x] 3.1 `SideMenuPanel` 컨테이너 배경색을 `AppColors.menuBackground`로 변경
- [x] 3.2 서브메뉴 `ListTile` 텍스트 색상을 `AppColors.menuText`로 변경
- [x] 3.3 서브메뉴 `ListTile` 호버 색상을 `AppColors.menuHover`로 변경
- [x] 3.4 `VerticalDivider` 색상을 다크 테마에 맞게 조정

## 4. 단독 메뉴 즉시 라우팅 검증 (app_layout.dart)

- [x] 4.1 서브메뉴 없는 메뉴(홈·내 아바타·커뮤니티)의 `onPressed`에서 `context.go(defaultRoute)` 호출이 정상 동작하는지 확인
- [x] 4.2 단독 메뉴 클릭 시 `selectedMenuProvider`가 업데이트되고 `SideMenuPanel`이 숨겨지는지 확인 (submenu가 null이면 `SizedBox.shrink()` 반환)

## 5. 검증 및 정리

- [x] 5.1 `flutter analyze`로 오류 없음 확인
- [x] 5.2 `dart format lib/`으로 코드 포맷팅
- [x] 5.3 웹 빌드 확인 (`flutter build web --no-pub`)


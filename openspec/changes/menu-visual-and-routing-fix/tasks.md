## 1. 색상 상수 추가 (app_theme.dart)

- [x] 1.1 `AppColors.sideBackground = Color(0xFF16213E)` 상수 추가 (SideMenuPanel 전용 배경)
- [x] 1.2 `AppColors.menuBorder = Color(0xFF2D2D44)` 상수 추가 (AppBar 하단 구분선 색상)

## 2. TopMenuBar AppBar 하단 구분선 추가 (app_layout.dart)

- [x] 2.1 `AppBar.bottom`에 `PreferredSize(height: 1)` 구분선 위젯 추가 — `AppColors.menuBorder` 색상 적용

## 3. SideMenuPanel 배경색 변경 (app_layout.dart)

- [x] 3.1 `SideMenuPanel` 컨테이너 `color`를 `AppColors.menuBackground` → `AppColors.sideBackground`로 교체

## 4. menuMap route 전체 경로로 정비 (menu_model.dart)

- [x] 4.1 `wardrobe` 서브메뉴 route를 전체 경로로 변경: `/wardrobe/all` → `/home/wardrobe/all`, `/wardrobe/recent` → `/home/wardrobe/recent`, `/wardrobe/manage` → `/home/wardrobe/manage`
- [x] 4.2 `house` 서브메뉴 route 전체 경로로 변경: `/house/structure` → `/home/house/structure`, `/house/furniture` → `/home/house/furniture`
- [x] 4.3 `weather` 서브메뉴 route 전체 경로로 변경: `/weather/today` → `/home/weather/today`, `/weather/week` → `/home/weather/week`
- [x] 4.4 `settings` 서브메뉴 route 전체 경로로 변경: `/settings/profile` → `/home/settings/profile`, `/settings/notification` → `/home/settings/notification`

## 5. SideMenuPanel 라우팅 단순화 (app_layout.dart)

- [x] 5.1 `SideMenuPanel.onTap`에서 `context.go('/home${item.route}')` → `context.go(item.route!)` 로 변경 (route가 이미 전체 경로이므로 접두사 불필요)

## 6. selectedMenuProvider URL 동기화 (app_layout.dart)

- [x] 6.1 `_resolveMenuKey(String location)` 헬퍼 함수 작성 — URL path prefix를 보고 해당 1단계 메뉴 키 반환 (예: `/home/weather/` → `'weather'`, `/home/avatar` → `'avatar'`)
- [x] 6.2 `AppLayout.build`에서 `GoRouterState.of(context).uri.toString()`으로 현재 경로를 읽고, `_resolveMenuKey`로 메뉴 키를 추론 후 `selectedMenuProvider`와 불일치하면 `addPostFrameCallback`으로 동기화

## 7. 검증 및 정리

- [x] 7.1 `flutter analyze`로 오류 없음 확인
- [x] 7.2 `dart format lib/`으로 코드 포맷팅
- [x] 7.3 웹 빌드 확인 (`flutter build web --no-pub`)


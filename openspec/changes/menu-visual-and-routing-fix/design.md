## Context

현재 `app_layout.dart`의 `TopMenuBar`(AppBar)와 `SideMenuPanel` 모두 `AppColors.menuBackground(#1A1A2E)` 동일 색상을 사용합니다. Flutter `Scaffold`에서 AppBar는 상단에, body Row의 첫 번째 자식(SideMenuPanel)은 좌측에 배치되어 있어 색상이 같으면 시각적으로 하나의 덩어리처럼 보입니다.

라우팅 측면에서: `menuMap`의 서브메뉴 `route` 값(`/wardrobe/all` 등)을 `SideMenuPanel.onTap`에서 `/home` 접두사를 붙여 `context.go('/home/wardrobe/all')`로 호출합니다. GoRouter에 등록된 경로는 `/home/wardrobe/all`이므로 이론상 매핑이 맞습니다. 그러나 실제로 GoRouter 17.x의 ShellRoute 내부에서 `context.go`를 호출할 때 inner navigator가 갱신되지 않는 케이스가 확인되며, `selectedMenuProvider` 상태와 실제 URL 간 불일치가 생길 수 있습니다.

**기술 스택**: Flutter/Dart, Riverpod 3.x, GoRouter 17.x, Android+iOS 공통

## Goals / Non-Goals

**Goals:**
- TopMenuBar(AppBar)와 SideMenuPanel의 배경색을 다르게 하여 시각적 구분 제공
- AppBar 하단에 경계선 추가로 상단/본문 영역 구분 명확화
- 가장 하위(leaf) 메뉴 클릭 시 중앙 콘텐츠 영역이 올바른 페이지로 전환됨을 보장
- `menuMap` 경로와 GoRouter 경로 일치 검증 및 정비
- `selectedMenuProvider` 상태가 URL 탐색과 동기화

**Non-Goals:**
- 전체 다크/라이트 모드 전환
- 메뉴 구조(menuMap 트리) 자체 변경
- 새 페이지 추가 — 기존 더미 페이지 활용

## Decisions

### 1. 시각 구분 → 다른 배경색 + AppBar 하단 경계선

**선택**: `AppColors.sideBackground = Color(0xFF16213E)` (TopMenuBar의 `#1A1A2E`보다 약간 진한 네이비)를 신규 추가하고, SideMenuPanel에 적용합니다. 추가로 AppBar의 `bottom` 속성에 1px 구분선(`AppColors.menuBorder = Color(0xFF2D2D44)`)을 추가합니다.

```dart
// app_theme.dart에 추가
static const Color sideBackground = Color(0xFF16213E); // 사이드패널 전용 배경
static const Color menuBorder = Color(0xFF2D2D44);     // 메뉴 영역 구분선
```

**대안 검토:**
- 동일 색상 + 굵은 border만: 경계선이 너무 얇으면 구분 효과 미미 → 색상 차이 병행 선택
- 그라디언트: 코드 복잡성 증가, 기각
- SidePanel에 우측 border만: 상단/좌측 구분 효과 없음, 기각

### 2. 라우팅 수정 → `menuMap` 경로를 GoRouter 전체 경로로 통일

현재 `menuMap` route 값(`/wardrobe/all`)에 `/home` 접두사를 `SideMenuPanel`에서 수동으로 붙이는 방식은 실수 여지가 있습니다. **`menuMap`의 route 값을 GoRouter 전체 경로(`/home/wardrobe/all`)로 변경**하고, `SideMenuPanel.onTap`에서 직접 `context.go(item.route!)`를 사용합니다.

```dart
// menu_model.dart — route를 전체 경로로 변경
MenuItem(id: 'today', label: '오늘의 날씨', route: '/home/weather/today'),

// app_layout.dart — SideMenuPanel.onTap 단순화
onTap: () {
  if (item.route != null) context.go(item.route!);
},
```

**대안 검토:**
- 기존 방식(접두사 붙이기) 유지: 경로 불일치 버그 가능성 지속, 기각
- Named routes 사용: GoRouter named route 리팩터링 필요, 현 스코프 초과, 기각

### 3. `selectedMenuProvider` URL 동기화 → GoRouter `redirect`에서 메뉴 키 추론

GoRouter의 전역 `redirect` 콜백에서 현재 `state.fullPath`를 파싱해 어느 1단계 메뉴에 속하는지 추론하고 `selectedMenuProvider`를 갱신합니다. 단, Provider는 redirect 내에서 직접 갱신할 수 없으므로 `GoRouterDelegate`의 `routerNeglect` 대신 `ref.read`를 쓰는 방법 또는 URL path prefix 매핑 헬퍼를 `AppLayout.build`에서 처리합니다.

```dart
// AppLayout.build 내 — 경로 변경 시 selectedMenuProvider 동기화
final location = GoRouterState.of(context).uri.toString();
final menuKey = _resolveMenuKey(location);
if (menuKey != null && menuKey != ref.read(selectedMenuProvider)) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(selectedMenuProvider.notifier).select(menuKey);
  });
}
```

## Risks / Trade-offs

| 리스크 | 완화 방법 |
|--------|----------|
| `menuMap` route 전체 경로 변경 시 기존 `context.go('/home${item.route}')` 코드가 이중 경로를 만들 수 있음 | `SideMenuPanel.onTap`을 `context.go(item.route!)` 단일 호출로 교체하며 동시 수정 |
| `addPostFrameCallback`으로 selectedMenuProvider 갱신 시 미세한 렌더링 지연 | 로딩 화면이 짧아 사용자에게 인식 불가 수준 |
| GoRouter 17.x의 ShellRoute child 갱신 타이밍 | 정상 navigate 플로우 확인 후 필요 시 `navigatorKey`로 직접 push 방식으로 전환 |


## Context

현재 `AppLayout`은 GoRouter `ShellRoute`의 `builder`에서 `child`로 전달받은 Navigator를 `widget.child`로 본문에 렌더링합니다. GoRouter 17.x에서 `ShellRoute` 내부 Navigator는 leaf 라우트 변경 시 내부 페이지를 업데이트하지만, 이 업데이트가 `AppLayout`의 rebuild를 보장하지 않아 본문 화면이 바뀌지 않습니다.

**기술 스택**: Flutter/Dart, Riverpod 3.x, GoRouter 17.x  
**영향 파일**: `menu_provider.dart`, `app_layout.dart`, `app_router.dart`

## Goals / Non-Goals

**Goals:**
- 좌측 서브메뉴(leaf) 클릭 시 본문 영역이 즉시 해당 페이지로 전환됨을 보장
- 1단계 상단 메뉴 클릭 시 해당 기본 페이지로 본문 즉시 전환
- URL(GoRouter)과 본문 페이지 상태가 항상 동기화됨
- 딥링크(직접 URL 입력)로 진입 시에도 올바른 본문 페이지 표시

**Non-Goals:**
- GoRouter 라우팅 구조 전면 재설계 (ShellRoute 유지)
- 새 페이지 추가 — 기존 더미 페이지 활용
- 애니메이션 방식 변경

## Decisions

### 1. `selectedLeafRouteProvider` 도입 — Riverpod으로 본문 페이지 제어

GoRouter Navigator(`widget.child`)에 의존하는 대신, `StateProvider<String>`으로 현재 leaf 경로를 추적합니다. `AppLayout`은 이 provider를 `ref.watch`하여 해당 경로에 맞는 위젯을 직접 렌더링합니다.

```dart
// menu_provider.dart
final selectedLeafRouteProvider = StateProvider<String>(
  (ref) => '/home/dashboard',
);
```

**대안 검토:**
- GoRouter Navigator 유지 + `AppLayout`에 `setState` 강제: GoRouter 내부 구현 의존으로 불안정
- `StatefulShellRoute`로 교체: GoRouter 17.x에서 별도 API, 대규모 리팩터 필요
- Provider 기반 제어 선택: Riverpod의 반응형 모델로 안정적, 코드 최소 변경 ✓

### 2. 라우트→위젯 매핑 헬퍼 — `menu_provider.dart`에 배치

경로 문자열에서 위젯을 반환하는 순수 함수 `buildPageForRoute(String route)`를 `menu_provider.dart`에 추가합니다. `AppLayout`이 이 함수를 사용해 본문을 렌더링합니다.

```dart
Widget buildPageForRoute(String route) {
  switch (route) {
    case '/home/dashboard': return const DashboardPage();
    case '/home/avatar':    return const AvatarPage();
    // ... 모든 leaf 경로 매핑
    default:                return const DashboardPage();
  }
}
```

**대안 검토:**
- `app_router.dart`에 배치: circular import 위험 (`app_router`가 `app_layout`을, `app_layout`이 `app_router`를 import하면 순환)
- `menu_provider.dart` 배치 선택: 기존 import 관계 유지, 순환 없음 ✓

### 3. `AppLayout`의 본문 렌더링 — `widget.child` 제거, provider 기반

```dart
// Before:
Expanded(child: Container(child: widget.child))

// After:
final leafRoute = ref.watch(selectedLeafRouteProvider);
Expanded(child: Container(child: buildPageForRoute(leafRoute)))
```

`AppLayout`의 `child` 파라미터를 제거하고, `AppRouter`에서도 `AppLayout()` (child 없음)으로 변경합니다. ShellRoute는 auth guard 역할로 유지합니다.

### 4. 전환 애니메이션 — `AnimatedSwitcher`로 페이드 효과 유지

GoRouter의 `_fadeTransition` 대신 `AnimatedSwitcher`를 사용하여 페이지 전환 시 동일한 페이드 효과를 제공합니다.

```dart
AnimatedSwitcher(
  duration: const Duration(milliseconds: 180),
  child: KeyedSubtree(
    key: ValueKey(leafRoute),
    child: buildPageForRoute(leafRoute),
  ),
)
```

## Risks / Trade-offs

| 리스크 | 완화 방법 |
|--------|----------|
| `buildPageForRoute`에서 경로 누락 시 기본값(Dashboard) 표시 | 모든 leaf 경로를 switch에 명시, flutter analyze로 검증 |
| GoRouter URL과 `selectedLeafRouteProvider` 불일치 | `didChangeDependencies`에서 URL → provider 동기화 유지 |
| `AppLayout(child:)` 제거로 기존 ShellRoute builder 수정 필요 | `app_router.dart` 한 곳만 수정, 범위 최소 |


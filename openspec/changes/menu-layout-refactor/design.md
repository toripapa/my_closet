## Context

현재 `lib/pages/layout/app_layout.dart`의 `TopMenuBar`는 Flutter `AppBar`의 `actions` 프로퍼티에 메뉴 버튼들을 배치하고 있어 타이틀 우측에 정렬된다. 이는 웹/태블릿 레이아웃에서 타이틀과 메뉴 간 시각적 분리감을 유발한다.

또한 TopMenuBar와 SideMenuPanel 배경이 모두 `#FFFFFF`(흰색)여서 흰 메인 콘텐츠 영역과 구분되지 않으며, 서브메뉴 없는 메뉴(홈·아바타·커뮤니티)를 클릭해도 `selectedMenuProvider`만 업데이트되고 본문 라우팅이 동작하지 않는 케이스가 존재한다.

**기술 스택**: Flutter/Dart, Riverpod 3.x, GoRouter 17.x  
**제약사항**: Android + iOS 공통 코드, 네이티브 코드 없음, 미니멀리즘 디자인

## Goals / Non-Goals

**Goals:**
- TopMenuBar 메뉴 버튼을 `AppBar.title` Row 내 좌측 배치로 이동
- TopMenuBar / SideMenuPanel 배경을 다크 계열로 변경, 텍스트 색상 대비 보장
- 서브메뉴 없는 1단계 메뉴 클릭 → 즉시 본문 라우팅 처리
- 서브메뉴 있는 메뉴 클릭 → SideMenuPanel 표시 후 첫 서브메뉴로 라우팅
- 다크 색상 상수를 `AppColors`에 추가하여 테마 일관성 유지

**Non-Goals:**
- 모바일 드로어(Drawer) 변환 — 현재 스코프 외
- 다크 모드 전체 전환 — 메뉴 영역만 변경
- 메뉴 구조(menuMap) 변경 — 기존 구조 유지
- 실제 서버 인증 — Mock 유지

## Decisions

### 1. 메뉴 버튼 위치 → `AppBar.title` Row 배치

`AppBar`의 `actions`를 비우고, `title` 속성에 `Row`를 넣어 앱 이름과 메뉴 버튼들을 함께 배치합니다.

```dart
AppBar(
  title: Row(
    children: [
      const Text('My Smart Closet'),
      const SizedBox(width: 24),
      ...menuItems.map((m) => _buildNavBtn(...)),
    ],
  ),
  actions: [logoutButton],
)
```

**대안 검토:**
- `flexibleSpace` 사용: 레이아웃 복잡도 증가, 기각
- `bottom` PreferredSize에 TabBar: 탭 위젯 의존성 추가, 기각
- `title` Row 선택: 가장 단순하고 공통 코드로 처리 가능 ✓

### 2. 다크 배경 색상 → `AppColors`에 상수 추가

`app_theme.dart`의 `AppColors`에 다크 메뉴 전용 색상을 추가합니다:

```dart
static const Color menuBackground = Color(0xFF1A1A2E);  // 다크 네이비
static const Color menuText = Color(0xFFE0E0E0);         // 밝은 회색 텍스트
static const Color menuSelected = Color(0xFF2D2D44);     // 선택 강조
static const Color menuHover = Color(0xFF252540);        // 호버
```

**대안 검토:**
- `ThemeData.dark()` 전체 전환: 메인 영역까지 영향, 기각
- 인라인 색상 하드코딩: 유지보수 어려움, 기각
- `AppColors` 상수 추가 선택 ✓

### 3. 단독 메뉴 즉시 라우팅 → `_buildNavBtn` 내 분기 처리

`menuMap[id] == null`인 메뉴는 클릭 시 바로 `context.go(defaultRoute)`를 호출하고, `selectedMenuProvider`도 업데이트합니다. 이미 router에 등록된 경로(`/home/avatar`, `/home/community` 등)를 사용하므로 라우터 변경은 불필요합니다.

```dart
onPressed: () {
  ref.read(selectedMenuProvider.notifier).select(id);
  context.go(defaultRoute);  // menuMap[id]가 null이든 아니든 항상 이동
},
```

현재 코드도 `context.go(defaultRoute)`를 항상 호출하지만, `wardrobe`, `house` 등 서브메뉴 있는 메뉴에서 `defaultRoute`가 첫 서브메뉴를 가리키도록 이미 설정되어 있어 실질적으로 동작합니다. 단독 메뉴도 동일하게 동작하므로 별도 예외 처리 없이 기존 구조가 유지됩니다.

## Risks / Trade-offs

| 리스크 | 완화 방법 |
|--------|----------|
| `AppBar.title`에 Row 배치 시 메뉴 항목이 많으면 overflow 발생 가능 | `Flexible` + `SingleChildScrollView` 래핑, 현재 7개 항목으로 문제없음 |
| 다크 배경에서 기존 `AppColors.hover`(밝은색) 사용 시 대비 불충분 | 메뉴 전용 `menuHover` 상수 별도 추가 |
| 기존 `AppColors.background` 흰색이 메뉴에 남아있을 경우 | `app_layout.dart`의 모든 색상 참조를 다크 상수로 교체 확인 |


## Context

GoRouter `ShellRoute`의 `child`(내부 Navigator)를 `AppLayout`의 본문에 그대로 전달하면, 라우트 변경 시 GoRouter가 Navigator 페이지를 업데이트하고 `AppLayout`의 `didUpdateWidget`이 호출되어 build가 실행됩니다. 이것이 올바른 GoRouter ShellRoute 사용 방법이며, 이전 fix에서 이를 `selectedLeafRouteProvider`로 대체한 것이 URL이 고정되는 원인이었습니다.

## Goals / Non-Goals

**Goals:**
- GoRouter ShellRoute `child` 기반 라우팅 복원 (실제 URL 변경)
- 12개 라우트별로 시각적으로 명확히 구분되는 페이지 구현
- 앱의 모노톤/미니멀 디자인 일관성 유지
- `selectedLeafRouteProvider` 완전 제거

**Non-Goals:**
- 실제 데이터 연동 (API/DB)
- 복잡한 인터랙션 구현

## Decisions

### 1. AppLayout 복원 — `widget.child`를 본문에 렌더링

```dart
class AppLayout extends ConsumerStatefulWidget {
  final Widget child;  // ShellRoute가 전달하는 Navigator
  const AppLayout({super.key, required this.child});
  ...
  // build에서:
  Expanded(child: Container(child: widget.child))
}
```

`didChangeDependencies`는 `selectedMenuProvider` 동기화용으로만 유지합니다. `selectedLeafRouteProvider` 관련 코드는 모두 제거합니다.

### 2. 페이지 디자인 원칙

- 각 페이지는 독립 파일(`lib/pages/<section>/<name>_page.dart`)
- 공통 레이아웃: `SingleChildScrollView` + `Padding` + 섹션별 카드
- 색상: `AppColors` 팔레트 사용 (배경 흰색, 텍스트 검은색, 구분선 회색)
- 아이콘: Material Icons 단색 검은색
- 각 페이지는 해당 섹션의 기능을 명확히 보여주는 플레이스홀더 UI

### 3. 섹션별 페이지 설계

| 라우트 | 페이지 | 주요 UI 요소 |
|--------|--------|-------------|
| `/home/dashboard` | DashboardPage | 환영 헤더 + 통계 카드 3개(옷장/집/날씨) + 빠른 메뉴 |
| `/home/avatar` | AvatarPage | 아바타 플레이스홀더(대형 아이콘) + 신체 정보 카드 + 스타일 태그 |
| `/home/wardrobe/all` | WardrobeAllPage | 검색바 + 카테고리 필터 + 옷 아이템 그리드(6개 카드) |
| `/home/wardrobe/recent` | WardrobeRecentPage | "최근 7일 추가" + 아이템 리스트 |
| `/home/wardrobe/manage` | WardrobeManagePage | 관리 필요 항목 경고 카드 |
| `/home/house/structure` | HouseStructurePage | 방 구조 카드 그리드(거실/침실/주방 등) |
| `/home/house/furniture` | HouseFurniturePage | 가구 카테고리 리스트 |
| `/home/weather/today` | WeatherTodayPage | 날씨 아이콘 + 온도 + 옷차림 추천 |
| `/home/weather/week` | WeatherWeekPage | 7일 예보 행 리스트 |
| `/home/community` | CommunityPage | 피드 카드 리스트(프로필+텍스트+좋아요) |
| `/home/settings/profile` | SettingsProfilePage | 프로필 정보 필드 폼 |
| `/home/settings/notification` | SettingsNotificationPage | 알림 토글 항목 리스트 |

## Risks / Trade-offs

| 리스크 | 완화 방법 |
|--------|----------|
| GoRouter ShellRoute child 업데이트가 다시 동작 안 할 가능성 | GoRouter 17.x에서 ShellRoute는 child 변경 시 AppLayout rebuild를 보장함. `didChangeDependencies`의 GoRouterState 의존성으로 추가 보장 |
| 페이지 코드량 증가 | 각 파일 분리로 유지보수성 확보, 공통 위젯 패턴 재사용 |


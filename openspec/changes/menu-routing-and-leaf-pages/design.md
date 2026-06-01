## Context

Flutter + GoRouter + Riverpod 기반의 My Closet 앱에서 상단 TopMenuBar와 좌측 SideMenuPanel이 구현되어 있으나, `all_dummy_pages.dart`에서 인라인 더미 클래스와 실제 페이지 파일의 export가 동일 이름으로 중복 정의되어 컴파일 충돌이 발생하는 상태였습니다. 또한 사이드 메뉴에서 현재 활성 항목이 강조 표시되지 않아 UX 피드백이 누락되어 있었습니다.

## Goals / Non-Goals

**Goals:**
- `all_dummy_pages.dart`의 중복 인라인 클래스 제거로 컴파일 충돌 해소
- 각 leaf 메뉴 클릭 시 GoRouter `context.go(route)`를 통해 정확한 페이지로 이동
- 사이드 메뉴에서 현재 URL과 일치하는 항목을 시각적으로 강조 표시
- 이미 구현된 실제 페이지 클래스(WardrobeAllPage 등)가 라우터와 올바르게 연결

**Non-Goals:**
- 새 페이지 UI 신규 설계 (이미 구현된 페이지 재사용)
- 라우터 구조 변경
- 새 외부 의존성 추가

## Decisions

### 결정 1: `all_dummy_pages.dart` → export-only 파일로 전환
- **선택**: 인라인 더미 클래스 전체 삭제, export 구문만 유지
- **이유**: 동일 이름의 클래스가 같은 라이브러리 스코프에 두 번 정의되면 Dart 컴파일러가 ambiguous export 에러를 발생시킴. 실제 페이지 파일이 이미 존재하므로 더미 클래스는 불필요
- **대안 검토**: 더미 클래스에 다른 이름 부여 → export rename 필요, 라우터 수정 필요 → 더 큰 변경 범위로 기각

### 결정 2: 활성 메뉴 감지 — `GoRouterState.of(context).uri` 비교
- **선택**: `SideMenuPanel.build` 내에서 `GoRouterState.of(context).uri.toString()`과 `item.route`를 직접 비교
- **이유**: ShellRoute 내에서 GoRouterState는 InheritedWidget으로 context에서 직접 접근 가능하며, URL 변경 시 자동 rebuild 됨. 별도 Provider 추가 불필요
- **대안 검토**: 별도 `activeSubmenuProvider` 추가 → 상태 동기화 복잡도 증가, URL이 단일 진실 원천인 상황에서 중복

## Risks / Trade-offs

- [Risk] `GoRouterState.of(context)`는 ShellRoute 내부에서만 유효 → `SideMenuPanel`은 항상 ShellRoute 내 `AppLayout` 자식으로 렌더링되므로 문제 없음
- [Risk] route 문자열 완전 일치 비교 → query parameter나 fragment가 붙으면 불일치 가능 → 현재 앱에서 query/fragment를 사용하지 않으므로 허용


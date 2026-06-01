## MODIFIED Requirements

### Requirement: 아바타 상태 Provider
`avatarProvider`는 현재 사용자의 전체 아바타 프로필(`AvatarProfile`)을 관리해야 한다. `AvatarProfile`은 아바타 이미지 URL, 신체 정보 5종, 등록 여부를 포함한다.

#### Scenario: 초기 상태 — 서버 프로필 로드 시도
- **WHEN** 앱이 시작되면
- **THEN** `avatarProvider`는 `GET /api/avatar/profile`을 호출하여 저장된 프로필을 불러와야 한다
- **THEN** 서버에 저장된 프로필이 없으면 `hasAvatar`는 `false`이고 모든 필드는 `null`이어야 한다
- **THEN** 서버 연결 실패 시 `hasAvatar`는 `false`로 폴백되어야 한다

#### Scenario: 프로필 로드 성공 시 상태 복원
- **WHEN** 서버에서 저장된 프로필을 성공적으로 수신하면
- **THEN** `avatarProvider`의 `hasAvatar`는 `true`여야 한다
- **THEN** `avatarProvider`의 `avatarImageUrl`, `height`, `weight`, `topSize`, `bottomSize`, `shoeSize`가 서버 데이터로 채워져야 한다

#### Scenario: 아바타 등록 완료 후 상태 업데이트
- **WHEN** 결과 페이지에서 저장이 성공하면
- **THEN** `avatarProvider`의 `hasAvatar`를 `true`로 업데이트해야 한다
- **THEN** `avatarProvider`의 전체 `AvatarProfile` 필드를 서버 응답값으로 업데이트해야 한다

### Requirement: 아바타 상태가 UI에 반영됨
`/home/avatar` 페이지는 `avatarProvider` 상태를 구독하여 실시간으로 UI를 갱신해야 한다.

#### Scenario: 상태 변경 시 UI 자동 갱신
- **WHEN** `avatarProvider`의 `hasAvatar`가 변경되면
- **THEN** `/home/avatar` 페이지의 버튼이 "아바타 등록" 또는 "아바타 수정"/"아바타 삭제"로 즉시 변경되어야 한다
- **THEN** 신체 정보 표시 영역도 최신 상태로 갱신되어야 한다


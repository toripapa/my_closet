## ADDED Requirements

### Requirement: 아바타 상태 Provider
`avatarProvider`는 현재 사용자의 아바타 등록 여부와 아바타 이미지 데이터를 관리해야 한다.

#### Scenario: 초기 상태 — 아바타 미등록
- **WHEN** 앱이 시작되면
- **THEN** `avatarProvider`의 `hasAvatar`는 `false`여야 한다
- **THEN** `avatarProvider`의 `avatarImageUrl`은 `null`이어야 한다

#### Scenario: 아바타 등록 완료 후 상태 업데이트
- **WHEN** 서버로부터 아바타 이미지 결과를 수신하면
- **THEN** `avatarProvider`의 `hasAvatar`를 `true`로 업데이트해야 한다
- **THEN** `avatarProvider`의 `avatarImageUrl`을 수신된 URL/Base64로 업데이트해야 한다

### Requirement: 아바타 상태가 UI에 반영됨
`/home/avatar` 페이지는 `avatarProvider` 상태를 구독하여 실시간으로 UI를 갱신해야 한다.

#### Scenario: 상태 변경 시 UI 자동 갱신
- **WHEN** `avatarProvider`의 `hasAvatar`가 변경되면
- **THEN** `/home/avatar` 페이지의 버튼이 "아바타 등록" 또는 "아바타 수정"으로 즉시 변경되어야 한다


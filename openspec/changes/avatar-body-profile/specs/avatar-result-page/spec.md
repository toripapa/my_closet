## ADDED Requirements

### Requirement: 아바타 결과 및 신체 정보 입력 페이지 표시
`/home/avatar/result` 페이지는 서버에서 생성된 아바타 이미지와 신체 정보 입력 폼을 함께 표시해야 한다.

#### Scenario: 결과 페이지 진입 시 아바타 이미지 표시
- **WHEN** 사용자가 카메라 촬영 후 서버 아바타 생성이 완료되면
- **THEN** `/home/avatar/result` 페이지로 이동해야 한다
- **THEN** 생성된 아바타 이미지가 페이지 상단에 표시되어야 한다

#### Scenario: 신체 정보 입력 폼 표시
- **WHEN** `/home/avatar/result` 페이지가 표시되면
- **THEN** 키(cm), 몸무게(kg), 상의 사이즈, 하의 사이즈, 신발 사이즈 입력 필드가 표시되어야 한다
- **THEN** 각 입력 필드는 선택적으로 입력 가능해야 한다 (필수 입력 아님)

### Requirement: 신체 정보 저장
"저장" 버튼을 클릭하면 아바타 이미지 URL과 신체 정보를 서버에 저장하고 아바타 페이지로 이동해야 한다.

#### Scenario: 저장 버튼 클릭 시 서버 전송 및 이동
- **WHEN** 사용자가 신체 정보를 입력하고 "저장" 버튼을 클릭하면
- **THEN** 시스템은 아바타 이미지 URL과 신체 정보를 `POST /api/avatar/profile`로 전송해야 한다
- **THEN** 저장 중 로딩 인디케이터를 표시해야 한다
- **THEN** 저장 성공 시 `avatarProvider`를 업데이트하고 `/home/avatar`로 이동해야 한다

#### Scenario: 저장 실패 시 오류 표시
- **WHEN** 서버 저장이 실패하면
- **THEN** 오류 스낵바를 표시하고 결과 페이지에 머물러야 한다


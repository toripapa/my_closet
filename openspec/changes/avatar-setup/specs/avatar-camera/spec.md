## ADDED Requirements

### Requirement: 카메라 촬영 및 이미지 선택
시스템은 `image_picker` 패키지를 통해 카메라 촬영 기능을 제공해야 한다. Android와 iOS 모두 동일한 코드로 동작해야 한다.

#### Scenario: 카메라 촬영 성공
- **WHEN** 사용자가 카메라로 사진을 촬영하면
- **THEN** 촬영된 이미지를 서버에 전송하는 흐름으로 진행해야 한다
- **THEN** 처리 중 로딩 인디케이터를 표시해야 한다

#### Scenario: 카메라 촬영 취소
- **WHEN** 사용자가 카메라를 실행했다가 취소하면
- **THEN** 시스템은 가이드 페이지로 돌아가야 한다

### Requirement: 이미지 업로드 및 아바타 생성 요청
촬영된 이미지를 `my_closet_server`의 아바타 생성 API에 multipart/form-data 형식으로 전송해야 한다.

#### Scenario: 이미지 업로드 성공 후 아바타 결과 표시
- **WHEN** 서버에서 아바타 생성이 완료되면
- **THEN** 생성된 아바타 이미지를 `/home/avatar` 페이지에 표시해야 한다
- **THEN** avatarProvider의 상태를 "등록 완료"로 업데이트해야 한다

#### Scenario: 업로드/생성 실패 처리
- **WHEN** 서버 통신 또는 아바타 생성이 실패하면
- **THEN** 오류 메시지를 사용자에게 표시해야 한다
- **THEN** 아바타 페이지로 돌아가야 한다


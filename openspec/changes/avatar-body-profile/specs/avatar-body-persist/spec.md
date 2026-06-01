## ADDED Requirements

### Requirement: 아바타 프로필 저장 API
`my_closet_server`는 `POST /api/avatar/profile` 엔드포인트를 통해 아바타 이미지 URL과 신체 정보를 SQLite DB에 저장(upsert)해야 한다.

#### Scenario: 유효한 프로필 데이터 저장 성공
- **WHEN** 클라이언트가 아바타 URL과 신체 정보를 JSON으로 전송하면
- **THEN** 서버는 `avatar_profiles` 테이블에 upsert로 저장해야 한다
- **THEN** HTTP 200과 저장된 프로필 데이터를 JSON으로 반환해야 한다

#### Scenario: 중복 저장 시 upsert 처리
- **WHEN** 이미 프로필이 존재하는 상태에서 저장 요청이 오면
- **THEN** 서버는 기존 레코드를 업데이트(upsert)해야 한다
- **THEN** HTTP 200을 반환해야 한다

### Requirement: 아바타 프로필 조회 API
`my_closet_server`는 `GET /api/avatar/profile` 엔드포인트를 통해 저장된 아바타 프로필을 반환해야 한다.

#### Scenario: 프로필 존재 시 조회 성공
- **WHEN** 클라이언트가 `GET /api/avatar/profile`을 요청하면
- **THEN** 서버는 저장된 아바타 URL과 신체 정보를 JSON으로 반환해야 한다
- **THEN** HTTP 200을 반환해야 한다

#### Scenario: 프로필 미존재 시 응답
- **WHEN** 저장된 프로필이 없는 상태에서 `GET /api/avatar/profile`을 요청하면
- **THEN** 서버는 HTTP 404를 반환해야 한다

### Requirement: 신체 정보 입력값 서버 검증
서버는 전달받은 신체 정보의 유효 범위를 검증해야 한다.

#### Scenario: 키 범위 검증
- **WHEN** 키 값이 50cm 미만이거나 250cm 초과인 경우
- **THEN** 서버는 HTTP 422와 검증 오류 메시지를 반환해야 한다

#### Scenario: 몸무게 범위 검증
- **WHEN** 몸무게 값이 10kg 미만이거나 300kg 초과인 경우
- **THEN** 서버는 HTTP 422와 검증 오류 메시지를 반환해야 한다


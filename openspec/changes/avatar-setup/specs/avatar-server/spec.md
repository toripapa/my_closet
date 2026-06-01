## ADDED Requirements

### Requirement: 아바타 생성 API 엔드포인트
`my_closet_server`는 `POST /api/avatar/generate` 엔드포인트를 제공해야 한다. 클라이언트로부터 이미지를 수신하고, 배경 제거 → LLM 아바타 생성 → 결과 반환 파이프라인을 실행해야 한다.

#### Scenario: 유효한 이미지 수신 및 처리 성공
- **WHEN** 클라이언트가 유효한 이미지 파일(JPEG/PNG, 5MB 이하)을 multipart/form-data로 전송하면
- **THEN** 서버는 배경 제거 처리 후 LLM API에 아바타 생성을 요청해야 한다
- **THEN** 생성된 아바타 이미지 URL 또는 Base64를 JSON 응답으로 반환해야 한다
- **THEN** HTTP 200 상태코드를 반환해야 한다

#### Scenario: 유효하지 않은 이미지 형식 거부
- **WHEN** 클라이언트가 허용되지 않는 형식의 파일을 전송하면
- **THEN** 서버는 HTTP 400 상태코드와 오류 메시지를 반환해야 한다

#### Scenario: 5MB 초과 이미지 거부
- **WHEN** 클라이언트가 5MB를 초과하는 이미지를 전송하면
- **THEN** 서버는 HTTP 413 상태코드와 오류 메시지를 반환해야 한다

### Requirement: API 키 보안 관리
서버의 LLM API 키는 소스코드에 하드코딩하지 않고 환경변수(`.env`)로만 관리해야 한다.

#### Scenario: 환경변수 미설정 시 서버 시작 실패
- **WHEN** `.env` 파일에 필수 API 키가 설정되지 않은 상태로 서버를 시작하면
- **THEN** 서버는 명확한 오류 메시지를 출력하고 시작을 거부해야 한다

### Requirement: 서버 레이어 분리
비즈니스 로직(배경 제거, LLM 호출)은 라우터가 아닌 서비스 레이어에 구현해야 한다.

#### Scenario: 라우터는 요청/응답 처리만 담당
- **WHEN** 아바타 생성 API가 호출되면
- **THEN** 라우터는 입력 검증과 응답 직렬화만 처리해야 한다
- **THEN** 배경 제거 및 LLM 호출 로직은 AvatarService 클래스에서 처리해야 한다


## ADDED Requirements

### Requirement: 아바타 삭제 버튼 표시
아바타가 등록된 상태에서 `/home/avatar` 페이지는 "아바타 삭제" 버튼을 표시해야 한다.

#### Scenario: 아바타 등록 완료 후 삭제 버튼 노출
- **WHEN** 사용자가 아바타를 등록한 상태로 `/home/avatar` 페이지를 표시하면
- **THEN** "아바타 수정" 버튼과 "아바타 삭제" 버튼이 모두 표시되어야 한다

### Requirement: 아바타 삭제 확인 및 실행
"아바타 삭제" 버튼 클릭 시 확인 다이얼로그를 표시하고, 확인 시 서버 데이터를 삭제한 후 UI를 초기화해야 한다.

#### Scenario: 삭제 버튼 클릭 시 확인 다이얼로그 표시
- **WHEN** 사용자가 "아바타 삭제" 버튼을 클릭하면
- **THEN** "정말 삭제하시겠습니까?" 확인 다이얼로그가 표시되어야 한다
- **THEN** "취소"와 "삭제" 버튼이 표시되어야 한다

#### Scenario: 삭제 확인 시 서버 데이터 삭제 및 UI 초기화
- **WHEN** 사용자가 다이얼로그에서 "삭제"를 클릭하면
- **THEN** 시스템은 `DELETE /api/avatar/profile`을 호출해야 한다
- **THEN** 성공 시 `avatarProvider`를 초기 상태(`hasAvatar=false`)로 초기화해야 한다
- **THEN** `/home/avatar` 페이지가 "아바타 등록" 버튼 상태로 갱신되어야 한다

#### Scenario: 삭제 취소
- **WHEN** 사용자가 다이얼로그에서 "취소"를 클릭하면
- **THEN** 다이얼로그가 닫히고 아무 변경 없이 현재 페이지를 유지해야 한다

### Requirement: 아바타 삭제 API
`my_closet_server`는 `DELETE /api/avatar/profile` 엔드포인트를 통해 저장된 아바타 프로필을 삭제해야 한다.

#### Scenario: 프로필 삭제 성공
- **WHEN** 클라이언트가 `DELETE /api/avatar/profile`을 요청하면
- **THEN** 서버는 DB에서 해당 프로필 레코드를 삭제해야 한다
- **THEN** HTTP 200을 반환해야 한다

#### Scenario: 삭제 대상 없음
- **WHEN** 저장된 프로필이 없는 상태에서 DELETE를 요청하면
- **THEN** 서버는 HTTP 404를 반환해야 한다


# User Authentication (Mock Login)

## Overview

Mock 인증 시스템으로 클라이언트 단에서 고정 계정 정보로 사용자를 인증합니다.

## Requirements

- **로그인 진입점**: 앱 시작 시 로그인 페이지가 먼저 표시됨
- **고정 계정**: ID "gagamel" / PW "1234"만 수락
- **상태 관리**: 로그인 성공 시 isAuthenticated = true로 전환
- **에러 처리**: 실패 시 사용자 친화적 에러 메시지 표시
- **로그아웃**: 사용자가 언제든 로그아웃 가능, 로그인 화면으로 복귀

## Inputs

- 사용자 입력: ID, Password (텍스트 필드)

## Outputs

- 성공: 전역 인증 상태 업데이트 (authProvider.isAuthenticated = true)
- 실패: 오류 메시지 팝업, 상태 유지

## Acceptance Criteria

- [ ] 올바른 ID/PW 입력 시 홈 화면으로 라우팅
- [ ] 잘못된 입력 시 에러 메시지 표시 후 폼 유지
- [ ] 로그인 상태는 메모리에 유지 (앱 재시작 시 초기화)

## Notes

- 향후 실제 인증 서버는 쉽게 대체 가능하도록 AuthNotifier 인터페이스 유지
- 환경변수로 테스트 계정 관리 가능하게 구성


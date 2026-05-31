# Menu-Based Navigation and Routing

## Overview

사용자의 메뉴 선택에 따라 동적으로 좌측 서브메뉴를 업데이트하고, 선택된 서브메뉴에 따라 본문 화면을 라우팅합니다.

## Menu Structure

### Top Menu (Level 1)

- 홈
- 내 아바타
- 내 옷장
- 나의 집
- 날씨
- 커뮤니티
- 설정

### Sub-Menu (Level 2)

#### 내 옷장
- 전체
- 최근 등록
- 관리 필요

#### 나의 집
- 현재 집 구조
- 전체 가구

#### 날씨
- 오늘의 날씨
- 이번주 날씨

#### 설정
- 회원정보
- 알림

(홈, 내 아바타, 커뮤니티는 서브메뉴 없음 → 즉시 본문 라우팅)

## Requirements

- **1단계 메뉴 클릭**: selectedMenuProvider 업데이트
- **2단계 메뉴 렌더링**: submenuProvider에서 서브메뉴 목록 로드
- **2단계 메뉴 클릭**: GoRouter로 해당 페이지 라우팅
- **라우트 경로**: /home, /wardrobe/:id, /house/:id 등 구조화
- **선택 상태 표시**: 현재 선택된 메뉴/서브메뉴 강조

## Inputs

- 사용자 메뉴 클릭

## Outputs

- 좌측 메뉴 목록 동적 업데이트
- 본문 페이지 변경
- URL 변경 (deep linking 지원)

## Acceptance Criteria

- [ ] 상단 메뉴 클릭 → 좌측 메뉴 업데이트
- [ ] 서브메뉴 클릭 → 본문 화면 변경
- [ ] 직접 라우팅 메뉴 (홈/커뮤니티) → 좌측 메뉴 숨김
- [ ] 라우트 기반 deep linking 작동

## Notes

- menuMap 데이터 구조로 메뉴 매핑 관리
- Riverpod의 StateProvider로 선택 상태 관리
- GoRouter의 선언적 라우팅으로 구현


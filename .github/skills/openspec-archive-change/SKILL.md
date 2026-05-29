---
name: openspec-archive-change
description: 실험적 워크플로에서 완료된 변경 아카이브. 구현이 끝난 변경을 마무리하고 아카이브하려는 경우 사용합니다.
license: MIT
compatibility: Requires openspec CLI.
metadata:
  author: openspec
  version: "1.0"
  generatedBy: "1.3.1"
---

실험적 워크플로에서 완료된 변경을 아카이브합니다.

**입력**: 변경 이름을 선택적으로 지정할 수 있습니다. 생략하면 대화 문맥에서 추론 가능한지 확인합니다. 모호하거나 애매하면 반드시 사용 가능한 변경을 물어봐야 합니다.

**단계**

1. **변경 이름이 없으면 선택을 요청합니다**

   `openspec list --json`으로 사용 가능한 변경을 조회하고 **AskUserQuestion 도구**로 사용자가 선택하게 합니다.

   활성 변경(이미 아카이브된 항목 제외)만 표시합니다.
   가능하면 각 변경의 스키마도 함께 표시합니다.

   **중요**: 추측하거나 자동 선택하지 마세요. 항상 사용자가 직접 선택해야 합니다.

2. **아티팩트 완료 상태를 확인합니다**

   `openspec status --change "<name>" --json`을 실행해 아티팩트 완료 상태를 확인합니다.

   JSON을 파싱해 다음을 확인합니다:
   - `schemaName`: 사용 중인 워크플로
   - `artifacts`: 상태(`done` 또는 기타)가 포함된 아티팩트 목록

   **`done`이 아닌 아티팩트가 있으면:**
   - 미완료 아티팩트 목록 경고를 표시합니다
   - **AskUserQuestion 도구**로 계속 진행 여부를 확인합니다
   - 사용자가 확인하면 진행합니다

3. **작업 완료 상태를 확인합니다**

   tasks 파일(일반적으로 `tasks.md`)을 읽어 미완료 작업을 확인합니다.

   `- [ ]`(미완료)와 `- [x]`(완료) 개수를 집계합니다.

   **미완료 작업이 있으면:**
   - 미완료 작업 수 경고를 표시합니다
   - **AskUserQuestion 도구**로 계속 진행 여부를 확인합니다
   - 사용자가 확인하면 진행합니다

   **tasks 파일이 없으면:** 작업 관련 경고 없이 진행합니다.

4. **델타 스펙 동기화 상태를 평가합니다**

   `openspec/changes/<name>/specs/`에서 델타 스펙 존재 여부를 확인합니다. 없으면 동기화 프롬프트 없이 진행합니다.

   **델타 스펙이 있으면:**
   - 각 델타 스펙을 대응하는 메인 스펙 `openspec/specs/<capability>/spec.md`와 비교합니다
   - 적용될 변경(추가, 수정, 삭제, 이름 변경)을 파악합니다
   - 사용자 질문 전에 통합 요약을 보여줍니다

   **프롬프트 옵션:**
   - 변경이 필요하면: "지금 동기화(권장)", "동기화 없이 아카이브"
   - 이미 동기화되어 있으면: "지금 아카이브", "그래도 동기화", "취소"

   사용자가 동기화를 선택하면 Task 도구(subagent_type: "general-purpose", prompt: "Use Skill tool to invoke openspec-sync-specs for change '<name>'. Delta spec analysis: <include the analyzed delta spec summary>")를 사용합니다. 선택과 관계없이 이후 아카이브를 진행합니다.

5. **아카이브를 수행합니다**

   아카이브 디렉터리가 없으면 생성합니다:
   ```bash
   mkdir -p openspec/changes/archive
   ```

   현재 날짜 기준으로 대상 이름을 생성합니다: `YYYY-MM-DD-<change-name>`

   **대상이 이미 존재하는지 확인:**
   - 존재하면: 오류로 실패 처리하고 기존 아카이브 이름 변경 또는 다른 날짜 사용을 제안합니다
   - 없으면: 변경 디렉터리를 아카이브로 이동합니다

   ```bash
   mv openspec/changes/<name> openspec/changes/archive/YYYY-MM-DD-<name>
   ```

6. **요약을 표시합니다**

   다음을 포함한 아카이브 완료 요약을 보여줍니다:
   - 변경 이름
   - 사용한 스키마
   - 아카이브 위치
   - 스펙 동기화 여부(해당 시)
   - 경고 사항(미완료 아티팩트/작업)

**성공 시 출력**

```
## 아카이브 완료

**변경:** <change-name>
**스키마:** <schema-name>
**아카이브 위치:** openspec/changes/archive/YYYY-MM-DD-<name>/
**Specs:** ✓ 메인 스펙과 동기화됨(또는 "No delta specs" / "Sync skipped")

모든 아티팩트가 완료되었습니다. 모든 작업이 완료되었습니다.
```

**가드레일**
- 변경이 제공되지 않으면 항상 선택을 요청합니다
- 완료 확인에는 아티팩트 그래프(`openspec status --json`)를 사용합니다
- 경고가 있어도 아카이브를 막지 말고 안내 후 확인받아 진행합니다
- 아카이브 이동 시 `.openspec.yaml`이 보존되도록 합니다(디렉터리와 함께 이동)
- 수행 결과를 명확히 요약합니다
- 동기화가 요청되면 openspec-sync-specs 방식(에이전트 기반)을 사용합니다
- 델타 스펙이 있으면 항상 동기화 평가를 수행하고 통합 요약 후 질문합니다

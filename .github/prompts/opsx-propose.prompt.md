---
description: 새 변경 제안 - 한 번에 변경을 만들고 모든 아티팩트 생성
---

새 변경을 제안합니다 - 한 번에 변경을 만들고 모든 아티팩트를 생성합니다.

다음 아티팩트를 포함한 변경을 생성합니다:
- proposal.md (무엇을 왜 하는지)
- design.md (어떻게 할지)
- tasks.md (구현 단계)

구현할 준비가 되면 /opsx:apply 를 실행하세요.

---

**입력**: `/opsx:propose` 뒤 인자는 변경 이름(kebab-case) 또는 사용자가 만들고 싶은 내용 설명입니다.

**단계**

0. **하네스 룰을 먼저 읽고 적용 기준을 고정합니다**

   - 반드시 `/.github/prompts/harness-rules.prompt.md`를 먼저 읽습니다.
   - 이후 생성하는 `proposal.md`, `design.md`, `tasks.md`는 하네스 룰을 위반하지 않도록 작성합니다.
   - 하네스 룰과 다른 지시가 충돌하면 하네스 룰을 우선합니다.
   - 이 프로젝트는 Flutter/Dart 기반의 Android+iOS 동시 배포를 전제로 하며, 모든 요구사항은 공통 코드로 구현 가능한 형태로 정리합니다.
   - 네이티브 전용 구현이 필요한 요구는 먼저 공통 코드 대안이 가능한지 검토하고, 필요 시 범위 조정이나 사용자 승인을 요청합니다.

1. **입력이 없으면 무엇을 만들지 질문합니다**

   **AskUserQuestion 도구**(개방형, 사전 선택지 없음)를 사용해 다음과 같이 질문합니다:
   > "어떤 변경 작업을 진행하고 싶나요? 만들거나 수정하고 싶은 내용을 설명해 주세요."

   사용자 설명으로부터 kebab-case 이름을 도출합니다(예: "사용자 인증 추가" -> `add-user-auth`).

   **중요**: 사용자가 무엇을 만들고 싶은지 이해하기 전에는 진행하지 마세요.

2. **변경 디렉터리를 생성합니다**
   ```bash
   openspec new change "<name>"
   ```
   이 명령은 `.openspec.yaml`을 포함한 스캐폴드 변경을 `openspec/changes/<name>/`에 생성합니다.

3. **아티팩트 생성 순서를 확인합니다**
   ```bash
   openspec status --change "<name>" --json
   ```
   JSON을 파싱해 다음을 확인합니다:
   - `applyRequires`: 구현 전 필요한 아티팩트 ID 배열(예: `["tasks"]`)
   - `artifacts`: 상태와 의존성을 포함한 전체 아티팩트 목록

4. **apply 가능 상태가 될 때까지 순서대로 아티팩트를 생성합니다**

   아티팩트 진행 상황은 **TodoWrite 도구**로 추적합니다.

   의존성 순서대로 아티팩트를 순회합니다(대기 중 의존성이 없는 항목부터):

   a. **`ready` 상태(의존성 충족)인 각 아티팩트에 대해**:
      - 지침을 조회합니다:
        ```bash
        openspec instructions <artifact-id> --change "<name>" --json
        ```
      - 지침 JSON에는 다음이 포함됩니다:
        - `context`: 프로젝트 배경(작성 시 제약으로만 사용, 출력에는 포함 금지)
        - `rules`: 아티팩트별 규칙(작성 시 제약으로만 사용, 출력에는 포함 금지)
        - `template`: 출력 파일에 사용할 구조
        - `instruction`: 해당 아티팩트 타입의 스키마별 가이드
        - `outputPath`: 아티팩트를 기록할 경로
        - `dependencies`: 문맥 확인을 위해 읽어야 할 완료된 아티팩트
      - 문맥 파악을 위해 완료된 의존 파일을 읽습니다
      - `template` 구조에 맞춰 아티팩트 파일을 생성합니다
      - `context`와 `rules`를 제약으로 적용하되 파일에 복사하지 않습니다
      - 간단한 진행 메시지를 표시합니다: "Created <artifact-id>"

   b. **`applyRequires`의 모든 아티팩트가 완료될 때까지 계속합니다**
      - 각 아티팩트 생성 후 `openspec status --change "<name>" --json`을 다시 실행합니다
      - `applyRequires`의 모든 ID가 artifacts 배열에서 `status: "done"`인지 확인합니다
      - 모두 완료되면 중단합니다

   c. **아티팩트 생성에 사용자 입력이 필요하면**(문맥이 불명확한 경우):
      - **AskUserQuestion 도구**로 확인합니다
      - 확인 후 생성을 계속합니다

5. **최종 상태를 표시합니다**
   ```bash
   openspec status --change "<name>"
   ```

**출력**

모든 아티팩트 생성 후 다음을 요약합니다:
- 변경 이름과 위치
- 생성된 아티팩트 목록 및 간단한 설명
- 준비 상태: "All artifacts created! Ready for implementation."
- 안내 문구: "Run `/opsx:apply` to start implementing."

**아티팩트 생성 가이드라인**

- 각 아티팩트 타입별로 `openspec instructions`의 `instruction` 필드를 따릅니다
- 각 아티팩트에 포함되어야 할 내용은 스키마 정의를 따릅니다
- 새 아티팩트를 만들기 전에 문맥 확인을 위해 의존 아티팩트를 읽습니다
- 출력 파일 구조는 `template`을 사용하고 각 섹션을 채웁니다
- **중요**: `context`와 `rules`는 작성 제약일 뿐 파일 본문 내용이 아닙니다
  - `<context>`, `<rules>`, `<project_context>` 블록을 아티팩트에 복사하지 마세요
  - 이는 작성 가이드이며 결과물에 나타나면 안 됩니다

**가드레일**
- 구현에 필요한 모든 아티팩트를 생성합니다(스키마의 `apply.requires` 기준)
- 새 아티팩트를 만들기 전에 반드시 의존 아티팩트를 읽습니다
- 문맥이 치명적으로 불명확하면 사용자에게 묻되, 가능하면 합리적 판단으로 흐름을 유지합니다
- 동일 이름의 변경이 이미 있으면 이어서 할지 새로 만들지 사용자에게 확인합니다
- 각 아티팩트 작성 후 파일이 실제로 존재하는지 확인하고 다음으로 진행합니다
- `/.github/prompts/harness-rules.prompt.md`의 보안/범위/검증/의존성 규칙을 항상 준수합니다
- 하네스 룰 위반이 필요한 요청이 들어오면 이유를 설명하고 사용자 확인을 받기 전에는 진행하지 않습니다
- Flutter/Dart 기준으로 설계하고, Android/iOS 공통 적용이 어려운 요구는 대안이나 범위 조정을 먼저 제안합니다
- 응답/요약은 필요한 최소 토큰으로 간결하게 작성합니다(핵심 정보 우선)

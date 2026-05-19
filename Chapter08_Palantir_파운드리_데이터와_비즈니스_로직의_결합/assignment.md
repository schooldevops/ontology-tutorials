# 8강 과제: Rule, Action, Workflow, Write-back 명세 작성하기

## 과제 목표

이번 과제는 온톨로지 객체의 상태를 기반으로 비즈니스 Rule을 평가하고, 실행 가능한 Action과 Workflow를 설계하는 것입니다.

## 제출물

`Chapter08_Palantir_파운드리_데이터와_비즈니스_로직의_결합/submission.md` 파일을 작성한다고 가정하고, 아래 항목을 모두 포함해 작성하세요.

## 과제 1. 핵심 개념 설명

아래 개념을 본인의 말로 설명하세요.

| 개념 | 설명 | 예시 |
| --- | --- | --- |
| Rule |  |  |
| Action |  |  |
| Workflow |  |  |
| Write-back |  |  |
| Audit Log |  |  |

반드시 포함할 키워드:

- 조건
- 실행 가능 여부
- 상태 전이
- 권한
- 승인
- 외부 시스템 기록

## 과제 2. 샘플 분석

다음 파일을 읽습니다.

- `samples/rule_action_matrix.md`
- `samples/business_logic_ontology.ttl`

아래 질문에 답하세요.

1. `R004_HighRiskRetentionTarget`은 왜 단일 객체만으로 판단하기 어려운 Rule인가요?
2. `OfferRetentionDiscount` Action이 `requiresApproval true`인 이유를 설명하세요.
3. `RetryPayment`와 `EscalateTicket`은 각각 어떤 시스템에 write-back하나요?
4. `WorkflowCase`가 없으면 운영 추적에서 어떤 정보가 부족해지나요?
5. `AuditLog`는 AI 에이전트가 Action을 실행할 때 왜 중요한가요?

## 과제 3. Rule 설계

다음 상황을 기반으로 Rule을 5개 이상 작성하세요.

> 활성 구독 고객이 최근 결제 실패를 경험했고, 갱신일이 30일 이내이며, 결제 실패 관련 CS 티켓이 열려 있다. 이 고객은 유지 관리 대상이며, 담당자 배정과 유지 쿠폰 제안이 필요하다.

각 Rule은 아래 형식으로 작성하세요.

| Rule ID | 이름 | 조건 | 결과 |
| --- | --- | --- | --- |
| R001 |  |  |  |

반드시 하나 이상의 Rule은 여러 객체의 상태를 함께 평가해야 합니다.

## 과제 4. Action 명세 작성

과제 3의 Rule에 연결되는 Action을 5개 이상 설계하세요.

각 Action마다 다음 항목을 작성하세요.

| Action | 대상 객체 | Trigger Rule | 실행 조건 | 입력값 | 실행 효과 | 권한/승인 | Write-back |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |

반드시 포함할 Action:

- AssignRetentionManager
- OfferRetentionDiscount
- RetryPayment
- EscalateTicket
- CloseWorkflowCase

## 과제 5. Workflow 상태 전이 설계

아래 워크플로우를 설계하세요.

```text
PaymentFailureRetention
```

필수 포함 상태:

- CREATED
- RISK_EVALUATED
- MANAGER_ASSIGNED
- OFFER_SENT
- PAYMENT_RETRIED
- RESOLVED
- ESCALATED

아래 표 형식으로 작성하세요.

| 현재 상태 | 이벤트 또는 Action | 다음 상태 | 실패 시 처리 |
| --- | --- | --- | --- |
| CREATED |  |  |  |

## 과제 6. AI 에이전트 실행 안전장치

AI 에이전트가 `OfferRetentionDiscount`를 실행한다고 가정하고, 실행 전후 검증 절차를 작성하세요.

반드시 포함할 내용:

- 대상 객체 검증
- Rule 평가 결과 확인
- 실행 권한 확인
- 승인 필요 여부 판단
- write-back 성공/실패 처리
- 감사 로그 기록
- 실행 후 온톨로지 상태 갱신

## 과제 7. 미니 Turtle 초안 작성

과제 3~5의 내용을 바탕으로 간단한 Turtle 초안을 작성하세요.

필수 조건:

- `Rule` 인스턴스 5개 이상
- `Action` 인스턴스 5개 이상
- `WorkflowCase` 인스턴스 1개 이상
- `ExternalSystem` 인스턴스 3개 이상
- `AuditLog` 인스턴스 1개 이상
- `triggeredByRule`, `availableAction`, `writesBackTo`, `hasAuditLog` 관계 사용

## 평가 기준

| 평가 항목 | 배점 | 설명 |
| --- | ---: | --- |
| Rule 설계 | 25 | 객체 상태와 관계를 기반으로 조건을 명확히 정의했는가 |
| Action 명세 | 30 | 실행 조건, 효과, 권한, write-back을 구체적으로 작성했는가 |
| Workflow 설계 | 25 | 상태 전이와 실패 처리를 운영 관점에서 설계했는가 |
| 안전장치 | 20 | AI 에이전트 Action 실행 시 검증과 감사 절차를 포함했는가 |

## 제출 예시 템플릿

```markdown
# 8강 과제 제출

## 과제 1. 핵심 개념 설명

| 개념 | 설명 | 예시 |
| --- | --- | --- |
| Rule |  |  |

## 과제 2. 샘플 분석

...

## 과제 3. Rule 설계

| Rule ID | 이름 | 조건 | 결과 |
| --- | --- | --- | --- |
| R001 | 결제 실패 위험 |  |  |

## 과제 4. Action 명세 작성

| Action | 대상 객체 | Trigger Rule | 실행 조건 | 입력값 | 실행 효과 | 권한/승인 | Write-back |
| --- | --- | --- | --- | --- | --- | --- | --- |
| AssignRetentionManager | CustomerAccount | R004 |  |  |  |  | CRM |

## 과제 5. Workflow 상태 전이 설계

| 현재 상태 | 이벤트 또는 Action | 다음 상태 | 실패 시 처리 |
| --- | --- | --- | --- |
| CREATED | PaymentFailed | RISK_EVALUATED |  |

## 과제 6. AI 에이전트 실행 안전장치

...

## 과제 7. 미니 Turtle 초안

```turtle
...
```
```

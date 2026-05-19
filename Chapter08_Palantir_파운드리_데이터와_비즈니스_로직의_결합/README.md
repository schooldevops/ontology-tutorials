# 8강: Palantir 파운드리: 데이터와 비즈니스 로직의 결합

## 강의 개요

7강에서는 Palantir식 온톨로지를 기업의 디지털 트윈으로 이해했습니다. 8강에서는 그 디지털 트윈 위에 비즈니스 로직을 결합하는 방법을 학습합니다.

운영형 온톨로지의 핵심은 객체를 단순히 조회하는 데서 끝나지 않는다는 점입니다. 객체의 상태를 읽고, 규칙을 평가하고, 적절한 Action을 실행하며, 그 결과를 원천 시스템에 다시 기록합니다.

```text
Data Object -> Rule Evaluation -> Action -> Write-back -> Updated Object State
```

이 흐름이 만들어지면 온톨로지는 정적인 데이터 모델이 아니라 업무 실행 레이어가 됩니다.

## 학습 목표

- 데이터와 비즈니스 로직이 온톨로지에서 어떻게 결합되는지 설명할 수 있다.
- Action, Rule, Workflow, Write-back의 역할을 구분할 수 있다.
- 조건 발생 시 실행해야 할 Action 명세를 작성할 수 있다.
- 실시간 의사결정 지원 구조를 온톨로지 관점에서 설명할 수 있다.

## 핵심 질문

1. 온톨로지 객체가 단순 조회 대상이 아니라 실행 대상이 된다는 것은 무엇인가?
2. Rule과 Action은 어떻게 연결되는가?
3. Write-back이 없으면 운영형 온톨로지는 어떤 한계를 가지는가?
4. AI 에이전트가 Action을 실행할 때 어떤 검증 절차가 필요한가?

## 1. 데이터와 비즈니스 로직의 분리 문제

전통적인 시스템에서는 데이터와 비즈니스 로직이 여러 곳에 흩어져 있습니다.

| 위치 | 예시 | 문제 |
| --- | --- | --- |
| 데이터베이스 | 주문, 구독, 티켓 테이블 | 업무 의미와 실행 규칙이 부족함 |
| 백엔드 서비스 | 환불 가능 여부, 구독 변경 조건 | 서비스별로 로직이 분산됨 |
| BI 대시보드 | 이탈 위험 고객 목록 | 조회는 가능하지만 실행은 별도 시스템에서 수행 |
| 운영 매뉴얼 | 상담원 처리 절차 | 시스템이 자동으로 적용하기 어려움 |

운영형 온톨로지는 이 분산된 요소를 객체, 상태, Rule, Action으로 연결합니다.

```text
CustomerAccount.status
Subscription.renewalDate
CSTicket.type
PaymentFailure.count
        |
        v
Rule: ChurnRiskCustomer
        |
        v
Action: OfferRetentionDiscount
```

## 2. Rule: 조건을 판단하는 비즈니스 로직

Rule은 객체의 상태와 관계를 평가해 어떤 판단을 내리는 비즈니스 로직입니다.

예:

```text
IF
  CustomerAccount.status = ACTIVE
  Subscription.status = ACTIVE
  Subscription.renewalDate <= 30 days
  CSTicket.type = PAYMENT_FAILURE
  CSTicket.status = OPEN
THEN
  CustomerAccount.riskLevel = HIGH
  availableAction = OfferRetentionDiscount
```

Rule은 단순 필터와 다릅니다. 여러 객체와 관계를 따라가며 조건을 평가하고, 새로운 상태나 실행 가능한 Action을 도출합니다.

## 3. Action: 업무를 실행하는 단위

Action은 사용자가 선택하거나 시스템/AI 에이전트가 조건에 따라 실행할 수 있는 업무 명령입니다.

Action 명세에는 다음이 포함되어야 합니다.

| 항목 | 설명 |
| --- | --- |
| 대상 객체 | Action이 적용되는 객체 |
| 실행 조건 | 실행 가능한 상태인지 검증하는 조건 |
| 입력값 | 실행 시 필요한 파라미터 |
| 권한 | 누가 실행할 수 있는지 |
| 효과 | 실행 후 변경되는 상태 |
| Write-back 대상 | 어느 시스템에 기록할지 |
| 감사 로그 | 누가, 언제, 왜 실행했는지 |

예:

```text
Action: OfferRetentionDiscount
Target: CustomerAccount
Precondition:
  riskLevel = HIGH
  Subscription.status = ACTIVE
Input:
  couponCode
  expiresAt
  reason
Effect:
  RetentionOffer.status = CREATED
Write-back:
  CRM
  Marketing Automation
Audit:
  actor, timestamp, reason
```

## 4. Write-back: 분석에서 운영으로 넘어가는 지점

Write-back은 Action 실행 결과를 원천 시스템이나 운영 시스템에 다시 기록하는 과정입니다.

예:

```text
OfferRetentionDiscount 실행
  -> CRM에 유지 쿠폰 제안 기록 생성
  -> Marketing Automation에 쿠폰 발송 요청
  -> 온톨로지의 CustomerAccount 상태 갱신
```

Write-back이 없으면 온톨로지는 좋은 분석 계층에 머무릅니다. Write-back이 있어야 실제 업무 프로세스가 변경됩니다.

## 5. Workflow: 여러 Action의 순서와 상태 전이

워크플로우는 하나 이상의 Action이 순서대로 실행되며 객체 상태를 바꾸는 흐름입니다.

예: 결제 실패 고객 유지 워크플로우

```text
PaymentFailureDetected
  -> OpenPaymentFailureTicket
  -> AssignRetentionManager
  -> OfferRetentionDiscount
  -> WaitForCustomerResponse
  -> ResolveTicket or EscalateTicket
```

각 단계는 상태 전이를 가집니다.

```text
Ticket.status:
  OPEN -> ASSIGNED -> OFFER_SENT -> RESOLVED
                      -> ESCALATED
```

운영형 온톨로지는 이 상태 전이와 각 단계의 실행 조건을 객체 모델에 연결합니다.

## 6. 실시간 의사결정 지원

실시간 의사결정은 새 데이터가 들어왔을 때 즉시 Rule을 평가하고 Action 후보를 제안하는 구조입니다.

예:

```text
Event: PaymentFailed
  customer = U010
  subscription = S5010

Rule Evaluation:
  active subscription? yes
  renewal within 30 days? yes
  open payment failure ticket? yes

Decision:
  riskLevel = HIGH
  recommend Action = OfferRetentionDiscount
```

이 구조는 상담원 화면, 운영 대시보드, AI 에이전트에서 모두 활용할 수 있습니다.

## 7. AI 에이전트와 Action 실행 안전장치

AI 에이전트가 Action을 실행할 때는 반드시 검증이 필요합니다.

필수 안전장치:

- 대상 객체가 정확한지 확인한다.
- 실행 조건을 시스템적으로 검증한다.
- 권한이 있는지 확인한다.
- 실행 전 변경 내용을 요약한다.
- 위험도가 높은 Action은 사람 승인 단계를 둔다.
- 실행 후 감사 로그를 남긴다.

예:

```text
AI 추천: OfferRetentionDiscount 실행
System 검증:
  riskLevel = HIGH
  subscription.status = ACTIVE
  actor has permission = true
Human approval:
  required for discount > 20%
Write-back:
  CRM and Marketing
Audit:
  actor = agent_01, approver = manager_01
```

## 8. 이번 강의의 핵심 정리

- 운영형 온톨로지는 데이터 객체, Rule, Action, Workflow, Write-back을 결합한다.
- Rule은 객체의 상태와 관계를 평가해 판단을 내린다.
- Action은 업무 실행 단위이며 실행 조건, 입력값, 효과, 권한, write-back 대상을 가져야 한다.
- Workflow는 여러 Action과 상태 전이를 묶은 업무 프로세스다.
- Write-back은 온톨로지를 분석 계층에서 운영 계층으로 확장하는 핵심이다.
- AI 에이전트가 Action을 실행하려면 조건 검증, 권한 확인, 승인, 감사 로그가 필요하다.

## 실습 파일

- [Rule과 Action 매트릭스 예제](samples/rule_action_matrix.md)
- [비즈니스 로직 결합 온톨로지 예제](samples/business_logic_ontology.ttl)
- [상세 과제](assignment.md)

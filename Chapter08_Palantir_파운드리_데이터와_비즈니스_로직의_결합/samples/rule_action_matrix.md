# 샘플: Rule과 Action 매트릭스

## 1. 상황

구독 커머스 기업에서 고객 이탈 위험을 줄이기 위해 운영형 온톨로지를 구축한다고 가정합니다.

핵심 객체:

- CustomerAccount
- Subscription
- Payment
- CSTicket
- RetentionOffer
- WorkflowCase

## 2. Rule 정의

| Rule ID | 이름 | 조건 | 결과 |
| --- | --- | --- | --- |
| R001 | 결제 실패 위험 | `Payment.status = FAILED` and `Subscription.status = ACTIVE` | `riskSignal = PAYMENT_FAILURE` |
| R002 | 갱신 임박 | `Subscription.renewalDate <= 30 days` | `riskSignal = RENEWAL_SOON` |
| R003 | 미해결 결제 문의 | `CSTicket.type = PAYMENT_FAILURE` and `CSTicket.status = OPEN` | `riskSignal = OPEN_PAYMENT_TICKET` |
| R004 | 고위험 유지 대상 | R001 + R002 + R003 | `CustomerAccount.riskLevel = HIGH` |

## 3. Action 매트릭스

| Action | 대상 객체 | 실행 조건 | 입력값 | 효과 | Write-back |
| --- | --- | --- | --- | --- | --- |
| AssignRetentionManager | CustomerAccount | `riskLevel = HIGH` | managerId, reason | 담당자 배정 | CRM |
| OfferRetentionDiscount | CustomerAccount | `riskLevel = HIGH` and `Subscription.status = ACTIVE` | couponCode, expiresAt | 유지 쿠폰 제안 생성 | CRM, Marketing |
| RetryPayment | Payment | `Payment.status = FAILED` | paymentMethodId | 결제 재시도 요청 | Payment Gateway |
| EscalateTicket | CSTicket | `status = OPEN` and `type = PAYMENT_FAILURE` | priority, assignee | 티켓 우선순위 상승 | CS |
| PauseSubscription | Subscription | `status = ACTIVE` and manager approval | reason, pauseUntil | 구독 일시정지 | Subscription |

## 4. 워크플로우 예시

```text
Workflow: PaymentFailureRetention

1. PaymentFailed 이벤트 수신
2. R001, R002, R003 평가
3. R004가 true이면 CustomerAccount.riskLevel = HIGH
4. AssignRetentionManager 실행
5. OfferRetentionDiscount 실행
6. 고객 응답 대기
7. 결제 재시도 또는 티켓 에스컬레이션
8. WorkflowCase 종료
```

## 5. 상태 전이

```text
WorkflowCase.status:
  CREATED
  -> RISK_EVALUATED
  -> MANAGER_ASSIGNED
  -> OFFER_SENT
  -> PAYMENT_RETRIED
  -> RESOLVED
  -> ESCALATED
```

## 6. 감사 로그 필드

Action 실행마다 다음 정보를 남깁니다.

| 필드 | 설명 |
| --- | --- |
| actionId | 실행된 Action |
| targetObject | 대상 객체 |
| actor | 실행자 또는 AI 에이전트 |
| approver | 승인자 |
| timestamp | 실행 시각 |
| reason | 실행 사유 |
| previousState | 실행 전 상태 |
| nextState | 실행 후 상태 |

## 7. 검토 질문

1. R001~R004 중 단일 객체만 보면 판단할 수 없는 Rule은 무엇인가요?
2. `OfferRetentionDiscount`에 사람 승인 조건이 필요한 경우는 언제인가요?
3. Write-back 대상 시스템이 여러 개인 경우 실패 처리는 어떻게 설계해야 하나요?
4. Action 실행 로그가 없으면 운영상 어떤 문제가 생기나요?

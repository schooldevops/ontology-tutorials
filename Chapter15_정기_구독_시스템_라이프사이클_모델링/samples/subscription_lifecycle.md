# 샘플: 구독 상태 전이 모델

## 1. 상태 목록

| State | 설명 | allowsAccess | isTerminal |
| --- | --- | --- | --- |
| CREATED | 구독 생성 직후 | false | false |
| PAYMENT_PENDING | 첫 결제 또는 갱신 결제 대기 | false | false |
| ACTIVE | 정상 이용 가능 | true | false |
| GRACE_PERIOD | 결제 실패 후 유예 기간 | true | false |
| PAUSED | 일시정지 | false | false |
| CANCELLED | 해지 완료 | false | true |
| EXPIRED | 기간 만료 | false | true |

## 2. 상태 전이

| From | Event | To | 조건 | 추천 Action |
| --- | --- | --- | --- | --- |
| CREATED | PaymentRequested | PAYMENT_PENDING | 결제 요청 생성 | RequestPayment |
| PAYMENT_PENDING | PaymentCaptured | ACTIVE | 결제 성공 | ActivateSubscription |
| PAYMENT_PENDING | PaymentFailed | GRACE_PERIOD | 결제 실패 | NotifyPaymentFailure |
| ACTIVE | RenewalPaymentFailed | GRACE_PERIOD | 갱신 결제 실패 | RetryPayment |
| GRACE_PERIOD | PaymentCaptured | ACTIVE | 재결제 성공 | RestoreSubscription |
| GRACE_PERIOD | GracePeriodExpired | CANCELLED | 유예 기간 만료 | FinalizeCancellation |
| ACTIVE | PauseRequested | PAUSED | 일시정지 가능 조건 충족 | PauseSubscription |
| PAUSED | ResumeRequested | ACTIVE | 재개 가능 조건 충족 | ResumeSubscription |
| ACTIVE | CancelRequested | CANCELLED | 해지 요청 승인 | CancelSubscription |

## 3. 이벤트 이력 예시

```text
Subscription_2001 hasSubscriptionEvent Event_001
Event_001 eventType SubscriptionCreated
Event_001 occurredAt 2026-05-01T10:00:00

Subscription_2001 hasSubscriptionEvent Event_002
Event_002 eventType PaymentCaptured
Event_002 occurredAt 2026-05-01T10:01:00

Subscription_2001 hasSubscriptionEvent Event_003
Event_003 eventType RenewalPaymentFailed
Event_003 occurredAt 2026-06-01T09:00:00
```

## 4. 시간 속성 예시

| Subscription | startDate | renewalDate | gracePeriodUntil | currentState |
| --- | --- | --- | --- | --- |
| Subscription_2001 | 2026-05-01 | 2026-06-01 | 2026-06-08 | GRACE_PERIOD |

## 5. 운영 Rule 예시

### 결제 실패 시 유예 전환

```text
IF
  currentState = ACTIVE
  latestPayment.status = FAILED
THEN
  currentState = GRACE_PERIOD
  gracePeriodUntil = today + 7 days
  availableAction = RetryPayment
  availableAction = NotifyPaymentFailure
```

### 유예 만료 시 해지

```text
IF
  currentState = GRACE_PERIOD
  gracePeriodUntil < today
THEN
  currentState = CANCELLED
  availableAction = FinalizeCancellation
```

## 6. 검토 질문

1. `SubscriptionPlan`과 `Subscription`을 분리하지 않으면 어떤 문제가 생기나요?
2. `currentState`만 저장하고 이벤트 이력을 저장하지 않으면 어떤 분석이 어려워지나요?
3. `GRACE_PERIOD` 상태에서 접근 권한을 허용할지 제한할지는 어떤 비즈니스 기준으로 결정해야 하나요?
4. `PAUSED`와 `CANCELLED`는 어떤 점에서 다른가요?

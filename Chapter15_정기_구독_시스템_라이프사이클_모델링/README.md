# 15강: 정기 구독 시스템 라이프사이클 모델링

## 강의 개요

12강에서는 코어 클래스를 설계했고, 13강에서는 객체 관계를 정의했으며, 14강에서는 데이터 속성과 제약 조건을 다뤘습니다. 15강에서는 정기 구독 시스템의 시간 흐름과 상태 변화를 온톨로지로 표현합니다.

구독은 단순히 "고객이 플랜을 가지고 있다"는 정적 관계가 아닙니다. 가입, 결제, 활성화, 갱신, 결제 실패, 유예, 일시정지, 재개, 해지 같은 이벤트와 상태 전이가 누적되는 라이프사이클입니다.

```text
CREATED -> PAYMENT_PENDING -> ACTIVE -> GRACE_PERIOD -> PAUSED -> ACTIVE -> CANCELLED
```

## 학습 목표

- 구독 상태와 상태 전이를 온톨로지로 표현할 수 있다.
- Subscription, SubscriptionPlan, Payment, BillingCycle, SubscriptionEvent를 구분할 수 있다.
- 시간 기반 속성과 이벤트 이력을 모델링할 수 있다.
- 결제 실패, 유예, 일시정지, 해지 같은 라이프사이클 규칙을 설계할 수 있다.
- 구독 상태 전이를 Rule과 Action으로 연결할 수 있다.

## 핵심 질문

1. `Subscription.status = ACTIVE` 하나만으로 구독 라이프사이클을 충분히 표현할 수 있는가?
2. 결제 실패가 발생하면 구독은 즉시 해지되어야 하는가, 유예 상태를 거쳐야 하는가?
3. 구독 상태 이력을 남기려면 상태값만 있으면 되는가, 이벤트 객체가 필요한가?
4. 구독 갱신일, 결제 실패 횟수, 유예 만료일은 어떤 Rule과 Action에 사용되는가?

## 1. 구독 라이프사이클의 특징

구독은 시간에 따라 상태가 변하는 지속 객체입니다.

일반 주문:

```text
주문 생성 -> 결제 완료 -> 배송 -> 종료
```

구독:

```text
가입 -> 첫 결제 -> 활성화 -> 주기적 갱신 -> 결제 실패 가능
-> 유예 -> 재시도 -> 복구 또는 해지
```

따라서 구독 모델에는 현재 상태뿐 아니라 과거 이벤트와 다음 예정 상태가 필요합니다.

## 2. 핵심 클래스

| 클래스 | 설명 |
| --- | --- |
| Subscription | 고객 계정이 특정 플랜을 이용하는 지속 상태 |
| SubscriptionPlan | 구독 상품 또는 요금제 |
| BillingCycle | 월간, 연간 같은 청구 주기 |
| Payment | 실제 결제 시도 또는 결제 결과 |
| SubscriptionEvent | 구독 상태 변화 이벤트 |
| SubscriptionState | 표준화된 구독 상태 |
| StateTransition | 상태 전이 규칙 |
| GracePeriod | 결제 실패 후 유예 기간 |
| CancellationReason | 해지 사유 |

## 3. 상태값 모델링

초기에는 문자열 상태값으로 시작할 수 있습니다.

```text
Subscription_2001 subscriptionStatus "ACTIVE"
```

하지만 라이프사이클이 중요해지면 상태를 인스턴스로 모델링하는 것이 좋습니다.

```text
Subscription_2001 hasCurrentState ActiveState
ActiveState type SubscriptionState
```

상태 인스턴스에는 메타데이터를 붙일 수 있습니다.

```text
ActiveState isTerminal false
CancelledState isTerminal true
GracePeriodState allowsAccess true
PausedState allowsAccess false
```

## 4. 주요 구독 상태

| 상태 | 설명 | 접근 권한 | 종료 상태 |
| --- | --- | --- | --- |
| CREATED | 구독 객체가 생성되었지만 결제 전 | false | false |
| PAYMENT_PENDING | 결제 대기 중 | false | false |
| ACTIVE | 정상 이용 가능 | true | false |
| GRACE_PERIOD | 결제 실패 후 제한적 유예 | true 또는 제한적 | false |
| PAUSED | 고객 또는 운영자가 일시정지 | false 또는 제한적 | false |
| CANCELLED | 해지 완료 | false | true |
| EXPIRED | 기간 만료 | false | true |

상태는 단순 라벨이 아니라 접근 권한, Action 가능 여부, 알림, 리스크 판단의 기준이 됩니다.

## 5. 상태 전이 모델

상태 전이는 어떤 상태에서 어떤 이벤트가 발생했을 때 다음 상태로 이동하는지를 정의합니다.

```text
CREATED --PaymentRequested--> PAYMENT_PENDING
PAYMENT_PENDING --PaymentCaptured--> ACTIVE
ACTIVE --PaymentFailed--> GRACE_PERIOD
GRACE_PERIOD --PaymentCaptured--> ACTIVE
GRACE_PERIOD --GracePeriodExpired--> CANCELLED
ACTIVE --PauseRequested--> PAUSED
PAUSED --ResumeRequested--> ACTIVE
ACTIVE --CancelRequested--> CANCELLED
```

상태 전이를 온톨로지 객체로 만들면 전이 조건과 Action을 붙일 수 있습니다.

```text
Transition_ActiveToGrace
  fromState ActiveState
  toState GracePeriodState
  triggeredBy PaymentFailedEvent
  requiresAction RetryPayment
```

## 6. 구독 이벤트 이력

상태값만 저장하면 "왜 상태가 바뀌었는지"를 알기 어렵습니다. 따라서 이벤트 이력이 필요합니다.

| 이벤트 | 설명 |
| --- | --- |
| SubscriptionCreated | 구독 생성 |
| PaymentRequested | 결제 요청 |
| PaymentCaptured | 결제 성공 |
| PaymentFailed | 결제 실패 |
| GracePeriodStarted | 유예 시작 |
| PauseRequested | 일시정지 요청 |
| ResumeRequested | 재개 요청 |
| CancelRequested | 해지 요청 |
| SubscriptionCancelled | 해지 완료 |

예:

```text
Subscription_2001 hasSubscriptionEvent Event_001
Event_001 eventType "PaymentFailed"
Event_001 occurredAt "2026-06-01T09:00:00"
Event_001 causedBy Payment_9001
```

## 7. 시간 기반 속성

구독 라이프사이클에는 날짜와 시간이 매우 중요합니다.

| 속성 | Domain | 설명 |
| --- | --- | --- |
| startDate | Subscription | 구독 시작일 |
| endDate | Subscription | 구독 종료일 |
| renewalDate | Subscription | 다음 갱신일 |
| trialEndDate | Subscription | 체험 종료일 |
| gracePeriodUntil | Subscription | 유예 종료일 |
| pausedAt | Subscription | 일시정지 시각 |
| cancelledAt | Subscription | 해지 시각 |
| occurredAt | SubscriptionEvent | 이벤트 발생 시각 |

이 값들은 다음과 같은 Rule에 사용됩니다.

```text
IF
  subscriptionStatus = GRACE_PERIOD
  gracePeriodUntil < today
THEN
  subscriptionStatus = CANCELLED
  Action = FinalizeCancellation
```

## 8. Rule과 Action 연결

구독 상태 전이는 Rule과 Action으로 운영됩니다.

예: 결제 실패 처리

```text
IF
  Subscription.status = ACTIVE
  Payment.status = FAILED
THEN
  Subscription.status = GRACE_PERIOD
  gracePeriodUntil = today + 7 days
  availableAction = RetryPayment
  availableAction = NotifyPaymentFailure
```

예: 유예 기간 만료

```text
IF
  Subscription.status = GRACE_PERIOD
  gracePeriodUntil < today
THEN
  Subscription.status = CANCELLED
  availableAction = FinalizeCancellation
```

## 9. 이번 강의의 핵심 정리

- 구독은 시간에 따라 상태가 변하는 지속 객체다.
- 현재 상태만으로는 부족하며 상태 전이와 이벤트 이력이 필요하다.
- SubscriptionPlan은 상품이고, Subscription은 고객이 플랜을 이용하는 상태다.
- Payment는 결제 시도와 결과를 나타내며 구독 상태 전이에 영향을 준다.
- SubscriptionState와 StateTransition을 모델링하면 라이프사이클 규칙을 명확히 표현할 수 있다.
- 시간 기반 속성은 갱신, 유예, 해지, 이탈 위험 Rule의 핵심 입력이다.

## 실습 파일

- [구독 상태 전이 모델 예제](samples/subscription_lifecycle.md)
- [구독 라이프사이클 온톨로지 예제](samples/subscription_lifecycle.ttl)
- [상세 과제](assignment.md)

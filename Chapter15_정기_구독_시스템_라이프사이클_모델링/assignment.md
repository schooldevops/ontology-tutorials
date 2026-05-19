# 15강 과제: 정기 구독 라이프사이클 온톨로지 설계하기

## 과제 목표

이번 과제는 정기 구독 시스템의 상태, 이벤트, 결제, 시간 속성, 상태 전이를 온톨로지로 모델링하는 것입니다.

## 제출물

`Chapter15_정기_구독_시스템_라이프사이클_모델링/submission.md` 파일을 작성한다고 가정하고, 아래 항목을 모두 포함해 작성하세요.

## 과제 1. 구독 라이프사이클 개념 정리

아래 개념을 본인의 말로 설명하세요.

| 개념 | 설명 | 예시 |
| --- | --- | --- |
| Subscription |  |  |
| SubscriptionPlan |  |  |
| BillingCycle |  |  |
| SubscriptionState |  |  |
| SubscriptionEvent |  |  |
| StateTransition |  |  |
| GracePeriod |  |  |

반드시 포함할 키워드:

- 현재 상태
- 이벤트 이력
- 결제 실패
- 유예 기간
- 갱신일
- 상태 전이

## 과제 2. 샘플 분석

다음 파일을 읽습니다.

- `samples/subscription_lifecycle.md`
- `samples/subscription_lifecycle.ttl`

아래 질문에 답하세요.

1. `SubscriptionPlan`과 `Subscription`을 분리한 이유는 무엇인가요?
2. `hasCurrentState`를 문자열 상태값 대신 객체 속성으로 둔 장점은 무엇인가요?
3. `SubscriptionEvent`가 없으면 어떤 분석이나 감사가 어려워지나요?
4. `GRACE_PERIOD` 상태는 왜 필요한가요?
5. `TransitionActiveToGrace`는 어떤 조건과 Action을 가지고 있나요?

## 과제 3. 상태 목록 설계

정기 구독 시스템의 상태를 최소 7개 이상 정의하세요.

아래 형식으로 작성하세요.

| State | 설명 | allowsAccess | isTerminal | 가능한 Action |
| --- | --- | --- | --- | --- |
| ACTIVE | 정상 이용 가능 | true | false | PauseSubscription |

반드시 포함할 상태:

- CREATED
- PAYMENT_PENDING
- ACTIVE
- GRACE_PERIOD
- PAUSED
- CANCELLED
- EXPIRED

## 과제 4. 상태 전이 설계

아래 형식으로 상태 전이를 최소 9개 이상 작성하세요.

| From State | Event | To State | 조건 | 추천 Action |
| --- | --- | --- | --- | --- |
| ACTIVE | RenewalPaymentFailed | GRACE_PERIOD | 결제 실패 | RetryPayment |

반드시 포함할 전이:

- CREATED -> PAYMENT_PENDING
- PAYMENT_PENDING -> ACTIVE
- PAYMENT_PENDING -> GRACE_PERIOD
- ACTIVE -> GRACE_PERIOD
- GRACE_PERIOD -> ACTIVE
- GRACE_PERIOD -> CANCELLED
- ACTIVE -> PAUSED
- PAUSED -> ACTIVE
- ACTIVE -> CANCELLED

## 과제 5. 이벤트 이력 모델링

다음 시나리오를 최소 12개의 트리플로 모델링하세요.

> 이서연의 베이직 구독은 2026년 5월 1일 생성되고 첫 결제에 성공해 ACTIVE가 되었다. 2026년 6월 1일 갱신 결제가 실패해 GRACE_PERIOD 상태가 되었고, 유예 기간은 2026년 6월 8일까지이다. 시스템은 결제 재시도와 결제 실패 알림 Action을 추천한다.

형식:

```text
Subject | Predicate | Object
```

## 과제 6. 라이프사이클 Rule 설계

아래 Rule을 작성하세요.

| Rule ID | 이름 | 조건 | 결과 | 추천 Action |
| --- | --- | --- | --- | --- |
| R001 |  |  |  |  |

반드시 포함할 Rule:

- 첫 결제 성공 시 ACTIVE 전환
- 갱신 결제 실패 시 GRACE_PERIOD 전환
- 유예 기간 내 재결제 성공 시 ACTIVE 복구
- 유예 기간 만료 시 CANCELLED 전환
- 일시정지 요청 시 PAUSED 전환
- 재개 요청 시 ACTIVE 전환
- 해지 요청 시 CANCELLED 전환

## 과제 7. 시간 기반 리스크 판단

다음 비즈니스 질문에 답하기 위한 조건을 설계하세요.

> 갱신일이 7일 이내이고, 최근 결제 실패 이벤트가 있으며, 현재 GRACE_PERIOD인 고객은 누구인가?

반드시 포함할 내용:

- 필요한 클래스
- 필요한 객체 속성
- 필요한 데이터 속성
- 필터 조건
- 반환해야 할 객체
- 추천 Action

## 과제 8. Turtle 초안 작성

과제 3~7을 바탕으로 Turtle 초안을 작성하세요.

필수 조건:

- `SubscriptionState` 인스턴스 7개 이상
- `StateTransition` 인스턴스 7개 이상
- `SubscriptionEvent` 인스턴스 3개 이상
- 시간 기반 데이터 속성 5개 이상
- Action 인스턴스 5개 이상
- 예시 구독 1개의 라이프사이클 그래프

## 평가 기준

| 평가 항목 | 배점 | 설명 |
| --- | ---: | --- |
| 상태 모델링 | 25 | 구독 상태와 종료/접근 권한을 적절히 정의했는가 |
| 상태 전이 설계 | 30 | 이벤트, 조건, Action을 포함해 전이를 명확히 설계했는가 |
| 이벤트 이력 | 20 | 상태 변화 원인과 시간을 추적할 수 있게 모델링했는가 |
| 시간 기반 Rule | 25 | 갱신일, 유예 만료일, 결제 실패를 Rule과 Action에 연결했는가 |

## 제출 예시 템플릿

```markdown
# 15강 과제 제출

## 과제 1. 구독 라이프사이클 개념 정리

| 개념 | 설명 | 예시 |
| --- | --- | --- |
| Subscription |  |  |

## 과제 2. 샘플 분석

...

## 과제 3. 상태 목록 설계

| State | 설명 | allowsAccess | isTerminal | 가능한 Action |
| --- | --- | --- | --- | --- |
| ACTIVE | 정상 이용 가능 | true | false | PauseSubscription |

## 과제 4. 상태 전이 설계

...

## 과제 5. 이벤트 이력 모델링

| Subject | Predicate | Object |
| --- | --- | --- |
| Subscription_3001 | hasSubscriptionEvent | Event_001 |

## 과제 6. 라이프사이클 Rule 설계

...

## 과제 7. 시간 기반 리스크 판단

...

## 과제 8. Turtle 초안

```turtle
...
```
```

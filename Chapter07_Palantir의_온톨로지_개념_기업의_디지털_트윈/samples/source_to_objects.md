# 샘플: 데이터 소스에서 온톨로지 객체로 투영하기

## 1. AS-IS 데이터 소스

커머스 기업의 데이터가 다음처럼 분산되어 있다고 가정합니다.

### CRM

| customer_id | name | segment | manager |
| --- | --- | --- | --- |
| C001 | 박지훈 | Growth | 이담당 |

### Commerce

| user_id | email | account_status |
| --- | --- | --- |
| U003 | jihoon@example.com | ACTIVE |

| order_id | user_id | status | ordered_at |
| --- | --- | --- | --- |
| O9001 | U003 | PAID | 2026-05-10 |

### Subscription

| subscription_id | user_id | plan_id | status | renewal_date |
| --- | --- | --- | --- | --- |
| S1001 | U003 | PLAN_BASIC | ACTIVE | 2026-06-01 |

### CS

| ticket_id | requester_email | type | status |
| --- | --- | --- | --- |
| T7001 | jihoon@example.com | REFUND | OPEN |

### Marketing

| event_id | event_name | participant_email |
| --- | --- | --- |
| E5001 | 신규 가입 쿠폰 이벤트 | jihoon@example.com |

## 2. TO-BE 온톨로지 객체

위 데이터를 다음 비즈니스 객체로 투영합니다.

| 온톨로지 객체 | 소스 | 핵심 속성 |
| --- | --- | --- |
| Person_001 | CRM, Commerce, CS, Marketing | name, email |
| CustomerAccount_001 | Commerce | accountStatus |
| Order_9001 | Commerce | status, orderedAt |
| Subscription_1001 | Subscription | status, renewalDate |
| BasicPlan | Subscription | planId |
| CSTicket_7001 | CS | type, status |
| Campaign_NewCoupon | Marketing | eventName |

## 3. 관계 투영

```text
Person_001 ownsAccount CustomerAccount_001
CustomerAccount_001 placesOrder Order_9001
CustomerAccount_001 ownsSubscription Subscription_1001
Subscription_1001 hasPlan BasicPlan
Person_001 raisesTicket CSTicket_7001
Person_001 participatesIn Campaign_NewCoupon
Campaign_NewCoupon influenced Subscription_1001
```

## 4. 상태 계산

온톨로지 객체는 단순 원천값뿐 아니라 계산된 상태도 가질 수 있습니다.

| 계산 상태 | 계산 기준 |
| --- | --- |
| isActiveSubscriber = true | Subscription.status = ACTIVE |
| hasOpenRefundTicket = true | CSTicket.type = REFUND and status = OPEN |
| daysUntilRenewal = 14 | renewal_date - today |
| churnRisk = HIGH | open refund ticket + renewal within 14 days |

## 5. 가능한 Action

| 대상 객체 | Action | 실행 조건 |
| --- | --- | --- |
| Subscription_1001 | PauseSubscription | status = ACTIVE |
| CustomerAccount_001 | OfferRetentionDiscount | churnRisk = HIGH |
| CSTicket_7001 | EscalateTicket | status = OPEN and type = REFUND |
| CustomerAccount_001 | AssignRetentionManager | churnRisk = HIGH |

## 6. 검토 질문

1. `Person_001`과 `CustomerAccount_001`을 분리하는 이유는 무엇인가요?
2. `CSTicket_7001`은 고객 상태 계산에 어떤 영향을 주나요?
3. `OfferRetentionDiscount` Action은 어떤 조건에서 실행되어야 하나요?
4. 객체 중심 모델이 SQL 테이블 중심 모델보다 비즈니스 사용자에게 유리한 이유는 무엇인가요?

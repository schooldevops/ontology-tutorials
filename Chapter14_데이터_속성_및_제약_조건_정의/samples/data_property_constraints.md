# 샘플: 데이터 속성과 제약 조건 설계

## 1. 시나리오

다음 통합 커머스 객체들이 있습니다.

```text
PremiumPlan_001 type SubscriptionPlan
Order_1001 type Order
Payment_5001 type Payment
Subscription_2001 type Subscription
Event_NewCoupon type CampaignEvent
OrderItem_001 type OrderItem
```

각 객체에는 다음 값이 필요합니다.

| 객체 | 필요한 값 |
| --- | --- |
| PremiumPlan_001 | 이름, 가격, 통화, 청구 주기 |
| Order_1001 | 주문 상태, 주문 시각 |
| Payment_5001 | 결제 상태, 결제 금액, 결제 시각 |
| Subscription_2001 | 구독 상태, 시작일, 갱신일 |
| Event_NewCoupon | 이벤트 이름, 시작일, 종료일 |
| OrderItem_001 | 수량, 단가, 할인 금액 |

## 2. 데이터 속성 정의

| Property | Domain | Range | 예시 값 |
| --- | --- | --- | --- |
| name | owl:Thing | xsd:string | "프리미엄 구독 플랜" |
| price | Product | xsd:decimal | 29000.00 |
| currency | Product | xsd:string | "KRW" |
| billingCycle | SubscriptionPlan | xsd:string | "MONTHLY" |
| orderStatus | Order | xsd:string | "PAID" |
| orderedAt | Order | xsd:dateTime | "2026-05-01T10:30:00" |
| paymentStatus | Payment | xsd:string | "CAPTURED" |
| amount | Payment | xsd:decimal | 29000.00 |
| paidAt | Payment | xsd:dateTime | "2026-05-01T10:31:00" |
| subscriptionStatus | Subscription | xsd:string | "ACTIVE" |
| startDate | Subscription | xsd:date | "2026-05-01" |
| renewalDate | Subscription | xsd:date | "2026-06-01" |
| eventStartDate | Event | xsd:date | "2026-05-01" |
| eventEndDate | Event | xsd:date | "2026-05-31" |
| quantity | OrderItem | xsd:integer | 1 |
| unitPrice | OrderItem | xsd:decimal | 29000.00 |
| discountAmount | OrderItem | xsd:decimal | 5000.00 |

## 3. 제약 조건 초안

| 대상 | 제약 | 이유 |
| --- | --- | --- |
| Product | price는 0 이상이어야 함 | 음수 가격 방지 |
| Product | currency는 ISO 통화 코드여야 함 | 통화 값 표준화 |
| SubscriptionPlan | billingCycle은 MONTHLY 또는 YEARLY | 허용 값 제한 |
| Order | orderedAt은 정확히 1개 | 주문 시각 필수 |
| Payment | amount는 0보다 커야 함 | 결제 금액 검증 |
| Subscription | hasPlan은 정확히 1개 | 구독은 하나의 플랜을 기준으로 활성화 |
| Event | eventStartDate <= eventEndDate | 이벤트 기간 정합성 |
| OrderItem | quantity는 1 이상 | 주문 항목 수량 검증 |

## 4. 문자열 상태값 표준화

원천 시스템마다 상태값이 다를 수 있습니다.

| 소스 시스템 | 원천 값 | 표준 값 |
| --- | --- | --- |
| Subscription | active | ACTIVE |
| Subscription | in_use | ACTIVE |
| Subscription | paused | PAUSED |
| Payment | paid | CAPTURED |
| Payment | complete | CAPTURED |
| Order | payment_done | PAID |

온톨로지 레이어에서는 표준 값을 사용하고, 매핑 테이블에서 원천 값을 변환하는 것이 좋습니다.

## 5. Rule 연결 예시

```text
IF
  subscriptionStatus = ACTIVE
  renewalDate <= today + 14 days
  paymentStatus = FAILED
THEN
  riskLevel = HIGH
```

이 Rule이 안정적으로 동작하려면 날짜 타입과 상태값이 일관되어야 합니다.

## 6. 검토 질문

1. `billingCycle`은 문자열 속성이 적절한가, 별도 클래스가 적절한가?
2. `status`를 모든 클래스에 공통 속성으로 두면 어떤 문제가 생길 수 있나요?
3. `price`와 `amount`의 Domain을 분리해야 하는 이유는 무엇인가요?
4. OWL cardinality와 SHACL minCount/maxCount는 어떤 상황에서 각각 유용한가요?

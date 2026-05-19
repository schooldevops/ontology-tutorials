# 샘플: 통합 커머스 관계 네트워크 설계

## 1. 시나리오

다음 업무 문장을 관계 네트워크로 바꿉니다.

> 김민준은 활성 고객 계정을 가지고 있고, 프리미엄 구독 플랜을 주문했다. 주문은 결제로 완료되었으며, 해당 계정은 프리미엄 구독을 소유한다. 김민준은 신규 가입 쿠폰 이벤트에 참여했고, 이후 환불 문의 티켓을 생성했다.

## 2. 핵심 객체

| 객체 | 클래스 |
| --- | --- |
| Person_001 | Person |
| Account_001 | CustomerAccount |
| PremiumPlan_001 | SubscriptionPlan |
| Order_1001 | Order |
| Payment_5001 | Payment |
| Subscription_2001 | Subscription |
| Event_NewCoupon | CampaignEvent |
| Ticket_7001 | CSTicket |

## 3. 객체 속성

| Subject | Predicate | Object | 설명 |
| --- | --- | --- | --- |
| Person_001 | ownsAccount | Account_001 | 사람이 계정을 소유 |
| Account_001 | placesOrder | Order_1001 | 계정이 주문 생성 |
| Order_1001 | containsProduct | PremiumPlan_001 | 주문이 플랜 포함 |
| Order_1001 | paidBy | Payment_5001 | 주문이 결제로 처리 |
| Account_001 | ownsSubscription | Subscription_2001 | 계정이 구독 소유 |
| Subscription_2001 | hasPlan | PremiumPlan_001 | 구독이 플랜 사용 |
| Person_001 | participatesIn | Event_NewCoupon | 사람이 이벤트 참여 |
| Person_001 | raisesTicket | Ticket_7001 | 사람이 티켓 생성 |
| Ticket_7001 | relatedToOrder | Order_1001 | 티켓이 주문과 관련 |
| Ticket_7001 | relatedToSubscription | Subscription_2001 | 티켓이 구독과 관련 |

## 4. 직접 관계를 피한 이유

### CustomerAccount purchases Product

이 관계는 간단하지만 주문과 결제 맥락을 잃습니다.

대신:

```text
CustomerAccount placesOrder Order
Order containsProduct Product
Order paidBy Payment
```

이 구조는 주문 상태, 결제 상태, 환불, 주문 항목 확장에 유리합니다.

## 5. 중간 객체가 필요한 경우

상품 수량, 단가, 할인 금액이 필요하면 `OrderItem`을 추가합니다.

```text
Order_1001 hasOrderItem OrderItem_001
OrderItem_001 itemProduct PremiumPlan_001
OrderItem_001 quantity 1
OrderItem_001 unitPrice 29000
OrderItem_001 discountAmount 5000
```

이벤트 참여 이력이 중요하면 `EventParticipation`을 추가합니다.

```text
Person_001 hasEventParticipation Participation_001
Participation_001 participationEvent Event_NewCoupon
Participation_001 participationChannel MobileApp
Participation_001 convertedTo Subscription_2001
```

## 6. 검토 질문

1. `Person participatesIn Event`와 `EventParticipation` 중 어떤 모델이 더 적절한 상황인가요?
2. `Order containsProduct Product`만으로 수량과 단가를 표현할 수 있나요?
3. `Ticket relatedToSubscription Subscription` 관계는 어떤 업무 질문에 도움이 되나요?
4. `placesOrder`의 역관계인 `orderedBy`를 정의하면 어떤 쿼리가 쉬워지나요?

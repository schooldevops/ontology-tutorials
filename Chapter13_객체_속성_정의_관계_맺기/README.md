# 13강: 객체 속성(Object Property) 정의 - 관계 맺기

## 강의 개요

12강에서는 통합 커머스 플랫폼의 코어 클래스를 설계했습니다. 13강에서는 그 클래스들을 실제 업무 관계로 연결합니다.

온톨로지에서 객체 속성(Object Property)은 인스턴스와 인스턴스를 연결하는 관계입니다. 클래스가 "무엇이 존재하는가"를 정의한다면, 객체 속성은 "그것들이 어떻게 연결되는가"를 정의합니다.

```text
CustomerAccount --placesOrder--> Order
Order --containsProduct--> Product
CustomerAccount --ownsSubscription--> Subscription
Subscription --hasPlan--> SubscriptionPlan
Person --participatesIn--> CampaignEvent
Person --raisesTicket--> CSTicket
```

## 학습 목표

- 객체 속성과 데이터 속성의 차이를 설명할 수 있다.
- Domain과 Range를 사용해 관계의 출발점과 도착점을 정의할 수 있다.
- 커머스 통합 플랫폼의 핵심 관계를 설계할 수 있다.
- 관계 이름을 업무 의미에 맞게 정의할 수 있다.
- 역관계, 다대다 관계, 중간 객체가 필요한 상황을 구분할 수 있다.

## 핵심 질문

1. `CustomerAccount --orders--> Product`처럼 바로 연결해도 되는가?
2. `placesOrder`와 `orderedBy`는 어떤 관계인가?
3. 이벤트 참여 관계에 참여 시각, 채널, 쿠폰 코드가 필요하면 어떻게 모델링해야 하는가?
4. 관계 이름은 왜 `has`보다 `placesOrder`, `ownsSubscription`, `raisesTicket`처럼 구체적인 것이 좋은가?

## 1. 객체 속성이란 무엇인가?

객체 속성은 한 개체가 다른 개체와 가지는 관계입니다.

예:

```text
Account_001 placesOrder Order_1001
Order_1001 containsProduct PremiumPlan_001
Subscription_2001 hasPlan PremiumPlan_001
Person_001 participatesIn Event_NewCoupon
Person_001 raisesTicket Ticket_7001
```

데이터 속성은 개체와 값을 연결합니다.

```text
Account_001 status "ACTIVE"
PremiumPlan_001 price 29000
Order_1001 orderedAt "2026-05-01T10:30:00"
```

객체 속성은 그래프의 간선입니다. 객체 속성이 잘 설계되어야 여러 도메인의 데이터가 하나의 지식 그래프로 연결됩니다.

## 2. Domain과 Range

객체 속성은 어떤 클래스에서 출발하고 어떤 클래스로 도착하는지 정의해야 합니다.

```text
Property: placesOrder
Domain: CustomerAccount
Range: Order
```

Turtle 표현:

```turtle
ex:placesOrder
    a owl:ObjectProperty ;
    rdfs:domain ex:CustomerAccount ;
    rdfs:range ex:Order .
```

Domain과 Range는 모델의 의미를 명확히 합니다.

- `CustomerAccount placesOrder Order`는 자연스럽다.
- `Product placesOrder CustomerAccount`는 잘못된 관계일 가능성이 높다.

## 3. 커머스 핵심 객체 속성

통합 커머스 플랫폼에서 우선 정의해야 할 관계는 다음과 같습니다.

| Property | Domain | Range | 설명 |
| --- | --- | --- | --- |
| ownsAccount | Person | CustomerAccount | 사람이 계정을 소유 |
| playsRole | CustomerAccount | Role | 계정이 역할을 가짐 |
| placesOrder | CustomerAccount | Order | 계정이 주문을 생성 |
| orderedBy | Order | CustomerAccount | 주문의 주체 |
| containsProduct | Order | Product | 주문이 상품을 포함 |
| paidBy | Order | Payment | 주문이 결제로 처리됨 |
| ownsSubscription | CustomerAccount | Subscription | 계정이 구독을 소유 |
| hasPlan | Subscription | SubscriptionPlan | 구독이 플랜을 사용 |
| participatesIn | Person | Event | 사람이 이벤트에 참여 |
| targets | CampaignEvent | CustomerSegment | 캠페인이 세그먼트를 타겟팅 |
| belongsToSegment | CustomerAccount | CustomerSegment | 계정이 세그먼트에 속함 |
| raisesTicket | Person | CSTicket | 사람이 CS 티켓을 생성 |
| relatedToOrder | CSTicket | Order | 티켓이 주문과 관련됨 |
| relatedToSubscription | CSTicket | Subscription | 티켓이 구독과 관련됨 |

이 관계들이 있어야 고객 여정이 하나의 그래프로 연결됩니다.

## 4. 직접 관계와 중간 객체

관계를 설계할 때 자주 하는 실수는 모든 것을 직접 연결하는 것입니다.

나쁜 예:

```text
CustomerAccount purchases Product
```

이 관계만 있으면 다음 정보가 사라집니다.

- 언제 주문했는가?
- 몇 개를 샀는가?
- 어떤 결제로 처리됐는가?
- 주문 상태는 무엇인가?
- 환불되었는가?

더 나은 예:

```text
CustomerAccount placesOrder Order
Order containsProduct Product
Order paidBy Payment
```

필요하면 `OrderItem` 중간 객체도 추가할 수 있습니다.

```text
Order hasOrderItem OrderItem
OrderItem itemProduct Product
OrderItem quantity 2
OrderItem unitPrice 59000
```

중간 객체는 관계 자체에 속성이나 상태가 필요할 때 사용합니다.

## 5. 역관계(Inverse Property)

관계는 방향을 가집니다.

```text
CustomerAccount placesOrder Order
Order orderedBy CustomerAccount
```

두 관계는 서로 역관계입니다.

```turtle
ex:placesOrder owl:inverseOf ex:orderedBy .
```

역관계를 정의하면 한 방향 사실만 있어도 반대 방향 관계를 추론할 수 있습니다.

```text
명시:
Account_001 placesOrder Order_1001

추론:
Order_1001 orderedBy Account_001
```

## 6. 다대다 관계와 참여 객체

이벤트 참여는 단순히 `Person participatesIn Event`로 표현할 수 있습니다.

```text
Person_001 participatesIn Event_NewCoupon
```

하지만 참여 관계에 다음 정보가 필요하면 별도 참여 객체가 좋습니다.

- 참여 시각
- 참여 채널
- 사용 쿠폰
- 유입 소스
- 전환 여부

확장 모델:

```text
Person hasEventParticipation EventParticipation
EventParticipation participationEvent CampaignEvent
EventParticipation participationChannel MobileApp
EventParticipation usedCoupon Coupon_001
EventParticipation convertedTo Subscription_2001
```

관계에 메타데이터가 붙기 시작하면 관계를 객체로 승격하는 것이 실무적으로 안전합니다.

## 7. 관계 이름 짓기 원칙

좋은 관계 이름은 업무 문장처럼 읽힙니다.

좋은 예:

```text
CustomerAccount placesOrder Order
Order containsProduct Product
Subscription hasPlan SubscriptionPlan
CampaignEvent targets CustomerSegment
Person raisesTicket CSTicket
```

피해야 할 예:

```text
CustomerAccount has Order
Order linkedTo Product
Person relatedTo Event
Ticket mappedTo Subscription
```

`has`, `linkedTo`, `relatedTo`는 너무 넓어서 의미가 흐려질 수 있습니다. 처음에는 편해 보이지만, 그래프가 커질수록 쿼리와 추론이 어려워집니다.

## 8. 관계 설계 검토 질문

객체 속성을 정의할 때 다음을 확인합니다.

1. 관계 이름이 업무 문장으로 자연스럽게 읽히는가?
2. Domain과 Range가 명확한가?
3. 관계에 추가 속성이 필요한가?
4. 필요하다면 중간 객체가 있는가?
5. 역관계가 필요한가?
6. 다대다 관계에서 이력 추적이 필요한가?
7. 이 관계가 실제 업무 질문에 답하는 데 필요한가?

## 9. 이번 강의의 핵심 정리

- 객체 속성은 인스턴스와 인스턴스를 연결하는 의미 관계다.
- Domain과 Range는 관계의 출발점과 도착점을 정의한다.
- 직접 연결이 항상 좋은 것은 아니며, 관계 자체의 상태가 필요하면 중간 객체를 사용한다.
- 역관계는 한 방향 관계에서 반대 방향 관계를 추론할 수 있게 한다.
- 관계 이름은 업무 의미가 드러나도록 구체적으로 지어야 한다.
- 통합 커머스 온톨로지의 힘은 고객, 주문, 상품, 구독, 이벤트, CS가 관계 네트워크로 연결될 때 나온다.

## 실습 파일

- [관계 네트워크 설계 예제](samples/object_property_network.md)
- [객체 속성 온톨로지 예제](samples/object_properties.ttl)
- [상세 과제](assignment.md)

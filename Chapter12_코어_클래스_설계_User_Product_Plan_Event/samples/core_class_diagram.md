# 샘플: 통합 커머스 플랫폼 코어 클래스 다이어그램 초안

## 1. 클래스 계층

```text
Thing
├── Person
├── CustomerAccount
├── Role
│   ├── BuyerRole
│   ├── SubscriberRole
│   └── RequesterRole
├── Product
│   ├── PhysicalProduct
│   │   ├── Device
│   │   └── Accessory
│   ├── DigitalProduct
│   │   ├── DigitalContent
│   │   └── SoftwareLicense
│   └── SubscriptionPlan
│       ├── BasicPlan
│       └── PremiumPlan
├── Transaction
│   ├── Order
│   └── Payment
├── Subscription
├── Event
│   ├── CampaignEvent
│   │   ├── AcquisitionCampaign
│   │   └── RetentionCampaign
│   └── PromotionEvent
│       ├── CouponEvent
│       └── DiscountEvent
├── CustomerSegment
│   ├── NewUserSegment
│   ├── VIPSegment
│   └── ChurnRiskSegment
└── CSTicket
```

## 2. 핵심 관계

| Subject Class | Relation | Object Class | 설명 |
| --- | --- | --- | --- |
| Person | ownsAccount | CustomerAccount | 사람이 고객 계정을 소유 |
| CustomerAccount | playsRole | Role | 계정이 구매자, 구독자 등 역할을 가짐 |
| CustomerAccount | placesOrder | Order | 계정이 주문을 생성 |
| Order | containsProduct | Product | 주문이 상품 또는 플랜을 포함 |
| Order | paidBy | Payment | 주문이 결제로 처리됨 |
| CustomerAccount | ownsSubscription | Subscription | 계정이 구독 상태를 소유 |
| Subscription | hasPlan | SubscriptionPlan | 구독이 특정 플랜을 사용 |
| Person | participatesIn | Event | 사람이 이벤트에 참여 |
| CampaignEvent | targets | CustomerSegment | 캠페인이 고객 세그먼트를 타겟팅 |
| CustomerAccount | belongsToSegment | CustomerSegment | 계정이 세그먼트에 속함 |
| Person | raisesTicket | CSTicket | 사람이 CS 티켓을 생성 |

## 3. 설계 검토 포인트

### Person과 CustomerAccount

한 사람이 여러 계정을 가질 수 있고, 하나의 계정이 가족/조직 계정처럼 여러 사람과 연결될 수도 있습니다. 초기 모델에서는 `Person ownsAccount CustomerAccount`를 기본으로 두되, 확장이 필요하면 `AccountMembership` 같은 중간 클래스를 추가할 수 있습니다.

### Product와 SubscriptionPlan

구독 플랜은 판매 가능한 대상이므로 `Product`의 하위 클래스로 둡니다. 단, 실제 구독 상태는 `Subscription` 클래스로 따로 둡니다.

### Event와 CustomerSegment

이벤트는 타겟 세그먼트와 참여자를 모두 가져야 합니다. 그래야 "어떤 세그먼트를 대상으로 했고, 실제 누가 참여했는가"를 분석할 수 있습니다.

## 4. 미니 시나리오

```text
김민준은 Account_001을 소유한다.
Account_001은 PremiumPlan을 주문했다.
Order_1001은 Payment_5001로 결제되었다.
Account_001은 Subscription_2001을 소유한다.
Subscription_2001은 PremiumPlan을 사용한다.
김민준은 신규 가입 쿠폰 이벤트에 참여했다.
신규 가입 쿠폰 이벤트는 NewUserSegment를 타겟팅했다.
김민준은 환불 문의 티켓 Ticket_7001을 생성했다.
```

## 5. 트리플 초안

```text
Person_001 | ownsAccount | Account_001
Account_001 | placesOrder | Order_1001
Order_1001 | containsProduct | PremiumPlan_001
Order_1001 | paidBy | Payment_5001
Account_001 | ownsSubscription | Subscription_2001
Subscription_2001 | hasPlan | PremiumPlan_001
Person_001 | participatesIn | Event_NewCoupon
Event_NewCoupon | targets | NewUserSegment
Person_001 | raisesTicket | Ticket_7001
```

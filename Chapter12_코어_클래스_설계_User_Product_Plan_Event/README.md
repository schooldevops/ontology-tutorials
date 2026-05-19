# 12강: 코어 클래스 설계 (User, Product, Plan, Event)

## 강의 개요

Phase 1에서는 온톨로지의 개념, 표준 언어, 추론, 엔터프라이즈 아키텍처를 학습했습니다. 12강부터는 통합 커머스 플랫폼을 실제로 모델링합니다.

이번 강의의 목표는 플랫폼의 근간이 되는 코어 클래스를 설계하는 것입니다. 커머스, 구독, CS, 이벤트 도메인을 통합하려면 먼저 여러 서비스가 공유할 수 있는 상위 개념을 안정적으로 정의해야 합니다.

```text
Person / User / CustomerAccount
Product / PhysicalProduct / DigitalProduct / SubscriptionPlan
Order / Payment / Subscription
CampaignEvent / PromotionEvent / CustomerSegment
```

## 학습 목표

- 통합 커머스 플랫폼의 코어 클래스를 식별할 수 있다.
- Super-class와 Sub-class의 차이를 설명할 수 있다.
- User, Product, Plan, Event 계열의 클래스 계층을 설계할 수 있다.
- UML식 클래스 다이어그램을 온톨로지 클래스 구조로 매핑할 수 있다.

## 핵심 질문

1. `User`, `Customer`, `Member`, `Subscriber`는 같은 클래스인가, 다른 역할인가?
2. `SubscriptionPlan`은 `Product`의 하위 클래스인가?
3. `Event`와 `Campaign`은 어떤 관계로 모델링해야 하는가?
4. 코어 클래스 설계가 잘못되면 이후 관계와 추론에 어떤 문제가 생기는가?

## 1. 코어 클래스란 무엇인가?

코어 클래스는 여러 도메인에서 공통으로 참조하는 최상위 업무 개념입니다.

예:

- 고객 도메인: Person, User, CustomerAccount
- 상품 도메인: Product, PhysicalProduct, DigitalProduct, SubscriptionPlan
- 거래 도메인: Order, Payment, Subscription
- 마케팅 도메인: CampaignEvent, PromotionEvent, CustomerSegment
- CS 도메인: CSTicket, TicketCategory

코어 클래스는 너무 세부적이면 재사용하기 어렵고, 너무 추상적이면 업무 의미가 약해집니다. 따라서 "여러 서비스가 공유하지만 업무적으로 구분 가능한 수준"에서 정의해야 합니다.

## 2. Person, User, CustomerAccount 구분

커머스 플랫폼에서 사람을 나타내는 개념은 자주 혼동됩니다.

| 개념 | 의미 | 예 |
| --- | --- | --- |
| Person | 실제 자연인 | 김민준 |
| User | 서비스 로그인 주체 | user_id = U001 |
| CustomerAccount | 거래와 구독을 소유하는 계정 | account_id = A001 |
| Subscriber | 구독자 역할 | 활성 구독을 가진 계정 또는 사람 |
| Requester | CS 문의자 역할 | 티켓을 생성한 사람 |

권장 모델:

```text
Person
  ownsAccount -> CustomerAccount

CustomerAccount
  playsRole -> SubscriberRole
  placesOrder -> Order
  ownsSubscription -> Subscription
```

`Subscriber`를 사람 자체로 두기보다 역할로 두면, 한 사람이 여러 시점에서 구매자, 구독자, 문의자 역할을 동시에 가질 수 있습니다.

## 3. Product와 Plan 계층

상품 계층은 Phase 2 전체에서 가장 중요합니다. 구독 플랜도 고객에게 판매되는 대상이므로 넓은 의미에서는 상품입니다.

```text
Product
├── PhysicalProduct
│   ├── Device
│   └── Accessory
├── DigitalProduct
│   ├── DigitalContent
│   └── SoftwareLicense
└── SubscriptionPlan
    ├── BasicPlan
    └── PremiumPlan
```

이 구조의 의미:

- 모든 `SubscriptionPlan`은 `Product`다.
- 모든 `PhysicalProduct`는 배송과 재고를 가질 수 있다.
- 모든 `DigitalProduct`는 다운로드 또는 접근 권한을 가질 수 있다.
- `BasicPlan`, `PremiumPlan`은 구체적인 플랜 유형이다.

중요한 설계 판단:

```text
프리미엄 구독 플랜 type PremiumPlan
PremiumPlan subClassOf SubscriptionPlan
SubscriptionPlan subClassOf Product
```

따라서 `프리미엄 구독 플랜`은 추론상 `Product`로도 취급됩니다.

## 4. Order, Payment, Subscription 구분

거래 도메인에서는 주문, 결제, 구독을 분리해야 합니다.

| 클래스 | 의미 |
| --- | --- |
| Order | 고객이 상품 또는 플랜을 구매하겠다는 거래 요청 |
| Payment | 실제 금액 결제 기록 |
| Subscription | 일정 기간 동안 플랜을 이용하는 지속 상태 |

예:

```text
CustomerAccount placesOrder Order_1001
Order_1001 containsProduct PremiumPlan
Order_1001 paidBy Payment_5001
CustomerAccount ownsSubscription Subscription_2001
Subscription_2001 hasPlan PremiumPlan
```

주문과 구독을 합치면 구독 상태 전이, 갱신, 일시정지, 해지 같은 라이프사이클을 표현하기 어렵습니다.

## 5. Event와 Campaign 계층

마케팅 도메인에서는 이벤트, 캠페인, 프로모션, 세그먼트를 구분합니다.

```text
Event
├── CampaignEvent
│   ├── AcquisitionCampaign
│   └── RetentionCampaign
└── PromotionEvent
    ├── CouponEvent
    └── DiscountEvent

CustomerSegment
├── NewUserSegment
├── VIPSegment
└── ChurnRiskSegment
```

관계 예:

```text
CampaignEvent targets CustomerSegment
Person participatesIn CampaignEvent
PromotionEvent provides Benefit
CampaignEvent influenced Subscription
```

`Event`를 단순 문자열로 두면 참여자, 타겟 세그먼트, 전환 효과, Action을 연결하기 어렵습니다.

## 6. UML에서 온톨로지로 매핑하기

UML 클래스 다이어그램과 온톨로지 클래스 구조는 비슷해 보이지만 목적이 다릅니다.

| UML | 온톨로지 |
| --- | --- |
| 클래스 | rdfs:Class 또는 owl:Class |
| 상속 | rdfs:subClassOf |
| 연관 | owl:ObjectProperty |
| 속성 | owl:DatatypeProperty |
| 인스턴스 | Individual |
| 제약 | OWL restriction 또는 SHACL |

예:

```text
UML:
SubscriptionPlan extends Product

Ontology:
ex:SubscriptionPlan rdfs:subClassOf ex:Product .
```

## 7. 코어 클래스 설계 원칙

### 1. 역할과 실체를 분리한다

`Person`은 실체이고, `SubscriberRole`은 역할입니다.

### 2. 거래와 상태를 분리한다

`Order`는 거래 이벤트이고, `Subscription`은 지속 상태입니다.

### 3. 상품 유형과 상품 속성을 혼동하지 않는다

`PhysicalProduct`는 유형이고, `color`, `weight`, `connectionType`은 속성입니다.

### 4. 이벤트를 문자열로 축소하지 않는다

이벤트는 타겟, 참여자, 혜택, 성과를 가진 업무 객체입니다.

### 5. 추론 가능한 계층을 만든다

`PremiumPlan subClassOf SubscriptionPlan`, `SubscriptionPlan subClassOf Product`처럼 상위 개념으로 추론 가능한 구조를 만듭니다.

## 8. 이번 강의의 핵심 정리

- 코어 클래스는 여러 도메인이 공유하는 최상위 업무 개념이다.
- Person, User, CustomerAccount, Role은 구분해야 한다.
- SubscriptionPlan은 Product의 하위 클래스로 모델링할 수 있다.
- Order, Payment, Subscription은 서로 다른 라이프사이클을 가지므로 분리한다.
- Event와 Campaign은 타겟, 참여, 전환 효과를 연결하는 업무 객체다.
- UML 다이어그램은 온톨로지 설계의 초안으로 유용하지만, 최종적으로는 클래스, 관계, 속성, 제약으로 명확히 매핑해야 한다.

## 실습 파일

- [코어 클래스 다이어그램 초안](samples/core_class_diagram.md)
- [코어 클래스 온톨로지 예제](samples/core_classes.ttl)
- [상세 과제](assignment.md)

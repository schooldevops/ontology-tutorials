# 2강: 온톨로지의 핵심 구성 요소

## 강의 개요

1강에서는 온톨로지가 데이터의 의미를 연결하는 지식 모델이라는 점을 살펴봤습니다. 2강에서는 온톨로지를 실제로 구성하는 기본 단위인 클래스, 속성, 인스턴스를 학습합니다.

온톨로지는 복잡해 보이지만 기본 구조는 단순합니다. 어떤 종류의 것이 존재하는지 정의하고, 그것들이 어떤 속성과 관계를 가지는지 설명하며, 실제 개별 대상을 그 구조에 배치합니다.

```text
Class      어떤 종류의 것인가?
Property   어떤 특징 또는 관계를 가지는가?
Instance   실제 세계의 어떤 개별 대상인가?
```

## 학습 목표

- 클래스, 속성, 인스턴스의 차이를 설명할 수 있다.
- 객체 속성과 데이터 속성을 구분할 수 있다.
- 실생활 객체를 온톨로지 구성 요소로 분해할 수 있다.
- 커머스 도메인의 고객, 상품, 주문을 온톨로지 요소로 모델링할 수 있다.

## 핵심 질문

1. `김민준`은 클래스인가, 인스턴스인가?
2. `Customer`와 `U001`은 어떤 관계인가?
3. `email`과 `placesOrder`는 모두 속성이지만 무엇이 다른가?
4. 좋은 온톨로지 모델은 왜 개별 데이터보다 먼저 개념 구조를 정의하는가?

## 1. 클래스(Class 또는 Concept)

클래스는 같은 성격을 가진 대상들의 개념적 묶음입니다. 프로그래밍의 클래스나 데이터베이스의 테이블과 비슷하게 느껴질 수 있지만, 온톨로지에서 클래스는 저장 구조보다 "업무 세계의 개념"을 표현하는 데 더 가깝습니다.

예:

- `Customer`: 상품을 구매하거나 서비스를 이용하는 고객
- `Product`: 판매 또는 제공 가능한 상품
- `SubscriptionPlan`: 반복 결제 기반으로 제공되는 구독 플랜
- `Order`: 고객의 구매 행위가 기록된 주문
- `MarketingEvent`: 고객 유입이나 전환을 유도하기 위한 이벤트

클래스는 보통 계층 구조를 가질 수 있습니다.

```text
Product
├── PhysicalProduct
└── SubscriptionPlan
```

이 구조는 `SubscriptionPlan`이 상품의 한 종류라는 의미를 명시합니다. 따라서 시스템은 구독 플랜을 상품으로도 취급할 수 있습니다.

## 2. 속성(Property 또는 Relation)

속성은 클래스나 인스턴스가 가지는 특징 또는 관계를 표현합니다. 온톨로지에서는 속성을 크게 두 종류로 나눌 수 있습니다.

### 데이터 속성(Data Property)

데이터 속성은 인스턴스와 값 사이의 관계입니다.

예:

```text
김민준 --name--> "김민준"
김민준 --email--> "minjun@example.com"
프리미엄구독플랜 --price--> 29000
```

데이터 속성의 대상은 문자열, 숫자, 날짜, 불리언 같은 리터럴 값입니다.

### 객체 속성(Object Property)

객체 속성은 인스턴스와 다른 인스턴스 사이의 관계입니다.

예:

```text
김민준 --placesOrder--> 주문O1001
주문O1001 --containsProduct--> 프리미엄구독플랜
김민준 --participatesIn--> 5월구독전환캠페인
```

객체 속성의 대상은 다른 개체입니다. 온톨로지와 지식 그래프에서 실제 의미 네트워크를 만드는 핵심은 대부분 객체 속성입니다.

## 3. 인스턴스(Instance 또는 Individual)

인스턴스는 클래스에 속하는 실제 개별 대상입니다.

예:

| 클래스 | 인스턴스 예 |
| --- | --- |
| Customer | 김민준, 이서연 |
| Product | 무선 키보드, 프리미엄 구독 플랜 |
| Order | O1001, O1002 |
| MarketingEvent | 5월 구독 전환 캠페인 |

클래스와 인스턴스의 관계는 `type` 또는 `rdf:type`으로 표현합니다.

```text
김민준 type Customer
프리미엄구독플랜 type SubscriptionPlan
O1001 type Order
```

## 4. 클래스, 속성, 인스턴스의 관계

온톨로지 모델은 세 요소가 함께 있어야 의미를 가집니다.

```text
Class:
  Customer
  Order
  Product

Instance:
  U001 is a Customer
  O1001 is an Order
  P001 is a Product

Property:
  U001 placesOrder O1001
  O1001 containsProduct P001
```

클래스만 있으면 추상적인 분류표에 머뭅니다. 인스턴스만 있으면 단순 데이터 목록에 가깝습니다. 속성이 있어야 개체들이 연결되고, 그래프 형태의 지식이 됩니다.

## 5. Domain과 Range

속성은 아무 곳에나 붙이는 것이 아니라, 보통 어떤 출발점과 도착점을 가지는지 정의합니다.

- Domain: 속성이 출발하는 클래스
- Range: 속성이 도착하는 클래스 또는 값 타입

예:

```text
placesOrder
  Domain: Customer
  Range: Order

containsProduct
  Domain: Order
  Range: Product

price
  Domain: Product
  Range: decimal
```

이 정의는 모델의 일관성을 높입니다. 예를 들어 `placesOrder`의 Domain이 `Customer`라면, 상품이 주문을 생성한다는 식의 잘못된 관계를 검토할 수 있습니다.

## 6. 실생활 객체 분해 예시

다음 문장을 온톨로지 요소로 분해해봅니다.

> 김민준 고객은 5월 구독 전환 캠페인에 참여했고, 프리미엄 구독 플랜을 주문했다.

### 클래스

- Customer
- MarketingEvent
- SubscriptionPlan
- Order

### 인스턴스

- 김민준
- 5월 구독 전환 캠페인
- 프리미엄 구독 플랜
- 주문 O1001

### 데이터 속성

- 김민준의 email
- 프리미엄 구독 플랜의 price
- 주문 O1001의 orderedAt

### 객체 속성

- 김민준 participatesIn 5월 구독 전환 캠페인
- 김민준 placesOrder 주문 O1001
- 주문 O1001 containsProduct 프리미엄 구독 플랜

## 7. 모델링할 때 자주 하는 실수

### 실수 1. 클래스와 인스턴스를 혼동한다

`Customer`는 클래스이고, `김민준`은 인스턴스입니다. `프리미엄 구독 플랜`은 경우에 따라 인스턴스일 수도 있고 클래스일 수도 있습니다.

이번 과정에서는 구체적인 판매 상품 하나를 나타낼 때 `프리미엄 구독 플랜`을 `SubscriptionPlan`의 인스턴스로 다룹니다.

### 실수 2. 모든 것을 문자열 속성으로 만든다

나쁜 예:

```text
김민준 --orderedProductName--> "프리미엄 구독 플랜"
```

좋은 예:

```text
김민준 --placesOrder--> 주문O1001
주문O1001 --containsProduct--> 프리미엄구독플랜
프리미엄구독플랜 --name--> "프리미엄 구독 플랜"
```

문자열로만 저장하면 상품의 가격, 유형, 구독 여부, 추천 관계 등을 확장하기 어렵습니다.

### 실수 3. 관계 이름을 업무 의미 없이 만든다

`has`, `relatedTo`, `linkedWith` 같은 이름만 쓰면 관계의 의미가 흐려집니다. 가능한 한 업무적으로 읽히는 관계 이름을 사용합니다.

예:

- `placesOrder`
- `containsProduct`
- `participatesIn`
- `subscribesTo`
- `raisesTicket`

## 8. 이번 강의의 핵심 정리

- 클래스는 개념의 종류를 정의한다.
- 인스턴스는 클래스에 속하는 실제 개별 대상이다.
- 데이터 속성은 인스턴스와 리터럴 값을 연결한다.
- 객체 속성은 인스턴스와 인스턴스를 연결한다.
- Domain과 Range는 속성이 어떤 대상 사이에서 사용되는지 제한한다.
- 좋은 온톨로지는 개념, 관계, 실제 데이터를 분리하되 의미 있게 연결한다.

## 실습 파일

- [객체 분해 예제](samples/object_decomposition.md)
- [온톨로지 구성 요소 예제](samples/core_components.ttl)
- [상세 과제](assignment.md)

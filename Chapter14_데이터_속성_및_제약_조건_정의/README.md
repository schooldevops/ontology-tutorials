# 14강: 데이터 속성(Data Property) 및 제약 조건 정의

## 강의 개요

12강에서는 코어 클래스를 정의했고, 13강에서는 클래스 사이의 객체 속성을 설계했습니다. 14강에서는 각 객체가 가지는 구체적인 상태값과 비즈니스 룰을 데이터 속성과 제약 조건으로 표현합니다.

객체 속성이 인스턴스와 인스턴스를 연결한다면, 데이터 속성은 인스턴스와 리터럴 값을 연결합니다.

```text
PremiumPlan_001 --price--> 29000
Subscription_2001 --status--> "ACTIVE"
Event_NewCoupon --startDate--> "2026-05-01"
Order_1001 --orderedAt--> "2026-05-01T10:30:00"
```

데이터 속성은 단순 메타데이터가 아닙니다. 가격, 상태, 날짜, 수량, 등급 같은 값은 Rule, 추론, Action 실행 조건의 기반이 됩니다.

## 학습 목표

- 데이터 속성과 객체 속성의 차이를 설명할 수 있다.
- Domain, Range, datatype을 사용해 데이터 속성을 정의할 수 있다.
- Cardinality 제약의 의미를 이해할 수 있다.
- 구독 플랜의 가격, 상태, 이벤트 기간 등 업무 속성을 모델링할 수 있다.
- OWL 제약과 SHACL 검증의 역할 차이를 설명할 수 있다.

## 핵심 질문

1. `price`, `status`, `startDate`는 왜 객체 속성이 아니라 데이터 속성인가?
2. `Subscription.status`는 문자열로 두는 것이 좋은가, 상태 클래스로 모델링하는 것이 좋은가?
3. 구독은 반드시 하나의 플랜을 가져야 한다는 제약은 어떻게 표현할 수 있는가?
4. OWL 제약과 데이터 품질 검증 규칙은 어떻게 다른가?

## 1. 데이터 속성이란 무엇인가?

데이터 속성은 개체와 리터럴 값을 연결합니다.

예:

```text
Product --name--> "프리미엄 구독 플랜"
Product --price--> 29000
Subscription --status--> "ACTIVE"
Event --startDate--> "2026-05-01"
Payment --amount--> 29000
```

리터럴 값에는 문자열, 숫자, 날짜, 날짜시간, 불리언 등이 있습니다.

| 값 유형 | XSD 타입 예 |
| --- | --- |
| 문자열 | `xsd:string` |
| 정수 | `xsd:integer` |
| 소수 | `xsd:decimal` |
| 날짜 | `xsd:date` |
| 날짜시간 | `xsd:dateTime` |
| 참/거짓 | `xsd:boolean` |

## 2. Domain, Range, Datatype

데이터 속성도 객체 속성과 마찬가지로 Domain과 Range를 가집니다.

```text
Property: price
Domain: Product
Range: xsd:decimal
```

Turtle 표현:

```turtle
ex:price
    a owl:DatatypeProperty ;
    rdfs:domain ex:Product ;
    rdfs:range xsd:decimal .
```

이 정의는 상품의 가격이 숫자 값이어야 한다는 의미를 표현합니다.

## 3. 통합 커머스 핵심 데이터 속성

| Property | Domain | Range | 설명 |
| --- | --- | --- | --- |
| name | owl:Thing | xsd:string | 표시 이름 |
| status | owl:Thing | xsd:string | 업무 상태 |
| price | Product | xsd:decimal | 상품 가격 |
| currency | Product | xsd:string | 통화 코드 |
| orderedAt | Order | xsd:dateTime | 주문 시각 |
| paidAt | Payment | xsd:dateTime | 결제 시각 |
| amount | Payment | xsd:decimal | 결제 금액 |
| startDate | Subscription | xsd:date | 구독 시작일 |
| endDate | Subscription | xsd:date | 구독 종료일 |
| renewalDate | Subscription | xsd:date | 다음 갱신일 |
| eventStartDate | Event | xsd:date | 이벤트 시작일 |
| eventEndDate | Event | xsd:date | 이벤트 종료일 |
| quantity | OrderItem | xsd:integer | 주문 항목 수량 |
| unitPrice | OrderItem | xsd:decimal | 주문 항목 단가 |
| discountAmount | OrderItem | xsd:decimal | 할인 금액 |

## 4. 상태값 모델링: 문자열 vs 클래스

상태값은 두 방식으로 표현할 수 있습니다.

### 방식 1. 문자열 데이터 속성

```text
Subscription_2001 status "ACTIVE"
```

장점:

- 단순하다.
- 원천 시스템 값을 그대로 매핑하기 쉽다.
- 초기 설계에 빠르게 적용할 수 있다.

단점:

- 허용 가능한 값 목록을 엄격히 관리하기 어렵다.
- 상태 간 전이 규칙을 표현하기 어렵다.
- 오탈자나 시스템별 값 차이를 놓치기 쉽다.

### 방식 2. 상태를 클래스 또는 인스턴스로 모델링

```text
Subscription_2001 hasSubscriptionStatus ActiveStatus
ActiveStatus type SubscriptionStatus
```

장점:

- 상태값을 표준화할 수 있다.
- 상태 전이 규칙을 모델링하기 좋다.
- 다국어 라벨, 설명, 우선순위, 종료 상태 여부 같은 메타데이터를 붙일 수 있다.

단점:

- 모델이 복잡해진다.
- 단순 조회에는 과할 수 있다.

초기 모델에서는 문자열로 시작하되, 상태 전이나 검증이 중요해지는 도메인은 상태 클래스로 승격하는 전략이 실용적입니다.

## 5. Cardinality 제약

Cardinality는 어떤 관계나 속성이 몇 개 있어야 하는지를 표현하는 제약입니다.

예:

```text
Subscription은 정확히 하나의 SubscriptionPlan을 가져야 한다.
Order는 최소 하나의 OrderItem을 가져야 한다.
Payment는 정확히 하나의 amount 값을 가져야 한다.
CampaignEvent는 최소 하나의 target CustomerSegment를 가져야 한다.
```

OWL 표현 예:

```turtle
ex:Subscription
    rdfs:subClassOf [
        a owl:Restriction ;
        owl:onProperty ex:hasPlan ;
        owl:qualifiedCardinality "1"^^xsd:nonNegativeInteger ;
        owl:onClass ex:SubscriptionPlan
    ] .
```

Cardinality는 설계 의도를 표현하는 데 유용하지만, 운영 데이터 검증에는 SHACL 같은 검증 언어가 더 직접적일 수 있습니다.

## 6. OWL 제약과 SHACL 검증

OWL과 SHACL은 목적이 다릅니다.

| 구분 | OWL | SHACL |
| --- | --- | --- |
| 주요 목적 | 의미 표현과 추론 | 데이터 유효성 검증 |
| 관점 | 열린 세계 가정 | 닫힌 검증 규칙에 가까움 |
| 예 | 구독은 플랜을 가진다 | 구독 데이터에는 `hasPlan`이 정확히 1개 있어야 한다 |
| 사용 시점 | 모델링, 추론 | 적재, 배포, CI 검증 |

예를 들어 운영 데이터에서 `Subscription`에 `hasPlan`이 없으면, SHACL은 검증 오류로 보고할 수 있습니다.

## 7. 비즈니스 룰과 데이터 속성

데이터 속성은 Rule과 Action 조건의 기반입니다.

예:

```text
IF
  Subscription.status = ACTIVE
  Subscription.renewalDate <= 14 days
  Payment.status = FAILED
THEN
  CustomerAccount.riskLevel = HIGH
  availableAction = OfferRetentionDiscount
```

이 룰이 작동하려면 `status`, `renewalDate`, `Payment.status` 같은 데이터 속성이 일관된 타입과 값 체계로 관리되어야 합니다.

## 8. 데이터 속성 설계 검토 질문

데이터 속성을 정의할 때 다음을 확인합니다.

1. 값이 다른 객체를 가리키는가, 리터럴 값인가?
2. Domain과 Range가 명확한가?
3. 날짜, 숫자, 문자열 타입이 적절한가?
4. 상태값의 허용 목록이 필요한가?
5. Cardinality 제약이 필요한가?
6. Rule이나 Action 조건에서 사용되는가?
7. 원천 시스템 값과 온톨로지 표준 값의 매핑이 필요한가?

## 9. 이번 강의의 핵심 정리

- 데이터 속성은 인스턴스와 리터럴 값을 연결한다.
- 데이터 속성도 Domain, Range, datatype을 가져야 한다.
- 가격, 상태, 날짜, 수량 같은 값은 Rule과 Action의 핵심 입력이다.
- 상태값은 처음에는 문자열로 둘 수 있지만, 복잡해지면 상태 클래스로 승격할 수 있다.
- Cardinality는 속성이나 관계의 개수 제약을 표현한다.
- OWL은 의미와 추론에 강하고, SHACL은 데이터 검증에 강하다.

## 실습 파일

- [데이터 속성과 제약 설계 예제](samples/data_property_constraints.md)
- [데이터 속성 온톨로지 예제](samples/data_properties_constraints.ttl)
- [상세 과제](assignment.md)

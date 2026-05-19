# 샘플: 트리플 구조 읽기

## 1. 자연어 문장

다음 문장을 RDF 트리플로 바꿔봅니다.

> 김민준 고객은 프리미엄 구독 플랜을 주문했고, 그 주문은 5월 구독 전환 캠페인의 영향을 받았다.

## 2. 후보 개체

| 개체 | 설명 | URI 예시 |
| --- | --- | --- |
| 김민준 | 고객 인스턴스 | `ex:U001` |
| 프리미엄 구독 플랜 | 구독 플랜 인스턴스 | `ex:P001` |
| 주문 O1001 | 주문 인스턴스 | `ex:O1001` |
| 5월 구독 전환 캠페인 | 마케팅 이벤트 인스턴스 | `ex:E001` |

## 3. 클래스 트리플

```text
ex:U001 | rdf:type | ex:Customer
ex:P001 | rdf:type | ex:SubscriptionPlan
ex:O1001 | rdf:type | ex:Order
ex:E001 | rdf:type | ex:MarketingEvent
```

Turtle에서는 `rdf:type`을 `a`로 줄여 쓸 수 있습니다.

```turtle
ex:U001 a ex:Customer .
ex:P001 a ex:SubscriptionPlan .
ex:O1001 a ex:Order .
ex:E001 a ex:MarketingEvent .
```

## 4. 객체 속성 트리플

```text
ex:U001 | ex:placesOrder | ex:O1001
ex:O1001 | ex:containsProduct | ex:P001
ex:O1001 | ex:influencedBy | ex:E001
```

## 5. 데이터 속성 트리플

```text
ex:U001 | ex:name | "김민준"
ex:P001 | ex:name | "프리미엄 구독 플랜"
ex:P001 | ex:price | "29000.00"^^xsd:decimal
ex:O1001 | ex:status | "PAID"
```

## 6. RDFS 스키마 트리플

```text
ex:SubscriptionPlan | rdfs:subClassOf | ex:Product
ex:placesOrder | rdfs:domain | ex:Customer
ex:placesOrder | rdfs:range | ex:Order
ex:containsProduct | rdfs:domain | ex:Order
ex:containsProduct | rdfs:range | ex:Product
```

## 7. OWL 의미 트리플

```text
ex:placesOrder | owl:inverseOf | ex:orderedBy
ex:PhysicalProduct | owl:disjointWith | ex:DigitalService
```

## 8. 읽기 연습

아래 트리플을 자연어로 읽어보세요.

```text
ex:P001 | rdf:type | ex:SubscriptionPlan
ex:SubscriptionPlan | rdfs:subClassOf | ex:Product
ex:U001 | ex:placesOrder | ex:O1001
ex:O1001 | ex:containsProduct | ex:P001
```

가능한 해석:

> P001은 구독 플랜이다. 구독 플랜은 상품의 하위 개념이다. U001 고객은 O1001 주문을 생성했고, O1001 주문은 P001 상품을 포함한다.

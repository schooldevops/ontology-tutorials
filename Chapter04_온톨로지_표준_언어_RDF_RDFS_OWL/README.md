# 4강: 온톨로지 표준 언어 (RDF, RDFS, OWL)

## 강의 개요

앞선 강의에서는 온톨로지를 개념, 관계, 인스턴스로 구성된 지식 모델로 이해했습니다. 4강에서는 이 지식 모델을 기계가 읽고 교환할 수 있는 표준 언어로 표현하는 방법을 학습합니다.

온톨로지 표준 언어의 핵심은 RDF, RDFS, OWL입니다.

```text
RDF    지식을 Subject-Predicate-Object 트리플로 표현한다.
RDFS   클래스, 하위 클래스, 속성의 Domain/Range를 표현한다.
OWL    더 정교한 제약, 동등성, 역관계, 추론 규칙을 표현한다.
```

## 학습 목표

- RDF 트리플 구조를 읽고 작성할 수 있다.
- URI가 온톨로지에서 왜 중요한지 설명할 수 있다.
- RDF, RDFS, OWL의 역할 차이를 구분할 수 있다.
- 간단한 Turtle 문법으로 클래스, 속성, 인스턴스를 표현할 수 있다.

## 핵심 질문

1. `김민준 purchased 프리미엄구독플랜`은 어떤 트리플 구조인가?
2. 사람이 읽는 이름과 기계가 식별하는 URI는 왜 분리되어야 하는가?
3. RDF와 RDFS는 각각 무엇을 표현하는가?
4. OWL은 RDFS보다 어떤 추가 표현력을 제공하는가?

## 1. RDF: 지식을 트리플로 표현하기

RDF(Resource Description Framework)는 지식을 트리플로 표현합니다.

```text
Subject   Predicate       Object
주어       관계            목적어
```

예:

```text
김민준 | type | Customer
김민준 | placesOrder | 주문O1001
주문O1001 | containsProduct | 프리미엄구독플랜
프리미엄구독플랜 | price | 29000
```

RDF의 강점은 모든 지식을 같은 기본 구조로 표현한다는 점입니다. 고객, 상품, 주문, 이벤트, 구독 관계가 모두 트리플로 연결되면 지식 그래프가 됩니다.

## 2. URI: 기계가 대상을 구분하는 이름

사람은 `김민준`이라는 이름을 읽을 수 있지만, 시스템은 같은 이름을 가진 두 사람을 구분해야 합니다. 그래서 RDF에서는 URI를 사용합니다.

```text
https://example.com/ontology/customer/U001
https://example.com/ontology/order/O1001
https://example.com/ontology/product/P001
```

Turtle에서는 URI를 줄여 쓰기 위해 prefix를 사용합니다.

```turtle
@prefix ex: <https://example.com/ontology/> .

ex:U001 ex:placesOrder ex:O1001 .
```

위 문장은 실제로 다음 의미입니다.

```text
https://example.com/ontology/U001
  https://example.com/ontology/placesOrder
  https://example.com/ontology/O1001
```

## 3. Turtle 문법 기초

Turtle은 RDF를 사람이 읽기 쉽게 작성하는 문법입니다.

### 기본 트리플

```turtle
ex:U001 ex:name "김민준" .
```

### 같은 Subject에 여러 Predicate 작성

```turtle
ex:U001
    a ex:Customer ;
    ex:name "김민준" ;
    ex:email "minjun@example.com" ;
    ex:placesOrder ex:O1001 .
```

여기서 `a`는 `rdf:type`의 축약형입니다.

```turtle
ex:U001 a ex:Customer .
```

위 문장은 `U001은 Customer 타입이다`라는 뜻입니다.

## 4. RDFS: 클래스와 속성의 의미 정의

RDF는 개별 사실을 표현하는 데 적합합니다. RDFS는 그 사실들이 따르는 기본 스키마를 표현합니다.

### 클래스 정의

```turtle
ex:Customer a rdfs:Class .
ex:Product a rdfs:Class .
ex:Order a rdfs:Class .
```

### 하위 클래스 정의

```turtle
ex:SubscriptionPlan rdfs:subClassOf ex:Product .
```

이 문장은 `SubscriptionPlan은 Product의 하위 클래스다`라는 의미입니다.

### Domain과 Range 정의

```turtle
ex:placesOrder
    a rdf:Property ;
    rdfs:domain ex:Customer ;
    rdfs:range ex:Order .
```

이 정의는 `placesOrder` 관계가 고객에서 주문으로 향하는 관계임을 나타냅니다.

## 5. OWL: 더 정교한 온톨로지 표현

OWL(Web Ontology Language)은 RDFS보다 더 풍부한 의미와 제약을 표현합니다.

예를 들어 다음과 같은 내용을 표현할 수 있습니다.

- 두 클래스가 서로 겹치지 않는다.
- 두 속성이 서로 역관계다.
- 어떤 속성은 전이성을 가진다.
- 두 URI가 같은 대상을 가리킨다.
- 특정 클래스는 어떤 속성을 반드시 가져야 한다.

### 역관계 예시

```turtle
ex:placesOrder owl:inverseOf ex:orderedBy .
```

이 문장은 다음 두 사실이 서로 대응됨을 의미합니다.

```text
김민준 placesOrder 주문O1001
주문O1001 orderedBy 김민준
```

### 서로소 클래스 예시

```turtle
ex:PhysicalProduct owl:disjointWith ex:DigitalService .
```

이 문장은 어떤 인스턴스가 동시에 실물 상품이면서 디지털 서비스일 수 없다는 제약을 표현합니다.

## 6. RDF, RDFS, OWL 비교

| 구분 | 역할 | 예시 |
| --- | --- | --- |
| RDF | 개별 사실을 트리플로 표현 | `U001 placesOrder O1001` |
| RDFS | 클래스, 하위 클래스, Domain/Range 정의 | `SubscriptionPlan subClassOf Product` |
| OWL | 정교한 의미, 제약, 추론 규칙 정의 | `placesOrder inverseOf orderedBy` |

RDF만으로도 지식 그래프를 만들 수 있습니다. 하지만 데이터가 커지고 도메인 규칙이 복잡해질수록 RDFS와 OWL이 필요해집니다.

## 7. 이번 강의의 핵심 정리

- RDF는 지식을 Subject-Predicate-Object 트리플로 표현한다.
- URI는 기계가 대상을 안정적으로 식별하기 위한 이름이다.
- Turtle은 RDF를 사람이 읽기 쉽게 작성하는 문법이다.
- RDFS는 클래스, 하위 클래스, 속성의 Domain/Range를 정의한다.
- OWL은 역관계, 동등성, 서로소 클래스, 속성 제약 등 더 풍부한 의미를 표현한다.
- 온톨로지 표준 언어를 이해하면 지식 그래프를 도구 간에 교환하고 추론 엔진과 연결할 수 있다.

## 실습 파일

- [트리플 읽기 예제](samples/triples.md)
- [RDF/RDFS/OWL Turtle 예제](samples/rdf_rdfs_owl_example.ttl)
- [상세 과제](assignment.md)

# 5강: 온톨로지와 추론 (Reasoning & Inference)

## 강의 개요

앞선 강의에서는 RDF, RDFS, OWL로 온톨로지를 표현하는 방법을 살펴봤습니다. 5강에서는 온톨로지의 핵심 가치 중 하나인 추론을 학습합니다.

추론은 명시적으로 저장하지 않은 사실을 기존 지식과 규칙을 바탕으로 도출하는 과정입니다.

```text
명시된 사실:
  A는 B의 부모다.
  B는 C의 부모다.

추론된 사실:
  A는 C의 조부모다.
```

온톨로지에서 추론은 단순 자동 계산이 아니라, 데이터에 의미 규칙을 적용해 새로운 지식을 만들어내는 과정입니다.

## 학습 목표

- 추론과 명시적 데이터의 차이를 설명할 수 있다.
- 클래스 상속, 역관계, 전이성, 대칭성 추론을 구분할 수 있다.
- 간단한 가족 관계 추론 규칙을 설계할 수 있다.
- 커머스 도메인에서 추론이 어떤 업무 가치를 만드는지 설명할 수 있다.

## 핵심 질문

1. `SubscriptionPlan`이 `Product`의 하위 클래스라면, 구독 플랜 인스턴스는 상품인가?
2. `김민준 placesOrder O1001`이 있을 때 `O1001 orderedBy 김민준`을 저장하지 않아도 알 수 있는가?
3. `A parentOf B`, `B parentOf C`에서 `A ancestorOf C`를 어떻게 도출하는가?
4. 추론으로 얻은 지식과 원본 데이터는 운영 시스템에서 어떻게 구분해야 하는가?

## 1. 추론이란 무엇인가?

추론은 이미 알고 있는 사실과 규칙을 사용해 새로운 사실을 도출하는 과정입니다.

예:

```text
사실 1: P001 type SubscriptionPlan
사실 2: SubscriptionPlan subClassOf Product

추론: P001 type Product
```

이 추론 덕분에 시스템은 `P001`을 구독 플랜으로도, 상품으로도 다룰 수 있습니다.

## 2. 명시된 지식과 추론된 지식

온톨로지에서는 지식을 두 층으로 볼 수 있습니다.

| 구분 | 설명 | 예 |
| --- | --- | --- |
| Asserted Knowledge | 사람이 직접 입력하거나 시스템에서 적재한 사실 | `U001 placesOrder O1001` |
| Inferred Knowledge | 규칙과 온톨로지 정의로부터 도출된 사실 | `O1001 orderedBy U001` |

추론된 지식은 원본 데이터와 다르게 관리하는 것이 좋습니다. 왜냐하면 규칙이 바뀌면 추론 결과도 달라질 수 있기 때문입니다.

## 3. 클래스 상속 추론

RDFS의 `subClassOf`는 가장 기본적인 추론을 제공합니다.

```text
SubscriptionPlan subClassOf DigitalService
DigitalService subClassOf Product
P001 type SubscriptionPlan
```

위 사실들로부터 다음을 추론할 수 있습니다.

```text
P001 type DigitalService
P001 type Product
```

이 구조는 검색과 집계에 유용합니다. 사용자가 "상품 전체"를 조회할 때 실물 상품과 구독 플랜을 함께 포함할 수 있습니다.

## 4. 역관계(Inverse Property)

역관계는 한 관계가 반대 방향 관계와 대응된다는 의미입니다.

```text
placesOrder inverseOf orderedBy
```

명시된 사실:

```text
U001 placesOrder O1001
```

추론된 사실:

```text
O1001 orderedBy U001
```

역관계를 사용하면 양방향 관계를 모두 저장하지 않아도 됩니다. 필요한 방향으로 질의할 때 추론을 통해 보완할 수 있습니다.

## 5. 전이성(Transitive Property)

전이성은 관계가 여러 단계로 이어질 때 같은 관계가 확장될 수 있다는 성질입니다.

예를 들어 `ancestorOf`는 전이 관계입니다.

```text
A ancestorOf B
B ancestorOf C
```

추론:

```text
A ancestorOf C
```

커머스나 공급망에서도 전이성이 중요합니다.

```text
SupplierA supplies PartB
PartB usedIn ProductC
ProductC includedIn SubscriptionBundleD
```

이런 관계가 잘 모델링되어 있으면 특정 공급사 문제가 어떤 상품과 고객에게 영향을 주는지 추적할 수 있습니다.

## 6. 대칭성(Symmetric Property)

대칭성은 관계의 방향을 바꿔도 의미가 유지되는 성질입니다.

예:

```text
ProductA compatibleWith ProductB
```

대칭 관계로 정의되어 있다면 다음을 추론할 수 있습니다.

```text
ProductB compatibleWith ProductA
```

모든 관계가 대칭인 것은 아닙니다. `placesOrder`는 대칭 관계가 아닙니다.

```text
U001 placesOrder O1001
```

이 사실이 있다고 해서 `O1001 placesOrder U001`이 되지는 않습니다.

## 7. 부모-조부모 추론 예제

다음 가족 관계를 생각해봅니다.

```text
민수 parentOf 지훈
지훈 parentOf 서연
```

규칙:

```text
X parentOf Y
Y parentOf Z
=> X grandparentOf Z
```

추론:

```text
민수 grandparentOf 서연
```

이 예제의 핵심은 `grandparentOf`를 직접 저장하지 않아도, 부모 관계 두 개와 규칙으로부터 도출할 수 있다는 점입니다.

## 8. 커머스 도메인 추론 예제

다음 업무 규칙을 생각해봅니다.

```text
고객이 6개월 이상 구독을 유지한다.
고객의 누적 구매액이 500,000원 이상이다.
=> 고객은 VIP 고객이다.
```

온톨로지 관점에서는 다음처럼 볼 수 있습니다.

```text
Customer hasSubscriptionDurationMonths 8
Customer hasTotalPurchaseAmount 730000
Rule: duration >= 6 and amount >= 500000 => type VIPCustomer
```

추론 결과:

```text
Customer type VIPCustomer
```

이런 추론은 마케팅, 고객 지원, 추천, 리스크 관리에 활용할 수 있습니다.

## 9. 추론 사용 시 주의할 점

### 규칙의 출처를 명확히 한다

추론 규칙은 비즈니스 정책입니다. 정책이 바뀌면 결과도 달라집니다.

예:

```text
기존 VIP 기준: 6개월 이상 + 50만원 이상
변경 VIP 기준: 12개월 이상 + 100만원 이상
```

### 원본과 추론 결과를 구분한다

추론 결과를 원본처럼 저장하면 나중에 왜 그런 결과가 나왔는지 추적하기 어려워질 수 있습니다.

### 너무 많은 추론은 운영 비용을 만든다

모든 관계를 실시간으로 추론하면 성능 문제가 생길 수 있습니다. 실무에서는 자주 쓰는 추론 결과를 캐시하거나 별도 그래프에 materialize하기도 합니다.

## 10. 이번 강의의 핵심 정리

- 추론은 명시된 사실과 규칙으로부터 새로운 사실을 도출하는 과정이다.
- 클래스 상속 추론은 하위 클래스 인스턴스를 상위 클래스 인스턴스로도 볼 수 있게 한다.
- 역관계는 한 방향 관계에서 반대 방향 관계를 도출한다.
- 전이성은 여러 단계로 이어지는 관계를 확장한다.
- 대칭성은 양방향 의미가 같은 관계에 사용한다.
- 추론 결과는 원본 데이터와 구분하고, 규칙 변경 가능성을 고려해야 한다.

## 실습 파일

- [가족 관계 추론 예제](samples/family_reasoning.md)
- [OWL 추론 예제](samples/reasoning_example.ttl)
- [상세 과제](assignment.md)

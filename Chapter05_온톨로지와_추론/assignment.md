# 5강 과제: 명시된 지식에서 숨은 관계 추론하기

## 과제 목표

이번 과제는 온톨로지 추론의 기본 유형을 이해하고, 직접 규칙을 적용해 새로운 사실을 도출하는 것입니다.

## 제출물

`Chapter05_온톨로지와_추론/submission.md` 파일을 작성한다고 가정하고, 아래 항목을 모두 포함해 작성하세요.

## 과제 1. 추론 개념 정리

아래 표를 채우세요.

| 개념 | 설명 | 예시 |
| --- | --- | --- |
| Asserted Knowledge |  |  |
| Inferred Knowledge |  |  |
| Reasoner |  |  |
| Inverse Property |  |  |
| Transitive Property |  |  |
| Symmetric Property |  |  |

반드시 포함할 키워드:

- 명시된 사실
- 추론된 사실
- 규칙
- 역관계
- 전이성
- 대칭성

## 과제 2. 샘플 분석

다음 파일을 읽습니다.

- `samples/family_reasoning.md`
- `samples/reasoning_example.ttl`

아래 질문에 답하세요.

1. `ex:placesOrder owl:inverseOf ex:orderedBy`가 있을 때, `ex:U001 ex:placesOrder ex:O1001`로부터 무엇을 추론할 수 있나요?
2. `ex:compatibleWith`가 `owl:SymmetricProperty`로 정의되면 어떤 추론이 가능한가요?
3. `ex:P001 a ex:SubscriptionPlan`과 `ex:SubscriptionPlan rdfs:subClassOf ex:DigitalService`로부터 어떤 타입을 추가로 추론할 수 있나요?
4. VIP 고객 추론이 OWL 속성 성질만으로 충분하지 않은 이유를 설명하세요.

## 과제 3. 가족 관계 추론

다음 명시된 사실과 규칙이 있습니다.

```text
영호 parentOf 민수
민수 parentOf 지훈
지훈 parentOf 서연
서연 siblingOf 도윤
```

규칙:

```text
parentOf inverseOf childOf
parentOf implies ancestorOf
ancestorOf is transitive
siblingOf is symmetric
X parentOf Y AND Y parentOf Z => X grandparentOf Z
```

아래 항목을 작성하세요.

1. 역관계로 추론되는 `childOf` 트리플을 모두 작성하세요.
2. 전이성으로 추론되는 `ancestorOf` 트리플을 모두 작성하세요.
3. 조부모 규칙으로 추론되는 `grandparentOf` 트리플을 모두 작성하세요.
4. 대칭성으로 추론되는 `siblingOf` 트리플을 작성하세요.

## 과제 4. 커머스 추론 규칙 설계

다음 비즈니스 규칙을 온톨로지 추론 관점으로 작성하세요.

> 고객이 6개월 이상 구독을 유지했고, 누적 구매액이 500,000원 이상이면 VIP 고객으로 분류한다.

반드시 포함할 내용:

- 필요한 클래스
- 필요한 데이터 속성
- 필요한 조건
- 추론되는 클래스 또는 관계
- 이 추론 결과를 마케팅 또는 CS에서 활용하는 방법

표현 형식 예:

```text
Customer(?c)
subscriptionDurationMonths(?c, ?m)
totalPurchaseAmount(?c, ?a)
?m >= 6
?a >= 500000
=> VIPCustomer(?c)
```

## 과제 5. 추론 운영 전략

아래 질문에 답하세요.

1. 추론 결과를 매번 실시간으로 계산하는 방식의 장단점은 무엇인가요?
2. 추론 결과를 별도 그래프나 컬럼에 저장하는 방식의 장단점은 무엇인가요?
3. 비즈니스 규칙이 변경되면 기존 추론 결과를 어떻게 관리해야 하나요?
4. 추론 결과와 원본 데이터를 구분하지 않으면 어떤 문제가 생길 수 있나요?

## 평가 기준

| 평가 항목 | 배점 | 설명 |
| --- | ---: | --- |
| 추론 개념 이해 | 25 | 명시 지식과 추론 지식을 구분했는가 |
| 규칙 적용 | 30 | 역관계, 전이성, 대칭성 추론을 정확히 적용했는가 |
| 업무 모델링 | 25 | 커머스 VIP 규칙을 온톨로지 관점으로 표현했는가 |
| 운영 관점 | 20 | 추론 결과 관리와 규칙 변경 리스크를 설명했는가 |

## 제출 예시 템플릿

```markdown
# 5강 과제 제출

## 과제 1. 추론 개념 정리

| 개념 | 설명 | 예시 |
| --- | --- | --- |
| Asserted Knowledge |  |  |
| Inferred Knowledge |  |  |

## 과제 2. 샘플 분석

...

## 과제 3. 가족 관계 추론

### childOf

| Subject | Predicate | Object |
| --- | --- | --- |
| 민수 | childOf | 영호 |

### ancestorOf

...

### grandparentOf

...

### siblingOf

...

## 과제 4. 커머스 추론 규칙 설계

```text
...
```

## 과제 5. 추론 운영 전략

...
```

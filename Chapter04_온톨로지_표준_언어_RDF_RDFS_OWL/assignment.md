# 4강 과제: RDF, RDFS, OWL로 간단한 온톨로지 작성하기

## 과제 목표

이번 과제는 자연어 업무 문장을 RDF 트리플로 변환하고, RDFS와 OWL을 사용해 기본 스키마와 의미 제약을 작성하는 것입니다.

## 제출물

`Chapter04_온톨로지_표준_언어_RDF_RDFS_OWL/submission.md` 파일을 작성한다고 가정하고, 아래 항목을 모두 포함해 작성하세요.

## 과제 1. RDF, RDFS, OWL 비교

아래 표를 채우세요.

| 구분 | 역할 | 표현 예시 | 필요한 이유 |
| --- | --- | --- | --- |
| RDF |  |  |  |
| RDFS |  |  |  |
| OWL |  |  |  |

반드시 포함할 키워드:

- Subject-Predicate-Object
- URI
- Class
- Domain
- Range
- inverseOf
- disjointWith

## 과제 2. 샘플 읽기

다음 파일을 읽습니다.

- `samples/triples.md`
- `samples/rdf_rdfs_owl_example.ttl`

아래 질문에 답하세요.

1. `ex:U001 a ex:Customer`에서 `a`는 무엇을 의미하나요?
2. `ex:SubscriptionPlan rdfs:subClassOf ex:DigitalService`는 어떤 의미인가요?
3. `ex:placesOrder rdfs:domain ex:Customer`와 `rdfs:range ex:Order`는 어떤 제약을 표현하나요?
4. `ex:placesOrder owl:inverseOf ex:orderedBy`를 사용하면 어떤 사실을 추론할 수 있나요?
5. `ex:PhysicalProduct owl:disjointWith ex:DigitalService`는 어떤 오류를 찾는 데 도움이 되나요?

## 과제 3. 자연어를 RDF 트리플로 변환

다음 문장을 최소 12개의 RDF 트리플로 바꾸세요.

> 박지훈 고객은 신규 가입 쿠폰 이벤트에 참여했고, 베이직 구독 플랜을 주문했다. 주문 상태는 결제 완료이며, 베이직 구독 플랜의 가격은 월 19,000원이다.

형식:

```text
Subject | Predicate | Object
```

예:

```text
ex:U003 | rdf:type | ex:Customer
ex:U003 | ex:name | "박지훈"
```

## 과제 4. RDFS 스키마 작성

과제 3에서 사용한 클래스와 속성에 대해 RDFS 스키마를 작성하세요.

반드시 포함할 내용:

- 클래스 5개 이상
- `rdfs:subClassOf` 2개 이상
- 객체 속성 3개 이상
- 데이터 속성 3개 이상
- 각 속성의 Domain과 Range

형식은 Turtle 또는 표 중 편한 방식으로 작성해도 됩니다.

예:

```turtle
ex:Customer a rdfs:Class .

ex:placesOrder
    a rdf:Property ;
    rdfs:domain ex:Customer ;
    rdfs:range ex:Order .
```

## 과제 5. OWL 의미 제약 추가

아래 OWL 표현을 직접 작성하고, 각각 어떤 의미인지 설명하세요.

1. `placesOrder`와 `orderedBy`를 역관계로 정의하세요.
2. `PhysicalProduct`와 `DigitalService`를 서로소 클래스로 정의하세요.
3. `BasicPlan`과 `PremiumPlan`이 모두 `SubscriptionPlan`의 하위 클래스임을 표현하세요.
4. 같은 고객을 가리키는 두 URI가 있다고 가정하고 `owl:sameAs`를 사용해 표현하세요.

## 과제 6. Turtle 파일 초안 작성

과제 3~5의 내용을 바탕으로 하나의 Turtle 초안을 작성하세요.

필수 조건:

- `@prefix` 선언을 포함할 것
- 클래스 정의 영역, 속성 정의 영역, 인스턴스 영역을 구분할 것
- 각 트리플은 마침표로 끝낼 것
- `rdf:`, `rdfs:`, `owl:`, `xsd:` prefix를 최소 한 번 이상 사용할 것

## 평가 기준

| 평가 항목 | 배점 | 설명 |
| --- | ---: | --- |
| RDF 이해 | 25 | 자연어 사실을 트리플로 정확히 변환했는가 |
| RDFS 이해 | 25 | 클래스, 하위 클래스, Domain/Range를 적절히 정의했는가 |
| OWL 이해 | 25 | 역관계, 서로소, 동일성 표현을 의미에 맞게 사용했는가 |
| 문법과 가독성 | 25 | Turtle 구조가 읽기 쉽고 기본 문법을 지켰는가 |

## 제출 예시 템플릿

```markdown
# 4강 과제 제출

## 과제 1. RDF, RDFS, OWL 비교

| 구분 | 역할 | 표현 예시 | 필요한 이유 |
| --- | --- | --- | --- |
| RDF |  |  |  |
| RDFS |  |  |  |
| OWL |  |  |  |

## 과제 2. 샘플 읽기

...

## 과제 3. RDF 트리플

| Subject | Predicate | Object |
| --- | --- | --- |
| ex:U003 | rdf:type | ex:Customer |

## 과제 4. RDFS 스키마

```turtle
...
```

## 과제 5. OWL 의미 제약

```turtle
...
```

## 과제 6. Turtle 파일 초안

```turtle
...
```
```

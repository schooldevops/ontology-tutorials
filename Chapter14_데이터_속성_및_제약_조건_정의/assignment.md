# 14강 과제: 데이터 속성과 제약 조건 설계하기

## 과제 목표

이번 과제는 통합 커머스 플랫폼의 주요 객체에 필요한 데이터 속성을 정의하고, Domain, Range, datatype, Cardinality, 검증 규칙을 설계하는 것입니다.

## 제출물

`Chapter14_데이터_속성_및_제약_조건_정의/submission.md` 파일을 작성한다고 가정하고, 아래 항목을 모두 포함해 작성하세요.

## 과제 1. 데이터 속성 개념 정리

아래 개념을 본인의 말로 설명하세요.

| 개념 | 설명 | 예시 |
| --- | --- | --- |
| Data Property |  |  |
| Literal |  |  |
| Datatype |  |  |
| Domain |  |  |
| Range |  |  |
| Cardinality |  |  |
| SHACL Validation |  |  |

반드시 포함할 키워드:

- `xsd:string`
- `xsd:decimal`
- `xsd:date`
- `xsd:dateTime`
- 상태값
- 허용 값
- 검증

## 과제 2. 샘플 분석

다음 파일을 읽습니다.

- `samples/data_property_constraints.md`
- `samples/data_properties_constraints.ttl`

아래 질문에 답하세요.

1. `price`와 `amount`를 서로 다른 데이터 속성으로 둔 이유는 무엇인가요?
2. `subscriptionStatus`와 `paymentStatus`를 공통 `status` 하나로만 처리하면 어떤 문제가 생길 수 있나요?
3. `Subscription`이 정확히 하나의 `hasPlan`을 가져야 하는 이유는 무엇인가요?
4. `OrderItem.quantity`가 1 이상이어야 하는 이유는 무엇인가요?
5. `eventStartDate <= eventEndDate` 같은 규칙은 OWL과 SHACL 중 어디에 더 적합한가요? 이유를 설명하세요.

## 과제 3. 핵심 데이터 속성 정의

통합 커머스 플랫폼의 데이터 속성을 최소 18개 이상 정의하세요.

아래 형식으로 작성하세요.

| Property | Domain | Range | 필수 여부 | 설명 |
| --- | --- | --- | --- | --- |
| price | Product | xsd:decimal | 필수 | 상품 가격 |

반드시 포함할 속성:

- name
- price
- currency
- billingCycle
- orderStatus
- orderedAt
- paymentStatus
- amount
- paidAt
- subscriptionStatus
- startDate
- endDate
- renewalDate
- eventStartDate
- eventEndDate
- quantity
- unitPrice
- discountAmount

## 과제 4. 상태값 표준화 설계

아래 상태값을 온톨로지 표준 값으로 매핑하세요.

| 도메인 | 원천 시스템 값 | 온톨로지 표준 값 | 설명 |
| --- | --- | --- | --- |
| Subscription | active |  |  |
| Subscription | in_use |  |  |
| Subscription | paused |  |  |
| Subscription | cancelled |  |  |
| Payment | paid |  |  |
| Payment | complete |  |  |
| Payment | failed |  |  |
| Order | payment_done |  |  |
| Order | refunded |  |  |

그리고 다음 질문에 답하세요.

1. 원천 값을 그대로 쓰지 않고 표준 값을 두는 이유는 무엇인가요?
2. 상태값을 문자열로 둘 때의 장단점은 무엇인가요?
3. 상태값을 별도 클래스 또는 인스턴스로 승격해야 하는 상황은 언제인가요?

## 과제 5. 제약 조건 설계

아래 객체에 대해 제약 조건을 설계하세요.

| 대상 클래스 | 제약 조건 | 표현 방식 후보 | 이유 |
| --- | --- | --- | --- |
| Product |  | OWL 또는 SHACL |  |
| SubscriptionPlan |  | OWL 또는 SHACL |  |
| Order |  | OWL 또는 SHACL |  |
| OrderItem |  | OWL 또는 SHACL |  |
| Payment |  | OWL 또는 SHACL |  |
| Subscription |  | OWL 또는 SHACL |  |
| CampaignEvent |  | OWL 또는 SHACL |  |

반드시 포함할 제약:

- 가격은 0 이상
- 통화는 허용 목록 중 하나
- 청구 주기는 `MONTHLY` 또는 `YEARLY`
- 주문은 최소 1개의 주문 항목을 가짐
- 주문 항목 수량은 1 이상
- 결제 금액은 0보다 큼
- 구독은 정확히 1개의 플랜을 가짐
- 이벤트 시작일은 종료일보다 늦을 수 없음

## 과제 6. Rule 조건으로 활용하기

다음 비즈니스 Rule을 데이터 속성 기반으로 작성하세요.

> 활성 구독이고, 갱신일이 14일 이내이며, 최근 결제가 실패한 고객은 이탈 위험 고객으로 분류한다.

반드시 포함할 내용:

- 필요한 클래스
- 필요한 객체 속성
- 필요한 데이터 속성
- 조건식
- 추론 또는 결과 상태
- 추천 Action

## 과제 7. Turtle 초안 작성

과제 3~6을 바탕으로 Turtle 초안을 작성하세요.

필수 조건:

- `owl:DatatypeProperty` 15개 이상
- 각 속성의 Domain과 Range
- Cardinality 제약 2개 이상
- 예시 인스턴스 1개의 속성값
- SHACL로 옮길 검증 아이디어 주석 3개 이상

## 평가 기준

| 평가 항목 | 배점 | 설명 |
| --- | ---: | --- |
| 데이터 속성 이해 | 25 | 리터럴 값과 객체 관계를 정확히 구분했는가 |
| 속성 정의 품질 | 25 | Domain, Range, datatype을 적절히 정의했는가 |
| 제약 설계 | 30 | Cardinality와 검증 규칙을 업무 의미에 맞게 설계했는가 |
| Rule 활용 | 20 | 데이터 속성을 비즈니스 Rule과 Action 조건에 연결했는가 |

## 제출 예시 템플릿

```markdown
# 14강 과제 제출

## 과제 1. 데이터 속성 개념 정리

| 개념 | 설명 | 예시 |
| --- | --- | --- |
| Data Property |  |  |

## 과제 2. 샘플 분석

...

## 과제 3. 핵심 데이터 속성 정의

| Property | Domain | Range | 필수 여부 | 설명 |
| --- | --- | --- | --- | --- |
| price | Product | xsd:decimal | 필수 |  |

## 과제 4. 상태값 표준화 설계

...

## 과제 5. 제약 조건 설계

...

## 과제 6. Rule 조건으로 활용하기

```text
...
```

## 과제 7. Turtle 초안

```turtle
...
```
```

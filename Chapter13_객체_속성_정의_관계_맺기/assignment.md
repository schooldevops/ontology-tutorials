# 13강 과제: 통합 커머스 객체 속성 설계하기

## 과제 목표

이번 과제는 12강에서 설계한 코어 클래스 사이의 객체 속성을 정의하고, 고객이 상품을 구매하고 이벤트에 참여하며 구독과 CS 티켓으로 연결되는 관계 네트워크를 설계하는 것입니다.

## 제출물

`Chapter13_객체_속성_정의_관계_맺기/submission.md` 파일을 작성한다고 가정하고, 아래 항목을 모두 포함해 작성하세요.

## 과제 1. 객체 속성 개념 정리

아래 개념을 본인의 말로 설명하세요.

| 개념 | 설명 | 예시 |
| --- | --- | --- |
| Object Property |  |  |
| Data Property |  |  |
| Domain |  |  |
| Range |  |  |
| Inverse Property |  |  |
| Reified Relationship |  |  |

반드시 포함할 키워드:

- 인스턴스 간 관계
- 리터럴 값
- Domain
- Range
- 역관계
- 중간 객체

## 과제 2. 샘플 분석

다음 파일을 읽습니다.

- `samples/object_property_network.md`
- `samples/object_properties.ttl`

아래 질문에 답하세요.

1. `CustomerAccount purchases Product`를 바로 쓰지 않고 `Order`를 중간에 둔 이유는 무엇인가요?
2. `placesOrder`와 `orderedBy`는 어떤 관계인가요?
3. `OrderItem` 중간 객체가 필요한 이유는 무엇인가요?
4. `EventParticipation` 중간 객체는 어떤 추가 정보를 표현하나요?
5. `Ticket relatedToSubscription Subscription` 관계는 어떤 업무 질문에 도움이 되나요?

## 과제 3. 핵심 객체 속성 정의

통합 커머스 플랫폼의 핵심 객체 속성을 최소 15개 이상 정의하세요.

아래 형식으로 작성하세요.

| Property | Domain | Range | 역관계 | 설명 |
| --- | --- | --- | --- | --- |
| placesOrder | CustomerAccount | Order | orderedBy | 계정이 주문을 생성 |

반드시 포함할 관계:

- ownsAccount
- playsRole
- placesOrder
- orderedBy
- containsProduct
- paidBy
- ownsSubscription
- hasPlan
- participatesIn
- targets
- belongsToSegment
- raisesTicket
- relatedToOrder
- relatedToSubscription
- availableAction

## 과제 4. 중간 객체가 필요한 관계 설계

아래 두 관계를 단순 직접 관계와 중간 객체 방식으로 각각 설계하고 비교하세요.

1. 주문이 상품을 포함한다.
2. 사람이 이벤트에 참여한다.

반드시 포함할 내용:

- 직접 관계 모델
- 중간 객체 모델
- 중간 객체에 붙일 데이터 속성
- 어떤 상황에서 중간 객체 모델이 더 적절한지

## 과제 5. 관계 네트워크 모델링

다음 문장을 최소 18개의 트리플로 모델링하세요.

> 이서연은 활성 고객 계정을 소유한다. 이 계정은 베이직 구독 플랜을 주문했고, 주문은 결제로 완료되었다. 주문에는 주문 항목이 있으며 수량은 1개, 단가는 19,000원이다. 이서연은 신규 가입 쿠폰 이벤트에 모바일 앱으로 참여했고, 그 참여는 베이직 구독으로 전환되었다. 이후 이서연은 환불 문의 티켓을 생성했고, 그 티켓은 주문과 구독 모두에 관련된다.

형식:

```text
Subject | Predicate | Object
```

## 과제 6. Turtle 초안 작성

과제 3~5의 내용을 바탕으로 Turtle 초안을 작성하세요.

필수 조건:

- `owl:ObjectProperty` 15개 이상
- 각 주요 관계의 Domain과 Range
- `owl:inverseOf` 1개 이상
- 중간 객체 클래스 2개 이상
- 예시 고객 1명의 관계 그래프

## 과제 7. 관계 설계 리뷰

본인이 설계한 관계 모델을 아래 기준으로 리뷰하세요.

| 기준 | 리뷰 질문 | 답변 |
| --- | --- | --- |
| 업무 의미 | 관계 이름이 업무 문장처럼 읽히는가? |  |
| Domain/Range | 출발점과 도착점이 명확한가? |  |
| 확장성 | 이력, 수량, 채널 같은 메타데이터를 추가할 수 있는가? |  |
| 추론 | 역관계나 상위 클래스 추론에 활용 가능한가? |  |
| 질의성 | 실제 업무 질문에 답하는 데 도움이 되는가? |  |

## 평가 기준

| 평가 항목 | 배점 | 설명 |
| --- | ---: | --- |
| 객체 속성 이해 | 25 | Object Property와 Data Property를 정확히 구분했는가 |
| 관계 모델링 | 30 | Domain/Range와 업무 의미를 명확히 정의했는가 |
| 중간 객체 설계 | 25 | 관계 메타데이터가 필요한 상황을 적절히 처리했는가 |
| 리뷰 품질 | 20 | 확장성, 추론, 질의 관점에서 모델을 검토했는가 |

## 제출 예시 템플릿

```markdown
# 13강 과제 제출

## 과제 1. 객체 속성 개념 정리

| 개념 | 설명 | 예시 |
| --- | --- | --- |
| Object Property |  |  |

## 과제 2. 샘플 분석

...

## 과제 3. 핵심 객체 속성 정의

| Property | Domain | Range | 역관계 | 설명 |
| --- | --- | --- | --- | --- |
| placesOrder | CustomerAccount | Order | orderedBy |  |

## 과제 4. 중간 객체가 필요한 관계 설계

...

## 과제 5. 관계 네트워크 모델링

| Subject | Predicate | Object |
| --- | --- | --- |
| Person_002 | ownsAccount | Account_002 |

## 과제 6. Turtle 초안

```turtle
...
```

## 과제 7. 관계 설계 리뷰

...
```

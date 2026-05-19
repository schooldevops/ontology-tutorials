# 12강 과제: 통합 커머스 플랫폼 코어 클래스 설계하기

## 과제 목표

이번 과제는 통합 커머스 플랫폼의 핵심 클래스 계층을 설계하고, UML식 클래스 구조를 온톨로지 클래스와 관계로 매핑하는 것입니다.

## 제출물

`Chapter12_코어_클래스_설계_User_Product_Plan_Event/submission.md` 파일을 작성한다고 가정하고, 아래 항목을 모두 포함해 작성하세요.

## 과제 1. 코어 클래스 개념 정리

아래 개념을 본인의 말로 설명하세요.

| 개념 | 설명 | 예시 |
| --- | --- | --- |
| Core Class |  |  |
| Super-class |  |  |
| Sub-class |  |  |
| Role |  |  |
| Object Property |  |  |
| Data Property |  |  |

반드시 포함할 키워드:

- Person
- CustomerAccount
- Product
- SubscriptionPlan
- Event
- CustomerSegment

## 과제 2. 샘플 분석

다음 파일을 읽습니다.

- `samples/core_class_diagram.md`
- `samples/core_classes.ttl`

아래 질문에 답하세요.

1. `SubscriptionPlan`을 `Product`의 하위 클래스로 둔 이유는 무엇인가요?
2. `Person`과 `CustomerAccount`를 분리한 이유는 무엇인가요?
3. `SubscriberRole`을 `Person`의 하위 클래스가 아니라 `Role`의 하위 클래스로 둔 이유는 무엇인가요?
4. `Order`, `Payment`, `Subscription`을 분리해야 하는 이유는 무엇인가요?
5. `CampaignEvent targets CustomerSegment` 관계가 필요한 이유는 무엇인가요?

## 과제 3. 클래스 계층 설계

통합 커머스 플랫폼의 코어 클래스 계층을 직접 설계하세요.

반드시 포함할 클래스:

- Person
- User
- CustomerAccount
- Role
- BuyerRole
- SubscriberRole
- RequesterRole
- Product
- PhysicalProduct
- DigitalProduct
- SubscriptionPlan
- BasicPlan
- PremiumPlan
- Order
- Payment
- Subscription
- Event
- CampaignEvent
- PromotionEvent
- CustomerSegment
- CSTicket

형식 예:

```text
Product
├── PhysicalProduct
├── DigitalProduct
└── SubscriptionPlan
    ├── BasicPlan
    └── PremiumPlan
```

## 과제 4. 관계 모델 설계

과제 3의 클래스에 대해 관계 속성을 최소 12개 이상 정의하세요.

아래 형식으로 작성하세요.

| Property | Domain | Range | 설명 |
| --- | --- | --- | --- |
| ownsAccount | Person | CustomerAccount | 사람이 고객 계정을 소유 |

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

## 과제 5. UML에서 온톨로지로 매핑하기

아래 UML식 표현을 Turtle 또는 트리플 형식으로 변환하세요.

```text
PremiumPlan extends SubscriptionPlan
SubscriptionPlan extends Product
CustomerAccount places Order
Order contains Product
Subscription has SubscriptionPlan
CampaignEvent targets CustomerSegment
Person raises CSTicket
```

예:

```turtle
ex:PremiumPlan rdfs:subClassOf ex:SubscriptionPlan .
```

## 과제 6. 미니 시나리오 모델링

다음 문장을 클래스, 인스턴스, 관계로 모델링하세요.

> 이서연은 활성 고객 계정을 가지고 있으며, 베이직 구독 플랜을 주문하고 결제했다. 이후 베이직 플랜 구독이 활성화되었고, 신규 가입 쿠폰 이벤트에 참여했으며, 환불 문의 티켓을 생성했다.

반드시 포함할 내용:

- 클래스 후보
- 인스턴스 후보
- 데이터 속성
- 객체 속성
- 최소 15개의 트리플

## 과제 7. Turtle 초안 작성

과제 3~6을 바탕으로 Turtle 초안을 작성하세요.

필수 조건:

- `owl:Class` 또는 `rdfs:Class` 15개 이상
- `rdfs:subClassOf` 8개 이상
- Object Property 10개 이상
- Data Property 5개 이상
- 예시 인스턴스 1명의 연결 그래프

## 평가 기준

| 평가 항목 | 배점 | 설명 |
| --- | ---: | --- |
| 클래스 계층 설계 | 30 | Super-class와 Sub-class를 적절히 구성했는가 |
| 역할/실체 구분 | 20 | Person, Account, Role을 정확히 분리했는가 |
| 관계 모델링 | 25 | 코어 클래스 사이의 관계를 명확히 정의했는가 |
| 온톨로지 매핑 | 25 | UML식 구조를 RDF/RDFS/OWL 표현으로 변환했는가 |

## 제출 예시 템플릿

```markdown
# 12강 과제 제출

## 과제 1. 코어 클래스 개념 정리

| 개념 | 설명 | 예시 |
| --- | --- | --- |
| Core Class |  |  |

## 과제 2. 샘플 분석

...

## 과제 3. 클래스 계층 설계

```text
Thing
├── Person
└── Product
```

## 과제 4. 관계 모델 설계

| Property | Domain | Range | 설명 |
| --- | --- | --- | --- |
| ownsAccount | Person | CustomerAccount |  |

## 과제 5. UML에서 온톨로지로 매핑하기

```turtle
...
```

## 과제 6. 미니 시나리오 모델링

...

## 과제 7. Turtle 초안

```turtle
...
```
```

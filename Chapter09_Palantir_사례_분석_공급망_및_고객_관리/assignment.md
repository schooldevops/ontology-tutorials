# 9강 과제: 공급망 병목이 고객 구독 서비스에 미치는 영향 추론하기

## 과제 목표

이번 과제는 공급망 리스크가 부품, 상품, 번들, 구독, 고객, CS 티켓으로 전파되는 경로를 온톨로지로 모델링하고, 대응 Action을 설계하는 것입니다.

## 제출물

`Chapter09_Palantir_사례_분석_공급망_및_고객_관리/submission.md` 파일을 작성한다고 가정하고, 아래 항목을 모두 포함해 작성하세요.

## 과제 1. 공급망 온톨로지 개념 설명

아래 개념을 본인의 말로 설명하세요.

| 개념 | 설명 | 예시 |
| --- | --- | --- |
| Supplier |  |  |
| Part |  |  |
| Product |  |  |
| InventoryItem |  |  |
| SubscriptionBundle |  |  |
| RiskSignal |  |  |
| Risk Propagation |  |  |

반드시 포함할 키워드:

- 공급사
- 부품
- 상품
- 재고
- 구독 번들
- 고객 영향
- CS 티켓

## 과제 2. 샘플 분석

다음 파일을 읽습니다.

- `samples/supply_chain_risk_scenario.md`
- `samples/supply_chain_customer_ontology.ttl`

아래 질문에 답하세요.

1. `SupplierA`의 지연은 어떤 객체들을 거쳐 `Customer_001`에게 영향을 주나요?
2. `WirelessKeyboard`의 재고가 충분했다면 `PremiumWorkBundle`의 리스크는 어떻게 달라질 수 있나요?
3. `Customer_001`의 `tier = VIP`는 Action 우선순위에 어떤 영향을 주나요?
4. `Ticket_7001`이 `DELIVERY_DELAY` 카테고리라는 사실은 어떤 대응 Action과 연결되나요?
5. 공급망 데이터와 CS 데이터를 연결하지 않으면 어떤 리스크를 놓칠 수 있나요?

## 과제 3. 리스크 전파 경로 작성

다음 상황을 온톨로지 경로로 작성하세요.

> SupplierB가 BatteryCell 공급을 지연했고, BatteryCell은 SmartSensor에 사용된다. SmartSensor는 SmartHomeBundle에 포함되며, 이 번들은 활성 구독자 2명에게 다음 배송 주기에 제공될 예정이다. 그중 한 명은 VIP이고 이미 배송 지연 티켓을 생성했다.

아래 형식으로 최소 8개 이상의 관계를 작성하세요.

```text
Subject | Predicate | Object
```

예:

```text
SupplierB | supplies | BatteryCell
BatteryCell | usedIn | SmartSensor
```

## 과제 4. 리스크 평가 Rule 설계

과제 3의 시나리오에 대해 Rule을 5개 이상 작성하세요.

각 Rule은 아래 형식으로 작성하세요.

| Rule ID | 이름 | 조건 | 결과 |
| --- | --- | --- | --- |
| R001 | 공급사 지연 | Supplier.status = DELAYED | Part.riskLevel = HIGH |

반드시 포함할 Rule:

- 공급사 지연이 부품 리스크로 전파되는 Rule
- 부품 리스크가 상품 리스크로 전파되는 Rule
- 상품 리스크와 재고 부족이 번들 이행 리스크로 전파되는 Rule
- 번들 리스크가 구독 배송 리스크로 전파되는 Rule
- VIP 고객과 열린 배송 지연 티켓이 우선순위를 높이는 Rule

## 과제 5. 대응 Action 설계

리스크 상황에서 실행할 Action을 6개 이상 설계하세요.

각 Action마다 다음을 작성하세요.

| Action | 대상 객체 | 실행 조건 | 실행 효과 | 우선순위 | Write-back 시스템 |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |

반드시 포함할 Action:

- FindAlternativeSupplier
- ReallocateInventory
- OfferAlternativeBundle
- NotifyImpactedCustomer
- AssignRetentionManager
- EscalateDeliveryTicket

## 과제 6. 영향 고객 질의 설계

아래 질문에 답하기 위한 그래프 탐색 절차를 작성하세요.

> 특정 공급사의 지연으로 인해 다음 14일 이내 갱신 예정인 VIP 구독 고객 중 배송 지연 티켓이 열려 있는 고객은 누구인가?

아래 순서로 작성하세요.

1. 시작 객체
2. 따라갈 관계 경로
3. 필터 조건
4. 반환해야 할 객체와 속성
5. 추천 Action

선택 사항: SPARQL 또는 Cypher와 유사한 의사 쿼리로 작성해도 됩니다.

## 과제 7. 미니 Turtle 초안 작성

과제 3~5의 내용을 바탕으로 Turtle 초안을 작성하세요.

필수 조건:

- 공급망 클래스 8개 이상
- 고객 관리 클래스 3개 이상
- 관계 속성 8개 이상
- RiskSignal 인스턴스 4개 이상
- Action 인스턴스 6개 이상
- 공급사에서 고객 티켓까지 이어지는 예시 그래프

## 평가 기준

| 평가 항목 | 배점 | 설명 |
| --- | ---: | --- |
| 리스크 경로 모델링 | 30 | 공급사에서 고객까지 영향 경로를 정확히 연결했는가 |
| Rule 설계 | 25 | 리스크 전파 조건과 결과를 명확히 정의했는가 |
| Action 설계 | 25 | 공급망 및 고객 관리 대응 Action을 적절히 설계했는가 |
| 질의 관점 | 20 | 영향 고객을 찾는 탐색 경로와 필터를 설명했는가 |

## 제출 예시 템플릿

```markdown
# 9강 과제 제출

## 과제 1. 공급망 온톨로지 개념 설명

| 개념 | 설명 | 예시 |
| --- | --- | --- |
| Supplier |  |  |

## 과제 2. 샘플 분석

...

## 과제 3. 리스크 전파 경로

| Subject | Predicate | Object |
| --- | --- | --- |
| SupplierB | supplies | BatteryCell |

## 과제 4. 리스크 평가 Rule 설계

| Rule ID | 이름 | 조건 | 결과 |
| --- | --- | --- | --- |
| R001 | 공급사 지연 |  |  |

## 과제 5. 대응 Action 설계

| Action | 대상 객체 | 실행 조건 | 실행 효과 | 우선순위 | Write-back 시스템 |
| --- | --- | --- | --- | --- | --- |
| FindAlternativeSupplier | Part |  |  |  | ERP |

## 과제 6. 영향 고객 질의 설계

...

## 과제 7. 미니 Turtle 초안

```turtle
...
```
```

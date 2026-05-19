# 9강: Palantir 사례 분석: 공급망 및 고객 관리

## 강의 개요

7강과 8강에서는 Palantir식 온톨로지를 객체, 상태, Action, Workflow 관점에서 살펴봤습니다. 9강에서는 이 관점을 공급망과 고객 관리 시나리오에 적용합니다.

공급망 문제는 단순히 재고가 부족한 문제가 아닙니다. 특정 공급사의 지연이 부품, 상품, 구독 번들, 고객 약속, CS 티켓, 매출 리스크로 전파될 수 있습니다. 온톨로지는 이 전파 경로를 객체와 관계로 연결해 "어디서 문제가 시작되어 누구에게 영향을 주는가"를 분석하게 합니다.

```text
Supplier -> Part -> Product -> Bundle -> Subscription -> Customer -> CSTicket
```

## 학습 목표

- 공급망 온톨로지의 핵심 객체와 관계를 설명할 수 있다.
- 리스크 전파 모델이 왜 필요한지 설명할 수 있다.
- 공급망 병목이 고객 경험과 CS에 미치는 영향을 그래프로 추적할 수 있다.
- 리스크 상황에서 실행할 Action과 Workflow를 설계할 수 있다.

## 핵심 질문

1. 공급사 지연이 어떤 상품과 고객에게 영향을 주는지 어떻게 추적할 수 있는가?
2. 재고 부족과 고객 이탈 위험은 어떤 관계로 연결되는가?
3. 공급망 리스크를 단순 대시보드가 아니라 온톨로지로 모델링하면 무엇이 달라지는가?
4. 병목 발생 시 시스템은 어떤 Action을 추천해야 하는가?

## 1. 공급망 문제를 그래프로 보는 이유

공급망은 본질적으로 관계 네트워크입니다.

```text
Supplier supplies Part
Part usedIn Product
Product includedIn SubscriptionBundle
SubscriptionBundle usedBy Customer
Customer raises CSTicket
```

테이블 중심으로 보면 각 정보는 분리되어 있습니다.

| 시스템 | 데이터 |
| --- | --- |
| ERP | 공급사, 발주, 입고 예정일 |
| WMS | 재고, 창고, 출고 가능 수량 |
| Commerce | 상품, 주문, 배송 상태 |
| Subscription | 구독 번들, 갱신 예정 고객 |
| CS | 배송 지연 문의, 환불 요청 |
| CRM | 고객 등급, 담당자 |

온톨로지는 이 데이터를 업무 객체와 관계로 연결합니다. 그러면 특정 공급사 문제가 어떤 고객군까지 영향을 미치는지 경로로 추적할 수 있습니다.

## 2. 공급망 온톨로지 핵심 객체

| 객체 | 설명 |
| --- | --- |
| Supplier | 부품이나 상품을 공급하는 외부 업체 |
| Part | 상품 생산 또는 구성에 필요한 부품 |
| Product | 판매 가능한 상품 |
| InventoryItem | 특정 창고의 재고 단위 |
| Warehouse | 재고가 보관되는 위치 |
| PurchaseOrder | 공급사에 발주한 주문 |
| Shipment | 입고 또는 출고 운송 단위 |
| SubscriptionBundle | 구독 고객에게 제공되는 상품 묶음 |
| CustomerAccount | 고객 계정 |
| CSTicket | 고객 문의 또는 불만 |
| RiskSignal | 리스크를 나타내는 신호 |
| MitigationAction | 리스크 완화 Action |

## 3. 리스크 전파 모델

리스크 전파 모델은 한 객체의 문제가 연결된 객체로 어떤 영향을 주는지 정의합니다.

예:

```text
Supplier.status = DELAYED
Supplier supplies PartA
PartA usedIn ProductX
ProductX includedIn BundlePremium
BundlePremium assignedTo SubscriptionS1
SubscriptionS1 ownedBy CustomerC1
```

추론 가능한 영향:

```text
ProductX supplyRisk = HIGH
BundlePremium fulfillmentRisk = HIGH
CustomerC1 experienceRisk = HIGH
```

이 구조는 "문제 공급사 목록"이 아니라 "영향받는 고객과 대응 우선순위"를 제공합니다.

## 4. 고객 관리와의 연결

공급망 리스크는 고객 관리로 이어집니다.

예:

```text
무선 키보드 재고 부족
-> 프리미엄 업무 생산성 번들 구성 불가
-> 다음 갱신 주기 고객 배송 지연
-> CS 배송 지연 티켓 증가
-> 구독 해지 위험 증가
```

온톨로지에서는 이 흐름을 객체 관계로 표현합니다.

```text
InventoryItem stockLevel LOW
Product includedIn SubscriptionBundle
CustomerAccount owns Subscription
Subscription expects BundleDelivery
CSTicket raisedBy CustomerAccount
CSTicket category DELIVERY_DELAY
```

## 5. 우선순위 판단

리스크가 발생했을 때 모든 고객에게 같은 대응을 할 수는 없습니다. 온톨로지는 우선순위 판단에 필요한 맥락을 연결합니다.

우선순위 기준 예:

- 고객 등급이 VIP인가?
- 갱신 예정일이 가까운가?
- 대체 상품이 있는가?
- 이미 열린 CS 티켓이 있는가?
- SLA 위반 가능성이 있는가?
- 상품이 구독 번들의 핵심 구성품인가?

예:

```text
IF
  CustomerAccount.tier = VIP
  Subscription.renewalDate <= 14 days
  Bundle.fulfillmentRisk = HIGH
  CSTicket.category = DELIVERY_DELAY
THEN
  priority = CRITICAL
  recommendedAction = AssignSeniorRetentionManager
```

## 6. 공급망 리스크 대응 Action

| 상황 | 추천 Action | 설명 |
| --- | --- | --- |
| 공급사 지연 | FindAlternativeSupplier | 대체 공급사 탐색 |
| 특정 부품 부족 | SubstitutePart | 호환 가능한 대체 부품 사용 |
| 상품 재고 부족 | ReallocateInventory | 창고 간 재고 재배치 |
| 배송 지연 예상 | NotifyImpactedCustomers | 영향 고객 사전 안내 |
| VIP 고객 영향 | AssignRetentionManager | 담당자 배정 |
| 구독 번들 구성 불가 | OfferAlternativeBundle | 대체 번들 제안 |
| CS 티켓 증가 | EscalateDeliveryTickets | 배송 지연 티켓 에스컬레이션 |

## 7. 시나리오: 공급망 병목이 고객 구독에 미치는 영향

상황:

```text
SupplierA가 BluetoothModule 부품 입고를 10일 지연했다.
BluetoothModule은 WirelessKeyboard에 사용된다.
WirelessKeyboard는 PremiumWorkBundle에 포함된다.
PremiumWorkBundle은 프리미엄 구독 고객에게 다음 배송 주기에 제공된다.
일부 VIP 고객은 갱신일이 7일 이내이고 이미 배송 지연 문의를 남겼다.
```

온톨로지 분석:

1. 지연 공급사 식별
2. 영향 부품 식별
3. 영향 상품 식별
4. 영향 번들 식별
5. 영향 구독 식별
6. 영향 고객 식별
7. CS 티켓과 고객 등급 결합
8. 우선순위와 Action 추천

결과:

```text
Customer_001 priority = CRITICAL
recommendedAction = AssignSeniorRetentionManager
recommendedAction = OfferAlternativeBundle
recommendedAction = NotifyImpactedCustomer
```

## 8. Palantir식 사례 분석 관점

이 장에서 말하는 사례 분석의 핵심은 특정 화면이나 제품 기능을 외우는 것이 아닙니다. 중요한 것은 다음 패턴입니다.

```text
1. 여러 소스 시스템의 데이터를 객체로 투영한다.
2. 객체 사이의 업무 관계를 모델링한다.
3. 상태와 리스크 신호를 계산한다.
4. 리스크가 관계를 따라 어떻게 전파되는지 추적한다.
5. 영향받는 고객과 업무 우선순위를 도출한다.
6. Action과 Workflow로 실제 조치까지 연결한다.
```

이 패턴은 공급망뿐 아니라 고객 관리, 금융 리스크, 제조 품질, 공공 안전, 헬스케어 운영에도 적용할 수 있습니다.

## 9. 이번 강의의 핵심 정리

- 공급망은 공급사, 부품, 상품, 재고, 주문, 고객이 연결된 관계 네트워크다.
- 온톨로지는 공급망 리스크가 어떤 객체를 거쳐 고객 경험으로 전파되는지 추적한다.
- 리스크 전파 모델은 단순 지표보다 영향 범위와 대응 우선순위를 더 잘 보여준다.
- 고객 관리와 공급망을 연결하면 배송 지연, 환불, 해지 위험을 선제적으로 대응할 수 있다.
- Palantir식 온톨로지 패턴은 객체 투영, 관계 모델링, 리스크 계산, Action 실행을 하나의 운영 흐름으로 결합한다.

## 실습 파일

- [공급망 리스크 전파 시나리오](samples/supply_chain_risk_scenario.md)
- [공급망 및 고객 관리 온톨로지 예제](samples/supply_chain_customer_ontology.ttl)
- [상세 과제](assignment.md)

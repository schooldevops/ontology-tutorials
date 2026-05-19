# 샘플: 엔터프라이즈 온톨로지 전체 아키텍처 도해

## 1. 레이어드 아키텍처

```text
┌───────────────────────────────────────────────────────────────┐
│ Business Interfaces                                            │
│ - AI Agent                                                     │
│ - Operator Console                                             │
│ - Executive Dashboard                                          │
│ - Customer Support Workspace                                   │
├───────────────────────────────────────────────────────────────┤
│ Action and Workflow Layer                                      │
│ - OfferRetentionDiscount                                       │
│ - NotifyImpactedCustomer                                       │
│ - EscalateTicket                                               │
│ - ReallocateInventory                                          │
├───────────────────────────────────────────────────────────────┤
│ Rule and Reasoning Layer                                       │
│ - VIPCustomer Rule                                             │
│ - ChurnRisk Rule                                               │
│ - SupplyRisk Propagation                                       │
│ - Inverse / Transitive / Subclass Reasoning                    │
├───────────────────────────────────────────────────────────────┤
│ Ontology Layer                                                 │
│ - Person, CustomerAccount, Product, Order                      │
│ - Subscription, CSTicket, CampaignEvent                        │
│ - Supplier, Part, InventoryItem, SubscriptionBundle            │
│ - ownsSubscription, raisesTicket, supplies, usedIn             │
├───────────────────────────────────────────────────────────────┤
│ Data Integration Layer                                         │
│ - ETL / ELT                                                    │
│ - CDC                                                          │
│ - API ingestion                                                │
│ - ID resolution                                                │
│ - Source-to-ontology mapping                                   │
├───────────────────────────────────────────────────────────────┤
│ Source Systems                                                 │
│ - CRM                                                          │
│ - Commerce                                                     │
│ - Subscription                                                 │
│ - CS                                                           │
│ - ERP / WMS                                                    │
│ - Marketing                                                    │
└───────────────────────────────────────────────────────────────┘
```

## 2. 데이터 흐름

```text
1. Source Systems
   CRM, Commerce, Subscription, CS, ERP, WMS, Marketing에서 데이터 발생

2. Data Integration
   데이터 정제, 식별자 매칭, 이벤트 수집, source-to-core 매핑 수행

3. Ontology Layer
   테이블과 이벤트를 비즈니스 객체 및 관계로 투영

4. Rule and Reasoning
   클래스 상속, 역관계, 리스크 전파, VIP/이탈 위험 추론 수행

5. Action and Workflow
   실행 가능한 Action 추천, 승인, write-back, 감사 로그 기록

6. Business Interfaces
   AI 에이전트, 대시보드, 운영자 화면에서 질의와 Action 실행
```

## 3. 예시 업무 질문과 필요한 경로

### 질문 1

> 신규 가입 쿠폰 이벤트를 통해 유입되어 베이직 구독을 시작한 고객 중 환불 문의를 남긴 고객은 누구인가?

필요 경로:

```text
CampaignEvent <-participatesIn- Person
Person -ownsAccount-> CustomerAccount
CustomerAccount -ownsSubscription-> Subscription
Subscription -hasPlan-> BasicPlan
Person -raisesTicket-> CSTicket
CSTicket.category = REFUND
```

### 질문 2

> 특정 공급사 지연으로 영향을 받는 VIP 구독 고객은 누구인가?

필요 경로:

```text
Supplier -supplies-> Part
Part -usedIn-> Product
Product -includedIn-> SubscriptionBundle
SubscriptionBundle -assignedTo-> Subscription
Subscription -ownedBy-> CustomerAccount
CustomerAccount.tier = VIP
```

### 질문 3

> 이탈 위험 고객에게 어떤 Action을 실행할 수 있는가?

필요 경로:

```text
CustomerAccount.riskLevel = HIGH
CustomerAccount -availableAction-> Action
Action -writesBackTo-> ExternalSystem
Action.precondition is satisfied
```

## 4. 아키텍처 리뷰 체크리스트

| 항목 | 질문 |
| --- | --- |
| 업무 질문 | 해결하려는 질문이 명확한가? |
| 객체 모델 | 필요한 비즈니스 객체가 정의되어 있는가? |
| 관계 모델 | 객체 사이의 관계가 업무 의미를 가지는가? |
| 데이터 매핑 | 원천 시스템 필드가 온톨로지 속성으로 매핑되는가? |
| 식별자 통합 | 같은 사람, 계정, 상품을 안정적으로 연결할 수 있는가? |
| 추론 | 명시되지 않은 타입, 리스크, 우선순위를 도출할 수 있는가? |
| Action | 판단 결과가 실행 가능한 업무로 연결되는가? |
| Write-back | 실행 결과가 원천 또는 운영 시스템에 기록되는가? |
| 감사 | 누가, 언제, 왜 실행했는지 추적 가능한가? |
| AI 사용성 | 자연어 질문을 객체와 관계 경로로 분해할 수 있는가? |

## 5. Phase 2 준비 포인트

Phase 2에 들어가기 전에 다음 개념을 명확히 해야 합니다.

- User, Person, CustomerAccount의 차이
- Product, SubscriptionPlan, Bundle의 차이
- Order, Payment, Subscription의 관계
- Event, Campaign, CustomerSegment의 관계
- CSTicket과 고객 경험 리스크의 관계
- VIPCustomer, ChurnRiskCustomer 같은 추론 클래스
- Action과 Workflow의 최소 명세

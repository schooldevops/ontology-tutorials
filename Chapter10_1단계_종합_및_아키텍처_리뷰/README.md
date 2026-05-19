# 10강: 1단계 종합 및 아키텍처 리뷰

## 강의 개요

1강부터 9강까지는 온톨로지의 기초 개념, 표준 언어, 추론, 엔터프라이즈 도입 가치, Palantir식 운영형 온톨로지, 공급망과 고객 관리 사례를 순서대로 학습했습니다. 10강은 Phase 1의 종합 장입니다.

이번 장의 목표는 지금까지 배운 개념을 하나의 시스템 아키텍처로 연결하는 것입니다.

```text
Operational Systems
  -> Data Integration
  -> Ontology Layer
  -> Reasoning / Rules
  -> Actions / Workflows
  -> AI Agent / Business Apps
```

온톨로지는 데이터베이스를 대체하지 않습니다. 기존 시스템 위에서 의미 계층을 만들고, 여러 데이터 소스를 비즈니스 객체와 관계로 연결하며, 추론과 Action을 통해 운영 업무로 확장합니다.

## 학습 목표

- Phase 1에서 배운 핵심 개념을 하나의 아키텍처로 설명할 수 있다.
- 기존 데이터베이스 위에서 온톨로지 레이어가 작동하는 방식을 이해할 수 있다.
- 지식 그래프 아키텍처의 주요 구성 요소를 설명할 수 있다.
- MSA, 데이터 웨어하우스, API, AI 에이전트와 온톨로지의 관계를 설명할 수 있다.
- 향후 Phase 2 실습에서 구축할 통합 커머스 온톨로지의 청사진을 그릴 수 있다.

## 핵심 질문

1. 온톨로지 레이어는 기존 RDBMS와 어떤 관계를 가지는가?
2. 데이터 통합과 의미 통합은 시스템 아키텍처에서 어디에 위치하는가?
3. 추론, Rule, Action, Workflow는 지식 그래프 위에서 어떻게 동작하는가?
4. AI 에이전트는 온톨로지를 어떻게 사용해 업무를 수행하는가?

## 1. Phase 1 핵심 개념 복습

| 강의 | 핵심 내용 | 아키텍처 관점 |
| --- | --- | --- |
| 1강 | 데이터, 정보, 지식 | 데이터 저장과 의미 모델의 차이 |
| 2강 | 클래스, 속성, 인스턴스 | 온톨로지 스키마의 기본 단위 |
| 3강 | 택소노미와 온톨로지 | 계층 분류에서 관계 네트워크로 확장 |
| 4강 | RDF, RDFS, OWL | 지식 표현 표준과 교환 형식 |
| 5강 | 추론 | 명시되지 않은 지식 도출 |
| 6강 | 엔터프라이즈 도입 가치 | 데이터 사일로와 의미 통합 |
| 7강 | Palantir식 디지털 트윈 | 객체 중심 운영 모델 |
| 8강 | Rule, Action, Workflow | 데이터와 업무 실행의 결합 |
| 9강 | 공급망 및 고객 관리 | 리스크 전파와 고객 영향 분석 |

이 표의 핵심은 온톨로지가 단순 모델링 기법이 아니라, 데이터와 업무 실행을 연결하는 계층이라는 점입니다.

## 2. 전체 아키텍처 개요

엔터프라이즈 온톨로지 아키텍처는 다음 레이어로 볼 수 있습니다.

```text
┌─────────────────────────────────────────────┐
│ Business Apps / AI Agents / Dashboards       │
├─────────────────────────────────────────────┤
│ Actions / Workflows / Write-back             │
├─────────────────────────────────────────────┤
│ Rules / Reasoning / Risk Propagation         │
├─────────────────────────────────────────────┤
│ Ontology Layer: Objects, Relations, Semantics │
├─────────────────────────────────────────────┤
│ Data Integration: ETL, CDC, API, Mapping      │
├─────────────────────────────────────────────┤
│ Source Systems: CRM, ERP, Commerce, CS, WMS   │
└─────────────────────────────────────────────┘
```

각 레이어는 역할이 다릅니다.

| 레이어 | 역할 |
| --- | --- |
| Source Systems | 실제 업무 처리를 수행하는 원천 시스템 |
| Data Integration | 원천 데이터를 수집, 정제, 매핑 |
| Ontology Layer | 업무 객체와 의미 관계 정의 |
| Rules / Reasoning | 추론, 리스크 계산, 조건 판단 |
| Actions / Workflows | 업무 실행, 상태 전이, write-back |
| AI / Apps | 사용자 경험, 자연어 질의, 의사결정 지원 |

## 3. 기존 데이터베이스와 온톨로지의 관계

기존 데이터베이스는 사라지지 않습니다. 각 시스템은 여전히 자기 역할을 수행합니다.

예:

- CRM: 고객 프로필과 영업 활동 관리
- Commerce DB: 주문, 상품, 장바구니 관리
- Subscription DB: 구독 상태와 결제 주기 관리
- CS DB: 티켓과 상담 이력 관리
- WMS/ERP: 재고, 발주, 공급망 관리

온톨로지 레이어는 이 시스템들의 데이터를 비즈니스 객체로 투영합니다.

```text
crm_customers          -> Person, CustomerAccount
commerce_orders        -> Order
subscription_records   -> Subscription
cs_tickets             -> CSTicket
inventory_items        -> InventoryItem
```

중요한 점은 테이블을 그대로 복사하는 것이 아니라, 업무 의미를 가진 객체와 관계로 재구성한다는 것입니다.

## 4. MSA와 온톨로지의 관계

MSA는 서비스를 업무 기능별로 나누는 아키텍처입니다.

```text
Customer Service
Order Service
Subscription Service
CS Service
Inventory Service
Marketing Service
```

각 서비스는 독립적으로 발전할 수 있지만, 전사 질문은 여러 서비스를 가로지릅니다.

예:

> 이벤트 A로 유입되어 프리미엄 구독을 시작했고, 배송 지연 CS 티켓이 열린 VIP 고객은 누구인가?

이 질문은 Marketing, Subscription, Inventory, CS, Customer 데이터를 모두 필요로 합니다.

온톨로지는 MSA 위에서 횡단 의미 계층을 제공합니다.

```text
Service Boundary  -> 각 서비스의 소유권과 트랜잭션 경계
Ontology Boundary -> 전사 개념과 관계의 의미 경계
```

온톨로지는 MSA를 대체하지 않습니다. 대신 여러 서비스를 연결해 전사 업무 질문에 답할 수 있는 의미 네트워크를 제공합니다.

## 5. 지식 그래프 아키텍처 구성 요소

### 객체 모델

비즈니스 객체를 정의합니다.

```text
Person
CustomerAccount
Product
Order
Subscription
CSTicket
Supplier
Part
InventoryItem
CampaignEvent
```

### 관계 모델

객체 사이의 의미 관계를 정의합니다.

```text
Person ownsAccount CustomerAccount
CustomerAccount placesOrder Order
CustomerAccount ownsSubscription Subscription
Subscription hasPlan SubscriptionPlan
Supplier supplies Part
Part usedIn Product
Product includedIn SubscriptionBundle
```

### 규칙과 추론

명시되지 않은 상태나 리스크를 도출합니다.

```text
Subscription.status = ACTIVE
renewalDate <= 14 days
CSTicket.category = DELIVERY_DELAY
Customer.tier = VIP
=> Customer.priority = CRITICAL
```

### Action과 Workflow

도출된 판단을 실제 업무 실행으로 연결합니다.

```text
priority = CRITICAL
=> AssignRetentionManager
=> NotifyImpactedCustomer
=> EscalateDeliveryTicket
```

### AI 에이전트

자연어 요청을 온톨로지 객체, 관계, Rule, Action으로 변환합니다.

```text
"배송 지연 위험이 있는 VIP 구독 고객에게 사전 안내해줘"
  -> find CustomerAccount
  -> traverse Subscription / Bundle / Inventory / Ticket
  -> evaluate risk
  -> execute NotifyImpactedCustomer
```

## 6. 온톨로지 도입 로드맵

처음부터 전사 전체를 모델링하려고 하면 실패하기 쉽습니다. 작은 업무 질문에서 시작하는 것이 좋습니다.

### 1단계. 핵심 질문 정의

예:

```text
환불 위험이 높은 활성 구독 고객은 누구인가?
공급망 지연으로 영향을 받을 VIP 고객은 누구인가?
이벤트 유입 후 구독을 유지하는 고객군은 누구인가?
```

### 2단계. 필요한 객체 식별

질문에 답하기 위한 최소 객체를 정합니다.

```text
CustomerAccount, Subscription, SubscriptionPlan, CSTicket, CampaignEvent
```

### 3단계. 관계 정의

객체 사이의 관계를 명확히 합니다.

```text
ownsSubscription, hasPlan, raisesTicket, participatesIn, influencedBy
```

### 4단계. 데이터 매핑

원천 시스템의 테이블과 필드를 온톨로지 객체와 속성에 매핑합니다.

### 5단계. Rule과 Action 추가

추론 가능한 상태와 실행 가능한 Action을 정의합니다.

### 6단계. 검증과 확장

실제 업무 질문에 답할 수 있는지 검증한 뒤, 다른 도메인으로 확장합니다.

## 7. Phase 2로 이어지는 청사진

Phase 2에서는 커머스 통합 플랫폼을 직접 모델링합니다. 10강의 아키텍처를 바탕으로 다음 도메인을 연결합니다.

```text
User / Customer
Product / Plan
Order / Payment
Subscription
CS Ticket
Event / Campaign
```

Phase 2의 목표는 단순 문서 작성이 아니라, 통합 플랫폼 관점의 지식 그래프를 설계하는 것입니다.

핵심 질문:

```text
고객은 어떤 상품을 구매했는가?
고객은 어떤 구독 플랜을 유지 중인가?
고객은 어떤 이벤트를 통해 유입되었는가?
고객은 어떤 CS 티켓을 생성했는가?
어떤 조건에서 VIP 또는 이탈 위험 고객으로 추론되는가?
어떤 Action을 실행할 수 있는가?
```

## 8. 이번 강의의 핵심 정리

- 온톨로지는 기존 데이터베이스 위에 올라가는 의미 계층이다.
- Source System, Data Integration, Ontology, Reasoning, Action, AI/App 레이어를 구분해야 한다.
- MSA는 서비스 경계를 관리하고, 온톨로지는 전사 의미 경계를 연결한다.
- 지식 그래프 아키텍처는 객체, 관계, 규칙, Action, Workflow, AI 에이전트를 함께 고려해야 한다.
- 좋은 온톨로지 도입은 큰 모델에서 시작하지 않고, 구체적인 업무 질문에서 시작한다.
- Phase 2에서는 커머스 통합 플랫폼을 대상으로 이 아키텍처를 실제 모델로 확장한다.

## 실습 파일

- [전체 아키텍처 도해](samples/architecture_blueprint.md)
- [Phase 1 통합 온톨로지 예제](samples/phase1_integrated_ontology.ttl)
- [상세 과제](assignment.md)

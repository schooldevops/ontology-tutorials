# 7강: Palantir의 온톨로지 개념: 기업의 디지털 트윈

## 강의 개요

앞선 강의에서는 W3C 표준 관점의 온톨로지, 즉 클래스, 속성, 인스턴스, RDF/RDFS/OWL, 추론을 다뤘습니다. 7강에서는 Palantir Foundry에서 자주 언급되는 실무형 온톨로지 관점을 학습합니다.

Palantir식 온톨로지는 단순히 지식을 표현하는 모델에 머물지 않습니다. 기업의 실제 운영 데이터를 비즈니스 객체로 투영하고, 그 객체에 상태, 관계, 권한, Action을 연결해 운영 가능한 디지털 트윈을 만듭니다.

```text
Data Sources     ERP, CRM, CS, Subscription, Marketing
        |
        v
Ontology Objects Customer, Product, Order, Subscription, Ticket
        |
        v
Actions          환불 승인, 구독 일시정지, 고객 등급 변경, 재고 보충 요청
```

## 학습 목표

- Palantir식 온톨로지와 학술적 온톨로지의 차이를 설명할 수 있다.
- 객체 중심 모델(Object-Centric Model)을 이해할 수 있다.
- 데이터 소스가 비즈니스 객체로 투영되는 구조를 설명할 수 있다.
- Action과 동적 디지털 트윈의 의미를 설명할 수 있다.

## 핵심 질문

1. 온톨로지가 단순 지식 그래프가 아니라 운영체제처럼 작동한다는 말은 무엇인가?
2. ERP의 주문 테이블과 CRM의 고객 테이블은 어떻게 `Customer`, `Order` 객체로 투영되는가?
3. 비즈니스 객체에 Action을 붙이면 무엇이 달라지는가?
4. 기업의 디지털 트윈은 정적인 대시보드와 어떻게 다른가?

## 1. 학술적 온톨로지와 운영형 온톨로지

학술적 또는 표준 중심 온톨로지는 주로 개념과 관계의 정확한 표현에 초점을 둡니다.

```text
Customer subClassOf Person
Customer placesOrder Order
SubscriptionPlan subClassOf Product
```

운영형 온톨로지는 여기에 실제 업무 실행 관점을 추가합니다.

```text
Customer hasRiskScore 0.82
Customer canExecuteAction PauseSubscription
Order canExecuteAction ApproveRefund
CSTicket triggers ReviewCustomerRetention
```

핵심 차이는 "무엇을 알고 있는가"에서 "무엇을 할 수 있는가"로 확장된다는 점입니다.

## 2. 객체 중심 모델(Object-Centric Model)

Palantir식 온톨로지는 테이블 중심이 아니라 객체 중심으로 기업 데이터를 바라봅니다.

테이블 중심 사고:

```text
crm_customers
orders
subscriptions
cs_tickets
campaign_events
```

객체 중심 사고:

```text
Customer
Order
Subscription
CSTicket
CampaignEvent
```

비즈니스 사용자는 보통 테이블이 아니라 업무 객체를 기준으로 사고합니다.

- 이 고객의 현재 상태는 무엇인가?
- 이 고객의 구독은 언제 갱신되는가?
- 이 주문은 환불 가능한가?
- 이 CS 티켓은 어떤 이벤트와 연결되는가?
- 이 고객에게 어떤 Action을 실행할 수 있는가?

온톨로지는 이 질문에 답할 수 있도록 원천 데이터를 비즈니스 객체로 재구성합니다.

## 3. 데이터 소스에서 객체로 투영하기

기업 데이터는 여러 시스템에 흩어져 있습니다.

| 소스 시스템 | 원천 데이터 | 온톨로지 객체 |
| --- | --- | --- |
| CRM | `crm_customers` | Customer |
| Commerce | `users`, `orders`, `order_items` | CustomerAccount, Order, Product |
| Subscription | `subscriptions`, `plans` | Subscription, SubscriptionPlan |
| CS | `tickets`, `requesters` | CSTicket, RequesterRole |
| Marketing | `campaign_events`, `participants` | CampaignEvent |

투영은 단순 복사가 아닙니다. 여러 테이블과 이벤트를 조합해 업무 객체의 상태와 관계를 구성하는 과정입니다.

```text
crm_customers.name
commerce.users.email
subscription.subscriptions.status
cs.tickets.refund_count
marketing.participants.event_id
        |
        v
Customer 객체의 속성, 관계, 상태
```

## 4. 기업의 디지털 트윈

디지털 트윈은 현실 세계의 객체, 상태, 관계, 변화를 디지털 공간에 동적으로 반영한 모델입니다.

제조업에서는 공장, 설비, 부품의 상태를 디지털 트윈으로 표현합니다. 엔터프라이즈 온톨로지에서는 고객, 주문, 구독, 재고, 캠페인, CS 티켓 같은 업무 객체가 디지털 트윈의 구성 요소가 됩니다.

정적인 대시보드:

```text
지난달 환불 건수: 120건
활성 구독자 수: 45,000명
```

동적 디지털 트윈:

```text
고객 U001은 활성 구독 중이다.
최근 결제 실패가 1회 발생했다.
환불 문의가 2건 있다.
갱신 예정일이 5일 남았다.
따라서 RetentionAction을 실행할 수 있다.
```

디지털 트윈은 상태를 보여주는 것에서 끝나지 않고, 현재 상태에서 어떤 조치를 할 수 있는지까지 연결합니다.

## 5. Action: 온톨로지 위의 업무 실행

Action은 온톨로지 객체에 연결된 실행 가능한 업무 명령입니다.

예:

| 객체 | Action | 설명 |
| --- | --- | --- |
| Customer | AssignRetentionManager | 유지 관리 담당자 배정 |
| Subscription | PauseSubscription | 구독 일시정지 |
| Order | ApproveRefund | 환불 승인 |
| Product | RequestRestock | 재고 보충 요청 |
| CSTicket | EscalateTicket | 상위 담당자에게 에스컬레이션 |

Action은 보통 다음 정보를 포함합니다.

- 실행 대상 객체
- 실행 가능 조건
- 입력 파라미터
- 권한 정책
- 실행 후 변경되는 상태
- 연결되는 외부 시스템 API

예:

```text
Action: PauseSubscription
Target: Subscription
Precondition:
  Subscription.status = ACTIVE
  Customer.hasOpenRefundTicket = false
Input:
  reason
  pauseUntil
Effect:
  Subscription.status = PAUSED
Write-back:
  Subscription system API
```

## 6. 객체, 관계, Action의 결합

운영형 온톨로지는 세 요소가 결합될 때 강력해집니다.

```text
Object:
  Subscription_1001

State:
  status = ACTIVE
  renewalDate = 2026-06-01

Relations:
  ownedBy CustomerAccount_001
  hasPlan BasicPlan
  influencedBy Campaign_NewCoupon

Actions:
  PauseSubscription
  ChangePlan
  OfferRetentionDiscount
```

이 구조를 통해 사용자는 "데이터를 조회"하는 것을 넘어 "상태를 이해하고 조치를 실행"할 수 있습니다.

## 7. Palantir식 온톨로지의 실무 가치

### 1. 비즈니스 사용자와 데이터 시스템 사이의 공통 언어

비즈니스 사용자는 SQL 테이블보다 `Customer`, `Order`, `Subscription` 같은 객체를 이해하기 쉽습니다.

### 2. 분석과 운영의 연결

분석 결과가 대시보드에 머무르지 않고 Action으로 이어집니다.

```text
ChurnRiskCustomer 감지
=> OfferRetentionDiscount 실행
=> Subscription 상태 변화
=> 결과가 다시 온톨로지에 반영
```

### 3. AI 에이전트의 작업 공간

AI 에이전트는 온톨로지 객체를 기준으로 질문을 해석하고, 필요한 Action을 선택할 수 있습니다.

예:

> 환불 위험이 높은 활성 구독 고객에게 유지 쿠폰을 제안해줘.

AI 에이전트는 다음을 수행해야 합니다.

1. `Customer` 중 활성 `Subscription`을 가진 대상을 찾는다.
2. `CSTicket`, 결제 실패, 갱신 예정일로 이탈 위험을 계산한다.
3. 권한과 조건을 확인한다.
4. `OfferRetentionDiscount` Action을 실행한다.
5. 실행 결과를 다시 기록한다.

## 8. 이번 강의의 핵심 정리

- Palantir식 온톨로지는 개념 표현을 넘어 운영 가능한 객체 모델을 지향한다.
- 객체 중심 모델은 테이블이 아니라 `Customer`, `Order`, `Subscription` 같은 업무 객체를 중심으로 데이터를 구성한다.
- 데이터 소스는 온톨로지 객체의 속성, 관계, 상태로 투영된다.
- 기업의 디지털 트윈은 업무 객체의 현재 상태와 변화, 실행 가능한 조치를 함께 표현한다.
- Action은 온톨로지를 분석 모델에서 운영 시스템으로 확장하는 핵심 요소다.
- AI 에이전트는 온톨로지 객체와 Action을 기준으로 기업 업무를 수행할 수 있다.

## 실습 파일

- [데이터 소스에서 객체로 투영하기](samples/source_to_objects.md)
- [운영형 온톨로지와 Action 예제](samples/operational_ontology_actions.ttl)
- [상세 과제](assignment.md)

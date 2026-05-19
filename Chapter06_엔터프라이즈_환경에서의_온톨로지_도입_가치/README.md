# 6강: 엔터프라이즈 환경에서의 온톨로지 도입 가치

## 강의 개요

앞선 강의에서는 온톨로지의 기본 구성 요소, 표준 언어, 추론 원리를 학습했습니다. 6강에서는 이 지식이 기업 환경에서 왜 필요한지 살펴봅니다.

엔터프라이즈 시스템은 보통 CRM, ERP, CS, 마케팅, 구독, 물류처럼 목적별로 나뉘어 있습니다. 각 시스템은 자기 업무에 최적화된 데이터 모델과 용어를 사용합니다. 이 구조는 개별 시스템 운영에는 효율적이지만, 전사 관점의 분석과 AI 활용에서는 데이터 사일로를 만듭니다.

온톨로지는 여러 시스템의 데이터를 하나의 의미 체계로 연결해 의미론적 상호운용성을 제공합니다.

```text
CRM.Customer
Commerce.User
Subscription.Subscriber
CS.Requester
        |
        v
EnterpriseOntology.Person / CustomerAccount
```

## 학습 목표

- 데이터 사일로가 생기는 원인을 설명할 수 있다.
- 의미론적 상호운용성의 필요성을 설명할 수 있다.
- 부서별로 다른 용어를 공통 온톨로지 개념에 매핑할 수 있다.
- 온톨로지 도입이 분석, 자동화, AI 에이전트에 주는 가치를 설명할 수 있다.

## 핵심 질문

1. CRM의 `Customer`와 CS의 `Requester`는 항상 같은 개념인가?
2. 같은 고객을 여러 시스템에서 다르게 부를 때 전사 분석은 왜 어려워지는가?
3. 데이터 통합과 의미 통합은 어떻게 다른가?
4. AI 에이전트가 기업 업무를 수행하려면 왜 온톨로지 계층이 필요한가?

## 1. 데이터 사일로란 무엇인가?

데이터 사일로는 조직이나 시스템별로 데이터가 분리되어 있어 전사 관점에서 연결하기 어려운 상태를 말합니다.

예:

| 시스템 | 주요 데이터 | 사람을 부르는 용어 |
| --- | --- | --- |
| CRM | 영업 리드, 고객 프로필 | Customer |
| Commerce | 회원, 주문, 장바구니 | User |
| Subscription | 구독 상태, 결제 주기 | Subscriber |
| CS | 문의자, 티켓, 환불 요청 | Requester |
| Marketing | 캠페인 참여자, 세그먼트 | Audience |

각 시스템의 데이터베이스는 정상적으로 동작할 수 있습니다. 문제는 전사 질문을 던질 때 발생합니다.

> 최근 3개월간 이벤트로 유입되어 구독을 시작했고, CS 환불 문의가 증가한 고객군은 누구인가?

이 질문은 CRM, 마케팅, 구독, CS, 커머스 데이터를 동시에 연결해야 합니다.

## 2. 데이터 통합과 의미 통합의 차이

### 데이터 통합

데이터 통합은 여러 시스템의 데이터를 한곳에 모으는 작업입니다.

예:

- 데이터 웨어하우스에 테이블 적재
- ETL/ELT 파이프라인 구성
- 고객 ID 매칭
- 주문, 결제, CS 데이터를 분석 DB로 복제

하지만 데이터를 한곳에 모았다고 해서 의미가 자동으로 통합되지는 않습니다.

### 의미 통합

의미 통합은 서로 다른 용어와 구조가 실제 업무에서 어떤 개념을 가리키는지 정의하고 연결하는 작업입니다.

예:

```text
CRM.Customer      same business entity as Core.Customer
Commerce.User    mapped to Core.CustomerAccount
CS.Requester     role played by Core.Person
Subscription.Subscriber  Customer with active subscription
```

온톨로지는 이 의미 통합을 명시적으로 표현하는 계층입니다.

## 3. 의미론적 상호운용성

상호운용성은 시스템들이 서로 데이터를 주고받고 함께 동작할 수 있는 능력입니다. 의미론적 상호운용성은 단순히 데이터 포맷이 맞는 수준을 넘어, 데이터의 의미까지 일관되게 이해하는 상태를 말합니다.

예를 들어 두 시스템이 모두 `status`라는 필드를 가진다고 해도 의미가 다를 수 있습니다.

| 시스템 | 필드 | 값 | 의미 |
| --- | --- | --- | --- |
| Order | status | ACTIVE | 주문이 정상 처리 중 |
| Subscription | status | ACTIVE | 구독이 현재 유효함 |
| CS Ticket | status | ACTIVE | 문의가 아직 열려 있음 |

온톨로지는 이런 필드와 값의 의미를 업무 개념으로 분리해 혼동을 줄입니다.

## 4. 용어 통합 예시: 고객, 사용자, 회원, 구독자

기업에서 가장 흔한 충돌은 사람과 고객을 가리키는 용어입니다.

나쁜 통합 방식:

```text
Customer = User = Member = Subscriber = Requester
```

모든 용어를 무조건 하나로 합치면 역할 차이가 사라집니다. 예를 들어 가입만 한 사용자는 구독자가 아닐 수 있고, CS 문의자는 구매 고객이 아닐 수도 있습니다.

더 나은 방식:

```text
Person
├── CustomerAccount
│   ├── BuyerRole
│   ├── SubscriberRole
│   └── RequesterRole
```

또는 역할 관계로 표현할 수 있습니다.

```text
Person playsRole Buyer
Person playsRole Subscriber
Person playsRole Requester
CustomerAccount belongsTo Person
Subscription belongsTo CustomerAccount
CSTicket raisedBy Person
```

핵심은 "같은 사람인가?"와 "같은 역할인가?"를 분리하는 것입니다.

## 5. 온톨로지 도입 가치

### 1. 전사 용어 사전이 된다

온톨로지는 단순 문서가 아니라, 시스템이 읽을 수 있는 업무 용어 사전 역할을 합니다.

```text
Subscriber = CustomerAccount that has active Subscription
Requester = Person that raises CSTicket
VIPCustomer = CustomerAccount inferred by business rule
```

### 2. 데이터 연결의 의미를 명확히 한다

테이블 조인은 기술적 연결입니다. 온톨로지 관계는 업무 의미를 가진 연결입니다.

```text
customer_id join user_id
```

보다 다음 관계가 더 명확합니다.

```text
CustomerAccount placed Order
CustomerAccount owns Subscription
Person raised CSTicket
Campaign influenced Acquisition
```

### 3. AI 에이전트의 도구 사용 기준이 된다

AI 에이전트가 "환불 위험이 높은 구독 고객을 찾아줘"라는 요청을 받으면 다음을 알아야 합니다.

- 구독 고객은 어떤 시스템에서 찾는가?
- 환불 위험은 어떤 CS 티켓과 주문 상태를 봐야 하는가?
- 고객 ID와 사용자 ID는 어떻게 연결되는가?
- 활성 구독과 해지 구독은 어떻게 구분하는가?

온톨로지는 이런 판단 기준을 제공합니다.

### 4. 추론과 자동화를 가능하게 한다

규칙을 온톨로지에 연결하면 새로운 상태를 자동으로 도출할 수 있습니다.

```text
구독 6개월 이상
누적 구매액 500,000원 이상
최근 CS 만족도 높음
=> VIPCustomer
```

또는

```text
환불 티켓 2건 이상
최근 결제 실패
구독 갱신 예정일 7일 이내
=> ChurnRiskCustomer
```

## 6. 도입 시 흔한 오해

### 오해 1. 온톨로지는 데이터베이스를 대체한다

온톨로지는 RDBMS, 데이터 웨어하우스, 이벤트 스트림을 대체하는 것이 아닙니다. 그 위에서 의미 계층을 제공합니다.

```text
Operational DB  -> 업무 처리
Data Warehouse  -> 분석 저장소
Ontology Layer  -> 의미 통합과 관계 모델
AI Agent        -> 자연어 질의와 업무 자동화
```

### 오해 2. 모든 개념을 처음부터 완벽히 정의해야 한다

실무에서는 핵심 도메인부터 작게 시작하는 것이 좋습니다.

추천 시작점:

- Customer / Person / Account
- Product / Plan
- Order / Payment
- Subscription
- CSTicket
- Campaign / Event

### 오해 3. 용어 사전만 만들면 충분하다

용어 정의는 시작점입니다. 온톨로지의 가치는 용어 사이의 관계, 제약, 추론 규칙까지 표현할 때 커집니다.

## 7. 이번 강의의 핵심 정리

- 엔터프라이즈 데이터는 시스템별로 분리되어 데이터 사일로를 만든다.
- 데이터 통합은 값을 모으는 것이고, 의미 통합은 개념과 관계를 정렬하는 것이다.
- 의미론적 상호운용성은 시스템들이 같은 데이터를 같은 의미로 이해하게 만든다.
- 온톨로지는 전사 용어 사전, 관계 모델, 추론 규칙, AI 도구 사용 기준으로 작동한다.
- 사람, 계정, 고객, 구독자, 문의자처럼 비슷하지만 다른 개념은 역할과 관계로 분리해야 한다.

## 실습 파일

- [AS-IS 데이터 사일로 예제](samples/data_silos.md)
- [엔터프라이즈 통합 온톨로지 예제](samples/enterprise_integration_ontology.ttl)
- [상세 과제](assignment.md)

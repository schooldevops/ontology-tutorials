# 16강: CS 및 이벤트 도메인의 유기적 통합

## 강의 개요

15강에서는 정기 구독 시스템의 상태 전이와 라이프사이클을 모델링했습니다. 16강에서는 고립되기 쉬운 고객 지원(CS) 데이터와 마케팅 이벤트 데이터를 고객의 핵심 여정(구매, 구독)과 의미론적으로 통합하는 방법을 배웁니다.

기업에서 CS 티켓이나 마케팅 이벤트 참여 이력은 별도의 시스템(예: Zendesk, 마케팅 자동화 툴)에 파편화되어 관리되는 경우가 많습니다. 온톨로지를 활용하면 "특정 이벤트로 유입된 고객이 어떤 상품을 구매하고, 이후 어떤 문제로 환불을 요청했는지"의 인과 관계(Traceability)를 하나로 연결할 수 있습니다.

## 학습 목표

- 고립된 CS/이벤트 데이터를 고객 구매 이력과 의미론적으로 연결할 수 있다.
- 원인-결과 관계성 및 이력 추적(Traceability)을 온톨로지로 모델링할 수 있다.
- "특정 이벤트로 가입한 고객이 환불 CS 티켓을 생성함"과 같은 복합 경로를 정의할 수 있다.
- 이벤트, 고객, 주문(구독), CS 티켓 간의 관계(Object Property)를 설정할 수 있다.

## 핵심 질문

1. CS 티켓은 단순히 고객(User)과만 연결되어야 하는가, 아니면 특정 주문(Order)이나 구독(Subscription)과도 연결되어야 하는가?
2. 고객이 이벤트에 참여한 사실을 기록할 때, 그 이벤트가 실질적인 '구매'로 이어졌음을 어떻게 증명할 것인가?
3. CS 발생 원인이 특정 프로모션이나 상품 결함임을 추론하려면 데이터 모델을 어떻게 구성해야 하는가?

## 1. 사일로화된 데이터의 문제점

일반적으로 기업 데이터는 목적에 따라 분리되어 있습니다.
- **CRM/마케팅 DB:** 어떤 고객이 어떤 프로모션 이메일을 열어보고 쿠폰을 받았는지 기록
- **커머스 DB:** 어떤 고객이 언제 어떤 상품을 결제했는지 기록
- **CS DB:** 어떤 고객이 언제 전화를 걸어 어떤 불만을 접수했는지 기록

이 경우, "블랙프라이데이 이벤트로 유입된 고객들의 3개월 내 환불 요청 비율" 같은 질문에 답하려면 복잡한 JOIN과 데이터 엔지니어링이 필요합니다.

## 2. 핵심 클래스

| 클래스 | 설명 |
| --- | --- |
| User | 플랫폼을 이용하는 고객 |
| Event (Promotion) | 마케팅 캠페인, 할인 행사 등 |
| Order / Subscription | 상품 구매 또는 구독 내역 |
| Ticket (CS Ticket) | 고객이 접수한 문의/불만/환불 요청 |
| Interaction | 고객과 시스템 간의 모든 접점 이력 |

## 3. 유기적 연결을 위한 객체 속성 (Object Property)

| 속성 (Property) | Domain | Range | 설명 |
| --- | --- | --- | --- |
| participatedIn | User | Event | 고객이 특정 이벤트에 참여함 |
| attributedTo | Order/Subscription | Event | 특정 결제가 특정 이벤트의 기여로 발생함 |
| relatesTo | Ticket | Order/Subscription | CS 티켓이 특정 주문이나 구독 건과 연관됨 |
| causedBy | Ticket | Event (or Product) | CS 티켓의 근본 원인이 특정 이벤트나 상품에 있음 |
| raisedBy | Ticket | User | 티켓을 생성한 주체 |

## 4. 경로 모델링: 이벤트 -> 구매 -> CS

"특정 이벤트로 가입한 고객이 환불 CS 티켓을 생성함"의 시나리오를 트리플 구조로 연결해 봅시다.

1. **이벤트 참여:**
   `User_001 participatedIn BlackFriday_Event`
2. **구독 발생 (이벤트 기여):**
   `Subscription_101 belongsTo User_001`
   `Subscription_101 attributedTo BlackFriday_Event`
3. **CS 티켓 접수 (환불 요청):**
   `Ticket_999 raisedBy User_001`
   `Ticket_999 relatesTo Subscription_101`
   `Ticket_999 hasType RefundRequest`

이렇게 모델링하면 지식 그래프 상에서 `BlackFriday_Event` 노드로부터 `Subscription_101`을 거쳐 `Ticket_999`까지 경로가 이어집니다.

## 5. 원인-결과 분석 (이력 추적)

온톨로지 상에서 경로가 연결되면 단순 검색을 넘어 패턴을 발견할 수 있습니다.

**추론 규칙 예시 (가설):**
만약 다수의 `RefundRequest` 티켓이 공통적으로 특정 `Event`에 `attributedTo`된 `Subscription`들과 연결되어 있다면, 해당 `Event`의 마케팅 메시지(예: 과대광고)가 환불의 원인일 수 있습니다.

```text
IF
  Ticket hasType RefundRequest
  Ticket relatesTo Subscription
  Subscription attributedTo Event
THEN
  Ticket mightBeCausedBy Event (추론된 관계)
```

## 6. 이번 강의의 핵심 정리

- 마케팅, 결제, CS 데이터는 별도의 사일로에 존재하지만, 온톨로지를 통해 단일 고객 여정으로 통합될 수 있다.
- `attributedTo`, `relatesTo` 같은 관계 속성을 이용해 이벤트, 주문, 티켓을 의미론적으로 엮을 수 있다.
- 연결된 그래프 데이터를 바탕으로 CS 원인 분석, 마케팅 ROI 측정 등 복잡한 비즈니스 질문에 쉽게 답할 수 있다.

## 실습 파일

- [CS-이벤트 통합 모델링 예제](samples/cs_event_integration.md)
- [CS-이벤트 통합 온톨로지 예제](samples/cs_event_integration.ttl)
- [상세 과제](assignment.md)

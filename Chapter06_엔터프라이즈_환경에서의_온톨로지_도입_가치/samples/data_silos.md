# 샘플: 엔터프라이즈 데이터 사일로 분석

## 1. 상황

커머스 기업 A사는 다음 시스템을 운영하고 있습니다.

| 시스템 | 목적 | 주요 테이블 | 사람 식별자 | 사람을 부르는 용어 |
| --- | --- | --- | --- | --- |
| CRM | 영업 및 고객 프로필 관리 | `crm_customers` | `customer_id` | Customer |
| Commerce | 회원, 주문, 상품 관리 | `users`, `orders` | `user_id` | User |
| Subscription | 구독 플랜과 결제 주기 관리 | `subscribers`, `subscriptions` | `subscriber_id` | Subscriber |
| CS | 문의, 환불, 불만 처리 | `requesters`, `tickets` | `requester_id` | Requester |
| Marketing | 캠페인과 이벤트 관리 | `audiences`, `campaign_events` | `audience_id` | Audience |

각 시스템은 자체 업무에는 문제가 없습니다. 하지만 전사 분석에서는 용어와 식별자가 충돌합니다.

## 2. 전사 질문 예시

> 최근 3개월간 신규 가입 쿠폰 이벤트에 참여했고, 베이직 구독 플랜을 시작했으며, 환불 문의를 1회 이상 남긴 고객은 누구인가?

이 질문에 답하려면 다음을 연결해야 합니다.

| 필요한 정보 | 소스 시스템 |
| --- | --- |
| 이벤트 참여 여부 | Marketing |
| 가입 고객 정보 | Commerce 또는 CRM |
| 구독 시작 여부 | Subscription |
| 구독 플랜 종류 | Subscription |
| 환불 문의 | CS |
| 동일 인물 매칭 | CRM, Commerce, Subscription, CS, Marketing |

## 3. 단순 데이터 통합의 한계

데이터 웨어하우스에 모든 테이블을 모아도 다음 문제가 남습니다.

- `customer_id`, `user_id`, `subscriber_id`, `requester_id`가 같은 사람인지 알기 어렵다.
- `status` 필드가 시스템마다 다른 의미를 가진다.
- `Customer`와 `Subscriber`의 관계가 명시되어 있지 않다.
- 이벤트가 주문이나 구독 전환에 어떤 영향을 주었는지 업무 관계가 없다.
- AI 에이전트가 어떤 테이블을 어떤 순서로 조회해야 하는지 알기 어렵다.

## 4. 공통 온톨로지 매핑 초안

| 소스 용어 | 공통 개념 | 매핑 방식 | 주의점 |
| --- | --- | --- | --- |
| CRM.Customer | Person 또는 CustomerAccount | 고객 프로필의 소유자 | B2B 계정이면 Person이 아닐 수 있음 |
| Commerce.User | CustomerAccount | 서비스 로그인 계정 | 가입만 하고 구매하지 않았을 수 있음 |
| Subscription.Subscriber | SubscriberRole | 활성 또는 과거 구독 역할 | 해지 고객도 과거 Subscriber일 수 있음 |
| CS.Requester | RequesterRole | 문의를 생성한 사람 | 비회원 문의 가능성 있음 |
| Marketing.Audience | CustomerSegmentMember | 캠페인 대상 또는 참여자 | 실제 고객이 아닐 수 있음 |

## 5. TO-BE 관계 모델 예시

```text
Person owns CustomerAccount
CustomerAccount places Order
CustomerAccount owns Subscription
Subscription hasPlan SubscriptionPlan
Person raises CSTicket
Person participatesIn CampaignEvent
CampaignEvent influences Subscription
```

## 6. 검토 질문

1. `Customer`, `User`, `Subscriber`, `Requester`를 모두 같은 클래스로 합치면 어떤 문제가 생기나요?
2. `Person`과 `CustomerAccount`를 분리하면 어떤 장점이 있나요?
3. `Subscriber`를 클래스가 아니라 역할로 모델링하는 방식의 장단점은 무엇인가요?
4. AI 에이전트가 전사 질문에 답하려면 어떤 매핑 정보가 필요할까요?

# 7강 과제: 데이터 소스를 비즈니스 객체와 Action으로 투영하기

## 과제 목표

이번 과제는 여러 시스템의 원천 데이터를 객체 중심 온톨로지로 재구성하고, 각 객체에서 실행 가능한 Action을 설계하는 것입니다.

## 제출물

`Chapter07_Palantir의_온톨로지_개념_기업의_디지털_트윈/submission.md` 파일을 작성한다고 가정하고, 아래 항목을 모두 포함해 작성하세요.

## 과제 1. Palantir식 온톨로지 개념 설명

아래 개념을 본인의 말로 설명하세요.

| 개념 | 설명 | 예시 |
| --- | --- | --- |
| 객체 중심 모델 |  |  |
| 디지털 트윈 |  |  |
| Action |  |  |
| Write-back |  |  |
| 운영형 온톨로지 |  |  |

반드시 포함할 키워드:

- Customer
- Order
- Subscription
- CSTicket
- 상태
- 관계
- 실행 가능 조건

## 과제 2. 샘플 분석

다음 파일을 읽습니다.

- `samples/source_to_objects.md`
- `samples/operational_ontology_actions.ttl`

아래 질문에 답하세요.

1. `Person_001`과 `CustomerAccount_001`을 분리한 이유는 무엇인가요?
2. `Subscription_1001` 객체는 어떤 소스 데이터에서 투영되었나요?
3. `riskLevel = HIGH`는 원천 데이터인가요, 계산된 상태인가요? 이유를 설명하세요.
4. `OfferRetentionDiscount` Action은 어떤 객체에 연결되어 있고, 어떤 조건에서 실행되나요?
5. Action에 `writesBackTo` 관계가 필요한 이유는 무엇인가요?

## 과제 3. 데이터 소스에서 객체로 투영하기

다음 AS-IS 데이터를 온톨로지 객체로 투영하세요.

### CRM

| customer_id | name | segment |
| --- | --- | --- |
| C010 | 김서연 | Retention |

### Commerce

| user_id | email | account_status |
| --- | --- | --- |
| U010 | seoyeon@example.com | ACTIVE |

| order_id | user_id | status |
| --- | --- | --- |
| O5010 | U010 | PAID |

### Subscription

| subscription_id | user_id | plan_id | status | renewal_date |
| --- | --- | --- | --- | --- |
| S5010 | U010 | PLAN_PREMIUM | ACTIVE | 2026-06-15 |

### CS

| ticket_id | requester_email | type | status |
| --- | --- | --- | --- |
| T5010 | seoyeon@example.com | PAYMENT_FAILURE | OPEN |

아래 항목을 작성하세요.

1. 생성할 온톨로지 객체 목록
2. 각 객체의 주요 속성
3. 객체 사이의 관계
4. 계산 가능한 상태 3개 이상

## 과제 4. Action 설계

과제 3의 객체 모델에 대해 실행 가능한 Action을 4개 이상 설계하세요.

각 Action마다 다음을 작성하세요.

| Action | 대상 객체 | 실행 조건 | 입력값 | 실행 효과 | Write-back 시스템 |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |

반드시 하나 이상 포함할 Action:

- 결제 실패 티켓 에스컬레이션
- 구독 플랜 변경
- 유지 쿠폰 제안
- 담당자 배정

## 과제 5. AI 에이전트 시나리오 작성

아래 자연어 요청을 AI 에이전트가 처리한다고 가정하세요.

> 갱신일이 30일 이내이고 결제 실패 문의가 열려 있는 활성 구독 고객에게 유지 쿠폰을 제안해줘.

아래 순서로 처리 절차를 작성하세요.

1. 자연어에서 찾아야 할 객체
2. 확인해야 할 상태와 관계
3. 실행 가능 조건
4. 선택할 Action
5. Write-back 대상 시스템
6. 실행 후 온톨로지에 반영할 결과

## 과제 6. 미니 운영형 온톨로지 초안

과제 3~4의 내용을 바탕으로 간단한 Turtle 초안을 작성하세요.

필수 조건:

- 객체 클래스 6개 이상
- Action 클래스 또는 인스턴스 4개 이상
- `availableAction` 관계 사용
- `precondition`, `effect`, `writesBackTo` 표현
- 예시 고객 1명의 연결 그래프

## 평가 기준

| 평가 항목 | 배점 | 설명 |
| --- | ---: | --- |
| 객체 중심 이해 | 25 | 테이블 데이터를 비즈니스 객체로 적절히 투영했는가 |
| 디지털 트윈 모델링 | 25 | 상태, 관계, 계산 상태를 함께 표현했는가 |
| Action 설계 | 30 | 실행 조건, 효과, write-back을 구체적으로 정의했는가 |
| AI 시나리오 | 20 | 자연어 요청을 객체 탐색과 Action 실행 절차로 분해했는가 |

## 제출 예시 템플릿

```markdown
# 7강 과제 제출

## 과제 1. Palantir식 온톨로지 개념 설명

| 개념 | 설명 | 예시 |
| --- | --- | --- |
| 객체 중심 모델 |  |  |

## 과제 2. 샘플 분석

...

## 과제 3. 데이터 소스에서 객체로 투영하기

### 객체 목록

- Person_010:
- CustomerAccount_010:

### 관계

| Subject | Predicate | Object |
| --- | --- | --- |
| Person_010 | ownsAccount | CustomerAccount_010 |

### 계산 상태

- ...

## 과제 4. Action 설계

| Action | 대상 객체 | 실행 조건 | 입력값 | 실행 효과 | Write-back 시스템 |
| --- | --- | --- | --- | --- | --- |
| OfferRetentionDiscount | CustomerAccount | riskLevel = HIGH | couponCode | offer created | CRM |

## 과제 5. AI 에이전트 시나리오

...

## 과제 6. 미니 운영형 온톨로지 초안

```turtle
...
```
```

# 10강 과제: 엔터프라이즈 온톨로지 아키텍처 리뷰 작성하기

## 과제 목표

이번 과제는 Phase 1에서 배운 내용을 종합해, 기존 데이터베이스 위에서 온톨로지 레이어가 작동하는 전체 아키텍처를 설계하고 리뷰하는 것입니다.

## 제출물

`Chapter10_1단계_종합_및_아키텍처_리뷰/submission.md` 파일을 작성한다고 가정하고, 아래 항목을 모두 포함해 작성하세요.

## 과제 1. Phase 1 핵심 개념 요약

1강부터 9강까지의 핵심 개념을 아래 표로 정리하세요.

| 강의 | 핵심 개념 | 본인이 이해한 의미 | 아키텍처에서의 역할 |
| --- | --- | --- | --- |
| 1강 | Data, Information, Knowledge |  |  |
| 2강 | Class, Property, Instance |  |  |
| 3강 | Taxonomy vs Ontology |  |  |
| 4강 | RDF, RDFS, OWL |  |  |
| 5강 | Reasoning |  |  |
| 6강 | Semantic Interoperability |  |  |
| 7강 | Digital Twin / Object-Centric Model |  |  |
| 8강 | Rule / Action / Workflow |  |  |
| 9강 | Risk Propagation |  |  |

## 과제 2. 샘플 아키텍처 분석

다음 파일을 읽습니다.

- `samples/architecture_blueprint.md`
- `samples/phase1_integrated_ontology.ttl`

아래 질문에 답하세요.

1. Source Systems와 Ontology Layer는 어떤 역할 차이가 있나요?
2. Data Integration Layer에서 ID resolution이 필요한 이유는 무엇인가요?
3. Rule and Reasoning Layer는 어떤 종류의 지식을 도출하나요?
4. Action and Workflow Layer가 없으면 온톨로지는 어떤 한계를 가지나요?
5. AI Agent가 자연어 질문을 처리할 때 온톨로지에서 어떤 정보를 사용하나요?

## 과제 3. 전체 아키텍처 도해 작성

아래 레이어를 모두 포함하는 아키텍처 도해를 작성하세요.

- Source Systems
- Data Integration
- Ontology Layer
- Rule and Reasoning
- Action and Workflow
- Business Apps / AI Agents

각 레이어마다 최소 3개 이상의 구성 요소를 작성하세요.

형식 예:

```text
Business Apps / AI Agents
  - AI Agent
  - Operator Console
  - Dashboard

Action and Workflow
  - ...
```

## 과제 4. 업무 질문 기반 설계

다음 업무 질문 중 하나를 선택해 온톨로지 아키텍처 관점으로 설계하세요.

1. 신규 가입 쿠폰 이벤트를 통해 유입되어 베이직 구독을 시작했고, 환불 문의를 남긴 고객은 누구인가?
2. 특정 공급사 지연으로 인해 다음 14일 이내 갱신 예정인 VIP 구독 고객 중 배송 지연 티켓이 열려 있는 고객은 누구인가?
3. 최근 6개월 이상 구독을 유지했고 누적 구매액이 500,000원 이상인 VIP 후보 고객은 누구인가?

반드시 포함할 내용:

- 필요한 Source Systems
- 필요한 비즈니스 객체
- 필요한 관계
- 필요한 데이터 속성
- 필요한 Rule 또는 추론
- 추천 Action
- Write-back 대상 시스템

## 과제 5. MSA와 온톨로지 관계 설명

아래 질문에 답하세요.

1. MSA의 서비스 경계와 온톨로지의 의미 경계는 어떻게 다른가요?
2. 각 서비스가 독립 DB를 가진 상황에서 전사 질문을 해결하기 어려운 이유는 무엇인가요?
3. 온톨로지 레이어가 API Gateway나 데이터 웨어하우스와 다른 점은 무엇인가요?
4. 온톨로지 도입 시 각 서비스 팀과 중앙 데이터/AI 팀은 어떤 책임을 나눠야 하나요?

## 과제 6. 아키텍처 리뷰 체크리스트 작성

본인이 설계한 온톨로지 아키텍처를 리뷰하기 위한 체크리스트를 작성하세요.

최소 10개 이상 작성하고, 아래 항목을 반드시 포함하세요.

- 업무 질문 명확성
- 객체 모델 적절성
- 관계 모델 적절성
- 원천 데이터 매핑
- 식별자 통합
- 추론 가능성
- Action 실행 가능성
- 권한과 승인
- Write-back
- 감사 로그
- AI 에이전트 사용성

## 과제 7. Phase 2 준비 설계

Phase 2에서 구축할 통합 커머스 플랫폼 온톨로지의 초안을 작성하세요.

반드시 포함할 클래스:

- User 또는 Person
- CustomerAccount
- Product
- SubscriptionPlan
- Order
- Payment
- Subscription
- CSTicket
- CampaignEvent
- CustomerSegment

반드시 포함할 관계:

- ownsAccount
- placesOrder
- containsProduct
- ownsSubscription
- hasPlan
- raisesTicket
- participatesIn
- targets
- belongsToSegment
- availableAction

선택 사항: Turtle 초안 또는 표 형식으로 작성해도 됩니다.

## 평가 기준

| 평가 항목 | 배점 | 설명 |
| --- | ---: | --- |
| Phase 1 종합 이해 | 25 | 1~9강 개념을 아키텍처 관점으로 연결했는가 |
| 아키텍처 설계 | 30 | 레이어, 구성 요소, 데이터 흐름을 명확히 표현했는가 |
| 업무 질문 적용 | 25 | 실제 질문을 객체, 관계, Rule, Action으로 분해했는가 |
| 리뷰 품질 | 20 | 운영, 권한, write-back, 감사, AI 사용성을 고려했는가 |

## 제출 예시 템플릿

```markdown
# 10강 과제 제출

## 과제 1. Phase 1 핵심 개념 요약

| 강의 | 핵심 개념 | 본인이 이해한 의미 | 아키텍처에서의 역할 |
| --- | --- | --- | --- |
| 1강 | Data, Information, Knowledge |  |  |

## 과제 2. 샘플 아키텍처 분석

...

## 과제 3. 전체 아키텍처 도해

```text
Business Apps / AI Agents
  - ...
```

## 과제 4. 업무 질문 기반 설계

...

## 과제 5. MSA와 온톨로지 관계 설명

...

## 과제 6. 아키텍처 리뷰 체크리스트

| 항목 | 리뷰 질문 | 통과 기준 |
| --- | --- | --- |
| 업무 질문 |  |  |

## 과제 7. Phase 2 준비 설계

...
```

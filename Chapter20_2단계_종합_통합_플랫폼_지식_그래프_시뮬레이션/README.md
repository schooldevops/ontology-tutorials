# 20강: 2단계 종합 - 통합 플랫폼 지식 그래프 시뮬레이션

## 강의 개요

Phase 2(11강 ~ 20강)에 걸쳐 우리는 커머스 통합 플랫폼을 위한 온톨로지 모델을 구축해왔습니다. 코어 클래스(User, Product, Plan, Event)를 설계하고, 객체 및 데이터 속성을 정의했으며, 구독 라이프사이클과 CS 데이터를 유기적으로 연결했습니다. 또한 SWRL을 통한 비즈니스 룰 적용, SPARQL을 이용한 질의, 그리고 논리적 정합성 검증 방법까지 다루었습니다.

이번 20강은 Phase 2의 총정리로, 그동안 개별적으로 다뤘던 모든 도메인(마케팅, 커머스, 구독, CS)이 하나의 **통합 지식 그래프(Knowledge Graph)** 안에서 어떻게 상호작용하는지 시뮬레이션하고 검증하는 시간을 갖습니다.

## 학습 목표

- 4개 주요 서비스(Event, Commerce, Subscription, CS)가 융합된 단일 개념 모델을 리뷰한다.
- 시뮬레이션 시나리오를 통해, 특정 이벤트 발생 시 그래프 전체에 미치는 파급 효과를 분석한다.
- 데이터 모델의 확장성(Scalability) 및 유지보수성을 평가하는 방법을 학습한다.
- 최종 통합 모델을 기반으로 Phase 3(실제 구축 및 AI 에이전트 연동)로 넘어가기 위한 준비를 마친다.

## 핵심 질문

1. 현재 설계된 온톨로지 모델에 새로운 도메인(예: 물류/배송)을 추가할 때 기존 스키마를 훼손하지 않고 확장할 수 있는가?
2. 마케팅팀, CS팀, 세일즈팀이 동일한 지식 그래프를 바라보며 각자의 KPI를 도출해낼 수 있는가?
3. 비즈니스 환경이 변할 때(예: 새로운 구독 플랜 출시), 온톨로지 구조의 수정은 얼마나 최소화될 수 있는가?

## 1. 통합 개념 모델 리뷰

우리가 완성한 온톨로지의 뼈대는 다음과 같이 연결되어 있습니다.

- **Event (마케팅):** 고객 유입의 시발점입니다. `User`와 `participatedIn`으로 연결되고, 파생된 `Subscription`과 `attributedTo`로 연결됩니다.
- **User (고객):** 모든 상호작용의 중심입니다. `User`는 `Subscription`을 소유(`hasSubscription`)하고, 불만이 생기면 `CSTicket`을 생성(`raisedBy`)합니다.
- **Subscription (구독/커머스):** 상태(`hasStatus`)를 가지며 시간에 따라 변화(Lifecycle)합니다. 추론 규칙(Rule)에 의해 고객 등급(VIP)을 결정짓는 핵심 지표가 됩니다.
- **CSTicket (고객지원):** 고객의 피드백입니다. 특정 `Subscription`과 연관(`relatesTo`)되며, 추론에 의해 근본 원인인 `Event`와 간접적으로 연결(`mightBeCausedBy`)될 수 있습니다.

## 2. 시뮬레이션 시나리오 (End-to-End Test)

실무에서는 스키마 설계가 끝나면 다양한 "What-If" 시나리오를 통해 모델의 건전성을 테스트합니다.

**시나리오 가설:**
> "대규모 연말 할인 이벤트(YearEnd_Promo)를 진행했다. 많은 유저가 1개월 무료 체험판(Trial_Plan)을 구독했다. 그런데 1개월 뒤 결제 갱신 시점에 대량의 결제 실패(PaymentFailed)가 발생했고, 시스템은 이들을 유예 상태(Grace_Period)로 변경했다. 유예 기간 내에 해지(Cancel)를 요청하는 CS 티켓이 폭증했다."

**검증 포인트 (지식 그래프가 답해야 할 질문들):**
1. 이 현상의 근본 원인은 무엇인가? (추론기: "해당 CS 티켓들은 모두 YearEnd_Promo에서 유입된 유저들에게서 발생함")
2. 논리적 오류는 없는가? (정합성 검증: "유예 상태이면서 동시에 활성 상태인 유저는 없는가?")
3. 어떤 비즈니스 룰을 실행해야 하는가? (Action: "유예 상태인 유저에게 해지 방지 쿠폰 자동 발송")

## 3. 확장성(Scalability) 검토

온톨로지 모델의 강력함은 '유연한 확장성'에 있습니다. 만약 회사가 실물 상품 '배송(Delivery)' 서비스를 새로 시작한다고 가정해 봅시다.

RDBMS라면 `Orders`, `Shipping`, `Tracking` 등의 테이블을 새로 만들고 기존 테이블에 외래 키를 추가하는 대규모 마이그레이션이 필요합니다. 
반면, 온톨로지에서는 단순히 새로운 클래스(`Delivery`)와 프로퍼티(`shippedTo`)를 추가하고, 기존 `User` 또는 `Subscription` 노드와 엣지로 연결만 해주면 됩니다. 기존 구조(마케팅, CS)에는 전혀 영향을 미치지 않습니다.

## 4. Phase 2 마무리 및 Phase 3 예고

지금까지 우리는 종이와 화이트보드, 그리고 개념적인 모델링 수준에서 온톨로지를 다루었습니다(Conceptual Modeling).
이제 다가오는 **Phase 3**에서는:
- 실제 소프트웨어(Protégé)를 이용해 이 모델을 코드로 작성하고,
- Neo4j와 같은 그래프 데이터베이스에 적재하여,
- 궁극적으로 LLM(대형 언어 모델)과 연결하여 자연어로 그래프 데이터를 탐색하는 **Agentic RAG** 시스템을 구축하게 됩니다.

## 실습 파일

- [통합 시뮬레이션 시나리오 및 아키텍처 리뷰](samples/integrated_simulation.md)
- [최종 통합 테스트용 온톨로지 (TTL)](samples/full_scenario.ttl)
- [상세 과제](assignment.md)

## 전체 강의 목록

- [Chapter 01: 온톨로지란 무엇인가](../Chapter01_온톨로지란_무엇인가/README.md)
- [Chapter 02: 온톨로지의 핵심 구성 요소](../Chapter02_온톨로지의_핵심_구성_요소/README.md)
- [Chapter 03: 택소노미와 온톨로지의 차이](../Chapter03_택소노미와_온톨로지의_차이/README.md)
- [Chapter 04: 온톨로지 표준 언어 RDF RDFS OWL](../Chapter04_온톨로지_표준_언어_RDF_RDFS_OWL/README.md)
- [Chapter 05: 온톨로지와 추론](../Chapter05_온톨로지와_추론/README.md)
- [Chapter 06: 엔터프라이즈 환경에서의 온톨로지 도입 가치](../Chapter06_엔터프라이즈_환경에서의_온톨로지_도입_가치/README.md)
- [Chapter 07: Palantir의 온톨로지 개념 기업의 디지털 트윈](../Chapter07_Palantir의_온톨로지_개념_기업의_디지털_트윈/README.md)
- [Chapter 08: Palantir 파운드리 데이터와 비즈니스 로직의 결합](../Chapter08_Palantir_파운드리_데이터와_비즈니스_로직의_결합/README.md)
- [Chapter 09: Palantir 사례 분석 공급망 및 고객 관리](../Chapter09_Palantir_사례_분석_공급망_및_고객_관리/README.md)
- [Chapter 10: 1단계 종합 및 아키텍처 리뷰](../Chapter10_1단계_종합_및_아키텍처_리뷰/README.md)
- [Chapter 12: 코어 클래스 설계 User Product Plan Event](../Chapter12_코어_클래스_설계_User_Product_Plan_Event/README.md)
- [Chapter 13: 객체 속성 정의 관계 맺기](../Chapter13_객체_속성_정의_관계_맺기/README.md)
- [Chapter 14: 데이터 속성 및 제약 조건 정의](../Chapter14_데이터_속성_및_제약_조건_정의/README.md)
- [Chapter 15: 정기 구독 시스템 라이프사이클 모델링](../Chapter15_정기_구독_시스템_라이프사이클_모델링/README.md)
- [Chapter 16: CS 및 이벤트 도메인의 유기적 통합](../Chapter16_CS_및_이벤트_도메인의_유기적_통합/README.md)
- [Chapter 17: 비즈니스 룰 및 커스텀 추론 규칙 작성](../Chapter17_비즈니스_룰_및_커스텀_추론_규칙_작성/README.md)
- [Chapter 18: SPARQL을 이용한 지식 그래프 질의 기초](../Chapter18_SPARQL을_이용한_지식_그래프_질의_기초/README.md)
- [Chapter 19: 온톨로지 정합성 검증 및 디버깅](../Chapter19_온톨로지_정합성_검증_및_디버깅/README.md)
- [Chapter 20: 2단계 종합 통합 플랫폼 지식 그래프 시뮬레이션](../Chapter20_2단계_종합_통합_플랫폼_지식_그래프_시뮬레이션/README.md)

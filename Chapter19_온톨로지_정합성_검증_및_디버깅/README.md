# 19강: 온톨로지 정합성 검증 및 디버깅

## 강의 개요

온톨로지 모델링에서 또 하나의 강력한 장점은 **데이터의 논리적 모순(Inconsistency)을 기계가 스스로 발견할 수 있다**는 점입니다. 18강까지 우리가 구축한 데이터가 완벽해 보일지라도, 시스템 연동 오류나 휴먼 에러로 인해 논리적으로 불가능한 데이터가 유입될 수 있습니다. 

이번 19강에서는 추론 엔진(Reasoner)을 활용하여 온톨로지의 일관성(Consistency)을 검사하고, 의도적으로 발생시킨 모순을 디버깅하는 방법을 학습합니다.

## 학습 목표

- 온톨로지의 정합성(Consistency)과 만족 가능성(Satisfiability)의 개념을 이해한다.
- `Disjoint classes`(상호 배타적 클래스)와 `Functional Property`(단일값 속성) 등 논리적 제약을 설정할 수 있다.
- 논리적 모순(예: "해지된 유저가 활성 결제 상태를 가짐")이 발생했을 때 추론기가 이를 어떻게 찾아내는지 파악한다.
- 불일치가 발생한 원인(Explanation)을 추적하고 디버깅하는 방법을 실습한다.

## 핵심 질문

1. RDBMS의 제약 조건(Constraints)과 온톨로지의 추론 기반 정합성 검사는 어떻게 다른가?
2. 특정 데이터 인스턴스가 상호 배타적인 두 클래스에 동시에 속하게 될 경우 어떤 일이 발생하는가?
3. "일관성 없는 온톨로지(Inconsistent Ontology)" 상태에서는 왜 모든 질의(SPARQL) 결과가 신뢰할 수 없게 되는가?

## 1. 정합성 검증(Consistency Checking)이란?

정합성 검증은 현재 입력된 지식(Fact)들이 우리가 정의한 스키마(TBox)의 논리적 제약 조건들과 충돌하지 않는지 확인하는 과정입니다.

- **RDBMS 제약 조건:** 데이터 타입, Null 여부, 외래 키 참조 등을 검사합니다.
- **온톨로지 제약 조건:** 의미론적 모순을 검사합니다. (예: "A는 B의 부모이다"와 "A는 B의 자식이다"가 동시에 존재할 수 없음)

## 2. 모순을 잡아내는 주요 논리 제약

### A. 서로소 클래스 (Disjoint Classes)
두 클래스의 교집합이 없음을 선언합니다. 어떤 인스턴스도 두 클래스에 동시에 속할 수 없습니다.
- 예: `ActiveSubscription` 과 `CancelledSubscription` 은 서로소입니다.

### B. 단일값 속성 (Functional Property)
하나의 주어에 대해 해당 속성은 오직 하나의 목적어만 가질 수 있음을 의미합니다.
- 예: `hasCurrentState`는 Functional Property이므로, 구독은 동시에 두 개의 현재 상태를 가질 수 없습니다.

### C. 도메인 및 범위 제한 (Domain & Range Restrictions)
- 예: `hasSubscription`의 Domain은 `User`, Range는 `Subscription`입니다. 만약 `Event_001 hasSubscription Sub_101` 이라는 트리플이 들어온다면, 추론기는 `Event_001`을 `User`로 간주하게 됩니다. 이때 `Event`와 `User`가 서로소 클래스라면 모순이 발생합니다.

## 3. 실무 예제: 모순 상황 디버깅

**오류 상황 시나리오:**
결제 시스템의 버그로 인해, 이미 해지 완료(Cancelled) 처리된 구독(Subscription_888)에 대해 최근 결제 성공(PaymentCaptured) 이벤트가 발생하여 상태가 'Active'로 중복 등록되었습니다.

**온톨로지 상의 데이터 (Fact):**
```text
Sub_888 rdf:type CancelledSubscription .
Sub_888 rdf:type ActiveSubscription .
```

**온톨로지의 제약 (Rule):**
```text
CancelledSubscription owl:disjointWith ActiveSubscription .
```

**추론 엔진의 동작:**
추론기(Pellet, HermiT 등)를 실행하면 **"Inconsistent Ontology"** 에러를 발생시킵니다. 즉, 데이터베이스 자체에 논리적 치명상이 있음을 경고하는 것입니다. Protégé 같은 에디터에서는 "Why?" 버튼을 통해 이 모순이 왜 발생했는지 경로를 추적(Explanation)해 줍니다.

## 4. 정합성 검증의 비즈니스 가치

기업 환경에서 데이터 파이프라인의 마지막 단계에 온톨로지 정합성 검사를 도입하면 다음과 같은 이점이 있습니다.

1. **데이터 품질(Data Quality) 자동 확보:** 개발자가 일일이 방어 코드(If-Else)를 짜지 않아도, 비즈니스 룰에 위배되는 잘못된 데이터 적재를 차단할 수 있습니다.
2. **사일로 통합 시의 충돌 감지:** 서로 다른 부서의 데이터를 통합할 때, 용어나 로직의 충돌(예: 마케팅에서는 '신규 고객', CS에서는 '기존 고객'으로 분류된 동명이인)을 기계적으로 찾아냅니다.
3. **디버깅 비용 감소:** 단순한 에러 메시지가 아니라 논리적 원인 제공자(A 속성 때문에 B가 모순됨)를 알려주므로 디버깅 속도가 매우 빨라집니다.

## 5. 이번 강의의 핵심 정리

- 온톨로지는 입력된 지식을 기반으로 논리적 모순을 스스로 찾아내는 능력이 있다.
- Disjoint, Functional Property 등의 제약 조건을 잘 설계하면 데이터 품질을 기계적으로 보장할 수 있다.
- 추론 엔진이 뱉어내는 "Inconsistent Ontology" 경고는 잘못된 비즈니스 로직이나 시스템 연동 버그를 조기에 발견하는 핵심 알람 척도가 된다.

## 실습 파일

- [정합성 검증 원리 예제](samples/consistency_check.md)
- [모순이 포함된 온톨로지 테스트 파일](samples/inconsistent_data.ttl)
- [상세 과제](assignment.md)

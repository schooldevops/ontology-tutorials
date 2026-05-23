# 온톨로지 정합성 검증 원리 예제

이 예제는 추론 엔진이 어떤 논리를 거쳐 데이터의 모순(Inconsistency)을 감지하는지 시나리오를 통해 설명합니다.

## 1. 기반 스키마 (TBox Rules)

우리는 시스템에 다음 두 가지 강력한 제약 조건을 선언해 두었습니다.

1. **상호 배타성 (Disjointness):** 
   `ActiveSubscription` 클래스와 `CancelledSubscription` 클래스는 서로 겹치지 않는다. (구독이 동시에 활성화 상태이면서 해지 상태일 수 없다.)
2. **단일값 속성 (Functional Property):**
   `hasCurrentStatus` 프로퍼티는 Functional 속성이다. (어떤 객체든 이 프로퍼티에 대해서는 오직 1개의 목적어만 가질 수 있다.)

## 2. 오류 데이터 주입 (ABox Facts)

시스템간 동기화 버그로 인해, `Subscription_999`에 대한 아래 2개의 사실(Fact)이 동시에 들어왔습니다.

```text
Fact 1: Subscription_999 hasCurrentStatus "Active"
Fact 2: Subscription_999 hasCurrentStatus "Cancelled"
```

## 3. 추론기의 판단 (Reasoning Process)

1. 추론기가 `Fact 1`과 `Fact 2`를 읽습니다.
2. `hasCurrentStatus`가 **Functional Property**임을 인지합니다.
3. Functional 속성인데 목적어가 2개("Active", "Cancelled") 존재하므로, 추론기는 이 두 값이 **같아야만 한다(SameAs)**고 논리적으로 강제(결론 도출)하려 시도합니다.
4. 그러나 만약 "Active"가 속한 클래스(`ActiveSubscription`의 기준 값)와 "Cancelled"가 속한 클래스(`CancelledSubscription`의 기준 값)가 스키마에서 **Disjoint(서로소)**로 묶여 있다면?
5. "같아야만 한다"는 결론과 "서로소이다"라는 전제가 **충돌(Contradiction)**합니다.
6. 결과적으로 추론기는 작동을 멈추고 **"Inconsistent Ontology"** 에러 리포트를 출력합니다.

## 4. 디버깅 및 해결

이러한 에러가 발생하면 SPARQL 쿼리가 정상 작동하지 않습니다(모든 쿼리의 결과가 모순에 빠지기 때문). 

개발자 혹은 데이터 관리자는:
1. 에디터(예: Protégé)의 Explanation 기능을 통해 어느 프로퍼티(`hasCurrentStatus`)에서 충돌이 났는지 확인합니다.
2. `Subscription_999`의 데이터 발생 로그를 추적하여, 왜 "Active"와 "Cancelled" 이벤트가 중복 처리되었는지 백엔드 버그를 수정합니다.
3. 잘못 들어온 트리플 중 하나를 삭제하여 온톨로지를 다시 일관된 상태로 만듭니다.

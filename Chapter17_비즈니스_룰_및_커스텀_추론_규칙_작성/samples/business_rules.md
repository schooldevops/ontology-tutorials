# 비즈니스 룰 모델링 예제

이 예제는 SWRL(Semantic Web Rule Language)의 개념을 차용하여, 온톨로지에 저장된 데이터를 바탕으로 고객의 상태(VIP)를 동적으로 추론하는 방법을 설명합니다.

## 1. 기반 데이터 구조 (Fact)

- `User_Bob` (타입: User)
- `User_Bob`의 총 구매액(`totalSpent`)은 600
- `Sub_Basic_002` (타입: Subscription)
- `Sub_Basic_002`의 상태(`hasStatus`)는 "Active"
- `Sub_Basic_002`의 유지 개월 수(`monthsActive`)는 8개월
- `Sub_Basic_002`는 `User_Bob`에게 속함 (`belongsTo`의 역관계인 `hasSubscription`)

## 2. 비즈니스 룰 선언 (SWRL 표현식)

**요구사항:** "구독 유지 6개월 이상이고 총 구매액이 500 이상인 활성 구독자는 VIP 등급으로 승급한다."

```text
User(?u) ^ 
hasSubscription(?u, ?s) ^ 
Subscription(?s) ^ 
hasStatus(?s, "Active") ^
monthsActive(?s, ?m) ^ swrlb:greaterThanOrEqual(?m, 6) ^
totalSpent(?u, ?t) ^ swrlb:greaterThanOrEqual(?t, 500)
-> VIPUser(?u)
```

## 3. 추론 결과 (Inferred Knowledge)

추론 엔진(Reasoner)이 온톨로지를 읽고 위의 규칙을 평가하면, 데이터베이스에 명시적으로 `VIPUser`라고 입력된 적이 없더라도 다음과 같은 새로운 지식을 도출합니다.

```text
User_Bob rdf:type VIPUser
```

### 활용 방안 (Action)

이 추론된 결과는 단순히 데이터를 조회하는 것을 넘어, 시스템이 트리거할 Action의 조건이 됩니다.
- 이벤트 플랫폼은 `VIPUser` 클래스에 속한 사용자에게만 특정 프리미엄 쿠폰을 발송합니다.
- CS 상담 화면에서 `User_Bob`을 조회할 때, 온톨로지는 실시간으로 이 규칙을 평가하여 화면에 "VIP 배지"를 표시합니다.

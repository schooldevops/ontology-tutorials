# SPARQL 쿼리 및 실행 예제

이 문서에서는 이벤트-구독 통합 온톨로지에서 데이터를 추출하는 SPARQL 질의문 예제들을 다룹니다.

## 1. 기본 조회 (SELECT)
모든 사용자의 이름과 총 구매액을 조회합니다.

```sparql
PREFIX : <http://example.org/ontology/commerce#>

SELECT ?userName ?spent
WHERE {
  ?user rdf:type :User .
  ?user :hasName ?userName .
  ?user :totalSpent ?spent .
}
```

## 2. 특정 조건을 만족하는 연결 노드 찾기 (다중 패턴)
`Event_BlackFriday`를 통해 유입된 활성(`Active`) 구독자 이름 찾기.

```sparql
PREFIX : <http://example.org/ontology/commerce#>

SELECT ?userName
WHERE {
  # 이벤트 기여 확인
  ?sub :attributedTo :Event_BlackFriday .
  
  # 구독 상태 확인
  ?sub :hasStatus "Active" .
  
  # 소유 유저 확인
  ?sub :belongsTo ?user .
  ?user :hasName ?userName .
}
```

## 3. FILTER와 OPTIONAL 활용
구매액이 500 이상인 사용자들의 이름과 구독ID를 조회합니다. 전화번호가 있으면 가져오고, 없으면 공란으로 둡니다.

```sparql
PREFIX : <http://example.org/ontology/commerce#>

SELECT ?userName ?subId ?phone
WHERE {
  ?user rdf:type :User .
  ?user :hasName ?userName .
  ?user :totalSpent ?spent .
  FILTER (?spent >= 500)
  
  ?user :hasSubscription ?sub .
  ?sub :hasSubscriptionId ?subId .
  
  OPTIONAL { ?user :hasPhone ?phone }
}
```

## 4. 추론된 지식(Inferred Knowledge) 조회
17강에서 작성한 SWRL 룰에 의해 생성된 `VIPUser` 리스트를 단순히 클래스 조회만으로 추출합니다.

```sparql
PREFIX : <http://example.org/ontology/commerce#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

SELECT ?vipName
WHERE {
  # 명시적으로 입력되지 않았어도, 추론기를 거치면 매칭됨
  ?user rdf:type :VIPUser . 
  ?user :hasName ?vipName .
}
```

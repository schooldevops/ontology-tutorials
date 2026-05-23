# 18강: SPARQL을 이용한 지식 그래프 질의 기초

## 강의 개요

17강까지 우리는 비즈니스 규칙과 구조를 담은 온톨로지를 구축하고, 그 위에 데이터를 매핑(인스턴스 생성)하며 추론을 통해 새로운 지식을 만들어냈습니다. 이번 18강에서는 이렇게 구축된 **지식 그래프(Knowledge Graph)에서 우리가 원하는 정보를 어떻게 빠르고 정확하게 추출할 것인가**를 다룹니다.

관계형 데이터베이스(RDBMS)에서 데이터를 조회할 때 SQL(Structured Query Language)을 사용하듯, 온톨로지와 같은 RDF 형식의 그래프 데이터를 조회할 때는 **SPARQL (SPARQL Protocol and RDF Query Language)**을 사용합니다. 

## 학습 목표

- SQL과 SPARQL의 차이점을 이해하고, 왜 그래프 쿼리가 복잡한 연결 관계를 탐색하는 데 유리한지 설명할 수 있다.
- SPARQL의 기본 구조(SELECT, WHERE)를 파악하고 단순 질의문을 작성할 수 있다.
- FILTER, OPTIONAL 등의 확장 기능을 사용하여 질의를 세밀하게 제어할 수 있다.
- "이벤트 A를 통해 유입되어 현재 구독 상태가 Active인 유저 목록"과 같은 비즈니스 질문을 SPARQL 쿼리로 변환할 수 있다.

## 핵심 질문

1. RDBMS의 `JOIN`과 SPARQL의 트리플(Triple) 패턴 매칭은 어떻게 다른가?
2. 그래프 구조에서 여러 단계를 건너뛰어 관계를 탐색할 때 SPARQL은 어떤 이점을 제공하는가?
3. 명시적 데이터(Fact)와 추론된 데이터(Inferred Knowledge)를 쿼리할 때 결과는 어떻게 달라지는가?

## 1. RDBMS SQL vs 그래프 SPARQL

**RDBMS (SQL)**
데이터가 엄격한 테이블에 담겨 있습니다. 여러 엔티티(고객, 구독, 결제)가 연관된 정보를 찾으려면 `JOIN` 연산을 반복해야 합니다. 
```sql
SELECT u.name
FROM User u
JOIN Subscription s ON u.id = s.user_id
JOIN Event e ON s.event_id = e.id
WHERE s.status = 'Active' AND e.name = 'BlackFriday';
```
테이블이 늘어날수록 JOIN문이 기하급수적으로 복잡해지고 쿼리 성능이 저하될 수 있습니다.

**지식 그래프 (SPARQL)**
데이터가 노드(Node)와 엣지(Edge)의 거대한 네트워크로 존재합니다. 테이블을 병합하는 개념이 아니라, **"내가 원하는 모양의 패턴(Sub-graph)을 전체 그래프에서 찾아줘"**라는 방식으로 동작합니다.

## 2. SPARQL 기본 문법

SPARQL은 SQL과 형태가 매우 유사하지만, `WHERE` 절 안에 **트리플(주어-동사-목적어)** 패턴을 적는다는 것이 가장 큰 특징입니다.

```sparql
PREFIX : <http://example.org/ontology/commerce#>

SELECT ?userName
WHERE {
  ?user rdf:type :User .
  ?user :hasName ?userName .
}
```
- `PREFIX`: 긴 URI를 줄여 쓰기 위한 접두사 선언입니다.
- `SELECT`: 결과로 출력할 변수를 지정합니다. 변수는 `?`로 시작합니다 (`?userName`).
- `WHERE`: 찾고자 하는 그래프의 패턴을 정의합니다. (주어-동사-목적어 순)
  - "?user는 User 클래스 타입이다."
  - "그리고 그 ?user의 :hasName 속성값은 ?userName이다."

## 3. 실무 예제: 복합 패턴 질의

**비즈니스 질문:** "블랙프라이데이 이벤트(Event_BlackFriday)를 통해 유입되어, 현재 'Active' 상태의 구독을 유지하고 있는 유저의 이름을 찾아주세요."

**SPARQL 쿼리:**
```sparql
PREFIX : <http://example.org/ontology/commerce#>

SELECT ?userName ?subId
WHERE {
  # 1. 구독 정보와 상태 매칭
  ?sub rdf:type :Subscription .
  ?sub :hasStatus "Active" .
  ?sub :hasSubscriptionId ?subId .
  
  # 2. 해당 구독의 유입 경로(이벤트) 매칭
  ?sub :attributedTo :Event_BlackFriday .
  
  # 3. 해당 구독을 소유한 사용자 매칭
  ?sub :belongsTo ?user .
  ?user :hasName ?userName .
}
```

위 쿼리는 그래프 데이터 내에서,
1. 상태가 "Active"인 구독 노드(`?sub`)를 찾고,
2. 그 구독 노드가 `Event_BlackFriday` 노드와 `attributedTo` 엣지로 연결되어 있는지 확인한 후,
3. 그 구독 노드와 `belongsTo` 엣지로 연결된 사용자 노드(`?user`)의 이름을 가져오는 것입니다.

## 4. 질의 제어: FILTER와 OPTIONAL

- **FILTER:** 특정 조건(수치 비교, 정규표현식 등)을 만족하는 결과만 필터링합니다.
- **OPTIONAL:** 데이터가 있으면 가져오고, 없으면 NULL(비워둠) 처리하는 기능입니다. (SQL의 LEFT JOIN과 유사)

**예제: 총 구매액 500 이상 필터링 및 전화번호 옵션**
```sparql
PREFIX : <http://example.org/ontology/commerce#>

SELECT ?userName ?phone
WHERE {
  ?user rdf:type :User .
  ?user :hasName ?userName .
  ?user :totalSpent ?spent .
  
  FILTER (?spent >= 500)
  
  OPTIONAL { ?user :hasPhone ?phone }
}
```

## 5. 이번 강의의 핵심 정리

- SPARQL은 그래프 데이터(RDF)에서 원하는 패턴을 매칭시켜 데이터를 찾아내는 강력한 질의 언어입니다.
- 테이블 JOIN의 복잡성 없이, 객체 간의 자연스러운 연결선(Property)을 따라가며 직관적인 쿼리를 작성할 수 있습니다.
- 앞선 17강에서 추론된 데이터(Inferred Knowledge, 예: `VIPUser`) 역시 SPARQL을 통해 자연스럽게 조회할 수 있습니다. (예: `?user rdf:type :VIPUser`)

## 실습 파일

- [SPARQL 쿼리 및 실행 예제](samples/sparql_queries.md)
- [쿼리 테스트용 온톨로지 데이터](samples/query_data.ttl)
- [상세 과제](assignment.md)

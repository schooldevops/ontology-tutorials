# 샘플: 실생활 객체를 온톨로지 구성 요소로 분해하기

## 시나리오

다음 업무 문장을 분석합니다.

> 이서연 고객은 모바일 앱에서 여름 할인 이벤트에 참여했고, 무선 키보드 1개를 주문했다. 주문은 결제 완료 상태이며, 상품 가격은 59,000원이다.

## 1. 후보 명사 찾기

| 후보 명사 | 해석 |
| --- | --- |
| 이서연 | 실제 고객 개인 |
| 고객 | 사람의 역할 또는 개념 |
| 모바일 앱 | 이벤트 참여 채널 |
| 여름 할인 이벤트 | 마케팅 이벤트 |
| 무선 키보드 | 판매 상품 |
| 주문 | 구매 행위의 기록 |
| 결제 완료 상태 | 주문 상태 |
| 59,000원 | 상품 가격 |

## 2. 클래스 후보

| 클래스 | 설명 |
| --- | --- |
| Customer | 상품을 구매하거나 이벤트에 참여하는 고객 |
| MarketingEvent | 고객 전환 또는 참여를 유도하는 이벤트 |
| Product | 판매 가능한 상품 |
| PhysicalProduct | 배송이 필요한 실물 상품 |
| Order | 고객의 구매 행위를 나타내는 주문 |
| Channel | 고객이 유입되거나 참여한 채널 |

## 3. 인스턴스 후보

| 인스턴스 | 타입 |
| --- | --- |
| 이서연 | Customer |
| 여름 할인 이벤트 | MarketingEvent |
| 무선 키보드 | PhysicalProduct |
| 주문 O2001 | Order |
| 모바일 앱 | Channel |

## 4. 데이터 속성 후보

| Subject | Property | Value |
| --- | --- | --- |
| 이서연 | name | "이서연" |
| 무선 키보드 | name | "무선 키보드" |
| 무선 키보드 | price | 59000 |
| 주문 O2001 | status | "PAID" |
| 주문 O2001 | quantity | 1 |

## 5. 객체 속성 후보

| Subject | Property | Object |
| --- | --- | --- |
| 이서연 | participatesIn | 여름 할인 이벤트 |
| 이서연 | placesOrder | 주문 O2001 |
| 주문 O2001 | containsProduct | 무선 키보드 |
| 여름 할인 이벤트 | hasChannel | 모바일 앱 |

## 6. 최종 트리플 초안

```text
이서연 | type | Customer
여름할인이벤트 | type | MarketingEvent
무선키보드 | type | PhysicalProduct
주문O2001 | type | Order
모바일앱 | type | Channel
이서연 | participatesIn | 여름할인이벤트
이서연 | placesOrder | 주문O2001
주문O2001 | containsProduct | 무선키보드
여름할인이벤트 | hasChannel | 모바일앱
무선키보드 | price | 59000
주문O2001 | status | PAID
```

## 7. 검토 질문

1. `모바일 앱`은 문자열 속성으로 두는 것이 나은가, 별도 `Channel` 인스턴스로 두는 것이 나은가?
2. `주문 O2001`의 `quantity`는 주문의 속성인가, 주문 항목의 속성인가?
3. `여름 할인 이벤트`가 여러 채널에서 동시에 운영된다면 모델을 어떻게 바꿔야 하는가?

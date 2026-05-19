# 3강: 택소노미와 온톨로지의 차이

## 강의 개요

1강에서는 온톨로지를 지식 모델로 이해했고, 2강에서는 클래스, 속성, 인스턴스라는 기본 구성 요소를 학습했습니다. 3강에서는 온톨로지와 자주 혼동되는 택소노미를 비교합니다.

택소노미는 대상을 계층적으로 분류하는 체계입니다. 온톨로지는 계층 분류를 포함할 수 있지만, 그보다 더 넓게 개념 사이의 다양한 관계와 규칙을 표현합니다.

```text
Taxonomy   무엇이 어떤 상위 분류에 속하는가?
Ontology   무엇이 무엇과 어떤 의미 관계를 가지는가?
```

## 학습 목표

- 택소노미와 온톨로지의 차이를 설명할 수 있다.
- `Is-A` 관계와 일반 관계를 구분할 수 있다.
- 쇼핑몰 카테고리를 온톨로지 모델로 확장할 수 있다.
- 계층 구조만으로는 표현하기 어려운 업무 지식을 식별할 수 있다.

## 핵심 질문

1. `무선 키보드`는 `키보드`의 하위 분류인가, `무선 연결 방식`을 가진 상품인가?
2. 쇼핑몰 카테고리만으로 "구독 고객에게 추천할 상품"을 판단할 수 있는가?
3. 택소노미의 `Is-A` 관계와 온톨로지의 `compatibleWith`, `purchasedWith`, `subscribesTo` 관계는 어떻게 다른가?
4. 계층 구조가 깊어질수록 왜 중복 분류와 예외 처리가 늘어나는가?

## 1. 택소노미란 무엇인가?

택소노미는 개념이나 대상을 상하위 관계로 분류한 체계입니다. 가장 익숙한 예는 쇼핑몰 카테고리입니다.

```text
상품
├── 전자제품
│   ├── 컴퓨터 주변기기
│   │   ├── 키보드
│   │   └── 마우스
│   └── 모바일 액세서리
└── 구독 서비스
    ├── 베이직 플랜
    └── 프리미엄 플랜
```

이 구조의 핵심 관계는 `Is-A`입니다.

```text
키보드 Is-A 컴퓨터 주변기기
컴퓨터 주변기기 Is-A 전자제품
전자제품 Is-A 상품
```

택소노미는 탐색, 메뉴 구성, 검색 필터, 상품 분류에 유용합니다. 사용자가 카테고리를 따라 내려가며 원하는 대상을 찾을 수 있기 때문입니다.

## 2. 택소노미의 장점과 한계

### 장점

- 이해하기 쉽다.
- 화면 메뉴나 필터로 구현하기 쉽다.
- 상위/하위 분류를 통해 큰 범주에서 작은 범주로 탐색할 수 있다.
- 데이터 정리의 출발점으로 적합하다.

### 한계

택소노미는 대부분 하나의 질문에 강합니다.

> 이 대상은 어떤 분류에 속하는가?

하지만 엔터프라이즈 업무에서는 다음과 같은 질문이 자주 등장합니다.

- 이 상품은 어떤 구독 플랜과 함께 추천할 수 있는가?
- 이 이벤트는 어떤 고객 세그먼트에 영향을 주었는가?
- 이 상품은 어떤 기기와 호환되는가?
- 이 고객은 이벤트 참여 후 어떤 상품을 구매했는가?
- 특정 상품의 품절이 어떤 구독 고객에게 영향을 주는가?

이런 질문은 단순 계층 구조만으로 답하기 어렵습니다. 개념 사이의 다차원 관계가 필요합니다.

## 3. 온톨로지는 택소노미를 포함한다

온톨로지는 택소노미를 버리는 것이 아닙니다. 택소노미의 계층 구조를 포함하면서, 그 위에 다양한 관계를 추가합니다.

```text
Product
├── PhysicalProduct
│   ├── Keyboard
│   └── Mouse
└── SubscriptionPlan
    ├── BasicPlan
    └── PremiumPlan

Keyboard --compatibleWith--> Device
Customer --purchased--> Product
Customer --subscribesTo--> SubscriptionPlan
Product --recommendedFor--> CustomerSegment
Event --targets--> CustomerSegment
```

택소노미는 주로 `Is-A` 관계를 표현합니다. 온톨로지는 여기에 `hasFeature`, `compatibleWith`, `purchasedWith`, `requires`, `targets`, `influencedBy` 같은 업무 관계를 추가합니다.

## 4. Is-A 관계와 다른 관계

### Is-A 관계

`Is-A`는 하위 개념이 상위 개념의 한 종류임을 의미합니다.

```text
SubscriptionPlan Is-A Product
PhysicalProduct Is-A Product
Keyboard Is-A PhysicalProduct
```

이 관계는 분류와 상속에 사용됩니다. `Keyboard`가 `PhysicalProduct`의 하위 클래스라면, 키보드는 실물 상품이 가지는 공통 속성을 물려받을 수 있습니다.

### 일반 관계

일반 관계는 개념이나 인스턴스 사이의 업무 의미를 표현합니다.

```text
WirelessKeyboard compatibleWith DesktopPC
CustomerU001 purchased WirelessKeyboard
PremiumPlan includes FreeShippingBenefit
SummerEvent targets DormantCustomerSegment
```

이 관계들은 상하위 분류가 아닙니다. `무선 키보드`는 `데스크톱 PC`의 한 종류가 아니라, 데스크톱 PC와 호환되는 상품입니다.

## 5. 쇼핑몰 카테고리의 문제

다음 상품을 생각해봅니다.

> 블루투스 무선 키보드

택소노미만 사용하면 어디에 배치해야 할지 고민이 생깁니다.

```text
전자제품 > 컴퓨터 주변기기 > 키보드
전자제품 > 모바일 액세서리 > 태블릿 액세서리
전자제품 > 무선기기 > 블루투스 기기
```

하나의 상품이 여러 분류 기준에 걸쳐 있습니다.

- 상품 종류: 키보드
- 연결 방식: 블루투스
- 호환 기기: 데스크톱, 태블릿
- 배송 방식: 택배 배송
- 추천 대상: 재택근무 고객, 태블릿 사용자

택소노미에서는 이 모든 기준을 카테고리 깊이로 밀어 넣으려는 유혹이 생깁니다. 그 결과 카테고리가 복잡해지고 중복이 늘어납니다.

온톨로지에서는 각 기준을 별도 관계나 속성으로 표현합니다.

```text
BluetoothKeyboard type Keyboard
BluetoothKeyboard hasConnectionType Bluetooth
BluetoothKeyboard compatibleWith Tablet
BluetoothKeyboard compatibleWith DesktopPC
BluetoothKeyboard recommendedFor RemoteWorkerSegment
BluetoothKeyboard deliveryMethod ParcelDelivery
```

## 6. 택소노미에서 온톨로지로 확장하는 절차

### 1단계. 기존 카테고리 트리를 수집한다

쇼핑몰, CRM, CS, 구독 시스템에서 사용하는 분류 체계를 수집합니다.

```text
상품 > 전자제품 > 컴퓨터 주변기기 > 키보드
```

### 2단계. Is-A 관계만 남긴다

진짜 상하위 개념인지 검토합니다.

```text
Keyboard Is-A PhysicalProduct
PhysicalProduct Is-A Product
```

`블루투스`나 `재택근무 추천`은 하위 클래스가 아니라 속성 또는 관계일 수 있습니다.

### 3단계. 분류 기준을 분리한다

카테고리에 섞여 있던 기준을 독립적인 속성으로 분리합니다.

| 기준 | 온톨로지 표현 |
| --- | --- |
| 상품 종류 | Class |
| 연결 방식 | Data Property 또는 Object Property |
| 호환 기기 | Object Property |
| 추천 대상 | Object Property |
| 배송 방식 | Object Property |

### 4단계. 업무 관계를 추가한다

상품과 고객, 이벤트, 주문, 구독 사이의 관계를 추가합니다.

```text
Customer participatesIn Event
Customer purchases Product
Customer subscribesTo SubscriptionPlan
Event targets CustomerSegment
Product recommendedFor CustomerSegment
```

### 5단계. 질문에 답할 수 있는지 검토한다

좋은 온톨로지는 실제 업무 질문에 답할 수 있어야 합니다.

예:

> 태블릿 사용자 중 여름 이벤트에 참여했고, 블루투스 키보드를 구매하지 않은 고객에게 추천할 상품은 무엇인가?

이 질문은 단순 카테고리만으로는 어렵지만, 온톨로지 관계가 있으면 탐색 가능한 그래프 문제가 됩니다.

## 7. 이번 강의의 핵심 정리

- 택소노미는 계층적 분류 체계다.
- 택소노미의 핵심 관계는 `Is-A`다.
- 온톨로지는 택소노미를 포함하면서 다양한 의미 관계를 표현한다.
- 모든 분류 기준을 카테고리 깊이로 표현하면 중복과 예외가 늘어난다.
- 상품 종류, 연결 방식, 호환 기기, 추천 대상처럼 서로 다른 기준은 별도 속성과 관계로 분리하는 것이 좋다.
- 엔터프라이즈 AI가 업무 질문에 답하려면 계층 구조보다 관계 네트워크가 중요하다.

## 실습 파일

- [쇼핑몰 택소노미 예제](samples/shop_taxonomy.md)
- [택소노미에서 온톨로지로 확장한 예제](samples/taxonomy_to_ontology.ttl)
- [상세 과제](assignment.md)

# 샘플: 쇼핑몰 택소노미 분석

## 1. 기존 카테고리 트리

다음은 쇼핑몰에서 흔히 볼 수 있는 상품 카테고리입니다.

```text
상품
├── 전자제품
│   ├── 컴퓨터 주변기기
│   │   ├── 키보드
│   │   │   ├── 유선 키보드
│   │   │   └── 무선 키보드
│   │   └── 마우스
│   └── 모바일 액세서리
│       ├── 태블릿 액세서리
│       └── 스마트폰 액세서리
└── 구독 서비스
    ├── 베이직 플랜
    └── 프리미엄 플랜
```

## 2. 택소노미 관점의 장점

- 상품 탐색 메뉴로 사용하기 쉽다.
- 상위 카테고리별 매출 집계가 쉽다.
- 사용자가 큰 범주에서 작은 범주로 이동할 수 있다.
- 운영자가 상품을 등록할 때 기본 분류 기준을 제공한다.

## 3. 택소노미 관점의 애매한 지점

### 블루투스 키보드

블루투스 키보드는 다음 여러 기준에 동시에 걸립니다.

| 기준 | 값 |
| --- | --- |
| 상품 종류 | 키보드 |
| 연결 방식 | 블루투스 |
| 전원 방식 | 배터리 |
| 호환 기기 | PC, 태블릿, 스마트폰 |
| 추천 대상 | 재택근무 고객, 태블릿 사용자 |

이 모든 기준을 카테고리로 만들면 카테고리 트리가 빠르게 복잡해집니다.

```text
전자제품 > 컴퓨터 주변기기 > 키보드 > 무선 키보드 > 블루투스 키보드
전자제품 > 모바일 액세서리 > 태블릿 액세서리 > 블루투스 키보드
전자제품 > 스마트폰 액세서리 > 블루투스 키보드
```

같은 상품이 여러 위치에 중복 등록되거나, 한 위치에만 등록되어 검색 누락이 발생할 수 있습니다.

## 4. 온톨로지로 분리할 기준

| 분류 기준 | 택소노미 표현 | 온톨로지 표현 |
| --- | --- | --- |
| 상품 종류 | 무선 키보드 카테고리 | `BluetoothKeyboard type Keyboard` |
| 연결 방식 | 블루투스 키보드 카테고리 | `hasConnectionType Bluetooth` |
| 호환 기기 | 태블릿 액세서리 카테고리 | `compatibleWith Tablet` |
| 추천 대상 | 재택근무 추천 카테고리 | `recommendedFor RemoteWorkerSegment` |
| 판매 방식 | 구독 서비스 카테고리 | `availableWith SubscriptionPlan` |

## 5. 확장된 관계 예시

```text
BluetoothKeyboard type Keyboard
Keyboard subClassOf PhysicalProduct
PhysicalProduct subClassOf Product
BluetoothKeyboard hasConnectionType Bluetooth
BluetoothKeyboard compatibleWith Tablet
BluetoothKeyboard compatibleWith DesktopPC
BluetoothKeyboard recommendedFor RemoteWorkerSegment
RemoteWorkerSegment targetedBy SummerEvent
CustomerU001 belongsTo RemoteWorkerSegment
```

## 6. 검토 질문

1. `무선 키보드`는 별도 클래스가 적절한가, 아니면 `connectionType = Wireless` 속성이 적절한가?
2. `태블릿 액세서리`는 상품 종류인가, 호환 기기 기준인가?
3. 추천 대상과 상품 분류를 같은 카테고리 트리에 넣으면 어떤 문제가 생기는가?
4. 온톨로지로 확장했을 때 마케팅, 추천, CS 분석에는 어떤 장점이 생기는가?

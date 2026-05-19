# 샘플: 공급망 리스크 전파 시나리오

## 1. 상황

커머스 구독 기업이 프리미엄 구독 고객에게 매월 업무 생산성 번들을 제공합니다.

이번 달 번들에는 다음 상품이 포함됩니다.

- 블루투스 무선 키보드
- 태블릿 거치대
- 노트북 파우치

그런데 블루투스 무선 키보드에 들어가는 `BluetoothModule` 부품의 공급이 지연되었습니다.

## 2. 공급망 객체

| 객체 | 인스턴스 | 상태 |
| --- | --- | --- |
| Supplier | SupplierA | DELAYED |
| Part | BluetoothModule | SHORTAGE |
| Product | WirelessKeyboard | AT_RISK |
| InventoryItem | InventoryKeyboardSeoul | LOW_STOCK |
| SubscriptionBundle | PremiumWorkBundle | FULFILLMENT_RISK |
| Subscription | Subscription_1001 | ACTIVE |
| CustomerAccount | Customer_001 | VIP |
| CSTicket | Ticket_7001 | OPEN |

## 3. 관계

```text
SupplierA supplies BluetoothModule
BluetoothModule usedIn WirelessKeyboard
WirelessKeyboard stockedAs InventoryKeyboardSeoul
WirelessKeyboard includedIn PremiumWorkBundle
PremiumWorkBundle assignedTo Subscription_1001
Subscription_1001 ownedBy Customer_001
Customer_001 raised Ticket_7001
Ticket_7001 category DELIVERY_DELAY
```

## 4. 리스크 전파

| 단계 | 조건 | 전파 결과 |
| --- | --- | --- |
| 공급사 | SupplierA.status = DELAYED | BluetoothModule.partRisk = HIGH |
| 부품 | BluetoothModule.partRisk = HIGH | WirelessKeyboard.supplyRisk = HIGH |
| 상품 | WirelessKeyboard.supplyRisk = HIGH and stock = LOW | PremiumWorkBundle.fulfillmentRisk = HIGH |
| 번들 | Bundle.fulfillmentRisk = HIGH | Subscription_1001.deliveryRisk = HIGH |
| 구독 | deliveryRisk = HIGH and renewalDate <= 14 days | Customer_001.experienceRisk = HIGH |
| 고객 | VIP and open delivery ticket | priority = CRITICAL |

## 5. 추천 Action

| Action | 대상 | 이유 |
| --- | --- | --- |
| FindAlternativeSupplier | BluetoothModule | SupplierA 지연 |
| ReallocateInventory | WirelessKeyboard | 다른 창고 재고 확인 필요 |
| OfferAlternativeBundle | Subscription_1001 | 번들 구성 불가 가능성 |
| NotifyImpactedCustomer | Customer_001 | 배송 지연 사전 안내 |
| AssignSeniorRetentionManager | Customer_001 | VIP + 갱신 임박 + 티켓 열림 |
| EscalateDeliveryTicket | Ticket_7001 | 고객 영향도 CRITICAL |

## 6. 검토 질문

1. 공급사 지연이 바로 고객 리스크가 되는 것이 아니라 중간에 어떤 객체를 거치나요?
2. `WirelessKeyboard`의 재고가 충분했다면 리스크 전파 결과는 어떻게 달라질까요?
3. VIP 고객과 일반 고객의 대응 Action은 어떻게 달라져야 하나요?
4. 공급망 리스크와 CS 티켓을 연결하지 않으면 어떤 대응이 늦어질 수 있나요?

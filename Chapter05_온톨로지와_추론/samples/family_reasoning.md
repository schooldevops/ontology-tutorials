# 샘플: 가족 관계로 추론 이해하기

## 1. 명시된 사실

다음 사실이 주어졌습니다.

```text
민수 parentOf 지훈
지훈 parentOf 서연
서연 siblingOf 도윤
```

## 2. 관계 성질

| 관계 | 성질 | 설명 |
| --- | --- | --- |
| parentOf | 일반 관계 | 부모에서 자식으로 향하는 방향 관계 |
| childOf | parentOf의 역관계 | 자식에서 부모로 향하는 방향 관계 |
| ancestorOf | 전이 관계 | 조상 관계는 여러 세대를 거쳐 확장 가능 |
| siblingOf | 대칭 관계 | A가 B의 형제자매이면 B도 A의 형제자매 |

## 3. 역관계 추론

규칙:

```text
parentOf inverseOf childOf
```

명시된 사실:

```text
민수 parentOf 지훈
```

추론:

```text
지훈 childOf 민수
```

## 4. 조부모 추론

규칙:

```text
X parentOf Y
Y parentOf Z
=> X grandparentOf Z
```

명시된 사실:

```text
민수 parentOf 지훈
지훈 parentOf 서연
```

추론:

```text
민수 grandparentOf 서연
```

## 5. 대칭성 추론

규칙:

```text
siblingOf is symmetric
```

명시된 사실:

```text
서연 siblingOf 도윤
```

추론:

```text
도윤 siblingOf 서연
```

## 6. 전이성 추론

규칙:

```text
ancestorOf is transitive
parentOf implies ancestorOf
```

명시된 사실:

```text
민수 parentOf 지훈
지훈 parentOf 서연
```

중간 추론:

```text
민수 ancestorOf 지훈
지훈 ancestorOf 서연
```

최종 추론:

```text
민수 ancestorOf 서연
```

## 7. 검토 질문

1. `parentOf`는 대칭 관계인가요? 아니라면 이유는 무엇인가요?
2. `siblingOf`는 전이 관계인가요? 예외 상황을 생각해보세요.
3. `grandparentOf`는 직접 저장하는 것이 좋을까요, 추론하는 것이 좋을까요?
4. 가족 관계 예제를 커머스의 고객-주문-상품 관계로 바꾸면 어떤 관계가 역관계가 될 수 있을까요?

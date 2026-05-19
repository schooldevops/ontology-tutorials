-- 1강 샘플: 일반적인 RDBMS 기반 커머스 스키마
-- 목적: 테이블 중심 모델이 데이터를 어떻게 저장하는지 확인한다.

CREATE TABLE users (
    user_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    joined_at DATE NOT NULL
);

CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    product_type VARCHAR(50) NOT NULL,
    price DECIMAL(12, 2) NOT NULL
);

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    user_id VARCHAR(20) NOT NULL,
    ordered_at TIMESTAMP NOT NULL,
    status VARCHAR(30) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE order_items (
    order_item_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    quantity INTEGER NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE marketing_events (
    event_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    channel VARCHAR(50) NOT NULL,
    started_at DATE NOT NULL,
    ended_at DATE NOT NULL
);

CREATE TABLE event_participants (
    event_id VARCHAR(20) NOT NULL,
    user_id VARCHAR(20) NOT NULL,
    participated_at TIMESTAMP NOT NULL,
    PRIMARY KEY (event_id, user_id),
    FOREIGN KEY (event_id) REFERENCES marketing_events(event_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 샘플 데이터
INSERT INTO users VALUES
('U001', '김민준', 'minjun@example.com', '2026-01-10'),
('U002', '이서연', 'seoyeon@example.com', '2026-02-15');

INSERT INTO products VALUES
('P001', '프리미엄 구독 플랜', 'SUBSCRIPTION_PLAN', 29000.00),
('P002', '무선 키보드', 'PHYSICAL_GOODS', 59000.00);

INSERT INTO orders VALUES
('O1001', 'U001', '2026-05-01 10:30:00', 'PAID'),
('O1002', 'U002', '2026-05-03 14:10:00', 'PAID');

INSERT INTO order_items VALUES
('OI001', 'O1001', 'P001', 1),
('OI002', 'O1002', 'P002', 1);

INSERT INTO marketing_events VALUES
('E001', '5월 구독 전환 캠페인', 'EMAIL', '2026-05-01', '2026-05-31');

INSERT INTO event_participants VALUES
('E001', 'U001', '2026-05-01 09:00:00');

-- 생각해볼 질문:
-- 1. P001이 단순 상품이 아니라 구독 플랜이라는 의미는 어디에 표현되어 있는가?
-- 2. U001이 이벤트 참여 후 구독 상품을 구매했다는 업무 의미는 쿼리 밖에서 어떻게 재사용할 수 있는가?
-- 3. users, customers, members 같은 용어가 여러 시스템에 흩어져 있다면 어떻게 통합할 것인가?

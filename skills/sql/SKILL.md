---
name: sql
description: SQL 쿼리 작성 모범 사례. SQL 쿼리 작성, 데이터베이스 스키마 설계, MySQL/PostgreSQL 작업 시 적용.
---

# SQL 규칙

SQL 쿼리 작성 시 적용되는 모범 사례입니다. 주로 MySQL/PostgreSQL 기준입니다.

---

## 📋 기본 원칙

### 1. 명명 규칙

```sql
-- 테이블: 복수형, snake_case
CREATE TABLE users (...);
CREATE TABLE order_items (...);

-- 컬럼: snake_case
user_id, created_at, first_name

-- Primary Key: id 또는 테이블명_id
id, user_id

-- Foreign Key: 참조테이블_id
user_id, product_id

-- 인덱스: idx_테이블_컬럼
idx_users_email
idx_orders_created_at

-- Boolean: is_, has_, can_ 접두사
is_active, has_permission, can_edit
```

### 2. 포맷팅

```sql
-- ✅ 좋음: 키워드 대문자, 들여쓰기
SELECT 
    u.id,
    u.name,
    u.email,
    COUNT(o.id) AS order_count
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
WHERE u.is_active = TRUE
    AND u.created_at >= '2024-01-01'
GROUP BY u.id, u.name, u.email
HAVING COUNT(o.id) > 0
ORDER BY order_count DESC
LIMIT 10;

-- ❌ 나쁨: 한 줄로, 소문자
select u.id, u.name, u.email, count(o.id) as order_count from users u left join orders o on o.user_id = u.id where u.is_active = true group by u.id order by order_count desc limit 10;
```

---

## 📋 SELECT 쿼리

### JOIN 종류

```sql
-- INNER JOIN: 양쪽 모두 있는 경우만
SELECT u.name, o.total
FROM users u
INNER JOIN orders o ON o.user_id = u.id;

-- LEFT JOIN: 왼쪽 기준, 오른쪽 없으면 NULL
SELECT u.name, o.total
FROM users u
LEFT JOIN orders o ON o.user_id = u.id;

-- 여러 테이블 JOIN
SELECT 
    o.id AS order_id,
    u.name AS user_name,
    p.name AS product_name,
    oi.quantity,
    oi.price
FROM orders o
INNER JOIN users u ON u.id = o.user_id
INNER JOIN order_items oi ON oi.order_id = o.id
INNER JOIN products p ON p.id = oi.product_id
WHERE o.created_at >= '2024-01-01';
```

### 집계 함수

```sql
-- 기본 집계
SELECT 
    COUNT(*) AS total_count,
    COUNT(DISTINCT user_id) AS unique_users,
    SUM(amount) AS total_amount,
    AVG(amount) AS avg_amount,
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount
FROM orders
WHERE created_at >= '2024-01-01';

-- GROUP BY
SELECT 
    DATE(created_at) AS date,
    COUNT(*) AS order_count,
    SUM(total) AS daily_total
FROM orders
GROUP BY DATE(created_at)
ORDER BY date DESC;

-- HAVING (GROUP BY 결과 필터링)
SELECT 
    user_id,
    COUNT(*) AS order_count
FROM orders
GROUP BY user_id
HAVING COUNT(*) >= 5;
```

### 서브쿼리

```sql
-- WHERE 서브쿼리
SELECT * FROM users
WHERE id IN (
    SELECT DISTINCT user_id 
    FROM orders 
    WHERE total > 1000
);

-- FROM 서브쿼리 (Derived Table)
SELECT avg_total
FROM (
    SELECT user_id, AVG(total) AS avg_total
    FROM orders
    GROUP BY user_id
) AS user_avg
WHERE avg_total > 500;

-- 스칼라 서브쿼리
SELECT 
    u.name,
    (SELECT COUNT(*) FROM orders o WHERE o.user_id = u.id) AS order_count
FROM users u;
```

### CTE (Common Table Expression)

```sql
-- 가독성 향상
WITH active_users AS (
    SELECT id, name
    FROM users
    WHERE is_active = TRUE
),
user_orders AS (
    SELECT 
        user_id,
        COUNT(*) AS order_count,
        SUM(total) AS total_spent
    FROM orders
    GROUP BY user_id
)
SELECT 
    au.name,
    COALESCE(uo.order_count, 0) AS orders,
    COALESCE(uo.total_spent, 0) AS spent
FROM active_users au
LEFT JOIN user_orders uo ON uo.user_id = au.id
ORDER BY spent DESC;
```

---

## 📋 INSERT / UPDATE / DELETE

### INSERT

```sql
-- 단일 행
INSERT INTO users (name, email, created_at)
VALUES ('John', 'john@example.com', NOW());

-- 여러 행
INSERT INTO users (name, email) VALUES
    ('Alice', 'alice@example.com'),
    ('Bob', 'bob@example.com'),
    ('Charlie', 'charlie@example.com');

-- SELECT 결과 삽입
INSERT INTO user_backups (user_id, name, email)
SELECT id, name, email
FROM users
WHERE is_active = FALSE;

-- UPSERT (있으면 UPDATE, 없으면 INSERT)
-- MySQL
INSERT INTO users (id, name, email)
VALUES (1, 'John', 'john@example.com')
ON DUPLICATE KEY UPDATE 
    name = VALUES(name),
    email = VALUES(email);

-- PostgreSQL
INSERT INTO users (id, name, email)
VALUES (1, 'John', 'john@example.com')
ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    email = EXCLUDED.email;
```

### UPDATE

```sql
-- 조건부 UPDATE
UPDATE users
SET 
    is_active = FALSE,
    updated_at = NOW()
WHERE last_login_at < '2023-01-01';

-- JOIN UPDATE (MySQL)
UPDATE orders o
INNER JOIN users u ON u.id = o.user_id
SET o.user_name = u.name
WHERE o.user_name IS NULL;
```

### DELETE

```sql
-- 조건부 DELETE
DELETE FROM users
WHERE is_active = FALSE
    AND created_at < '2020-01-01';

-- ⚠️ 항상 WHERE 절 확인!
-- 실수 방지: 먼저 SELECT로 확인
SELECT * FROM users WHERE ...;  -- 확인 후
DELETE FROM users WHERE ...;    -- 삭제
```

---

## 📋 인덱스

```sql
-- 단일 컬럼 인덱스
CREATE INDEX idx_users_email ON users(email);

-- 복합 인덱스 (왼쪽부터 사용됨)
CREATE INDEX idx_orders_user_date ON orders(user_id, created_at);

-- 유니크 인덱스
CREATE UNIQUE INDEX idx_users_email_unique ON users(email);

-- 인덱스 확인
SHOW INDEX FROM users;           -- MySQL
\d users                         -- PostgreSQL

-- 쿼리 실행 계획 확인
EXPLAIN SELECT * FROM users WHERE email = 'test@example.com';
EXPLAIN ANALYZE SELECT ...;      -- PostgreSQL (실제 실행)
```

---

## 📋 트랜잭션

```sql
-- 명시적 트랜잭션
BEGIN;  -- 또는 START TRANSACTION

UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

-- 성공 시
COMMIT;

-- 실패 시
ROLLBACK;
```

---

## 📋 성능 팁

```sql
-- ✅ 필요한 컬럼만 SELECT
SELECT id, name, email FROM users;

-- ❌ 모든 컬럼 (느림)
SELECT * FROM users;

-- ✅ LIMIT 사용
SELECT * FROM orders ORDER BY created_at DESC LIMIT 100;

-- ✅ 인덱스 활용 (WHERE, ORDER BY, JOIN)
SELECT * FROM users WHERE email = 'test@example.com';  -- idx_users_email

-- ❌ 함수로 감싸면 인덱스 미사용
SELECT * FROM users WHERE LOWER(email) = 'test@example.com';

-- ✅ BETWEEN 사용
SELECT * FROM orders WHERE created_at BETWEEN '2024-01-01' AND '2024-12-31';

-- ❌ OR 대신 IN 사용
SELECT * FROM users WHERE status IN ('active', 'pending', 'verified');
```

---

## 🚫 금지 사항

1. **SELECT * 남용 금지** (필요한 컬럼만)
2. **WHERE 없이 UPDATE/DELETE 금지** (전체 변경 위험)
3. **N+1 쿼리 금지** (JOIN 또는 IN 사용)
4. **인덱스 없는 대용량 테이블 조회 금지**
5. **문자열 직접 삽입 금지** (SQL Injection 위험 - Prepared Statement 사용)
6. **프로덕션에서 EXPLAIN 없이 느린 쿼리 실행 금지**

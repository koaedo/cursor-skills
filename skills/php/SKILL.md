---
name: php
description: PHP 파일 작성 모범 사례. PHP 코드 작성, PSR-12 스타일, Laravel/Symfony 패턴 사용 시 적용.
---

# PHP 규칙

PHP 파일 작성 시 적용되는 모범 사례입니다. `.php` 파일에서 사용하세요.

---

## 📋 기본 원칙

### 1. PSR-12 코딩 스타일

```php
<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\User;
use App\Repositories\UserRepository;

class UserService
{
    private UserRepository $repository;

    public function __construct(UserRepository $repository)
    {
        $this->repository = $repository;
    }

    public function findById(int $id): ?User
    {
        return $this->repository->find($id);
    }
}
```

### 2. Type Declarations (PHP 7.4+)

```php
<?php

declare(strict_types=1);

// 매개변수 & 반환 타입
function calculateTotal(array $items, float $discount = 0.0): float
{
    $total = array_sum(array_column($items, 'price'));
    return $total * (1 - $discount);
}

// 프로퍼티 타입 (PHP 7.4+)
class Product
{
    public int $id;
    public string $name;
    public float $price;
    public ?string $description = null;  // Nullable
}
```

---

## 📋 클래스

### 1. Constructor Property Promotion (PHP 8.0+)

```php
<?php

// ✅ 좋음: PHP 8.0+ 생성자 프로퍼티 프로모션
class User
{
    public function __construct(
        private int $id,
        private string $name,
        private string $email,
        private ?DateTime $createdAt = null
    ) {
        $this->createdAt ??= new DateTime();
    }
}

// ❌ 나쁨: 전통적인 방식 (반복적)
class User
{
    private int $id;
    private string $name;
    
    public function __construct(int $id, string $name)
    {
        $this->id = $id;
        $this->name = $name;
    }
}
```

### 2. Interface & Trait

```php
<?php

interface PaymentGateway
{
    public function charge(float $amount): PaymentResult;
    public function refund(string $transactionId): bool;
}

trait Timestampable
{
    private ?DateTime $createdAt = null;
    private ?DateTime $updatedAt = null;

    public function setCreatedAt(): void
    {
        $this->createdAt = new DateTime();
    }

    public function setUpdatedAt(): void
    {
        $this->updatedAt = new DateTime();
    }
}

class Order
{
    use Timestampable;
    
    // ...
}
```

---

## 📋 배열 처리

### 1. 배열 함수 활용

```php
<?php

$users = [
    ['id' => 1, 'name' => 'Alice', 'active' => true],
    ['id' => 2, 'name' => 'Bob', 'active' => false],
    ['id' => 3, 'name' => 'Charlie', 'active' => true],
];

// 필터링
$activeUsers = array_filter($users, fn($u) => $u['active']);

// 매핑
$names = array_map(fn($u) => $u['name'], $users);

// 컬럼 추출
$ids = array_column($users, 'id');

// 키-값 매핑
$userMap = array_column($users, null, 'id');  // id를 키로

// 리듀스
$total = array_reduce($items, fn($sum, $item) => $sum + $item['price'], 0);
```

### 2. Spread Operator (PHP 7.4+)

```php
<?php

// 배열 병합
$merged = [...$array1, ...$array2];

// 함수 인자 전개
function sum(int ...$numbers): int
{
    return array_sum($numbers);
}

$nums = [1, 2, 3, 4, 5];
echo sum(...$nums);  // 15
```

---

## 📋 예외 처리

```php
<?php

// 구체적인 예외 처리
try {
    $user = $this->userService->findById($id);
    
    if ($user === null) {
        throw new UserNotFoundException($id);
    }
    
    return $user;
} catch (DatabaseException $e) {
    $this->logger->error('Database error: ' . $e->getMessage());
    throw $e;
} catch (UserNotFoundException $e) {
    $this->logger->warning("User not found: {$e->getUserId()}");
    return null;
}

// 커스텀 예외
class UserNotFoundException extends Exception
{
    public function __construct(
        private int $userId,
        string $message = "User not found"
    ) {
        parent::__construct("{$message}: ID {$userId}");
    }

    public function getUserId(): int
    {
        return $this->userId;
    }
}
```

---

## 📋 데이터베이스 (PDO)

### 1. Prepared Statements (SQL Injection 방지)

```php
<?php

// ✅ 좋음: Prepared Statement
$stmt = $pdo->prepare('SELECT * FROM users WHERE email = :email');
$stmt->execute(['email' => $email]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

// ✅ 좋음: 여러 파라미터
$stmt = $pdo->prepare('
    INSERT INTO users (name, email, created_at) 
    VALUES (:name, :email, :created_at)
');
$stmt->execute([
    'name' => $name,
    'email' => $email,
    'created_at' => date('Y-m-d H:i:s'),
]);

// ❌ 나쁨: 직접 문자열 삽입 (SQL Injection 취약)
$result = $pdo->query("SELECT * FROM users WHERE email = '$email'");
```

### 2. Transaction

```php
<?php

try {
    $pdo->beginTransaction();
    
    $stmt = $pdo->prepare('UPDATE accounts SET balance = balance - :amount WHERE id = :from');
    $stmt->execute(['amount' => $amount, 'from' => $fromId]);
    
    $stmt = $pdo->prepare('UPDATE accounts SET balance = balance + :amount WHERE id = :to');
    $stmt->execute(['amount' => $amount, 'to' => $toId]);
    
    $pdo->commit();
} catch (Exception $e) {
    $pdo->rollBack();
    throw $e;
}
```

---

## 📋 보안

### 1. 출력 이스케이프 (XSS 방지)

```php
<?php

// HTML 출력 시
echo htmlspecialchars($userInput, ENT_QUOTES, 'UTF-8');

// 헬퍼 함수
function e(string $value): string
{
    return htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
}

// 사용
<h1><?= e($user->name) ?></h1>
```

### 2. 비밀번호 해싱

```php
<?php

// ✅ 좋음: password_hash 사용
$hash = password_hash($password, PASSWORD_DEFAULT);

// 검증
if (password_verify($inputPassword, $storedHash)) {
    // 로그인 성공
}

// ❌ 나쁨: md5/sha1 사용 (보안 취약)
$hash = md5($password);
```

### 3. CSRF 방지

```php
<?php

// 토큰 생성
$_SESSION['csrf_token'] = bin2hex(random_bytes(32));

// 폼에 삽입
<input type="hidden" name="csrf_token" value="<?= $_SESSION['csrf_token'] ?>">

// 검증
if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
    throw new SecurityException('Invalid CSRF token');
}
```

---

## 📋 Null 처리 (PHP 8.0+)

```php
<?php

// Nullsafe operator
$country = $user?->address?->country;

// Null coalescing
$name = $user['name'] ?? 'Guest';
$config = $options['timeout'] ?? 30;

// Null coalescing assignment
$data['count'] ??= 0;  // 없으면 0으로 초기화

// Match expression (PHP 8.0+)
$result = match($status) {
    'pending' => 'Waiting',
    'approved' => 'Accepted',
    'rejected' => 'Denied',
    default => 'Unknown',
};
```

---

## 📋 Named Arguments (PHP 8.0+)

```php
<?php

// 가독성 향상
$user = new User(
    name: 'John',
    email: 'john@example.com',
    role: 'admin',
    active: true
);

// 선택적 매개변수 건너뛰기
function createUser(
    string $name,
    string $email,
    string $role = 'user',
    bool $active = true,
    ?DateTime $createdAt = null
): User {
    // ...
}

$user = createUser(
    name: 'John',
    email: 'john@example.com',
    active: false  // role은 기본값 사용
);
```

---

## 🚫 금지 사항

1. **`mysql_*` 함수 사용 금지** (PDO 또는 MySQLi 사용)
2. **SQL 직접 삽입 금지** (Prepared Statement 사용)
3. **`eval()` 사용 금지** (보안 위험)
4. **`md5()`/`sha1()` 비밀번호 해싱 금지** (`password_hash()` 사용)
5. **`extract()` 사용 금지** (변수 오염 위험)
6. **`@` 에러 억제 연산자 남용 금지** (적절한 예외 처리)
7. **짧은 태그 `<?` 사용 금지** (`<?php` 사용)
8. **HTML에 직접 PHP 변수 출력 금지** (`htmlspecialchars()` 사용)

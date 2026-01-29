# Python 규칙

Python 파일 작성 시 적용되는 모범 사례입니다. `.py` 파일에서 사용하세요.

---

## 📋 기본 원칙

### 1. PEP 8 스타일 가이드

```python
# ✅ 좋음: snake_case
user_name = "John"
def get_user_by_id(user_id: int) -> User:
    pass

# ✅ 좋음: PascalCase (클래스)
class UserService:
    pass

# ✅ 좋음: UPPER_CASE (상수)
MAX_RETRIES = 3
API_BASE_URL = "https://api.example.com"
```

### 2. Type Hints 사용

```python
from typing import List, Dict, Optional, Union

def get_user(user_id: int) -> Optional[User]:
    """사용자 조회"""
    return users.get(user_id)

def process_items(items: List[str]) -> Dict[str, int]:
    """아이템 처리"""
    return {item: len(item) for item in items}
```

---

## 📋 함수

### 1. Docstring 작성

```python
def calculate_total(items: List[Item], discount: float = 0.0) -> float:
    """
    총 금액을 계산합니다.
    
    Args:
        items: 계산할 아이템 목록
        discount: 할인율 (0.0 ~ 1.0)
    
    Returns:
        할인이 적용된 총 금액
    
    Raises:
        ValueError: 할인율이 유효 범위를 벗어난 경우
    """
    if not 0 <= discount <= 1:
        raise ValueError("Discount must be between 0 and 1")
    
    total = sum(item.price for item in items)
    return total * (1 - discount)
```

### 2. 기본 인자 주의

```python
# ❌ 나쁨: 가변 객체를 기본값으로
def add_item(item, items=[]):  # 버그 발생!
    items.append(item)
    return items

# ✅ 좋음: None 사용
def add_item(item, items=None):
    if items is None:
        items = []
    items.append(item)
    return items
```

---

## 📋 클래스

### 1. dataclass 활용

```python
from dataclasses import dataclass
from datetime import datetime

@dataclass
class User:
    id: int
    name: str
    email: str
    created_at: datetime = datetime.now()
    
    def __post_init__(self):
        if not self.email:
            raise ValueError("Email is required")
```

### 2. Property 사용

```python
class Circle:
    def __init__(self, radius: float):
        self._radius = radius
    
    @property
    def radius(self) -> float:
        return self._radius
    
    @radius.setter
    def radius(self, value: float):
        if value <= 0:
            raise ValueError("Radius must be positive")
        self._radius = value
    
    @property
    def area(self) -> float:
        return 3.14159 * self._radius ** 2
```

---

## 📋 예외 처리

```python
# 구체적인 예외 처리
try:
    result = fetch_data(url)
except ConnectionError as e:
    logger.error(f"Connection failed: {e}")
    raise
except ValueError as e:
    logger.warning(f"Invalid data: {e}")
    return default_value

# 커스텀 예외
class UserNotFoundError(Exception):
    """사용자를 찾을 수 없을 때 발생"""
    def __init__(self, user_id: int):
        self.user_id = user_id
        super().__init__(f"User {user_id} not found")
```

---

## 📋 Context Manager

```python
# with 문 사용
with open('data.txt', 'r') as f:
    content = f.read()

# 커스텀 context manager
from contextlib import contextmanager

@contextmanager
def timer(name: str):
    start = time.time()
    try:
        yield
    finally:
        elapsed = time.time() - start
        print(f"{name} took {elapsed:.2f}s")

# 사용
with timer("Data processing"):
    process_data()
```

---

## 📋 Comprehension

```python
# List comprehension
squares = [x**2 for x in range(10)]
even_squares = [x**2 for x in range(10) if x % 2 == 0]

# Dict comprehension
user_map = {user.id: user for user in users}

# Generator expression (메모리 효율)
sum_squares = sum(x**2 for x in range(1000000))
```

---

## 🚫 금지 사항

1. **`except:` (bare except) 금지** (구체적 예외 지정)
2. **가변 객체 기본 인자 금지** (None 사용)
3. **`from module import *` 금지** (명시적 import)
4. **전역 변수 남용 금지** (함수 인자로 전달)
5. **`type()` 비교 금지** (`isinstance()` 사용)

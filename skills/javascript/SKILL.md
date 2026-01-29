# JavaScript 규칙

JavaScript 파일 작성 시 적용되는 모범 사례입니다. `.js`, `.mjs`, `.cjs` 파일에서 사용하세요.

---

## 📋 기본 원칙

### 1. ES6+ 문법 사용

```javascript
// ✅ 좋음: ES6+
const name = 'John';
const greet = (name) => `Hello, ${name}!`;
const { id, name } = user;
const merged = { ...obj1, ...obj2 };

// ❌ 나쁨: ES5
var name = 'John';
function greet(name) { return 'Hello, ' + name + '!'; }
```

### 2. const 우선, let 필요시만

```javascript
// ✅ 좋음
const PI = 3.14159;
const users = []; // 배열 자체는 불변, 내용은 변경 가능
let count = 0;    // 재할당 필요한 경우만

// ❌ 나쁨
var x = 1;        // var 사용 금지
let constant = 5; // 재할당 안 하면 const 사용
```

---

## 📋 함수

### 1. 화살표 함수 vs 일반 함수

```javascript
// 화살표 함수: 콜백, 짧은 함수
const double = (x) => x * 2;
array.map((item) => item.id);

// 일반 함수: this 바인딩 필요, 생성자
function Person(name) {
  this.name = name;
}
```

### 2. 기본 매개변수 & Rest/Spread

```javascript
// 기본 매개변수
function greet(name = 'Guest', greeting = 'Hello') {
  return `${greeting}, ${name}!`;
}

// Rest: 나머지 매개변수
function sum(...numbers) {
  return numbers.reduce((a, b) => a + b, 0);
}

// Spread: 배열/객체 펼치기
const merged = [...arr1, ...arr2];
const updated = { ...user, name: 'New Name' };
```

---

## 📋 비동기 처리

### async/await 우선

```javascript
// ✅ 좋음: async/await
async function fetchUser(id) {
  try {
    const response = await fetch(`/api/users/${id}`);
    return await response.json();
  } catch (error) {
    console.error('Failed to fetch user:', error);
    throw error;
  }
}

// 병렬 처리
const [users, posts] = await Promise.all([
  fetchUsers(),
  fetchPosts()
]);
```

---

## 📋 배열 메서드

```javascript
// 함수형 메서드 선호
const activeUsers = users.filter((u) => u.active);
const names = users.map((u) => u.name);
const total = numbers.reduce((sum, n) => sum + n, 0);

// 존재 여부
const hasAdmin = users.some((u) => u.role === 'admin');
const allActive = users.every((u) => u.active);

// 찾기
const admin = users.find((u) => u.role === 'admin');
```

---

## 📋 모듈

```javascript
// ✅ 좋음: ES Modules
import { fetchUser } from './api.js';
export const API_URL = '/api';
export default function App() { ... }

// Named Export 선호 (트리쉐이킹 가능)
export const fetchUser = () => { ... };
export const fetchPosts = () => { ... };
```

---

## 🚫 금지 사항

1. **`var` 사용 금지** (const/let 사용)
2. **`==` 사용 금지** (`===` 사용)
3. **`eval()` 사용 금지** (보안 위험)
4. **`with` 문 사용 금지**
5. **콜백 지옥 금지** (async/await 사용)

# TypeScript 규칙

TypeScript 파일 작성 시 적용되는 모범 사례입니다. `.ts` 파일에서 사용하세요.

---

## 📋 타입 정의

### 1. Interface vs Type

```typescript
// Interface: 객체 형태, 확장 가능
interface User {
  id: number;
  name: string;
  email?: string; // 선택적
}

interface Admin extends User {
  role: 'admin';
  permissions: string[];
}

// Type: 유니온, 복잡한 타입
type Status = 'pending' | 'active' | 'inactive';
type ID = number | string;
type Callback<T> = (data: T) => void;
```

### 2. any 금지, unknown 사용

```typescript
// ❌ 나쁨: any
function process(data: any) {
  return data.value; // 타입 검사 무시
}

// ✅ 좋음: unknown + 타입 가드
function process(data: unknown) {
  if (typeof data === 'object' && data !== null && 'value' in data) {
    return (data as { value: string }).value;
  }
  throw new Error('Invalid data');
}
```

---

## 📋 함수 타입

### 1. 명시적 반환 타입

```typescript
// ✅ 좋음: 반환 타입 명시
function getUser(id: number): User | null {
  return users.find(u => u.id === id) ?? null;
}

async function fetchUsers(): Promise<User[]> {
  const response = await fetch('/api/users');
  return response.json();
}
```

### 2. 제네릭 활용

```typescript
// 제네릭 함수
function first<T>(arr: T[]): T | undefined {
  return arr[0];
}

// 제네릭 인터페이스
interface ApiResponse<T> {
  data: T;
  status: number;
  message: string;
}
```

---

## 📋 타입 가드

```typescript
// typeof 가드
function process(value: string | number) {
  if (typeof value === 'string') {
    return value.toUpperCase();
  }
  return value * 2;
}

// in 가드
function isAdmin(user: User | Admin): user is Admin {
  return 'role' in user && user.role === 'admin';
}

// 커스텀 타입 가드
function isNotNull<T>(value: T | null): value is T {
  return value !== null;
}
```

---

## 📋 유틸리티 타입

```typescript
// Partial: 모든 속성 선택적
type PartialUser = Partial<User>;

// Required: 모든 속성 필수
type RequiredUser = Required<User>;

// Pick: 특정 속성만
type UserPreview = Pick<User, 'id' | 'name'>;

// Omit: 특정 속성 제외
type UserWithoutId = Omit<User, 'id'>;

// Record: 키-값 매핑
type UserMap = Record<string, User>;
```

---

## 📋 Strict 모드 설정

```json
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true
  }
}
```

---

## 🚫 금지 사항

1. **`any` 타입 사용 금지** (unknown 또는 제네릭 사용)
2. **타입 단언 남용 금지** (타입 가드 사용)
3. **`// @ts-ignore` 금지** (문제 해결)
4. **암시적 any 금지** (strict 모드)
5. **빈 인터페이스 금지** (최소 하나의 속성)

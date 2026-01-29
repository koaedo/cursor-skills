---
name: tdd-workflow
description: 테스트 주도 개발(TDD) 워크플로우. TDD 개발, 테스트 먼저 작성, Red-Green-Refactor 사이클 요청 시 사용.
---

# TDD Workflow Skill

테스트 주도 개발(Test-Driven Development) 워크플로우입니다. "TDD로 개발해줘", "테스트 먼저 작성해줘" 등의 요청 시 사용하세요.

---

## 🔄 TDD 사이클 (Red-Green-Refactor)

```
🔴 RED      → 실패하는 테스트 작성
    ↓
🟢 GREEN   → 테스트 통과하는 최소 코드
    ↓
🔵 REFACTOR → 코드 개선 (테스트 유지)
    ↓
   반복
```

---

## 📋 Step 1: RED (실패하는 테스트)

```typescript
// 1. 테스트 먼저 작성
describe('validateEmail', () => {
  it('should return true for valid email', () => {
    expect(validateEmail('user@example.com')).toBe(true);
  });

  it('should return false for invalid email', () => {
    expect(validateEmail('invalid-email')).toBe(false);
  });
});

// 2. 테스트 실행 → 실패 확인
// Error: validateEmail is not defined
```

---

## 📋 Step 2: GREEN (최소 구현)

```typescript
// 3. 최소 구현
function validateEmail(email: string): boolean {
  if (!email) return false;
  return email.includes('@') && email.includes('.');
}

// 4. 테스트 실행 → 통과 확인
```

---

## 📋 Step 3: REFACTOR (개선)

```typescript
// 5. 리팩토링 (더 정확한 검증)
function validateEmail(email: string): boolean {
  if (!email) return false;
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

// 6. 테스트 재실행 → 여전히 통과 확인
```

---

## 📋 테스트 구조 (AAA)

```typescript
it('should add two numbers', () => {
  // Arrange (준비)
  const calculator = new Calculator();
  const a = 5, b = 3;

  // Act (실행)
  const result = calculator.add(a, b);

  // Assert (검증)
  expect(result).toBe(8);
});
```

---

## 📋 테스트 명명 규칙

```typescript
// ✅ 좋음: 행동 기반
it('should return user when ID exists')
it('should throw error when ID is invalid')

// ❌ 나쁨: 구현 기반
it('test getUserById')
it('works correctly')
```

---

## 📋 테스트 유형

| 유형 | 범위 | 속도 | 예시 |
|------|------|------|------|
| Unit | 단일 함수/클래스 | 빠름 | `validateEmail()` |
| Integration | 여러 모듈 | 보통 | UserService + DB |
| E2E | 전체 플로우 | 느림 | 로그인 → 대시보드 |

---

## 📋 TDD 체크리스트

**시작 전:**
- [ ] 요구사항이 명확한가?
- [ ] 테스트 케이스를 나열했는가?

**RED:**
- [ ] 테스트가 실패하는가?
- [ ] 하나의 기능만 테스트하는가?

**GREEN:**
- [ ] 테스트가 통과하는가?
- [ ] 최소한의 코드인가?

**REFACTOR:**
- [ ] 테스트가 여전히 통과하는가?
- [ ] 중복이 제거되었는가?

---

## 🚫 TDD 안티패턴

1. **테스트 없이 구현 먼저** - TDD 핵심 위반
2. **너무 큰 단위 테스트** - 작게 나누기
3. **구현 세부사항 테스트** - 행동 테스트
4. **깨진 테스트 방치** - 즉시 수정
5. **테스트 간 의존성** - 독립적 유지

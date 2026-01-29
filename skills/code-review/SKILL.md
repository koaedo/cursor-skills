# Code Review Skill

코드 리뷰 워크플로우입니다. "코드 리뷰해줘", "코드 검토해줘" 등의 요청 시 사용하세요.

---

## 📋 리뷰 체크리스트

### 1. 가독성 (Readability)

```typescript
// ❌ 나쁨: 불명확한 변수명
const d = new Date();
const t = d.getTime();
const r = users.filter(u => u.a && u.s === 1);

// ✅ 좋음: 명확한 변수명
const currentDate = new Date();
const timestamp = currentDate.getTime();
const activeVerifiedUsers = users.filter(
  user => user.isActive && user.status === UserStatus.VERIFIED
);
```

### 2. 함수 크기 및 복잡도

```typescript
// ❌ 나쁨: 너무 긴 함수
function processOrder(order) {
  // 100줄의 코드...
}

// ✅ 좋음: 작은 함수로 분리
function processOrder(order) {
  validateOrder(order);
  const total = calculateTotal(order.items);
  const payment = processPayment(order.paymentInfo, total);
  return createOrderRecord(order, payment);
}
```

### 3. 에러 처리

```typescript
// ❌ 나쁨: 에러 무시
try {
  await saveUser(user);
} catch (e) {
  console.log(e);
}

// ✅ 좋음: 적절한 에러 처리
try {
  await saveUser(user);
} catch (error) {
  logger.error('Failed to save user', { userId: user.id, error });
  throw new UserSaveError(user.id, error);
}
```

---

## 📋 리뷰 포인트

### 1. 성능

- [ ] 불필요한 반복문이 있는가?
- [ ] N+1 쿼리 문제가 있는가?
- [ ] 메모이제이션이 필요한 부분이 있는가?
- [ ] 불필요한 리렌더링이 발생하는가?

### 2. 보안

- [ ] 입력 검증이 되어 있는가?
- [ ] SQL 인젝션 가능성이 있는가?
- [ ] XSS 취약점이 있는가?
- [ ] 민감 정보가 노출되는가?

### 3. 테스트

- [ ] 테스트가 작성되었는가?
- [ ] 엣지 케이스가 커버되는가?
- [ ] 테스트가 독립적인가?

---

## 📋 코드 리뷰 코멘트 템플릿

### 필수 수정 (Blocker)

```
🚫 [Blocker] SQL 인젝션 취약점이 있습니다.
현재: db.query(`SELECT * FROM users WHERE id = ${id}`)
제안: db.query('SELECT * FROM users WHERE id = ?', [id])
```

### 권장 수정 (Suggestion)

```
💡 [Suggestion] 이 로직을 별도 함수로 분리하면 재사용성이 높아집니다.
```

### 질문 (Question)

```
❓ [Question] 이 로직의 의도가 무엇인가요? 
주석이나 변수명으로 명확히 해주시면 좋겠습니다.
```

### 칭찬 (Praise)

```
👍 [Praise] 에러 처리가 잘 되어 있네요!
```

---

## 📋 리뷰 우선순위

| 우선순위 | 카테고리 | 예시 |
|----------|----------|------|
| 🔴 Critical | 버그, 보안 | SQL 인젝션, 무한 루프 |
| 🟠 Major | 성능, 설계 | N+1 쿼리, 중복 코드 |
| 🟡 Minor | 가독성 | 변수명, 포맷팅 |
| 🟢 Trivial | 스타일 | 공백, 들여쓰기 |

---

## 📋 좋은 리뷰어 되기

1. **구체적으로**: "이상하다" → "변수명이 기능을 설명하지 않습니다"
2. **대안 제시**: 문제만 지적하지 말고 해결책도 제안
3. **칭찬하기**: 좋은 코드도 언급
4. **질문하기**: 이해가 안 되면 비판 대신 질문
5. **겸손하게**: "~해야 합니다" → "~하면 어떨까요?"

---

## 🚫 리뷰 안티패턴

1. **"LGTM"만 남기기** - 실제로 검토하기
2. **스타일만 지적** - 중요한 것 먼저
3. **개인 취향 강요** - 팀 컨벤션 따르기
4. **늦은 리뷰** - 24시간 내 응답
5. **공격적 표현** - 코드를 비판, 사람은 X

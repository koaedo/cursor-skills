---
name: security-audit
description: 보안 감사 워크플로우. 보안 검토, 취약점 확인, 보안 점검, 코드 보안 감사 요청 시 사용.
---

# Security Audit Skill

보안 감사 워크플로우입니다. "보안 검토해줘", "취약점 확인해줘" 등의 요청 시 사용하세요.

---

## 📋 보안 감사 체크리스트

### 1. 입력 검증

```typescript
// ❌ 취약: 입력 검증 없음
app.get('/user/:id', (req, res) => {
  db.query(`SELECT * FROM users WHERE id = ${req.params.id}`);
});

// ✅ 안전: 파라미터화된 쿼리
app.get('/user/:id', (req, res) => {
  const id = parseInt(req.params.id, 10);
  if (isNaN(id)) return res.status(400).send('Invalid ID');
  db.query('SELECT * FROM users WHERE id = ?', [id]);
});
```

### 2. XSS 방지

```typescript
// ❌ 취약: 직접 HTML 삽입
element.innerHTML = userInput;

// ✅ 안전: 텍스트로 처리
element.textContent = userInput;

// ✅ 안전: 이스케이프 처리
element.innerHTML = escapeHtml(userInput);
```

### 3. CSRF 보호

```typescript
// 토큰 검증
app.post('/api/transfer', csrfProtection, (req, res) => {
  // CSRF 토큰 자동 검증
});
```

---

## 📋 인증/인가 검사

### 1. 비밀번호 보안

```typescript
// ❌ 나쁨: 평문 저장
user.password = password;

// ✅ 좋음: 해시 저장
import bcrypt from 'bcrypt';
user.password = await bcrypt.hash(password, 12);

// 검증
const isValid = await bcrypt.compare(inputPassword, user.password);
```

### 2. JWT 검증

```typescript
// 토큰 검증 미들웨어
function verifyToken(req, res, next) {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).send('Unauthorized');
  
  try {
    req.user = jwt.verify(token, process.env.JWT_SECRET);
    next();
  } catch (error) {
    return res.status(403).send('Invalid token');
  }
}
```

---

## 📋 데이터 보호

### 1. 민감 정보 노출 방지

```typescript
// ❌ 나쁨: 비밀번호 포함
res.json(user);

// ✅ 좋음: 민감 정보 제외
const { password, ...safeUser } = user;
res.json(safeUser);
```

### 2. 환경 변수 사용

```typescript
// ❌ 나쁨: 하드코딩
const apiKey = 'sk-1234567890';

// ✅ 좋음: 환경 변수
const apiKey = process.env.API_KEY;
```

---

## 📋 의존성 보안

```bash
# 취약점 검사
npm audit
npm audit fix

# 고위험 취약점만 수정
npm audit fix --only=prod
```

---

## 📋 보안 헤더

```typescript
import helmet from 'helmet';

app.use(helmet()); // 기본 보안 헤더

// 또는 개별 설정
app.use(helmet.contentSecurityPolicy());
app.use(helmet.xssFilter());
app.use(helmet.noSniff());
```

---

## 📋 OWASP Top 10 체크리스트

| # | 취약점 | 확인 항목 |
|---|--------|----------|
| 1 | Injection | SQL/NoSQL 인젝션 방지 |
| 2 | Broken Auth | 강력한 인증 구현 |
| 3 | Sensitive Data | 암호화 적용 |
| 4 | XXE | XML 파서 보안 |
| 5 | Broken Access | 권한 검증 |
| 6 | Security Misconfig | 기본 설정 변경 |
| 7 | XSS | 출력 이스케이프 |
| 8 | Insecure Deserialization | 역직렬화 검증 |
| 9 | Vulnerable Components | 의존성 업데이트 |
| 10 | Insufficient Logging | 로깅 구현 |

---

## 🚫 절대 금지

1. **평문 비밀번호 저장 금지**
2. **SQL 문자열 연결 금지**
3. **민감 정보 로깅 금지**
4. **시크릿 하드코딩 금지**
5. **HTTP (비암호화) 금지**

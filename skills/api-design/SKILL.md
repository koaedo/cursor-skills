---
name: api-design
description: RESTful API 설계 및 모범 사례 가이드. API 엔드포인트 설계, REST API 구현, 응답 형식 정의, 페이지네이션/필터링/정렬 구현 시 사용.
---

# API Design Skill

RESTful API 설계 및 모범 사례 가이드

## When to Use
- API 엔드포인트 설계 시
- REST API 구현 시
- API 응답 형식 정의 시
- 페이지네이션, 필터링, 정렬 구현 시

## File Patterns
- `**/api/**`
- `**/routes/**`
- `**/controllers/**`

---

## 📋 REST 원칙

### 1. 리소스 기반 URL

```
✅ 좋음: 리소스 중심
GET    /users           # 사용자 목록
GET    /users/123       # 특정 사용자
POST   /users           # 사용자 생성
PUT    /users/123       # 사용자 전체 수정
PATCH  /users/123       # 사용자 부분 수정
DELETE /users/123       # 사용자 삭제

❌ 나쁨: 동사 중심
GET    /getUsers
POST   /createUser
POST   /deleteUser/123
```

### 2. 계층적 리소스

```
✅ 좋음: 계층 표현
GET    /users/123/posts           # 사용자의 게시글
GET    /users/123/posts/456       # 특정 게시글
GET    /posts/456/comments        # 게시글의 댓글

⚠️ 주의: 너무 깊은 중첩 피하기 (3단계 이하)
GET    /users/123/posts/456/comments/789/replies  # 너무 깊음
GET    /comments/789/replies                      # 더 나음
```

### 3. HTTP 메서드

| 메서드 | 용도 | 멱등성 | 안전 |
|--------|------|--------|------|
| GET | 조회 | ✅ | ✅ |
| POST | 생성 | ❌ | ❌ |
| PUT | 전체 수정 | ✅ | ❌ |
| PATCH | 부분 수정 | ❌ | ❌ |
| DELETE | 삭제 | ✅ | ❌ |

---

## 📋 HTTP 상태 코드

### 1. 성공 (2xx)

```
200 OK              # 일반적인 성공
201 Created         # 리소스 생성 성공
204 No Content      # 성공, 응답 본문 없음 (DELETE)
```

### 2. 클라이언트 오류 (4xx)

```
400 Bad Request     # 잘못된 요청 형식
401 Unauthorized    # 인증 필요
403 Forbidden       # 권한 없음 (인증은 됨)
404 Not Found       # 리소스 없음
409 Conflict        # 충돌 (중복 등)
422 Unprocessable   # 유효성 검증 실패
429 Too Many Requests # 요청 제한 초과
```

### 3. 서버 오류 (5xx)

```
500 Internal Server Error  # 서버 오류
502 Bad Gateway            # 게이트웨이 오류
503 Service Unavailable    # 서비스 불가
504 Gateway Timeout        # 타임아웃
```

---

## 📋 요청/응답 형식

### 1. 성공 응답

```typescript
// 단일 리소스
{
  "data": {
    "id": "123",
    "name": "John Doe",
    "email": "john@example.com",
    "createdAt": "2024-01-15T10:30:00Z"
  }
}

// 목록 (페이지네이션)
{
  "data": [
    { "id": "1", "name": "User 1" },
    { "id": "2", "name": "User 2" }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5
  }
}
```

### 2. 오류 응답

```typescript
// 유효성 오류 (422)
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": [
      { "field": "email", "message": "Invalid email format" },
      { "field": "password", "message": "Password must be at least 8 characters" }
    ]
  }
}

// 일반 오류 (400, 404 등)
{
  "error": {
    "code": "USER_NOT_FOUND",
    "message": "User with ID 123 not found"
  }
}
```

---

## 📋 페이지네이션

### Offset 기반

```
GET /users?page=2&limit=20
```

### Cursor 기반 (권장 - 대용량)

```
GET /users?cursor=abc123&limit=20

응답:
{
  "data": [...],
  "pagination": {
    "nextCursor": "def456",
    "hasMore": true
  }
}
```

---

## 📋 필터링 & 정렬

```
GET /users?status=active
GET /users?role=admin&status=active
GET /users?sort=createdAt&order=desc
GET /users?sort=-createdAt  # - 는 내림차순
GET /users?fields=id,name,email
```

---

## 📋 인증 & 보안

```
Authorization: Bearer <access_token>
X-API-Key: <api_key>

X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1640000000
```

---

## 📋 체크리스트

```
URL 설계:
[ ] 리소스 기반 URL인가?
[ ] 적절한 HTTP 메서드 사용?
[ ] 계층이 3단계 이하인가?

응답:
[ ] 일관된 응답 형식?
[ ] 적절한 상태 코드?
[ ] 유용한 오류 메시지?

기능:
[ ] 페이지네이션 지원?
[ ] 필터링/정렬 지원?
[ ] Rate limiting 적용?
```

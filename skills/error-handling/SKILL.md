# Error Handling Skill

견고한 에러 처리 패턴 가이드

## When to Use
- 에러 처리 로직 구현 시
- 커스텀 에러 클래스 설계 시
- API 에러 핸들링 시
- React Error Boundary 구현 시

## File Patterns
- `**/*.ts`
- `**/*.tsx`
- `**/*.js`
- `**/*.jsx`

---

## 📋 에러 처리 원칙

```
┌─────────────────────────────────────────────────────────────┐
│                    에러 처리 계층                            │
│                                                             │
│  ┌──────────────────────────────────────────────┐           │
│  │            전역 에러 핸들러                    │  ← 마지막 방어선 │
│  └──────────────────────────────────────────────┘           │
│  ┌──────────────────────────────────────────────┐           │
│  │          에러 바운더리 (React)                │  ← UI 보호    │
│  └──────────────────────────────────────────────┘           │
│  ┌──────────────────────────────────────────────┐           │
│  │           try-catch (로컬)                   │  ← 개별 처리  │
│  └──────────────────────────────────────────────┘           │
└─────────────────────────────────────────────────────────────┘
```

---

## 📋 커스텀 에러 클래스

### 기본 에러 클래스

```typescript
// 기본 애플리케이션 에러
class AppError extends Error {
  constructor(
    message: string,
    public readonly code: string,
    public readonly statusCode: number = 500,
    public readonly isOperational: boolean = true
  ) {
    super(message);
    this.name = this.constructor.name;
    Error.captureStackTrace(this, this.constructor);
  }
}

// 구체적인 에러 타입들
class ValidationError extends AppError {
  constructor(message: string, public readonly fields?: Record<string, string>) {
    super(message, 'VALIDATION_ERROR', 400);
  }
}

class NotFoundError extends AppError {
  constructor(resource: string, id: string) {
    super(`${resource} with id ${id} not found`, 'NOT_FOUND', 404);
  }
}

class UnauthorizedError extends AppError {
  constructor(message = 'Unauthorized') {
    super(message, 'UNAUTHORIZED', 401);
  }
}
```

### 사용 예시

```typescript
async function getUser(id: string) {
  const user = await db.user.findUnique({ where: { id } });
  
  if (!user) {
    throw new NotFoundError('User', id);
  }
  
  return user;
}
```

---

## 📋 Express 에러 핸들링

### 전역 에러 핸들러

```typescript
export function errorHandler(
  error: Error,
  req: Request,
  res: Response,
  next: NextFunction
) {
  if (res.headersSent) {
    return next(error);
  }

  if (error instanceof AppError) {
    return res.status(error.statusCode).json({
      error: {
        code: error.code,
        message: error.message,
      }
    });
  }

  // 예상치 못한 에러
  console.error('Unexpected error:', error);
  
  const message = process.env.NODE_ENV === 'production'
    ? 'Internal server error'
    : error.message;

  res.status(500).json({
    error: { code: 'INTERNAL_ERROR', message }
  });
}
```

### Async 핸들러 래퍼

```typescript
export function asyncHandler(
  fn: (req: Request, res: Response, next: NextFunction) => Promise<any>
): RequestHandler {
  return (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
}

// 사용 예시
app.get('/users/:id', asyncHandler(async (req, res) => {
  const user = await getUser(req.params.id);
  res.json({ data: user });
}));
```

---

## 📋 React 에러 처리

### Error Boundary

```typescript
class ErrorBoundary extends Component<Props, State> {
  state: State = { hasError: false };

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('Error caught by boundary:', error, errorInfo);
    this.props.onError?.(error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return this.props.fallback || <DefaultErrorFallback error={this.state.error} />;
    }
    return this.props.children;
  }
}
```

### 사용

```tsx
function App() {
  return (
    <ErrorBoundary
      fallback={<FullPageError />}
      onError={(error) => sendToErrorTracking(error)}
    >
      <Header />
      <ErrorBoundary fallback={<ContentError />}>
        <MainContent />
      </ErrorBoundary>
      <Footer />
    </ErrorBoundary>
  );
}
```

---

## 📋 비동기 에러 처리

### Promise.allSettled 활용

```typescript
// 여러 작업 중 일부 실패해도 진행
async function batchProcess(items: Item[]) {
  const results = await Promise.allSettled(
    items.map(item => processItem(item))
  );

  const successes = results
    .filter((r): r is PromiseFulfilledResult<Item> => r.status === 'fulfilled')
    .map(r => r.value);

  const failures = results
    .filter((r): r is PromiseRejectedResult => r.status === 'rejected')
    .map(r => r.reason);

  return { successes, failures };
}
```

---

## 📋 에러 처리 체크리스트

```
설계:
[ ] 커스텀 에러 클래스 정의?
[ ] 에러 코드 체계?
[ ] 사용자 친화적 메시지?

구현:
[ ] 전역 에러 핸들러?
[ ] React Error Boundary?
[ ] async/await 에러 처리?

보안:
[ ] 상세 정보 프로덕션 숨김?
[ ] 스택 트레이스 노출 방지?
```

---

## 🚫 에러 처리 안티패턴

```typescript
// ❌ 에러 무시
try {
  riskyOperation();
} catch (e) {
  // 아무것도 안 함
}

// ❌ 모든 에러 동일 처리
catch (error) {
  return res.status(500).json({ error: 'Error' });
}

// ❌ 너무 넓은 catch
try {
  // 100줄의 코드
} catch (error) {
  // 어디서 발생했는지 불명확
}
```

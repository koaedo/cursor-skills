---
name: react-best-practices
description: React 성능 최적화 패턴 (Vercel 검증). React 성능 최적화, 워터폴 제거, Server Components, 번들 최적화 시 사용.
---

# React Best Practices Skill

Vercel의 10년+ React 경험에서 검증된 성능 최적화 패턴

## When to Use
- React 애플리케이션 성능 최적화 시
- 워터폴 패턴 제거 시
- 번들 사이즈 최적화 시
- Server Components 활용 시

## File Patterns
- `**/*.tsx`
- `**/*.jsx`

---

## 🔴 CRITICAL: 워터폴 제거

### 1. 순차 요청 → 병렬 요청

```tsx
// ❌ 워터폴: 순차 실행 (느림)
async function Page() {
  const user = await fetchUser(id);      // 1초
  const posts = await fetchPosts(id);    // 1초
  const comments = await fetchComments(); // 1초
  // 총 3초
}

// ✅ 병렬 실행
async function Page() {
  const [user, posts, comments] = await Promise.all([
    fetchUser(id),
    fetchPosts(id),
    fetchComments()
  ]);
  // 총 1초
}
```

### 2. Suspense로 점진적 로딩

```tsx
// ✅ 중요 컨텐츠 먼저, 나머지는 스트리밍
function Page() {
  return (
    <div>
      <Header /> {/* 즉시 렌더링 */}
      <MainContent /> {/* 즉시 렌더링 */}
      <Suspense fallback={<Skeleton />}>
        <Comments /> {/* 나중에 스트리밍 */}
      </Suspense>
    </div>
  );
}
```

---

## 🔴 CRITICAL: 번들 사이즈 최적화

### 1. 동적 임포트

```tsx
// ❌ 나쁨: 초기 번들에 모두 포함
import HeavyChart from './HeavyChart';

// ✅ 좋음: 필요할 때 로드
const HeavyChart = dynamic(() => import('./HeavyChart'), {
  loading: () => <Skeleton />,
  ssr: false
});
```

### 2. 트리 쉐이킹

```tsx
// ❌ 나쁨: 전체 라이브러리 임포트
import _ from 'lodash';

// ✅ 좋음: 필요한 것만
import debounce from 'lodash/debounce';
```

### 3. 큰 의존성 교체

```
moment.js (300KB) → date-fns (30KB)
lodash (70KB) → lodash-es + 개별 임포트
```

---

## 🟡 HIGH: 서버 사이드 성능

### Server Components 활용 (Next.js 13+)

```tsx
// ✅ 서버 컴포넌트 (기본값)
// - 클라이언트로 JS 전송 안 함
// - 직접 DB/API 접근 가능
async function ProductList() {
  const products = await db.products.findMany();
  return <ul>{products.map(p => <li key={p.id}>{p.name}</li>)}</ul>;
}

// ✅ 클라이언트 컴포넌트 (필요할 때만)
'use client';
function AddToCartButton() {
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(c => c + 1)}>Add ({count})</button>;
}
```

---

## 🟡 MEDIUM-HIGH: 클라이언트 데이터 페칭

### 캐싱 전략

```tsx
import { useQuery } from '@tanstack/react-query';

function Products() {
  const { data, isLoading } = useQuery({
    queryKey: ['products'],
    queryFn: fetchProducts,
    staleTime: 5 * 60 * 1000, // 5분간 fresh
    cacheTime: 30 * 60 * 1000, // 30분간 캐시 유지
  });
}
```

### Optimistic Updates

```tsx
const mutation = useMutation({
  mutationFn: updateTodo,
  onMutate: async (newTodo) => {
    await queryClient.cancelQueries(['todos']);
    const previous = queryClient.getQueryData(['todos']);
    queryClient.setQueryData(['todos'], (old) => [...old, newTodo]);
    return { previous };
  },
  onError: (err, newTodo, context) => {
    queryClient.setQueryData(['todos'], context.previous);
  },
});
```

---

## 🟡 MEDIUM: 리렌더링 최적화

### 1. 상태 분리

```tsx
// ❌ 나쁨: 전체 리렌더링
function App() {
  const [user, setUser] = useState(null);
  const [theme, setTheme] = useState('light');
  const [cart, setCart] = useState([]);
}

// ✅ 좋음: 상태 분리 (별도 컴포넌트/훅)
function useUser() { ... }
function useTheme() { ... }
function useCart() { ... }
```

### 2. 메모이제이션 적절히 사용

```tsx
// ✅ 비용이 큰 계산
const sortedItems = useMemo(
  () => items.sort((a, b) => a.price - b.price),
  [items]
);

// ✅ 자식에게 전달하는 콜백
const handleClick = useCallback(() => {
  doSomething(id);
}, [id]);

// ⚠️ 단순 값은 메모이제이션 불필요
const double = count * 2; // useMemo 불필요
```

### 3. Context 최적화

```tsx
// ❌ 나쁨: 큰 Context 하나
const AppContext = createContext({ user, theme, cart, ... });

// ✅ 좋음: 작은 Context 여러 개
const UserContext = createContext(null);
const ThemeContext = createContext('light');
```

---

## 🟢 MEDIUM: 렌더링 성능

### 가상화 (긴 리스트)

```tsx
import { FixedSizeList } from 'react-window';

function VirtualList({ items }) {
  return (
    <FixedSizeList
      height={400}
      itemCount={items.length}
      itemSize={50}
    >
      {({ index, style }) => (
        <div style={style}>{items[index].name}</div>
      )}
    </FixedSizeList>
  );
}
```

### 지연 로딩 이미지

```tsx
import Image from 'next/image';

<Image
  src="/hero.jpg"
  alt="Hero"
  width={1200}
  height={600}
  priority={true} // LCP 이미지
  placeholder="blur"
/>
```

---

## 📋 체크리스트

| 카테고리 | 항목 | 확인 |
|----------|------|------|
| **워터폴** | Promise.all로 병렬 실행? | ☐ |
| **번들** | 동적 임포트 사용? | ☐ |
| **번들** | 불필요한 의존성 제거? | ☐ |
| **서버** | Server Components 활용? | ☐ |
| **캐싱** | React Query/SWR 사용? | ☐ |
| **리렌더** | 불필요한 리렌더링 없음? | ☐ |
| **리스트** | 1000+ 항목 가상화? | ☐ |
| **이미지** | Next/Image 사용? | ☐ |

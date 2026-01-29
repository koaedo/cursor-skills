---
name: performance-optimization
description: 웹 애플리케이션 성능 최적화. Core Web Vitals, 번들 사이즈 최적화, 렌더링 성능 개선, 성능 튜닝 시 사용.
---

# Performance Optimization Skill

웹 애플리케이션 성능 최적화 가이드

## When to Use
- 웹 애플리케이션 성능 개선 시
- Core Web Vitals 최적화 시
- 번들 사이즈 최적화 시
- 렌더링 성능 개선 시

## File Patterns
- `**/*.ts`
- `**/*.tsx`
- `**/*.js`
- `**/*.jsx`

---

## 📋 성능 측정 지표

### Core Web Vitals

```
┌─────────────────────────────────────────────────────────────┐
│                    Core Web Vitals                          │
│                                                             │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │     LCP     │ │     INP     │ │     CLS     │           │
│  │   < 2.5s    │ │   < 200ms   │ │   < 0.1     │           │
│  │  (Good)     │ │   (Good)    │ │   (Good)    │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
│                                                             │
│  LCP: Largest Contentful Paint (로딩)                       │
│  INP: Interaction to Next Paint (상호작용)                  │
│  CLS: Cumulative Layout Shift (시각적 안정성)               │
└─────────────────────────────────────────────────────────────┘
```

### 측정 도구

```bash
npx lighthouse https://example.com --view
```

```typescript
import { onCLS, onINP, onLCP } from 'web-vitals';
onCLS(console.log);
onINP(console.log);
onLCP(console.log);
```

---

## 📋 번들 최적화

### 1. 코드 스플리팅

```typescript
// ❌ 모든 것을 한 번에 로드
import HeavyComponent from './HeavyComponent';

// ✅ 동적 임포트 (React.lazy)
import { lazy, Suspense } from 'react';

const HeavyComponent = lazy(() => import('./HeavyComponent'));

function App() {
  return (
    <Suspense fallback={<Loading />}>
      <HeavyComponent />
    </Suspense>
  );
}
```

### 2. 트리 쉐이킹

```typescript
// ❌ 전체 라이브러리 임포트
import _ from 'lodash';
_.debounce(fn, 300);

// ✅ 필요한 함수만 임포트
import debounce from 'lodash/debounce';
debounce(fn, 300);
```

### 3. 번들 분석

```bash
# Next.js
npx @next/bundle-analyzer

# Vite
npx vite-bundle-visualizer

# Webpack
npx webpack-bundle-analyzer stats.json
```

---

## 📋 이미지 최적화

### 포맷 선택

```
AVIF > WebP > PNG/JPEG
```

### 반응형 이미지

```tsx
<img
  src="/image-800.jpg"
  srcSet="
    /image-400.jpg 400w,
    /image-800.jpg 800w,
    /image-1200.jpg 1200w
  "
  sizes="(max-width: 600px) 400px, 800px"
  alt="Description"
  loading="lazy"
/>

// Next.js Image
import Image from 'next/image';
<Image
  src="/hero.jpg"
  width={1200}
  height={600}
  priority  // LCP 이미지
  placeholder="blur"
/>
```

---

## 📋 렌더링 최적화

### 1. Memoization

```tsx
// React.memo - 컴포넌트 메모이제이션
const ExpensiveList = React.memo(function ExpensiveList({ items }) {
  return (
    <ul>
      {items.map(item => <ListItem key={item.id} item={item} />)}
    </ul>
  );
});

// useMemo - 값 메모이제이션
const processedData = useMemo(() => {
  return heavyCalculation(data);
}, [data]);

// useCallback - 함수 메모이제이션
const handleClick = useCallback((id: string) => {
  // ...
}, []);
```

### 2. 가상화 (Virtualization)

```tsx
import { useVirtualizer } from '@tanstack/react-virtual';

function VirtualList({ items }) {
  const parentRef = useRef(null);

  const virtualizer = useVirtualizer({
    count: items.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 50,
  });

  return (
    <div ref={parentRef} style={{ height: '400px', overflow: 'auto' }}>
      <div style={{ height: virtualizer.getTotalSize() }}>
        {virtualizer.getVirtualItems().map((virtualRow) => (
          <div
            key={virtualRow.key}
            style={{ position: 'absolute', top: virtualRow.start }}
          >
            {items[virtualRow.index].name}
          </div>
        ))}
      </div>
    </div>
  );
}
```

### 3. Debounce & Throttle

```typescript
const debouncedSearch = useMemo(
  () => debounce((q: string) => {
    fetchResults(q);
  }, 300),
  []
);
```

---

## 📋 네트워크 최적화

### 캐싱 전략

```typescript
// React Query 캐싱
const { data } = useQuery({
  queryKey: ['users'],
  queryFn: fetchUsers,
  staleTime: 5 * 60 * 1000,     // 5분간 fresh
  gcTime: 30 * 60 * 1000,       // 30분간 캐시 유지
});
```

### 프리페칭

```typescript
// 마우스 오버 시 프리페치
<div onMouseEnter={() => {
  queryClient.prefetchQuery({
    queryKey: ['user', userId],
    queryFn: () => fetchUser(userId),
  });
}}>
  <Link href={`/users/${userId}`}>View</Link>
</div>
```

---

## 📋 CSS 최적화

### 애니메이션 최적화

```css
/* ❌ 레이아웃 트리거 (느림) */
.animated {
  left: 0;
  transition: left 0.3s;
}

/* ✅ transform 사용 (GPU 가속) */
.animated {
  transform: translateX(0);
  transition: transform 0.3s;
  will-change: transform;
}
```

---

## 📋 성능 체크리스트

```
측정:
[ ] Lighthouse 점수 확인?
[ ] Core Web Vitals 측정?
[ ] 번들 크기 분석?

번들:
[ ] 코드 스플리팅?
[ ] 트리 쉐이킹?
[ ] 불필요한 의존성 제거?

이미지:
[ ] 최적 포맷 (WebP/AVIF)?
[ ] 반응형 이미지?
[ ] Lazy loading?

렌더링:
[ ] 불필요한 리렌더링 방지?
[ ] 긴 목록 가상화?
[ ] Debounce/Throttle?
```

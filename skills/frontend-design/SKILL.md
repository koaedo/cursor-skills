# Frontend Design Skill

프론트엔드 컴포넌트 설계 및 구조화 가이드

## When to Use
- 프론트엔드 프로젝트 구조 설계 시
- 컴포넌트 아키텍처 설계 시
- 상태 관리 전략 수립 시
- 스타일링 전략 결정 시

## File Patterns
- `**/*.tsx`
- `**/*.jsx`
- `**/*.vue`
- `**/*.svelte`

---

## 📁 폴더 구조

### Feature-based 구조 (권장)

```
src/
├── features/              # 기능별 모듈
│   ├── auth/
│   │   ├── components/    # 인증 관련 컴포넌트
│   │   ├── hooks/         # 인증 관련 훅
│   │   ├── services/      # API 호출
│   │   ├── types/         # 타입 정의
│   │   └── index.ts       # public API
│   ├── products/
│   └── cart/
│
├── components/            # 공통 컴포넌트
│   ├── ui/               # 기본 UI (Button, Input)
│   └── layout/           # 레이아웃 (Header, Footer)
│
├── hooks/                # 공통 훅
├── utils/                # 유틸리티
├── styles/               # 글로벌 스타일
└── types/                # 글로벌 타입
```

### 컴포넌트 폴더 구조

```
Button/
├── Button.tsx            # 메인 컴포넌트
├── Button.test.tsx       # 테스트
├── Button.module.css     # 스타일
├── Button.stories.tsx    # Storybook (선택)
└── index.ts              # export
```

---

## 📋 컴포넌트 설계 원칙

### 1. 단일 책임 원칙 (SRP)

```tsx
// ❌ 나쁨: 여러 책임
function UserProfile({ userId }) {
  // 데이터 페칭 + 폼 처리 + 렌더링
  // 100줄+ 코드
}

// ✅ 좋음: 책임 분리
function UserProfile({ userId }) {
  return (
    <UserDataProvider userId={userId}>
      <ProfileHeader />
      <ProfileContent />
      <ProfileActions />
    </UserDataProvider>
  );
}
```

### 2. 합성 패턴 (Composition)

```tsx
// ✅ 좋음: 합성 가능한 컴포넌트
<Card>
  <Card.Header>
    <Card.Title>제목</Card.Title>
  </Card.Header>
  <Card.Body>내용</Card.Body>
  <Card.Footer>
    <Button>저장</Button>
  </Card.Footer>
</Card>

// 구현
const Card = ({ children }) => <div className="card">{children}</div>;
Card.Header = ({ children }) => <div className="card-header">{children}</div>;
Card.Body = ({ children }) => <div className="card-body">{children}</div>;
```

---

## 📋 상태 관리

### 상태 분류

```
Local State (컴포넌트 내부)
└── useState, useReducer
    예: 폼 입력, 모달 열림/닫힘

Shared State (컴포넌트 간 공유)
└── Context, Zustand, Jotai
    예: 테마, 사용자 설정

Server State (서버 데이터)
└── React Query, SWR
    예: API 응답 데이터

URL State (URL 파라미터)
└── Router params, search params
    예: 페이지네이션, 필터
```

### 상태 위치 결정

```tsx
// 1. 이 컴포넌트만 사용? → useState
const [isOpen, setIsOpen] = useState(false);

// 2. 부모/자식 공유? → Props drilling 또는 Context

// 3. 멀리 떨어진 컴포넌트 공유? → Global state
const theme = useThemeStore((state) => state.theme);

// 4. 서버 데이터? → React Query
const { data } = useQuery(['users'], fetchUsers);

// 5. URL에 반영? → URL state
const [page] = useSearchParams();
```

---

## 📋 컴포넌트 패턴

### Container/Presentational

```tsx
// Container: 로직 담당
function UserListContainer() {
  const { data: users, isLoading } = useUsers();
  const handleDelete = (id) => deleteUser(id);
  
  if (isLoading) return <Spinner />;
  return <UserList users={users} onDelete={handleDelete} />;
}

// Presentational: UI만 담당
function UserList({ users, onDelete }) {
  return (
    <ul>
      {users.map((user) => (
        <UserItem key={user.id} user={user} onDelete={onDelete} />
      ))}
    </ul>
  );
}
```

### Custom Hooks

```tsx
function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState(value);

  useEffect(() => {
    const timer = setTimeout(() => setDebouncedValue(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]);

  return debouncedValue;
}

// 사용
function Search() {
  const [query, setQuery] = useState('');
  const debouncedQuery = useDebounce(query, 300);
}
```

---

## 📋 스타일링 전략

### CSS Modules

```tsx
import styles from './Button.module.css';

function Button({ variant = 'primary', children }) {
  return (
    <button className={`${styles.button} ${styles[variant]}`}>
      {children}
    </button>
  );
}
```

### Tailwind CSS

```tsx
function Button({ variant = 'primary', children }) {
  const variants = {
    primary: 'bg-blue-500 text-white hover:bg-blue-600',
    secondary: 'bg-gray-200 text-gray-800 hover:bg-gray-300',
  };
  
  return (
    <button className={`px-4 py-2 rounded ${variants[variant]}`}>
      {children}
    </button>
  );
}
```

---

## 📋 체크리스트

```
설계:
[ ] 컴포넌트가 단일 책임을 가지는가?
[ ] 적절한 추상화 수준인가?
[ ] 재사용 가능한가?

상태:
[ ] 상태 위치가 적절한가?
[ ] 불필요한 전역 상태가 없는가?
[ ] Props drilling이 과도하지 않은가?

구조:
[ ] 폴더 구조가 일관되는가?
[ ] 공통 컴포넌트가 잘 분리되었는가?
[ ] 순환 의존성이 없는가?
```

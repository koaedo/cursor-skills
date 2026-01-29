# React 규칙

React 컴포넌트 작성 시 적용되는 모범 사례입니다. `.jsx`, `.tsx` 파일에서 사용하세요.

---

## 📋 컴포넌트 구조

### 1. 함수형 컴포넌트 사용

```tsx
// ✅ 좋음: 함수형 컴포넌트
interface UserCardProps {
  user: User;
  onSelect?: (user: User) => void;
}

export function UserCard({ user, onSelect }: UserCardProps) {
  return (
    <div className="user-card" onClick={() => onSelect?.(user)}>
      <h3>{user.name}</h3>
      <p>{user.email}</p>
    </div>
  );
}
```

### 2. 파일 구조

```
components/
├── UserCard/
│   ├── index.tsx        # 컴포넌트
│   ├── UserCard.test.tsx # 테스트
│   └── UserCard.css     # 스타일
```

---

## 📋 Hooks 사용

### 1. useState

```tsx
// 기본 사용
const [count, setCount] = useState(0);

// 객체 상태
const [user, setUser] = useState<User | null>(null);

// 함수형 업데이트
setCount(prev => prev + 1);
```

### 2. useEffect

```tsx
// 마운트 시 한 번
useEffect(() => {
  fetchData();
}, []);

// 의존성 변경 시
useEffect(() => {
  fetchUser(userId);
}, [userId]);

// 클린업
useEffect(() => {
  const subscription = subscribe();
  return () => subscription.unsubscribe();
}, []);
```

### 3. useMemo / useCallback

```tsx
// 계산 비용이 높은 값 메모이제이션
const sortedUsers = useMemo(
  () => users.sort((a, b) => a.name.localeCompare(b.name)),
  [users]
);

// 콜백 메모이제이션
const handleClick = useCallback(
  (id: number) => selectUser(id),
  [selectUser]
);
```

---

## 📋 상태 관리

### 1. 상태 끌어올리기

```tsx
// 부모에서 상태 관리
function Parent() {
  const [selected, setSelected] = useState<number | null>(null);
  
  return (
    <>
      <ChildA selected={selected} onSelect={setSelected} />
      <ChildB selected={selected} />
    </>
  );
}
```

### 2. Context 사용

```tsx
// Context 생성
const ThemeContext = createContext<Theme>('light');

// Provider
function App() {
  return (
    <ThemeContext.Provider value="dark">
      <Main />
    </ThemeContext.Provider>
  );
}

// 사용
function Component() {
  const theme = useContext(ThemeContext);
  return <div className={theme}>...</div>;
}
```

---

## 📋 조건부 렌더링

```tsx
// && 연산자
{isLoggedIn && <UserMenu />}

// 삼항 연산자
{isLoading ? <Spinner /> : <Content />}

// Early return
function Component({ user }: Props) {
  if (!user) return <LoginPrompt />;
  return <UserProfile user={user} />;
}
```

---

## 📋 리스트 렌더링

```tsx
// key는 고유하고 안정적인 값
{users.map(user => (
  <UserCard key={user.id} user={user} />
))}

// ❌ 나쁨: index를 key로
{users.map((user, index) => (
  <UserCard key={index} user={user} />
))}
```

---

## 📋 이벤트 처리

```tsx
// 타입 안전한 이벤트 핸들러
function Form() {
  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    // 제출 로직
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setValue(e.target.value);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input onChange={handleChange} />
    </form>
  );
}
```

---

## 🚫 금지 사항

1. **클래스 컴포넌트 금지** (함수형 사용)
2. **상태 직접 수정 금지** (setState 사용)
3. **useEffect 내 무한 루프 금지** (의존성 배열 확인)
4. **index를 key로 사용 금지** (고유 ID 사용)
5. **과도한 props drilling 금지** (Context 또는 상태 관리 사용)

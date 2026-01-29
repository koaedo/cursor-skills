---
name: web-design-guidelines
description: UI/UX 규칙과 WCAG 접근성 가이드라인. UI/UX 디자인, 접근성 구현, 반응형 디자인, 스타일 시스템 구축 시 사용.
---

# Web Design Guidelines Skill

Vercel 기반 100+ UI/UX 규칙과 WCAG 접근성 가이드라인

## When to Use
- UI/UX 디자인 시
- 접근성 구현 시
- 반응형 디자인 시
- 스타일 시스템 구축 시

## File Patterns
- `**/*.tsx`
- `**/*.jsx`
- `**/*.css`
- `**/*.scss`

---

## 📋 레이아웃

### 일관된 간격 시스템

```css
/* ✅ 좋음: 8px 그리드 시스템 */
:root {
  --spacing-xs: 4px;
  --spacing-sm: 8px;
  --spacing-md: 16px;
  --spacing-lg: 24px;
  --spacing-xl: 32px;
  --spacing-2xl: 48px;
}

/* ❌ 나쁨: 임의의 값 */
.card { margin: 17px; padding: 13px; }
```

### 컨테이너 너비

```css
.container {
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 var(--spacing-md);
}
```

---

## 📋 타이포그래피

### 폰트 스케일

```css
:root {
  --font-xs: 0.75rem;    /* 12px */
  --font-sm: 0.875rem;   /* 14px */
  --font-base: 1rem;     /* 16px */
  --font-lg: 1.125rem;   /* 18px */
  --font-xl: 1.25rem;    /* 20px */
  --font-2xl: 1.5rem;    /* 24px */
  --font-3xl: 2rem;      /* 32px */
}

body { line-height: 1.5; }
h1, h2, h3 { line-height: 1.2; }
```

### 가독성

```css
/* 최대 줄 길이: 65-75자 */
.prose { max-width: 65ch; }
```

---

## 📋 색상

### 색상 시스템

```css
:root {
  /* Primary */
  --color-primary: #0070f3;
  --color-primary-hover: #0060df;
  
  /* Semantic */
  --color-success: #10b981;
  --color-warning: #f59e0b;
  --color-error: #ef4444;
  
  /* Neutral */
  --color-text: #1a1a1a;
  --color-text-secondary: #666666;
  --color-background: #ffffff;
}

/* 다크 모드 */
@media (prefers-color-scheme: dark) {
  :root {
    --color-text: #ffffff;
    --color-background: #0a0a0a;
  }
}
```

### 대비 비율 (WCAG)

```
텍스트 대비:
- 일반 텍스트: 최소 4.5:1
- 큰 텍스트 (18px+): 최소 3:1
- UI 컴포넌트: 최소 3:1
```

---

## ♿ 접근성 (WCAG 2.1)

### 1. 시맨틱 HTML

```tsx
// ✅ 좋음: 시맨틱 태그
<header>
  <nav aria-label="Main navigation">
    <ul><li><a href="/">Home</a></li></ul>
  </nav>
</header>
<main>
  <article><h1>Title</h1><p>Content</p></article>
</main>
<footer>...</footer>

// ❌ 나쁨: div 남용
<div class="header"><div class="nav">...</div></div>
```

### 2. 키보드 접근성

```tsx
// ✅ 포커스 가능한 요소
<button onClick={handleClick}>Click me</button>
<a href="/page">Link</a>

// ❌ 클릭만 가능한 div
<div onClick={handleClick}>Click me</div>

// 커스텀 요소는 role + tabIndex
<div 
  role="button"
  tabIndex={0}
  onClick={handleClick}
  onKeyDown={(e) => e.key === 'Enter' && handleClick()}
>
  Custom Button
</div>
```

### 3. 포커스 스타일

```css
/* ✅ 명확한 포커스 표시 */
:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}

/* ❌ 포커스 스타일 제거 금지 */
*:focus { outline: none; } /* 접근성 위반 */
```

### 4. 이미지 대체 텍스트

```tsx
// ✅ 의미 있는 이미지
<img src="chart.png" alt="2024년 매출 그래프: 1분기 100억" />

// ✅ 장식용 이미지
<img src="decoration.png" alt="" role="presentation" />

// ❌ 부적절한 alt
<img src="logo.png" alt="image" />
```

### 5. 폼 접근성

```tsx
<label htmlFor="email">Email</label>
<input id="email" type="email" aria-describedby="email-help" />
<p id="email-help">We'll never share your email.</p>

// 에러 메시지
<input aria-invalid={hasError} aria-describedby="error-msg" />
{hasError && <p id="error-msg" role="alert">Invalid email</p>}
```

---

## 📱 반응형 디자인

### Mobile First

```css
/* 기본: 모바일 */
.card { padding: var(--spacing-sm); }

/* 태블릿 이상 */
@media (min-width: 768px) {
  .card { padding: var(--spacing-md); }
}

/* 데스크톱 */
@media (min-width: 1024px) {
  .card { padding: var(--spacing-lg); }
}
```

### 터치 타겟

```css
/* 최소 44x44px (WCAG) */
.button, .link {
  min-height: 44px;
  min-width: 44px;
}
```

### 유동적 타이포그래피

```css
h1 { font-size: clamp(1.5rem, 5vw, 3rem); }
p { font-size: clamp(1rem, 2vw, 1.125rem); }
```

---

## 🎨 컴포넌트 패턴

### 모달 접근성

```tsx
<div
  role="dialog"
  aria-modal="true"
  aria-labelledby="modal-title"
  aria-describedby="modal-description"
>
  <h2 id="modal-title">Title</h2>
  <p id="modal-description">Description</p>
  <button onClick={onClose}>Close</button>
</div>

// 포커스 트랩 필수
// ESC 키로 닫기
// 배경 클릭으로 닫기
```

---

## 📋 체크리스트

| 카테고리 | 항목 | 확인 |
|----------|------|------|
| **접근성** | 대비 비율 4.5:1 이상? | ☐ |
| **접근성** | 키보드로 모든 기능 사용 가능? | ☐ |
| **접근성** | 포커스 스타일 표시? | ☐ |
| **접근성** | 이미지에 alt 텍스트? | ☐ |
| **반응형** | 모바일 퍼스트? | ☐ |
| **반응형** | 터치 타겟 44px 이상? | ☐ |
| **일관성** | 간격 시스템 사용? | ☐ |
| **일관성** | 색상 시스템 사용? | ☐ |

---
name: css-scss
description: CSS 및 SCSS 스타일시트 모범 사례. CSS 파일 작성, SCSS 스타일링, 스타일 구조화, BEM 네이밍 시 사용.
---

# CSS/SCSS 규칙

CSS 및 SCSS 스타일시트 작성 시 적용되는 모범 사례입니다.

---

## 📋 기본 원칙

### 1. BEM 네이밍 컨벤션

```scss
// Block__Element--Modifier
.card { }
.card__header { }
.card__title { }
.card__body { }
.card__footer { }
.card--featured { }
.card--disabled { }

// HTML
<div class="card card--featured">
  <div class="card__header">
    <h2 class="card__title">Title</h2>
  </div>
  <div class="card__body">Content</div>
</div>
```

### 2. CSS 변수 (Custom Properties)

```css
:root {
  /* Colors */
  --color-primary: #3498db;
  --color-secondary: #2ecc71;
  --color-error: #e74c3c;
  --color-text: #333;
  --color-text-muted: #666;
  --color-background: #fff;
  
  /* Spacing */
  --spacing-xs: 0.25rem;
  --spacing-sm: 0.5rem;
  --spacing-md: 1rem;
  --spacing-lg: 1.5rem;
  --spacing-xl: 2rem;
  
  /* Typography */
  --font-family-base: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  --font-size-sm: 0.875rem;
  --font-size-base: 1rem;
  --font-size-lg: 1.25rem;
  
  /* Border Radius */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 16px;
  --radius-full: 9999px;
  
  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.1);
  --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
  --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
}

/* 다크 모드 */
@media (prefers-color-scheme: dark) {
  :root {
    --color-text: #f5f5f5;
    --color-background: #1a1a1a;
  }
}
```

---

## 📋 SCSS 기능

### 1. 변수와 믹스인

```scss
// _variables.scss
$breakpoints: (
  sm: 576px,
  md: 768px,
  lg: 992px,
  xl: 1200px
);

// _mixins.scss
@mixin respond-to($breakpoint) {
  @media (min-width: map-get($breakpoints, $breakpoint)) {
    @content;
  }
}

@mixin flex-center {
  display: flex;
  align-items: center;
  justify-content: center;
}

@mixin truncate($lines: 1) {
  @if $lines == 1 {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  } @else {
    display: -webkit-box;
    -webkit-line-clamp: $lines;
    -webkit-box-orient: vertical;
    overflow: hidden;
  }
}

// 사용
.container {
  padding: 1rem;
  
  @include respond-to(md) {
    padding: 2rem;
  }
}

.title {
  @include truncate(2);
}
```

### 2. 중첩과 & 선택자

```scss
.button {
  padding: 0.5rem 1rem;
  background: var(--color-primary);
  border: none;
  border-radius: var(--radius-md);
  cursor: pointer;
  transition: all 0.2s ease;
  
  // 호버 상태
  &:hover {
    opacity: 0.9;
    transform: translateY(-1px);
  }
  
  // 비활성화
  &:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
  
  // 변형
  &--primary {
    background: var(--color-primary);
    color: white;
  }
  
  &--secondary {
    background: var(--color-secondary);
    color: white;
  }
  
  &--outline {
    background: transparent;
    border: 1px solid var(--color-primary);
    color: var(--color-primary);
  }
  
  // 크기
  &--sm {
    padding: 0.25rem 0.5rem;
    font-size: var(--font-size-sm);
  }
  
  &--lg {
    padding: 0.75rem 1.5rem;
    font-size: var(--font-size-lg);
  }
}
```

### 3. 반복문과 맵

```scss
// 색상 유틸리티 생성
$colors: (
  primary: #3498db,
  success: #2ecc71,
  warning: #f39c12,
  danger: #e74c3c
);

@each $name, $color in $colors {
  .text-#{$name} {
    color: $color;
  }
  
  .bg-#{$name} {
    background-color: $color;
  }
}

// 스페이싱 유틸리티
$spacings: (0, 1, 2, 3, 4, 5);

@each $i in $spacings {
  .mt-#{$i} { margin-top: #{$i * 0.25}rem; }
  .mb-#{$i} { margin-bottom: #{$i * 0.25}rem; }
  .pt-#{$i} { padding-top: #{$i * 0.25}rem; }
  .pb-#{$i} { padding-bottom: #{$i * 0.25}rem; }
}
```

---

## 📋 레이아웃

### Flexbox

```css
/* 가로 정렬 */
.flex-row {
  display: flex;
  gap: 1rem;
}

/* 세로 정렬 */
.flex-col {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

/* 중앙 정렬 */
.flex-center {
  display: flex;
  align-items: center;
  justify-content: center;
}

/* 양끝 정렬 */
.flex-between {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
```

### Grid

```css
/* 기본 그리드 */
.grid {
  display: grid;
  gap: 1rem;
}

/* 반응형 카드 그리드 */
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
}

/* 12컬럼 그리드 */
.container {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: 1rem;
}

.sidebar { grid-column: span 3; }
.main { grid-column: span 9; }
```

---

## 📋 반응형 디자인

### Mobile First

```scss
.container {
  padding: 1rem;           // 모바일 기본
  
  @media (min-width: 768px) {
    padding: 2rem;         // 태블릿
  }
  
  @media (min-width: 1024px) {
    padding: 3rem;         // 데스크톱
    max-width: 1200px;
    margin: 0 auto;
  }
}
```

### Container Query (최신)

```css
.card-container {
  container-type: inline-size;
}

.card {
  padding: 1rem;
}

@container (min-width: 400px) {
  .card {
    display: flex;
    gap: 1rem;
  }
}
```

---

## 📋 애니메이션

```scss
// 트랜지션
.button {
  transition: all 0.2s ease;
  
  &:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-md);
  }
}

// 키프레임 애니메이션
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.fade-in {
  animation: fadeIn 0.3s ease forwards;
}

// 스피너
@keyframes spin {
  to { transform: rotate(360deg); }
}

.spinner {
  width: 24px;
  height: 24px;
  border: 2px solid #eee;
  border-top-color: var(--color-primary);
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}
```

---

## 🚫 금지 사항

1. **`!important` 남용 금지** (특이성 문제 해결로)
2. **인라인 스타일 남용 금지** (유지보수 어려움)
3. **ID 선택자 스타일링 금지** (특이성 너무 높음)
4. **깊은 중첩 금지** (3단계 이하로)
5. **px 고정값 남용 금지** (rem, em 사용)
6. **vendor prefix 직접 작성 금지** (autoprefixer 사용)

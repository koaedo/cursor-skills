---
name: tailwind
description: Tailwind CSS 사용 모범 사례. Tailwind 클래스 사용, 유틸리티 조합, 반응형 디자인, 커스텀 설정 시 적용.
---

# Tailwind CSS 규칙

Tailwind CSS 사용 시 적용되는 모범 사례입니다.

---

## 📋 기본 원칙

### 1. 유틸리티 클래스 조합

```html
<!-- 버튼 -->
<button class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors">
  Click me
</button>

<!-- 카드 -->
<div class="p-6 bg-white rounded-xl shadow-md hover:shadow-lg transition-shadow">
  <h2 class="text-xl font-bold text-gray-800 mb-2">Title</h2>
  <p class="text-gray-600">Description text here.</p>
</div>
```

### 2. 반응형 디자인

```html
<!-- Mobile First: sm → md → lg → xl → 2xl -->
<div class="
  grid 
  grid-cols-1 
  sm:grid-cols-2 
  md:grid-cols-3 
  lg:grid-cols-4 
  gap-4
">
  <!-- Cards -->
</div>

<!-- 숨기기/보이기 -->
<nav class="hidden md:flex">Desktop Nav</nav>
<nav class="flex md:hidden">Mobile Nav</nav>
```

---

## 📋 자주 쓰는 패턴

### Flexbox 레이아웃

```html
<!-- 가로 중앙 정렬 -->
<div class="flex items-center justify-center">

<!-- 양끝 정렬 -->
<div class="flex items-center justify-between">

<!-- 세로 스택 -->
<div class="flex flex-col gap-4">

<!-- 가로 스택 -->
<div class="flex flex-row gap-4">

<!-- Flex Wrap -->
<div class="flex flex-wrap gap-2">
```

### Grid 레이아웃

```html
<!-- 기본 그리드 -->
<div class="grid grid-cols-3 gap-4">

<!-- 반응형 카드 그리드 -->
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">

<!-- 12컬럼 그리드 -->
<div class="grid grid-cols-12 gap-4">
  <aside class="col-span-3">Sidebar</aside>
  <main class="col-span-9">Content</main>
</div>
```

### 간격 (Spacing)

```html
<!-- Padding -->
<div class="p-4">       <!-- 모든 방향 -->
<div class="px-4 py-2"> <!-- 가로, 세로 -->
<div class="pt-4">      <!-- top만 -->

<!-- Margin -->
<div class="m-4">
<div class="mx-auto">   <!-- 가로 중앙 -->
<div class="mt-8 mb-4">

<!-- Gap (Flex/Grid) -->
<div class="flex gap-4">
<div class="grid gap-6">
```

---

## 📋 상태 변형

```html
<!-- 호버 -->
<button class="bg-blue-500 hover:bg-blue-600">

<!-- 포커스 -->
<input class="border focus:border-blue-500 focus:ring-2 focus:ring-blue-200">

<!-- 활성화 -->
<button class="bg-blue-500 active:bg-blue-700">

<!-- 비활성화 -->
<button class="bg-blue-500 disabled:opacity-50 disabled:cursor-not-allowed">

<!-- 그룹 호버 -->
<div class="group">
  <span class="group-hover:text-blue-500">Hover parent to change me</span>
</div>

<!-- 다크 모드 -->
<div class="bg-white dark:bg-gray-800 text-black dark:text-white">
```

---

## 📋 컴포넌트 예시

### 버튼 변형

```html
<!-- Primary -->
<button class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 
               focus:outline-none focus:ring-2 focus:ring-blue-300 transition-colors">
  Primary
</button>

<!-- Secondary -->
<button class="px-4 py-2 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 
               transition-colors">
  Secondary
</button>

<!-- Outline -->
<button class="px-4 py-2 border-2 border-blue-500 text-blue-500 rounded-lg 
               hover:bg-blue-50 transition-colors">
  Outline
</button>

<!-- Ghost -->
<button class="px-4 py-2 text-blue-500 hover:bg-blue-50 rounded-lg transition-colors">
  Ghost
</button>
```

### Input

```html
<input 
  type="text"
  class="w-full px-4 py-2 border border-gray-300 rounded-lg
         focus:border-blue-500 focus:ring-2 focus:ring-blue-200 
         focus:outline-none transition-colors
         placeholder:text-gray-400"
  placeholder="Enter text..."
/>

<!-- 에러 상태 -->
<input 
  class="w-full px-4 py-2 border border-red-500 rounded-lg
         focus:ring-2 focus:ring-red-200 bg-red-50"
/>
<p class="mt-1 text-sm text-red-500">Error message</p>
```

### 카드

```html
<div class="bg-white rounded-xl shadow-md overflow-hidden hover:shadow-lg transition-shadow">
  <img src="..." class="w-full h-48 object-cover" />
  <div class="p-6">
    <span class="text-xs font-semibold text-blue-500 uppercase tracking-wide">
      Category
    </span>
    <h2 class="mt-2 text-xl font-bold text-gray-800">Card Title</h2>
    <p class="mt-2 text-gray-600 line-clamp-2">
      Description text that might be long...
    </p>
    <button class="mt-4 text-blue-500 hover:text-blue-600 font-medium">
      Read more →
    </button>
  </div>
</div>
```

---

## 📋 @apply로 재사용 (CSS)

```css
/* globals.css */
@layer components {
  .btn {
    @apply px-4 py-2 rounded-lg font-medium transition-colors focus:outline-none focus:ring-2;
  }
  
  .btn-primary {
    @apply btn bg-blue-500 text-white hover:bg-blue-600 focus:ring-blue-300;
  }
  
  .btn-secondary {
    @apply btn bg-gray-200 text-gray-800 hover:bg-gray-300 focus:ring-gray-300;
  }
  
  .input {
    @apply w-full px-4 py-2 border border-gray-300 rounded-lg
           focus:border-blue-500 focus:ring-2 focus:ring-blue-200 
           focus:outline-none transition-colors;
  }
  
  .card {
    @apply bg-white rounded-xl shadow-md p-6;
  }
}
```

---

## 📋 tailwind.config.js 커스터마이징

```javascript
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/**/*.{js,ts,jsx,tsx}',
  ],
  darkMode: 'class', // 'media' 또는 'class'
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eff6ff',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
        },
        brand: '#ff5722',
      },
      fontFamily: {
        sans: ['Pretendard', 'sans-serif'],
      },
      spacing: {
        '128': '32rem',
      },
      animation: {
        'fade-in': 'fadeIn 0.3s ease-out',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0', transform: 'translateY(10px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/line-clamp'),
  ],
};
```

---

## 🚫 금지 사항

1. **@apply 남용 금지** (Tailwind의 장점 상실)
2. **!important 직접 사용 금지** (`!` prefix 사용: `!text-red-500`)
3. **인라인 style 속성과 혼용 금지**
4. **임의값 남용 금지** (`w-[137px]` 대신 디자인 시스템 값 사용)
5. **클래스 순서 무시 금지** (prettier-plugin-tailwindcss 사용)

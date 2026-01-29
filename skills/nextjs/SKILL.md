---
name: nextjs
description: Next.js 애플리케이션 모범 사례. Next.js App Router, 서버 컴포넌트, 라우팅, SSR/SSG 구현 시 사용.
---

# Next.js 규칙

Next.js 애플리케이션 작성 시 적용되는 모범 사례입니다. App Router (Next.js 13+) 기준입니다.

---

## 📋 프로젝트 구조

```
app/
├── layout.tsx          # 루트 레이아웃
├── page.tsx            # 홈페이지 (/)
├── loading.tsx         # 로딩 UI
├── error.tsx           # 에러 UI
├── not-found.tsx       # 404 페이지
├── globals.css         # 전역 스타일
│
├── (auth)/             # Route Group (URL에 미포함)
│   ├── login/page.tsx
│   └── register/page.tsx
│
├── dashboard/
│   ├── layout.tsx      # 중첩 레이아웃
│   ├── page.tsx
│   └── [id]/           # 동적 라우트
│       └── page.tsx
│
└── api/                # API Routes
    └── users/
        └── route.ts
```

---

## 📋 서버 컴포넌트 vs 클라이언트 컴포넌트

### 기본은 서버 컴포넌트

```tsx
// app/users/page.tsx - 서버 컴포넌트 (기본)
async function UsersPage() {
  // 서버에서 직접 데이터 페칭
  const users = await fetch('https://api.example.com/users', {
    cache: 'no-store'  // 또는 { next: { revalidate: 60 } }
  }).then(res => res.json());

  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}

export default UsersPage;
```

### 클라이언트 컴포넌트가 필요한 경우

```tsx
'use client';  // 파일 최상단에 선언

import { useState, useEffect } from 'react';

export default function Counter() {
  const [count, setCount] = useState(0);

  // useState, useEffect, onClick 등 → 클라이언트 컴포넌트 필요
  return (
    <button onClick={() => setCount(c => c + 1)}>
      Count: {count}
    </button>
  );
}
```

### 언제 무엇을 쓸까?

| 기능 | 서버 컴포넌트 | 클라이언트 컴포넌트 |
|------|--------------|-------------------|
| 데이터 페칭 | ✅ | ❌ |
| 민감한 정보 (API 키 등) | ✅ | ❌ |
| useState, useEffect | ❌ | ✅ |
| onClick, onChange | ❌ | ✅ |
| 브라우저 API (localStorage) | ❌ | ✅ |

---

## 📋 데이터 페칭

### 1. 서버 컴포넌트에서 fetch

```tsx
// 캐싱 옵션
// 기본: 영구 캐시
const data = await fetch('https://api.example.com/data');

// 캐시 안 함 (항상 최신)
const data = await fetch(url, { cache: 'no-store' });

// 60초마다 재검증 (ISR)
const data = await fetch(url, { next: { revalidate: 60 } });
```

### 2. Server Actions (폼 처리)

```tsx
// app/actions.ts
'use server';

export async function createUser(formData: FormData) {
  const name = formData.get('name');
  const email = formData.get('email');
  
  await db.user.create({ data: { name, email } });
  
  revalidatePath('/users');  // 캐시 무효화
}

// app/users/new/page.tsx
import { createUser } from '../actions';

export default function NewUserPage() {
  return (
    <form action={createUser}>
      <input name="name" required />
      <input name="email" type="email" required />
      <button type="submit">Create</button>
    </form>
  );
}
```

---

## 📋 라우팅

### 동적 라우트

```tsx
// app/posts/[slug]/page.tsx
interface Props {
  params: { slug: string };
}

export default async function PostPage({ params }: Props) {
  const post = await getPost(params.slug);
  return <article>{post.content}</article>;
}

// 정적 생성 (빌드 시)
export async function generateStaticParams() {
  const posts = await getAllPosts();
  return posts.map(post => ({ slug: post.slug }));
}
```

### Parallel Routes & Intercepting Routes

```tsx
// 병렬 라우트: @슬롯명
app/
├── @modal/
│   └── (..)photo/[id]/page.tsx  // 인터셉트
├── layout.tsx  // { children, modal } props 받음
└── page.tsx
```

---

## 📋 메타데이터 & SEO

```tsx
// 정적 메타데이터
export const metadata = {
  title: 'My App',
  description: 'My App description',
  openGraph: {
    title: 'My App',
    images: ['/og-image.png'],
  },
};

// 동적 메타데이터
export async function generateMetadata({ params }): Promise<Metadata> {
  const post = await getPost(params.slug);
  return {
    title: post.title,
    description: post.excerpt,
  };
}
```

---

## 📋 API Routes

```tsx
// app/api/users/route.ts
import { NextRequest, NextResponse } from 'next/server';

export async function GET(request: NextRequest) {
  const users = await db.user.findMany();
  return NextResponse.json(users);
}

export async function POST(request: NextRequest) {
  const body = await request.json();
  const user = await db.user.create({ data: body });
  return NextResponse.json(user, { status: 201 });
}

// app/api/users/[id]/route.ts
export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const user = await db.user.findUnique({ where: { id: params.id } });
  if (!user) {
    return NextResponse.json({ error: 'Not found' }, { status: 404 });
  }
  return NextResponse.json(user);
}
```

---

## 📋 미들웨어

```tsx
// middleware.ts (루트에 위치)
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  // 인증 체크
  const token = request.cookies.get('token');
  
  if (!token && request.nextUrl.pathname.startsWith('/dashboard')) {
    return NextResponse.redirect(new URL('/login', request.url));
  }
  
  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*', '/api/:path*'],
};
```

---

## 🚫 금지 사항

1. **서버 컴포넌트에서 useState/useEffect 사용 금지**
2. **클라이언트 컴포넌트에서 async 사용 금지**
3. **API 키를 클라이언트 컴포넌트에 노출 금지**
4. **불필요한 'use client' 남발 금지** (성능 저하)
5. **getServerSideProps/getStaticProps 사용 금지** (App Router에서는 사용 안 함)

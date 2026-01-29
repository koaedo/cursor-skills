---
name: graphql
description: GraphQL 스키마 및 쿼리 모범 사례. GraphQL 스키마 정의, 쿼리/뮤테이션 작성, resolver 구현 시 사용.
---

# GraphQL 규칙

GraphQL 스키마 및 쿼리 작성 시 적용되는 모범 사례입니다.

---

## 📋 스키마 정의

### 기본 타입

```graphql
# 스칼라 타입
type User {
  id: ID!              # Non-null ID
  name: String!        # Non-null String
  email: String!
  age: Int
  balance: Float
  isActive: Boolean!
  createdAt: DateTime! # 커스텀 스칼라
}

# 열거형
enum UserRole {
  ADMIN
  USER
  GUEST
}

# 인터페이스
interface Node {
  id: ID!
}

type User implements Node {
  id: ID!
  name: String!
}

# 유니온
union SearchResult = User | Post | Comment
```

### Query & Mutation

```graphql
type Query {
  # 단일 조회
  user(id: ID!): User
  
  # 목록 조회 (페이지네이션)
  users(
    first: Int
    after: String
    filter: UserFilter
  ): UserConnection!
  
  # 검색
  search(query: String!): [SearchResult!]!
}

type Mutation {
  # 생성
  createUser(input: CreateUserInput!): CreateUserPayload!
  
  # 수정
  updateUser(input: UpdateUserInput!): UpdateUserPayload!
  
  # 삭제
  deleteUser(id: ID!): DeleteUserPayload!
}

# Input 타입
input CreateUserInput {
  name: String!
  email: String!
  role: UserRole = USER
}

# Payload (응답)
type CreateUserPayload {
  user: User
  errors: [Error!]
}
```

### Subscription

```graphql
type Subscription {
  userCreated: User!
  messageReceived(channelId: ID!): Message!
}
```

---

## 📋 프론트엔드에서 GraphQL 사용하기

### 1. Apollo Client (React) - 가장 인기

```bash
npm install @apollo/client graphql
```

```tsx
// lib/apollo.ts
import { ApolloClient, InMemoryCache, HttpLink } from '@apollo/client';

export const client = new ApolloClient({
  link: new HttpLink({
    uri: 'https://api.example.com/graphql',
    headers: {
      authorization: `Bearer ${token}`,
    },
  }),
  cache: new InMemoryCache(),
});

// App.tsx
import { ApolloProvider } from '@apollo/client';
import { client } from './lib/apollo';

function App() {
  return (
    <ApolloProvider client={client}>
      <MyComponent />
    </ApolloProvider>
  );
}
```

### 2. useQuery - 데이터 조회

```tsx
import { gql, useQuery } from '@apollo/client';

// 쿼리 정의
const GET_USERS = gql`
  query GetUsers($first: Int, $after: String) {
    users(first: $first, after: $after) {
      edges {
        node {
          id
          name
          email
        }
      }
      pageInfo {
        hasNextPage
        endCursor
      }
    }
  }
`;

// 컴포넌트에서 사용
function UserList() {
  const { loading, error, data } = useQuery(GET_USERS, {
    variables: { first: 10 },
  });

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error: {error.message}</p>;

  return (
    <ul>
      {data.users.edges.map(({ node }) => (
        <li key={node.id}>{node.name}</li>
      ))}
    </ul>
  );
}
```

### 3. useMutation - 데이터 변경

```tsx
import { gql, useMutation } from '@apollo/client';

const CREATE_USER = gql`
  mutation CreateUser($input: CreateUserInput!) {
    createUser(input: $input) {
      user {
        id
        name
        email
      }
      errors {
        field
        message
      }
    }
  }
`;

function CreateUserForm() {
  const [createUser, { loading, error }] = useMutation(CREATE_USER, {
    // 캐시 업데이트
    update(cache, { data: { createUser } }) {
      cache.modify({
        fields: {
          users(existingUsers = []) {
            const newUserRef = cache.writeFragment({
              data: createUser.user,
              fragment: gql`
                fragment NewUser on User {
                  id
                  name
                  email
                }
              `,
            });
            return [...existingUsers, newUserRef];
          },
        },
      });
    },
    // 완료 후 쿼리 다시 실행
    refetchQueries: [{ query: GET_USERS }],
  });

  const handleSubmit = async (e) => {
    e.preventDefault();
    const formData = new FormData(e.target);
    
    try {
      const { data } = await createUser({
        variables: {
          input: {
            name: formData.get('name'),
            email: formData.get('email'),
          },
        },
      });
      
      if (data.createUser.errors) {
        // 에러 처리
      } else {
        // 성공 처리
      }
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <input name="name" required />
      <input name="email" type="email" required />
      <button type="submit" disabled={loading}>
        {loading ? 'Creating...' : 'Create User'}
      </button>
    </form>
  );
}
```

### 4. useSubscription - 실시간 데이터

```tsx
import { gql, useSubscription } from '@apollo/client';

const MESSAGE_SUBSCRIPTION = gql`
  subscription OnMessageReceived($channelId: ID!) {
    messageReceived(channelId: $channelId) {
      id
      content
      sender {
        name
      }
    }
  }
`;

function ChatRoom({ channelId }) {
  const { data, loading } = useSubscription(MESSAGE_SUBSCRIPTION, {
    variables: { channelId },
  });

  // 새 메시지가 오면 data가 업데이트됨
  useEffect(() => {
    if (data?.messageReceived) {
      // 새 메시지 처리
      console.log('New message:', data.messageReceived);
    }
  }, [data]);

  return <div>...</div>;
}
```

### 5. Fragment - 재사용 가능한 필드

```tsx
// fragments.ts
import { gql } from '@apollo/client';

export const USER_FIELDS = gql`
  fragment UserFields on User {
    id
    name
    email
    avatar
  }
`;

export const POST_FIELDS = gql`
  fragment PostFields on Post {
    id
    title
    content
    author {
      ...UserFields
    }
  }
  ${USER_FIELDS}
`;

// 사용
const GET_POST = gql`
  query GetPost($id: ID!) {
    post(id: $id) {
      ...PostFields
    }
  }
  ${POST_FIELDS}
`;
```

---

## 📋 urql (경량 대안)

```tsx
import { createClient, Provider, useQuery, useMutation } from 'urql';

const client = createClient({
  url: 'https://api.example.com/graphql',
});

function App() {
  return (
    <Provider value={client}>
      <UserList />
    </Provider>
  );
}

function UserList() {
  const [result] = useQuery({
    query: `
      query {
        users {
          id
          name
        }
      }
    `,
  });

  const { data, fetching, error } = result;

  if (fetching) return <p>Loading...</p>;
  if (error) return <p>Error!</p>;

  return (
    <ul>
      {data.users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}
```

---

## 📋 React Query + graphql-request (간단한 방법)

```tsx
import { useQuery, useMutation } from '@tanstack/react-query';
import { request, gql } from 'graphql-request';

const endpoint = 'https://api.example.com/graphql';

const GET_USERS = gql`
  query {
    users {
      id
      name
    }
  }
`;

function UserList() {
  const { data, isLoading, error } = useQuery({
    queryKey: ['users'],
    queryFn: () => request(endpoint, GET_USERS),
  });

  if (isLoading) return <p>Loading...</p>;
  if (error) return <p>Error!</p>;

  return (
    <ul>
      {data.users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}
```

---

## 📋 네이밍 컨벤션

```graphql
# Query: 명사 또는 get + 명사
query GetUser { user { ... } }
query Users { users { ... } }

# Mutation: 동사 + 명사
mutation CreateUser { ... }
mutation UpdateUser { ... }
mutation DeleteUser { ... }

# Input: 동작명 + Input
input CreateUserInput { ... }
input UpdateUserInput { ... }

# Payload: 동작명 + Payload
type CreateUserPayload { ... }

# Enum: UPPER_SNAKE_CASE
enum UserStatus {
  ACTIVE
  INACTIVE
  PENDING_VERIFICATION
}
```

---

## 🚫 금지 사항

1. **Query에서 데이터 변경 금지** (Mutation 사용)
2. **중첩 쿼리 과도한 깊이 금지** (N+1 문제 발생)
3. **스키마에 민감한 필드 노출 금지** (password 등)
4. **쿼리 복잡도 제한 없이 운영 금지** (DoS 방지)
5. **인라인 문자열 쿼리 남용 금지** (gql 태그 사용)
6. **캐시 전략 없이 사용 금지** (불필요한 요청 방지)

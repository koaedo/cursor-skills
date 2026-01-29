---
name: docker
description: Dockerfile 및 Docker Compose 모범 사례. Docker 이미지 빌드, 컨테이너 설정, docker-compose 작성 시 사용.
---

# Docker 규칙

Dockerfile 및 Docker Compose 작성 시 적용되는 모범 사례입니다.

---

## 📋 Dockerfile 기본

### 1. 기본 구조

```dockerfile
# 1. 베이스 이미지 (버전 고정)
FROM node:20-alpine

# 2. 메타데이터
LABEL maintainer="your@email.com"
LABEL version="1.0"

# 3. 환경 변수
ENV NODE_ENV=production
ENV PORT=3000

# 4. 작업 디렉토리
WORKDIR /app

# 5. 의존성 먼저 복사 (캐시 활용)
COPY package*.json ./

# 6. 의존성 설치
RUN npm ci --only=production

# 7. 소스 코드 복사
COPY . .

# 8. 포트 노출
EXPOSE 3000

# 9. 실행 명령
CMD ["node", "server.js"]
```

### 2. 멀티스테이지 빌드 (권장)

```dockerfile
# ===== Build Stage =====
FROM node:20-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ===== Production Stage =====
FROM node:20-alpine AS production

WORKDIR /app

# 빌드 결과물만 복사
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

ENV NODE_ENV=production
EXPOSE 3000

# 비루트 사용자 (보안)
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001
USER nextjs

CMD ["node", "dist/server.js"]
```

---

## 📋 언어별 Dockerfile

### Node.js

```dockerfile
FROM node:20-alpine

WORKDIR /app

# 의존성 캐시 레이어
COPY package*.json ./
RUN npm ci --only=production

COPY . .

EXPOSE 3000
CMD ["node", "server.js"]
```

### Python

```dockerfile
FROM python:3.11-slim

WORKDIR /app

# 시스템 의존성
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Python 의존성
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000
CMD ["python", "app.py"]
```

### PHP (Laravel)

```dockerfile
FROM php:8.2-fpm-alpine

WORKDIR /var/www/html

# PHP 확장
RUN docker-php-ext-install pdo pdo_mysql

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . .
RUN composer install --no-dev --optimize-autoloader

RUN chown -R www-data:www-data storage bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]
```

### Go

```dockerfile
# Build
FROM golang:1.21-alpine AS builder

WORKDIR /app
COPY go.* ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o main .

# Production (scratch = 빈 이미지)
FROM scratch

COPY --from=builder /app/main /main

EXPOSE 8080
ENTRYPOINT ["/main"]
```

---

## 📋 Docker Compose

### 기본 구조

```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build: 
      context: .
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgres://user:pass@db:5432/mydb
    depends_on:
      - db
      - redis
    volumes:
      - ./uploads:/app/uploads
    restart: unless-stopped

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: mydb
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

### 개발 환경용

```yaml
# docker-compose.dev.yml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "3000:3000"
    volumes:
      # 소스 코드 마운트 (Hot Reload)
      - .:/app
      - /app/node_modules  # node_modules 제외
    environment:
      - NODE_ENV=development
    command: npm run dev
```

---

## 📋 최적화 팁

### 1. 레이어 캐시 활용

```dockerfile
# ✅ 좋음: 자주 변경되는 것을 나중에
COPY package*.json ./
RUN npm ci
COPY . .             # 소스 변경 시 여기서만 재빌드

# ❌ 나쁨: 모든 것을 한 번에
COPY . .             # 소스 변경 시 npm ci부터 다시
RUN npm ci
```

### 2. 이미지 크기 줄이기

```dockerfile
# Alpine 사용
FROM node:20-alpine  # ~50MB (vs node:20 ~350MB)

# 불필요한 파일 제외 (.dockerignore)
# .dockerignore
node_modules
.git
*.md
.env*
```

### 3. RUN 명령 합치기

```dockerfile
# ✅ 좋음: 하나의 레이어
RUN apt-get update && apt-get install -y \
    curl \
    git \
    vim \
    && rm -rf /var/lib/apt/lists/*

# ❌ 나쁨: 여러 레이어 (캐시 문제)
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y git
```

---

## 📋 자주 쓰는 명령어

### 이미지

```bash
# 빌드
docker build -t myapp:1.0 .
docker build -f Dockerfile.prod -t myapp:prod .

# 목록
docker images

# 삭제
docker rmi myapp:1.0
docker image prune -a  # 미사용 이미지 삭제
```

### 컨테이너

```bash
# 실행
docker run -d -p 3000:3000 --name myapp myapp:1.0
docker run -it --rm myapp:1.0 sh  # 인터랙티브 + 종료 시 삭제

# 목록
docker ps       # 실행 중
docker ps -a    # 전체

# 로그
docker logs myapp
docker logs -f myapp  # 실시간

# 접속
docker exec -it myapp sh
docker exec -it myapp bash

# 정지/삭제
docker stop myapp
docker rm myapp
docker rm -f myapp  # 강제 삭제

# 정리
docker system prune -a  # 미사용 전체 삭제
```

### Docker Compose

```bash
# 시작
docker-compose up -d
docker-compose up -d --build  # 재빌드

# 로그
docker-compose logs -f

# 정지
docker-compose down
docker-compose down -v  # 볼륨도 삭제

# 특정 서비스만
docker-compose up -d app
docker-compose logs app
docker-compose restart app
```

---

## 📋 .dockerignore

```
# Git
.git
.gitignore

# Node
node_modules
npm-debug.log

# Python
__pycache__
*.pyc
.venv

# IDE
.idea
.vscode

# 환경 파일
.env
.env.*
*.local

# 문서
*.md
docs/

# 테스트
test/
tests/
coverage/

# Docker
Dockerfile*
docker-compose*
```

---

## 🚫 금지 사항

1. **latest 태그 사용 금지** (버전 명시: `node:20-alpine`)
2. **루트 사용자로 실행 금지** (보안: `USER nonroot`)
3. **민감 정보 Dockerfile에 하드코딩 금지** (환경 변수 사용)
4. **불필요한 패키지 설치 금지** (이미지 크기 증가)
5. **캐시 무시하는 순서 금지** (의존성 → 소스 순서)
6. **docker-compose.yml에 비밀번호 직접 입력 금지** (.env 사용)

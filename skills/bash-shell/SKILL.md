# Bash/Shell 규칙

Bash 스크립트 작성 시 적용되는 모범 사례입니다.

---

## 📋 기본 원칙

### 1. 스크립트 헤더

```bash
#!/bin/bash

# 스크립트 설명
# Usage: ./script.sh [options]
# Author: Your Name
# Date: 2024-01-01

set -e          # 에러 시 즉시 종료
set -u          # 정의되지 않은 변수 사용 시 에러
set -o pipefail # 파이프라인 에러 감지

# 또는 한 줄로
set -euo pipefail
```

### 2. 변수

```bash
# 변수 선언 (= 주변 공백 없음!)
NAME="John"
COUNT=10
ARRAY=("a" "b" "c")

# 변수 사용 (중괄호 권장)
echo "Hello, ${NAME}!"
echo "Count: ${COUNT}"

# 기본값 설정
DEFAULT_PORT="${PORT:-8080}"        # PORT 없으면 8080
REQUIRED_VAR="${VAR:?Error: VAR required}"  # 없으면 에러

# 읽기 전용 (상수)
readonly MAX_RETRIES=3
declare -r API_URL="https://api.example.com"

# 환경 변수로 내보내기
export PATH="${PATH}:/usr/local/bin"
```

---

## 📋 조건문

### if 문

```bash
# 문자열 비교
if [[ "${NAME}" == "John" ]]; then
    echo "Hello John"
elif [[ "${NAME}" == "Jane" ]]; then
    echo "Hello Jane"
else
    echo "Hello stranger"
fi

# 숫자 비교
if [[ ${COUNT} -gt 10 ]]; then
    echo "Greater than 10"
fi

# 비교 연산자
# 문자열: ==, !=, -z (빈 문자열), -n (비어있지 않음)
# 숫자: -eq, -ne, -lt, -le, -gt, -ge

# 파일 검사
if [[ -f "${FILE}" ]]; then
    echo "File exists"
fi

if [[ -d "${DIR}" ]]; then
    echo "Directory exists"
fi

if [[ -r "${FILE}" ]]; then
    echo "File is readable"
fi

# 파일 검사 연산자
# -f: 파일 존재
# -d: 디렉토리 존재
# -e: 존재 (파일/디렉토리)
# -r: 읽기 가능
# -w: 쓰기 가능
# -x: 실행 가능
# -s: 파일 크기 > 0
```

### 논리 연산

```bash
# AND (&&)
if [[ -f "${FILE}" && -r "${FILE}" ]]; then
    echo "File exists and is readable"
fi

# OR (||)
if [[ -z "${VAR}" || "${VAR}" == "default" ]]; then
    echo "Using default"
fi

# NOT (!)
if [[ ! -f "${FILE}" ]]; then
    echo "File not found"
fi
```

---

## 📋 반복문

### for 문

```bash
# 리스트 반복
for item in "a" "b" "c"; do
    echo "${item}"
done

# 배열 반복
FRUITS=("apple" "banana" "cherry")
for fruit in "${FRUITS[@]}"; do
    echo "${fruit}"
done

# 범위 반복
for i in {1..5}; do
    echo "Number: ${i}"
done

# C 스타일
for ((i=0; i<10; i++)); do
    echo "${i}"
done

# 파일 반복
for file in *.txt; do
    echo "Processing: ${file}"
done

# 명령어 출력 반복
for user in $(cat users.txt); do
    echo "User: ${user}"
done
```

### while 문

```bash
# 기본 while
COUNT=0
while [[ ${COUNT} -lt 5 ]]; do
    echo "Count: ${COUNT}"
    ((COUNT++))
done

# 파일 읽기 (줄 단위)
while IFS= read -r line; do
    echo "Line: ${line}"
done < "${FILE}"

# 무한 루프
while true; do
    echo "Running..."
    sleep 1
done
```

---

## 📋 함수

```bash
# 함수 정의
function greet() {
    local name="${1}"  # 지역 변수
    echo "Hello, ${name}!"
}

# 또는
greet() {
    local name="${1}"
    echo "Hello, ${name}!"
}

# 호출
greet "John"

# 반환값 (0: 성공, 1-255: 실패)
function check_file() {
    local file="${1}"
    if [[ -f "${file}" ]]; then
        return 0
    else
        return 1
    fi
}

if check_file "test.txt"; then
    echo "File exists"
fi

# 값 반환 (echo 사용)
function get_timestamp() {
    echo "$(date +%Y%m%d_%H%M%S)"
}

TIMESTAMP=$(get_timestamp)
echo "Timestamp: ${TIMESTAMP}"
```

---

## 📋 입출력

### 명령줄 인자

```bash
#!/bin/bash

# $0: 스크립트 이름
# $1, $2, ...: 인자
# $#: 인자 개수
# $@: 모든 인자 (배열)
# $?: 마지막 명령 종료 코드

echo "Script: $0"
echo "First arg: ${1:-none}"
echo "Arg count: $#"

# getopts로 옵션 파싱
while getopts "hf:v" opt; do
    case ${opt} in
        h) echo "Help"; exit 0 ;;
        f) FILE="${OPTARG}" ;;
        v) VERBOSE=true ;;
        *) echo "Invalid option"; exit 1 ;;
    esac
done
```

### 사용자 입력

```bash
# 기본 입력
read -p "Enter name: " NAME
echo "Hello, ${NAME}"

# 비밀번호 (숨김)
read -sp "Enter password: " PASSWORD
echo

# 타임아웃
if read -t 5 -p "Enter (5s timeout): " INPUT; then
    echo "You entered: ${INPUT}"
else
    echo "Timeout"
fi

# Yes/No 확인
read -p "Continue? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Continuing..."
fi
```

### 리다이렉션

```bash
# 출력 리다이렉션
echo "text" > file.txt   # 덮어쓰기
echo "text" >> file.txt  # 추가

# 입력 리다이렉션
while read line; do
    echo "${line}"
done < input.txt

# stderr 리다이렉션
command 2> error.log      # stderr만
command > output.log 2>&1 # 둘 다 합치기
command &> all.log        # 둘 다 (bash 4+)

# Here Document
cat << EOF
This is a
multi-line
string
EOF
```

---

## 📋 유용한 패턴

### 에러 처리

```bash
# trap으로 정리 작업
cleanup() {
    echo "Cleaning up..."
    rm -f "${TEMP_FILE}"
}
trap cleanup EXIT

# 에러 메시지 함수
error() {
    echo "[ERROR] $1" >&2
    exit 1
}

# 사용
[[ -f "${FILE}" ]] || error "File not found: ${FILE}"
```

### 디렉토리 이동

```bash
# 스크립트 디렉토리로 이동
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

# 안전한 디렉토리 변경
cd "${DIR}" || exit 1
```

### 명령 존재 확인

```bash
# command -v 사용
if command -v docker &> /dev/null; then
    echo "Docker is installed"
else
    echo "Docker is not installed"
    exit 1
fi

# 또는
which git &> /dev/null || error "Git is required"
```

### 색상 출력

```bash
# ANSI 색상 코드
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

echo -e "${GREEN}Success${NC}"
echo -e "${RED}Error${NC}"
echo -e "${YELLOW}Warning${NC}"
```

---

## 📋 텍스트 처리

```bash
# grep: 패턴 검색
grep "error" log.txt
grep -i "error" log.txt      # 대소문자 무시
grep -r "TODO" src/          # 재귀 검색

# sed: 텍스트 치환
sed 's/old/new/g' file.txt   # 모든 old → new
sed -i 's/old/new/g' file.txt  # 파일 직접 수정

# awk: 필드 처리
awk '{print $1}' file.txt    # 첫 번째 필드
awk -F',' '{print $2}' file.csv  # CSV 두 번째 컬럼
awk '{sum += $1} END {print sum}' numbers.txt  # 합계

# cut: 필드 추출
cut -d',' -f1 file.csv       # CSV 첫 번째 컬럼
cut -c1-10 file.txt          # 처음 10글자

# sort & uniq
sort file.txt                 # 정렬
sort -u file.txt              # 중복 제거 정렬
sort file.txt | uniq -c       # 중복 횟수 카운트
```

---

## 🚫 금지 사항

1. **[[ ]] 대신 [ ] 사용 금지** (더 안전한 [[ ]] 사용)
2. **변수 따옴표 없이 사용 금지** (`"${VAR}"` 사용)
3. **eval 사용 금지** (보안 위험)
4. **cd 실패 무시 금지** (`cd dir || exit 1`)
5. **rm -rf / 또는 rm -rf ${VAR}/ 금지** (변수 빈 경우 위험)
6. **set -e 없이 스크립트 실행 금지**

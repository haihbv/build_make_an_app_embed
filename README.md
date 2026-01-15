# Hướng dẫn lập trình GNU Make từ cơ bản đến nâng cao

Tài liệu tham khảo: GNU Make Manual - <https://www.gnu.org/software/make/manual/>

---

## Mục lục

### Phần 1: Cơ bản (cho người mới học)

1. [Makefile là gì?](#1-makefile-là-gì)
2. [Cài đặt và kiểm tra](#2-cài-đặt)
3. [Ví dụ đầu tiên](#3-ví-dụ-đầu-tiên)
4. [Cách viết Rules](#4-rules-là-gì)
5. [Sử dụng biến](#5-biến-trong-makefile)
6. [Bài tập cơ bản](#6-bài-tập-cơ-bản)

### Phần 2: Trung cấp

1. [Biến tự động](#7-biến-tự-động)
2. [Pattern Rules](#8-pattern-rules)
3. [Functions](#9-functions)
4. [Phony Targets](#10-phony-targets)
5. [Bài tập trung cấp](#11-bài-tập-trung-cấp)

### Phần 3: Nâng cao

1. [Điều kiện](#12-conditionals)
2. [Include và nhiều Makefile](#13-include)
3. [Tự động tạo dependencies](#14-dependencies)
4. [Recursive Make](#15-recursive-make)
5. [Dự án thực tế](#16-dự-án-thực-tế)

### Phần 4: Tham khảo

1. [Kinh nghiệm hay](#17-best-practices)
2. [Xử lý lỗi thường gặp](#18-troubleshooting)
3. [Bảng tra cứu nhanh](#19-cheat-sheet)

---

# PHẦN 1: CƠ BẢN

## 1. Makefile là gì?

### Mục tiêu

Sau phần này bạn sẽ:

- Hiểu Makefile là gì và để làm gì
- Biết khi nào nên dùng
- Hiểu cách Make hoạt động

### Giới thiệu

GNU Make là công cụ tự động hóa việc biên dịch chương trình. Thay vì gõ tay từng lệnh gcc, bạn chỉ cần gõ `make` và mọi thứ tự động chạy.

Ví dụ so sánh:

**Không dùng Makefile:**

```bash
# Mỗi lần build phải gõ tay hết:
gcc -c main.c -o main.o
gcc -c utils.c -o utils.o
gcc -c math.c -o math.o
gcc main.o utils.o math.o -o myprogram
```

**Dùng Makefile:**

```bash
# Chỉ cần:
make
```

### Tại sao nên học Make?

**1. Tiết kiệm thời gian**

Giả sử dự án có 100 file .c, bạn chỉ sửa 1 file.

- Make chỉ biên dịch lại file đó thôi
- Không cần build lại cả 100 file

**2. Tự động hóa công việc**

- Không cần nhớ câu lệnh dài
- Tránh gõ nhầm
- Cả team dùng chung một cách build

**3. Quản lý phụ thuộc**

Ví dụ: main.c dùng hàm từ utils.h

- Nếu utils.h thay đổi → Make biết phải build lại main.c
- Tự động, không cần bạn nhớ

### Cách Make hoạt động

Make hoạt động dựa trên thời gian sửa đổi của file:

```
main.c     (10:00 sáng)
utils.c    (10:00 sáng)
     ↓
  [make]
     ↓
myprogram  (10:30 sáng)

Bạn sửa main.c lúc 11:00
Make so sánh: main.c (11:00) mới hơn myprogram (10:30)
Kết luận: Cần build lại!
```

Đơn giản vậy thôi. Make chỉ so sánh thời gian để quyết định có cần build lại hay không.

---

## 2. Cài đặt

### Trên Windows

**Cách 1: Dùng Chocolatey**

```powershell
# Cài Chocolatey nếu chưa có: https://chocolatey.org/install
choco install make
```

**Cách 2: Dùng MinGW**

```powershell
# Tải MinGW: http://mingw.org
# Hoặc dùng MSYS2: https://www.msys2.org
```

### Trên Linux

```bash
# Ubuntu/Debian
sudo apt-get install build-essential
```

### Trên MacOS

```bash
# macOS đã có sẵn hoặc cài qua Xcode
xcode-select --install
```

### Kiểm tra xem đã cài chưa

```bash
make --version
```

Nếu ra kết quả là phiên bản Make thì ok rồi.

---

## 3. Ví dụ đầu tiên

### Tạo file đơn giản

Tạo file tên `Makefile` (hoặc `makefile`) với nội dung:

```makefile
hello:
 echo "Hello, Make!"
```

**Lưu ý:** Dòng thứ 2 phải bắt đầu bằng phím TAB, không phải dấu cách!

Chạy thử:

```bash
make hello
```

Kết quả:

```
echo "Hello, Make!"
Hello, Make!
```

Xong! Đó là Makefile đơn giản nhất.

### Ví dụ thực tế hơn

Tạo file main.c:

```c
// main.c
#include <stdio.h>
int main() {
    printf("Hello World\n");
    return 0;
}
```

Tạo Makefile:

```makefile
program: main.c
 gcc -o program main.c
```

Chạy:

```bash
make program
./program
```

Kết quả:

```
gcc -o program main.c
Hello World
```

---

## 4. Rules là gì?

### Cấu trúc của một Rule

```makefile
target: prerequisites
 recipe
```

Giải thích từng phần:

- **target**: File muốn tạo hoặc tên hành động
- **prerequisites**: Các file cần có trước (phụ thuộc)
- **recipe**: Lệnh cần chạy (phải bắt đầu bằng TAB!)

### Cách đọc Rule

Đọc như câu tiếng Việt:

```
Để tạo target, cần có prerequisites, 
thì chạy recipe
```

Ví dụ:

```makefile
program: main.o
 gcc -o program main.o
```

Đọc: "Để tạo program, cần có main.o, thì chạy lệnh gcc"

### Rule với nhiều phụ thuộc

```makefile
program: main.o utils.o math.o
 gcc -o program main.o utils.o math.o

main.o: main.c
 gcc -c main.c

utils.o: utils.c
 gcc -c utils.c

math.o: math.c
 gcc -c math.c
```

Đọc Makefile từ dưới lên:

1. Make muốn tạo program
2. program cần main.o, utils.o, math.o
3. Make kiểm tra từng file .o
4. Nếu thiếu hoặc cũ → chạy rule tương ứng

### Dependencies với header files

```makefile
main.o: main.c utils.h
 gcc -c main.c
```

Bây giờ nếu utils.h thay đổi, Make sẽ build lại main.o.

---

## 5. Biến trong Makefile

### Khai báo biến

```makefile
CC = gcc
CFLAGS = -Wall -Wextra -O2
TARGET = myprogram
OBJS = main.o utils.o math.o
```

Cú pháp: `TÊN = giá trị`

### Sử dụng biến

```makefile
$(TARGET): $(OBJS)
 $(CC) $(CFLAGS) -o $(TARGET) $(OBJS)
```

Cú pháp: `$(TÊN)` hoặc `${TÊN}`

### Tại sao dùng biến?

**Trước:**

```makefile
program: main.o utils.o
 gcc -Wall -O2 -o program main.o utils.o

test: test.o
 gcc -Wall -O2 -o test test.o
```

Nếu muốn đổi compiler sang clang, phải sửa 2 chỗ.

**Sau:**

```makefile
CC = gcc
CFLAGS = -Wall -O2

program: main.o utils.o
 $(CC) $(CFLAGS) -o program main.o utils.o

test: test.o
 $(CC) $(CFLAGS) -o test test.o
```

Giờ chỉ cần sửa 1 chỗ: `CC = clang`

### Các kiểu gán biến

**1. Gán thường (=)**

```makefile
CC = gcc
COMPILER = $(CC)
CC = clang
# COMPILER sẽ là clang (đánh giá lúc dùng)
```

**2. Gán ngay (:=)**

```makefile
CC := gcc
COMPILER := $(CC)
CC := clang
# COMPILER vẫn là gcc (đánh giá ngay lập tức)
```

**3. Gán nếu chưa có (?=)**

```makefile
CC ?= gcc
# Chỉ gán nếu CC chưa được định nghĩa
```

**4. Thêm vào (+=)**

```makefile
CFLAGS = -Wall
CFLAGS += -O2
# CFLAGS = -Wall -O2
```

### Ví dụ hoàn chỉnh với biến

```makefile
CC = gcc
CFLAGS = -Wall -Wextra -std=c11
TARGET = myprogram
SOURCES = main.c utils.c math.c
OBJECTS = main.o utils.o math.o

$(TARGET): $(OBJECTS)
 $(CC) $(CFLAGS) -o $(TARGET) $(OBJECTS)

%.o: %.c
 $(CC) $(CFLAGS) -c $<

clean:
 rm -f $(OBJECTS) $(TARGET)
```

---

## 6. Bài tập cơ bản

### Bài 1: Hello World

Tạo Makefile in ra "Hello World".

<details>
<summary>Đáp án</summary>

```makefile
hello:
 echo "Hello World"

.PHONY: hello
```

</details>

### Bài 2: Build chương trình đơn giản

Cho file hello.c:

```c
#include <stdio.h>
int main() {
    printf("Hi!\n");
    return 0;
}
```

Viết Makefile để build.

<details>
<summary>Đáp án</summary>

```makefile
CC = gcc
TARGET = hello

$(TARGET): hello.c
 $(CC) -o $(TARGET) hello.c

clean:
 rm -f $(TARGET)

.PHONY: clean
```

</details>

### Bài 3: Build với nhiều file

Cho 3 file:

- main.c (có hàm main)
- add.c (có hàm add)
- add.h (khai báo hàm add)

Viết Makefile build ra chương trình `calculator`.

<details>
<summary>Đáp án</summary>

```makefile
CC = gcc
CFLAGS = -Wall
TARGET = calculator
OBJS = main.o add.o

$(TARGET): $(OBJS)
 $(CC) -o $(TARGET) $(OBJS)

main.o: main.c add.h
 $(CC) $(CFLAGS) -c main.c

add.o: add.c add.h
 $(CC) $(CFLAGS) -c add.c

clean:
 rm -f $(OBJS) $(TARGET)

.PHONY: clean
```

</details>

---

# PHẦN 2: TRUNG CẤP

## 7. Biến tự động

Make cung cấp sẵn một số biến đặc biệt (automatic variables).

### Danh sách biến tự động

```makefile
$@  # Tên của target
$<  # Tên của prerequisite đầu tiên
$^  # Tất cả prerequisites (bỏ trùng lặp)
$+  # Tất cả prerequisites (giữ trùng lặp)
$?  # Prerequisites mới hơn target
$*  # Phần tên không có extension
```

### Ví dụ cụ thể

```makefile
program: main.o utils.o
 gcc -o $@ $^
 # $@ = program
 # $^ = main.o utils.o
 # Tương đương: gcc -o program main.o utils.o
```

```makefile
%.o: %.c
 gcc -c $< -o $@
 # $< = file .c
 # $@ = file .o
 # Ví dụ: main.c → gcc -c main.c -o main.o
```

### Ví dụ thực tế

**Không dùng biến tự động:**

```makefile
program: main.o utils.o math.o
 gcc -o program main.o utils.o math.o

main.o: main.c
 gcc -c main.c -o main.o

utils.o: utils.c
 gcc -c utils.c -o utils.o

math.o: math.c
 gcc -c math.c -o math.o
```

**Dùng biến tự động:**

```makefile
program: main.o utils.o math.o
 gcc -o $@ $^

%.o: %.c
 gcc -c $< -o $@
```

Ngắn gọn hơn nhiều!

---

## 8. Pattern Rules

Pattern rule là rule áp dụng cho nhiều file cùng mẫu.

### Cú pháp

```makefile
%.o: %.c
 gcc -c $< -o $@
```

Dấu `%` là wildcard (ký tự đại diện).

Rule này nói: "Mọi file .o được tạo từ file .c cùng tên"

### Ví dụ hoạt động

Khi Make cần tạo `main.o`:

1. Tìm pattern rule `%.o: %.c`
2. Match: `%` = `main`
3. Tìm file `main.c`
4. Chạy: `gcc -c main.c -o main.o`

### Makefile gọn hơn

**Trước:**

```makefile
main.o: main.c
 gcc -c main.c

utils.o: utils.c
 gcc -c utils.c

math.o: math.c
 gcc -c math.c
```

**Sau:**

```makefile
%.o: %.c
 gcc -c $< -o $@
```

### Pattern với nhiều loại file

```makefile
# C files
%.o: %.c
 gcc -c $< -o $@

# C++ files
%.o: %.cpp
 g++ -c $< -o $@

# Assembly files
%.o: %.s
 as $< -o $@
```

---

## 9. Functions

Make có sẵn nhiều function xử lý string và file.

### Wildcard - Tìm file

```makefile
# Lấy tất cả file .c trong thư mục
SOURCES = $(wildcard *.c)
# SOURCES = main.c utils.c math.c
```

### Patsubst - Thay thế pattern

```makefile
SOURCES = main.c utils.c math.c
OBJECTS = $(patsubst %.c,%.o,$(SOURCES))
# OBJECTS = main.o utils.o math.o
```

Hoặc viết ngắn:

```makefile
OBJECTS = $(SOURCES:.c=.o)
```

### Ví dụ kết hợp

```makefile
SOURCES = $(wildcard *.c)
OBJECTS = $(SOURCES:.c=.o)

program: $(OBJECTS)
 gcc -o $@ $^

%.o: %.c
 gcc -c $<

clean:
 rm -f $(OBJECTS) program
```

Makefile này tự động tìm tất cả file .c và build!

### Functions khác hữu ích

**dir - Lấy thư mục**

```makefile
FILES = src/main.c src/utils.c
DIRS = $(dir $(FILES))
# DIRS = src/ src/
```

**notdir - Lấy tên file**

```makefile
FILES = src/main.c include/utils.h
NAMES = $(notdir $(FILES))
# NAMES = main.c utils.h
```

**basename - Bỏ extension**

```makefile
FILES = main.c utils.c
BASE = $(basename $(FILES))
# BASE = main utils
```

**addprefix - Thêm prefix**

```makefile
FILES = main.o utils.o
WITH_PATH = $(addprefix build/,$(FILES))
# WITH_PATH = build/main.o build/utils.o
```

### Ví dụ thực tế với functions

```makefile
# Tìm tất cả file .c trong src/
SOURCES = $(wildcard src/*.c)

# Chuyển thành tên .o trong build/
OBJECTS = $(addprefix build/,$(notdir $(SOURCES:.c=.o)))

program: $(OBJECTS)
 gcc -o $@ $^

build/%.o: src/%.c
 @mkdir -p build
 gcc -c $< -o $@

clean:
 rm -rf build program

.PHONY: clean
```

---

## 10. Phony Targets

### Phony target là gì?

Phony target là target không phải file thật, mà là một hành động.

Ví dụ: `clean`, `install`, `test`

### Vấn đề khi không dùng .PHONY

```makefile
clean:
 rm -f *.o program
```

Nếu có file tên `clean` trong thư mục:

```bash
$ make clean
make: 'clean' is up to date.
```

Make nghĩ `clean` là file, và file đã tồn tại nên không làm gì.

### Giải pháp

```makefile
.PHONY: clean

clean:
 rm -f *.o program
```

Khai báo `.PHONY` → Make biết `clean` là hành động, không phải file.

### Các phony target thường dùng

```makefile
.PHONY: all clean install test run

# Build mọi thứ
all: program

# Xóa file build
clean:
 rm -f *.o program

# Cài đặt
install: program
 cp program /usr/local/bin/

# Chạy test
test: program
 ./program --test

# Chạy chương trình
run: program
 ./program
```

### Ví dụ đầy đủ

```makefile
CC = gcc
CFLAGS = -Wall -Wextra
TARGET = myapp
SOURCES = $(wildcard *.c)
OBJECTS = $(SOURCES:.c=.o)

.PHONY: all clean install test

all: $(TARGET)

$(TARGET): $(OBJECTS)
 $(CC) -o $@ $^

%.o: %.c
 $(CC) $(CFLAGS) -c $<

clean:
 rm -f $(OBJECTS) $(TARGET)

install: $(TARGET)
 install -m 755 $(TARGET) /usr/local/bin/

test: $(TARGET)
 ./$(TARGET) --test
```

---

## 11. Bài tập trung cấp

### Bài 1: Makefile tự động

Viết Makefile:

- Tự động tìm tất cả file .c
- Build ra chương trình `app`
- Có target `clean`

<details>
<summary>Đáp án</summary>

```makefile
CC = gcc
CFLAGS = -Wall
TARGET = app
SOURCES = $(wildcard *.c)
OBJECTS = $(SOURCES:.c=.o)

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJECTS)
 $(CC) -o $@ $^

%.o: %.c
 $(CC) $(CFLAGS) -c $<

clean:
 rm -f $(OBJECTS) $(TARGET)
```

</details>

### Bài 2: Makefile với cấu trúc thư mục

Cấu trúc:

```
src/
  main.c
  utils.c
build/
  (file .o ở đây)
myapp (file thực thi)
```

<details>
<summary>Đáp án</summary>

```makefile
CC = gcc
CFLAGS = -Wall
TARGET = myapp
SOURCES = $(wildcard src/*.c)
OBJECTS = $(patsubst src/%.c,build/%.o,$(SOURCES))

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJECTS)
 $(CC) -o $@ $^

build/%.o: src/%.c | build
 $(CC) $(CFLAGS) -c $< -o $@

build:
 mkdir -p build

clean:
 rm -rf build $(TARGET)
```

</details>

---

# PHẦN 3: NÂNG CAO

## 12. Conditionals

### Cú pháp

```makefile
ifeq ($(VAR),value)
    # code khi VAR == value
else
    # code khi VAR != value
endif
```

### Ví dụ: Debug vs Release

```makefile
MODE = debug

ifeq ($(MODE),debug)
    CFLAGS = -g -O0 -DDEBUG
else
    CFLAGS = -O3 -DNDEBUG
endif

program: main.c
 gcc $(CFLAGS) -o program main.c
```

Sử dụng:

```bash
make MODE=debug    # Build debug
make MODE=release  # Build release
```

### Kiểm tra biến có tồn tại không

```makefile
ifndef CC
    CC = gcc
endif
```

### Ví dụ thực tế

```makefile
# Chọn compiler
ifeq ($(OS),Windows_NT)
    CC = cl.exe
    RM = del
else
    CC = gcc
    RM = rm -f
endif

# Debug hoặc Release
DEBUG ?= 0
ifeq ($(DEBUG),1)
    CFLAGS += -g -O0
else
    CFLAGS += -O2
endif

program: main.c
 $(CC) $(CFLAGS) -o program main.c

clean:
 $(RM) program
```

---

## 13. Include

### Include file khác

```makefile
include common.mk
include config.mk
```

Chia Makefile thành nhiều file nhỏ dễ quản lý hơn.

### Ví dụ

**config.mk:**

```makefile
CC = gcc
CFLAGS = -Wall -Wextra
LDFLAGS = -lm
```

**Makefile:**

```makefile
include config.mk

program: main.o
 $(CC) -o $@ $^ $(LDFLAGS)

%.o: %.c
 $(CC) $(CFLAGS) -c $<
```

### Include tùy chọn

```makefile
-include config.mk
```

Dấu `-` ở đầu nghĩa là: nếu file không tồn tại, không báo lỗi.

---

## 14. Dependencies

### Vấn đề

```makefile
main.o: main.c
 gcc -c main.c
```

Nếu main.c include utils.h, mà utils.h thay đổi, Make không biết phải build lại main.o.

### Giải pháp: Tự động tạo dependencies

```makefile
CC = gcc
CFLAGS = -Wall -MMD -MP

SOURCES = $(wildcard *.c)
OBJECTS = $(SOURCES:.c=.o)
DEPS = $(OBJECTS:.o=.d)

program: $(OBJECTS)
 $(CC) -o $@ $^

%.o: %.c
 $(CC) $(CFLAGS) -c $<

-include $(DEPS)

clean:
 rm -f $(OBJECTS) $(DEPS) program

.PHONY: clean
```

**Giải thích:**

- `-MMD`: Tạo file .d chứa dependencies
- `-MP`: Tránh lỗi khi xóa header file
- `-include $(DEPS)`: Load các file .d

Ví dụ file main.d:

```makefile
main.o: main.c utils.h math.h
```

Giờ nếu utils.h hoặc math.h thay đổi, Make sẽ build lại main.o.

---

## 15. Recursive Make

### Khi nào dùng?

Dự án lớn với nhiều thư mục con, mỗi thư mục có Makefile riêng.

### Ví dụ cấu trúc

```
project/
  Makefile
  src/
    Makefile
    main.c
  lib/
    Makefile
    utils.c
```

**project/Makefile:**

```makefile
.PHONY: all clean

all:
 $(MAKE) -C src
 $(MAKE) -C lib

clean:
 $(MAKE) -C src clean
 $(MAKE) -C lib clean
```

**src/Makefile:**

```makefile
CC = gcc
program: main.c
 $(CC) -o program main.c

clean:
 rm -f program

.PHONY: clean
```

Chạy:

```bash
make        # Build tất cả
make clean  # Clean tất cả
```

---

## 16. Dự án thực tế

### Cấu trúc dự án

```
myproject/
├── Makefile
├── src/
│   ├── main.c
│   └── utils.c
├── include/
│   └── utils.h
└── build/
    └── (file .o ở đây)
```

### Makefile hoàn chỉnh

```makefile
# Cấu hình
CC = gcc
CFLAGS = -Wall -Wextra -Iinclude -MMD -MP
LDFLAGS = -lm

# Build mode: debug hoặc release
MODE ?= release
ifeq ($(MODE),debug)
    CFLAGS += -g -O0 -DDEBUG
else
    CFLAGS += -O2 -DNDEBUG
endif

# Files và directories
SRC_DIR = src
BUILD_DIR = build
INC_DIR = include

TARGET = myapp
SOURCES = $(wildcard $(SRC_DIR)/*.c)
OBJECTS = $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SOURCES))
DEPS = $(OBJECTS:.o=.d)

# Targets
.PHONY: all clean run test install

all: $(TARGET)

$(TARGET): $(OBJECTS)
 @echo "Linking $(TARGET)..."
 @$(CC) -o $@ $^ $(LDFLAGS)
 @echo "Build complete!"

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
 @echo "Compiling $<..."
 @$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR):
 @mkdir -p $(BUILD_DIR)

clean:
 @echo "Cleaning..."
 @rm -rf $(BUILD_DIR) $(TARGET)
 @echo "Done!"

run: $(TARGET)
 ./$(TARGET)

test: $(TARGET)
 ./$(TARGET) --test

install: $(TARGET)
 install -m 755 $(TARGET) /usr/local/bin/

-include $(DEPS)
```

### Sử dụng

```bash
# Build release
make

# Build debug
make MODE=debug

# Clean
make clean

# Build và chạy
make run

# Install
sudo make install
```

---

# PHẦN 4: THAM KHẢO

## 17. Best Practices

### 1. Luôn dùng biến

Không tốt:

```makefile
program: main.o
 gcc -Wall -O2 -o program main.o
```

Tốt:

```makefile
CC = gcc
CFLAGS = -Wall -O2
program: main.o
 $(CC) $(CFLAGS) -o $@ $^
```

### 2. Dùng automatic variables

Không tốt:

```makefile
program: main.o utils.o
 gcc -o program main.o utils.o
```

Tốt:

```makefile
program: main.o utils.o
 gcc -o $@ $^
```

### 3. Dùng pattern rules

Không tốt:

```makefile
main.o: main.c
 gcc -c main.c
utils.o: utils.c
 gcc -c utils.c
```

Tốt:

```makefile
%.o: %.c
 gcc -c $<
```

### 4. Tổ chức rõ ràng

```makefile
# Cấu hình
CC = gcc
CFLAGS = -Wall

# Files
SOURCES = $(wildcard *.c)
OBJECTS = $(SOURCES:.c=.o)

# Targets
all: program

program: $(OBJECTS)
 $(CC) -o $@ $^
```

### 5. Thêm .PHONY cho non-file targets

```makefile
.PHONY: all clean install test run
```

### 6. Dùng @ để ẩn lệnh không cần thiết

```makefile
clean:
 @rm -f *.o program
 @echo "Clean done!"
```

Kết quả:

```
Clean done!
```

Thay vì:

```
rm -f *.o program
echo "Clean done!"
Clean done!
```

---

## 18. Troubleshooting

### Lỗi 1: missing separator

```
makefile:5: *** missing separator. Stop.
```

**Nguyên nhân:** Dùng space thay vì TAB

**Giải pháp:**

```makefile
# Sai (spaces)
target:
    echo "Hello"

# Đúng (TAB)
target:
 echo "Hello"
```

### Lỗi 2: No rule to make target

```
make: *** No rule to make target 'main.o'. Stop.
```

**Nguyên nhân:**

- File main.c không tồn tại
- Hoặc thiếu rule để tạo main.o

**Giải pháp:**

- Kiểm tra file có đúng tên không
- Thêm rule: `%.o: %.c`

### Lỗi 3: Target không rebuild

Make nói "nothing to be done".

**Nguyên nhân:** Target mới hơn prerequisites

**Giải pháp:**

```bash
# Force rebuild
make -B

# Hoặc touch file nguồn
touch main.c
make
```

### Lỗi 4: Biến không hoạt động

```makefile
# Sai - shell variable
echo $HOME

# Đúng - escape $
echo $$HOME

# Đúng - make variable
echo $(MYVAR)
```

### Debug Makefile

```bash
# Xem make đang làm gì (dry run)
make -n

# Force rebuild
make -B

# Debug mode
make --debug

# Xem lý do rebuild
make --debug=b

# In ra tất cả biến
make -p
```

---

## 19. Cheat Sheet

### Cú pháp cơ bản

```makefile
# Biến
VAR = value
VAR := value
VAR ?= value
VAR += value

# Rule
target: prerequisites
 recipe

# Pattern rule
%.o: %.c
 recipe
```

### Automatic variables

```makefile
$@  # Target name
$<  # First prerequisite
$^  # All prerequisites (no duplicates)
$+  # All prerequisites (with duplicates)
$?  # Prerequisites newer than target
$*  # Stem (pattern match)
```

### Functions

```makefile
$(wildcard *.c)                    # Tìm file
$(patsubst %.c,%.o,$(SRC))        # Thay pattern
$(SRC:.c=.o)                       # Thay extension
$(dir src/main.c)                  # Lấy thư mục
$(notdir src/main.c)               # Lấy tên file
$(basename main.c)                 # Bỏ extension
$(addprefix pre-,$(FILES))        # Thêm prefix
$(addsuffix -suf,$(FILES))        # Thêm suffix
```

### Phony targets

```makefile
.PHONY: all clean install test

all: program
clean:
 rm -f *.o
```

### Conditionals

```makefile
ifeq ($(VAR),value)
    # ...
else
    # ...
endif

ifdef VAR
    # ...
endif

ifndef VAR
    # ...
endif
```

### Lệnh make hữu ích

```bash
make                # Chạy target đầu tiên
make target         # Chạy target cụ thể
make -n             # Dry run
make -B             # Force rebuild
make -j4            # Parallel (4 jobs)
make -C dir         # Chạy trong thư mục khác
make VAR=value      # Override biến
make --debug        # Debug mode
```

### Template cơ bản

```makefile
CC = gcc
CFLAGS = -Wall -Wextra
TARGET = program
SOURCES = $(wildcard *.c)
OBJECTS = $(SOURCES:.c=.o)

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJECTS)
 $(CC) -o $@ $^

%.o: %.c
 $(CC) $(CFLAGS) -c $<

clean:
 rm -f $(OBJECTS) $(TARGET)
```

---

## Kết luận

Make là công cụ mạnh để:

- Tự động hóa build
- Quản lý dependencies
- Tăng tốc compile
- Tạo build nhất quán

**Lời khuyên:**

1. Bắt đầu đơn giản, từ từ thêm tính năng
2. Dùng biến và pattern rules để tránh lặp code
3. Test với `make -n` trước khi chạy thật
4. Viết comment cho Makefile phức tạp
5. Luôn khai báo `.PHONY`

Chúc bạn học tốt!

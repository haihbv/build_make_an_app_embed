#basic makefile for embedded to build project bare-metal

TARGET_NAME := demo_stm32f10x

PRO_DIR := .
OUTPUT_PATH := $(PRO_DIR)/output
INC_DIR := $(PRO_DIR)/include
SRC_DIR := $(PRO_DIR)/source
LINKER_DIR := $(PRO_DIR)/linker_ld
ST_FLASH := C:/msys64/mingw64/bin/st-flash

#Compiler
COMPILER_DIR := C:/toolchains/armgcc
PREFIX_GCC_COMPILER := arm-none-eabi

##compile c file
CC := $(COMPILER_DIR)/bin/$(PREFIX_GCC_COMPILER)-gcc

##compile asm file
ASM := $(COMPILER_DIR)/bin/$(PREFIX_GCC_COMPILER)-as

##link object file
LD := $(COMPILER_DIR)/bin/$(PREFIX_GCC_COMPILER)-gcc

##file bin
OBJCOPY := $(COMPILER_DIR)/bin/$(PREFIX_GCC_COMPILER)-objcopy

##Compiler option
# 1. Syntax: architecture -c -O0 -g -mthumb, tap lenh thumb de build cho con chip
# 2. Tập lệnh thump để build cho con chip
# 3. Chỉ build ra file object

LINKER_FILE := $(LINKER_DIR)/stm32f10x_startup.ld

CC_OPT := -march=armv7-m -mcpu=cortex-m3 -c -O0 -g -mthumb -I$(INC_DIR)
ASM_OPT := -march=armv7-m -mcpu=cortex-m3 -c -mthumb

FILE_TO_LINK := $(OUTPUT_PATH)/main.o $(OUTPUT_PATH)/stm32f10x_startup.o $(OUTPUT_PATH)/sys.o

LD_OPT := -nostartfiles -T $(LINKER_FILE) -Wl,-Map,$(OUTPUT_PATH)/$(TARGET_NAME).map

main.o: $(SRC_DIR)/main.c | $(OUTPUT_PATH)
	$(CC) $(CC_OPT) $(SRC_DIR)/main.c -o $(OUTPUT_PATH)/main.o
	@echo "compile $(SRC_DIR)/main.c file"

stm32f10x_startup.o: $(SRC_DIR)/stm32f10x_startup.c | $(OUTPUT_PATH)
	$(CC) $(CC_OPT) $(SRC_DIR)/stm32f10x_startup.c -o $(OUTPUT_PATH)/stm32f10x_startup.o
	@echo "compile $(SRC_DIR)/stm32f10x_startup.c file"

sys.o: $(SRC_DIR)/sys.c | $(OUTPUT_PATH)
	$(CC) $(CC_OPT) $(SRC_DIR)/sys.c -o $(OUTPUT_PATH)/sys.o
	@echo "compile $(SRC_DIR)/sys.c file"

build: main.o stm32f10x_startup.o sys.o
	$(LD) $(FILE_TO_LINK) $(LD_OPT) -o $(OUTPUT_PATH)/$(TARGET_NAME).elf
	@echo "link object files to create new binary image ($(TARGET_NAME).elf)"

# Compiler Process
pre: $(SRC_DIR)/main.c
	@echo "compile $(SRC_DIR)/main.i file"
	$(CC) $(CC_OPT) -E $(SRC_DIR)/main.c -o $(OUTPUT_PATH)/new_main.i

asm_code: $(OUTPUT_PATH)/new_main.i
	@echo "compile $(OUTPUT_PATH)/main.s file"
	$(CC) $(CC_OPT) -S $(OUTPUT_PATH)/new_main.i -o $(OUTPUT_PATH)/new_main.s 

build_asm: $(OUTPUT_PATH)/new_main.s
	@echo "compile $(OUTPUT_PATH)/new_main.o file"
	$(ASM) $(ASM_OPT_OPT) $(OUTPUT_PATH)/new_main.s -o $(OUTPUT_PATH)/new_main.o

# Build file bin
bin: build
	@echo "built file bin"
	$(OBJCOPY) -O binary $(OUTPUT_PATH)/$(TARGET_NAME).elf $(OUTPUT_PATH)/$(TARGET_NAME).bin

flash: bin
	$(ST_FLASH) write $(OUTPUT_PATH)/$(TARGET_NAME).bin 0x8000000

clean:
	@rm -rf $(OUTPUT_PATH)/*

.PHONY: build clean



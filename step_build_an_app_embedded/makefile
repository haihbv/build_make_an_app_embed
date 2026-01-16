#basic makefile for embedded to build project bare-metal

PROJ_NAME := demo_stm32f10x

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

##tool convert .elf to .bin
OBJCOPY := $(COMPILER_DIR)/bin/$(PREFIX_GCC_COMPILER)-objcopy

#Linker Script file memory region description
LINKER_FILE := $(LINKER_DIR)/stm32f10x_startup.ld

#Compiler Option
CC_OPT := -march=armv7-m -mcpu=cortex-m3 -c -O0 -g -mthumb -I$(INC_DIR)
ASM_OPT := -march=armv7-m -mcpu=cortex-m3 -c -mthumb

# Link object file
FILE_TO_LINK := $(OUTPUT_PATH)/main.o $(OUTPUT_PATH)/stm32f10x_startup.o $(OUTPUT_PATH)/sys.o

LD_OPT := -nostartfiles -T $(LINKER_FILE) -Wl,-Map,$(OUTPUT_PATH)/$(PROJ_NAME).map

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
	$(LD) $(FILE_TO_LINK) $(LD_OPT) -o $(OUTPUT_PATH)/$(PROJ_NAME).elf
	@echo "link object files to create new binary image ($(PROJ_NAME).elf)"

# Compiler Process
pre: $(SRC_DIR)/main.c
	@echo "compile $(SRC_DIR)/main.i file"
	$(CC) $(CC_OPT) -E $(SRC_DIR)/main.c -o $(OUTPUT_PATH)/new_main.i

asm_code: $(OUTPUT_PATH)/new_main.i
	@echo "compile $(OUTPUT_PATH)/main.s file"
	$(CC) $(CC_OPT) -S $(OUTPUT_PATH)/new_main.i -o $(OUTPUT_PATH)/new_main.s 

build_asm: $(OUTPUT_PATH)/new_main.s
	@echo "compile $(OUTPUT_PATH)/new_main.o file"
	$(ASM) $(ASM_OPT) $(OUTPUT_PATH)/new_main.s -o $(OUTPUT_PATH)/new_main.o

# Build file bin
bin: build
	@echo "built file bin"
	$(OBJCOPY) -O binary $(OUTPUT_PATH)/$(PROJ_NAME).elf $(OUTPUT_PATH)/$(PROJ_NAME).bin

flash: bin
	$(ST_FLASH) write $(OUTPUT_PATH)/$(PROJ_NAME).bin 0x8000000

clean:
ifneq ($(OUTPUT_PATH),)
ifneq ($(OUTPUT_PATH),/)
ifneq ($(OUTPUT_PATH),.)
	-@C:/msys64/usr/bin/rm -rf $(OUTPUT_PATH)/*
endif
endif
endif

.PHONY: build clean

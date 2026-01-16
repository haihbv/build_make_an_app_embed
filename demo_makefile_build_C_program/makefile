# basic makefile to build C program

CC := gcc
PREFIX := main

build: main.o
	@echo "success build"
	$(CC) $(PREFIX).o -o $(PREFIX)

pre: main.c
	@echo "compile preprocessor"
	$(CC) -E $(PREFIX).c -o $(PREFIX).i

asm_code: main.i
	@echo "compile assembly"
	$(CC) -S $(PREFIX).i -o $(PREFIX).s

build_asm: main.s
	@echo "compile opject file"
	$(CC) -c $(PREFIX).s -o $(PREFIX).o

run:
	./main

clean:
	rm -f *.i *.s *.o *.out $(PREFIX)

.PHONY: clean build
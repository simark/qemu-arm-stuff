ARCH=arm-none-eabi

AS=$(ARCH)-as
CC=$(ARCH)-gcc
LD=$(ARCH)-ld
OBJCOPY=$(ARCH)-objcopy
CPU=arm926ej-s

CFLAGS=-ffunction-sections -mcpu=$(CPU) -g -Wall
LDFLAGS=-T test.ld
LIBS=-lc -lnosys

all: test.elf flash.data

test.elf: test.o test.ld
	$(CC) $(LDFLAGS) test.o -o test.elf $(LIBS)

test.o: test.c
	$(CC) -c $(CFLAGS) $^ -o $@

flash.data: gen-flash.py
	python3 $< $@

.PHONY: clean
clean:
	rm -f *.o test.elf flash.data


QEMU_CMDLINE = qemu-system-arm -M versatilepb -m 128M -nographic -kernel test.elf -drive if=pflash,file=flash.data,format=raw

.PHONY: run-qemu
run-qemu:
	$(QEMU_CMDLINE)

.PHONY: run-qemu-debug
run-qemu-debug:
	$(QEMU_CMDLINE) -s -S
	

.PHONY: run-gdb
run-gdb:
	arm-none-eabi-gdb -nx test.elf -ex "tar rem :1234"

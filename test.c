#include <string.h>
#include <stdio.h>
#include <stdlib.h>

volatile unsigned int * const UART0DR = (unsigned int *)0x101f1000;

/* Symbols defined by linker script. */
extern char flash_start;
extern char heap_start;
extern char heap_end;
extern char __stack;

int main() {
    char *buf;
    int i;
    int *p ;

    printf("Salut!\n");

    printf("Heap start: %p\n", &heap_start);
    printf("Heap end: %p\n", &heap_end);
    printf("Flash address: %p\n", &flash_start);
    printf("Stack base address: %p\n", &__stack);
    printf("Local variable address: %p\n", &buf);

    p = (int *) &flash_start;
    for (i = 0; i < 20; i++) {
	printf("Flash value %d: %08x\n", i, p[i]);
    }

    buf = malloc(0x1000);
    printf("Buf 1 address: %p\n", buf);

    buf = malloc(0x1000);
    printf("Buf 2 address: %p\n", buf);

    free(buf);

    buf = malloc(0x1000);
    printf("Buf 3 address: %p\n", buf);

    return 0;
}

#define STDIN 0
#define STDOUT 1
#define STDERR 2

int _write(int file, char *ptr, int len) {
    if (file == STDOUT || file == STDERR) {
	int i;

	for (i = 0; i < len; i++) {
	    *UART0DR = (unsigned int) ptr[i];
	}
    }

    return 0;
}

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#define FLASH_SIZE (64 * 1024 * 1024)

volatile unsigned int * const UART0DR = (unsigned int *)0x101f1000;

void print_uart0(const char *s) {
    while(*s != '\0') { /* Loop until end of string */
	*UART0DR = (unsigned int)(*s); /* Transmit char */
	s++; /* Next char */
    }
}

extern char flash_start;
extern char heap_start;
extern char heap_end;

int main() {
    char *buf;
    int i;
    int *p = (int *) &flash_start;
    const int num_ints = 20;

    print_uart0("Salut!\n");

    sprintf(buf, "Heap start: %p\n", &heap_start);
    print_uart0(buf);

    sprintf(buf, "Heap end: %p\n", &heap_end);
    print_uart0(buf);

    sprintf(buf, "Flash address: %p\n", flash_start);
    print_uart0(buf);

    for (i = 0; i < num_ints; i++) {
	sprintf(buf, "Value %08x\n", p[i]);
	print_uart0(buf);
    }

    buf = malloc(8888);
    sprintf(buf, "Buf address: %p\n", buf);
    print_uart0(buf);

    return 0;
}

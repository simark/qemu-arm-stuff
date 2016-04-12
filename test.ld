MEMORY
{
  SDRAM (XRW) : ORIGIN = 0x00000000, LENGTH = 0x08000000
  FLASH (xr)  : ORIGIN = 0x34000000, LENGTH = 0x04000000
  SRAM (xrw)  : ORIGIN = 0x38000000, LENGTH = 0x04000000
}

/* Define this so we can read flash in our program. */
flash_start = ORIGIN(FLASH);

/* Define heap size, used lower in this file. */
heap_size = 0x10000;

/* Define stack base, used in newlib's crt0.S. */
__stack = ORIGIN(SDRAM) + LENGTH(SDRAM);

ENTRY(_mainCRTStartup);

SECTIONS
{
  /* QEMU has starts executing at 0x10000... */
  . = 0x10000;

  .text : {
    *(.text)
    *(.text.*)
  } > SDRAM
  
  .data : {
    *(.data)
    *(.data.*)
  } > SDRAM

  .bss : {
    __bss_start__ = .;
    *(.bss)
    *(.bss.*)
    *(COMMON)
    __bss_end__ = .;
  } > SDRAM

  .heap : {
    /* Define "end" symbol (the end of interesting stuff) for the _sbrk
       implementation from libgloss. */
    end = .;

    heap_start = .;
    . = . + heap_size;
    heap_end = .;
  } > SDRAM
}

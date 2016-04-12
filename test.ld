MEMORY
{
  SDRAM (XRW) : ORIGIN = 0x00000000, LENGTH = 0x08000000
  FLASH (xr)  : ORIGIN = 0x34000000, LENGTH = 0x04000000
  SRAM (xrw)  : ORIGIN = 0x38000000, LENGTH = 0x04000000
}

flash_start = ORIGIN(FLASH);

stack_size = 4096;
heap_size = 4096;

_stack_start = ORIGIN(SRAM) + LENGTH(SRAM);
_stack_end = _stack_start - stack_size;

SECTIONS
{
  /* QEMU has starts executing at 0x10000... */
  . = 0x10000;


  .text : {
    *(.text)
    *(.text._sbrk)
  } > SDRAM
  
  .data : {
    *(.data)
  } > SDRAM

  .bss : {
    __bss_start__ = .;
    *(.bss)
    *(COMMON)
    __bss_end__ = .;
  } > SDRAM
  
  
  .heap : {
    . = . + heap_size;
    /* Define "end" symbol for the _sbrk implementation from libgloss. */
    end = .;
  } > SDRAM
}

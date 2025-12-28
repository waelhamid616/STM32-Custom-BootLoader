/* App linker script - STM32F446RE (512KB Flash, 128KB SRAM)
 * App starts at 0x08008000 (after 32KB bootloader).
 * This file defines where code and data are placed in Flash and RAM.
 */

ENTRY(Reset_Handler)   /* Program entry point (called after reset) */

/* Define the physical memory regions of the MCU */
MEMORY
{
  FLASH (rx)  : ORIGIN = 0x08008000, LENGTH = 480K   /* App Flash region */
  RAM   (xrw) : ORIGIN = 0x20000000, LENGTH = 128K  /* SRAM region */
}

/* Top of stack: used by startup code to initialize MSP */
_estack = ORIGIN(RAM) + LENGTH(RAM);

/* Section placement rules */
SECTIONS
{
  /* Interrupt vector table
   * Must be placed at the start of the app Flash region
   */
  .isr_vector :
  {
    KEEP(*(.isr_vector))    /* Keep vector table even if unused */
  } > FLASH

  /* Program code and read-only data */
  .text :
  {
    *(.text*)               /* All executable code */
    *(.rodata*)             /* Constants and read-only data */
    KEEP(*(.init))          /* C runtime init code */
    KEEP(*(.fini))          /* C runtime fini code */
  } > FLASH

  /* Exception handling tables (used by GCC) */
  .ARM.extab :
  {
    *(.ARM.extab* .gnu.linkonce.armextab.*)
  } > FLASH

  .ARM.exidx :
  {
    *(.ARM.exidx* .gnu.linkonce.armexidx.*)
  } > FLASH

  /* Address in Flash where initial .data values are stored */
  _sidata = LOADADDR(.data);

  /* Initialized data section
   * Copied from Flash to RAM by startup code
   */
  .data :
  {
    _sdata = .;              /* Start of .data in RAM */
    *(.data*)               /* Initialized global/static variables */
    _edata = .;              /* End of .data in RAM */
  } > RAM AT > FLASH

  /* Uninitialized data section
   * Zeroed by startup code
   */
  .bss :
  {
    _sbss = .;               /* Start of .bss */
    *(.bss*)                /* Uninitialized global/static variables */
    *(COMMON)               /* Common symbols */
    _ebss = .;               /* End of .bss */
  } > RAM
}

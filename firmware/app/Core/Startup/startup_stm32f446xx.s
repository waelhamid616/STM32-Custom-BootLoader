.syntax unified
.cpu cortex-m4
.fpu fpv4-sp-d16
.thumb

.global g_pfnVectors
.global Reset_Handler

/* External symbols from linker script */
.extern _estack
.extern _sidata
.extern _sdata
.extern _edata
.extern _sbss
.extern _ebss

.section .isr_vector, "a", %progbits
.type g_pfnVectors, %object
g_pfnVectors:
    .word _estack          /* Initial stack pointer */
    .word Reset_Handler    /* Reset handler */
    .word Default_Handler  /* NMI */
    .word Default_Handler  /* HardFault */
    .word Default_Handler  /* MemManage */
    .word Default_Handler  /* BusFault */
    .word Default_Handler  /* UsageFault */
    .word 0
    .word 0
    .word 0
    .word 0
    .word Default_Handler  /* SVCall */
    .word Default_Handler  /* DebugMonitor */
    .word 0
    .word Default_Handler  /* PendSV */
    .word Default_Handler  /* SysTick */

/* Reset handler */
.section .text.Reset_Handler
.type Reset_Handler, %function
Reset_Handler:
    /* Copy .data from Flash to RAM */
    ldr r0, =_sidata
    ldr r1, =_sdata
    ldr r2, =_edata
1:
    cmp r1, r2
    ittt lt
    ldrlt r3, [r0], #4
    strlt r3, [r1], #4
    blt 1b

    /* Zero .bss */
    ldr r0, =_sbss
    ldr r1, =_ebss
2:
    cmp r0, r1
    it lt
    strlt r3, [r0], #4
    blt 2b

    /* Call main */
    bl main

    /* If main returns, loop forever */
3:
    b 3b

.size Reset_Handler, .-Reset_Handler

/* Default interrupt handler */
.section .text.Default_Handler
Default_Handler:
    b Default_Handler

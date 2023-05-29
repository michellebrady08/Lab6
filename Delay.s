.cpu cortex-m3      @ Generates Cortex-M3 instructions
.extern __main
.section .text
.align	1
.syntax unified
.thumb

.global delay

# Argumento: r0 = TimeDelay
delay:
    mov     r10, r0
delay_loop:
    cmp     r10, #0
    bne     delay_loop
    bx      lr


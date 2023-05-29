.cpu cortex-m3      @ Generates Cortex-M3 instructions
.extern __main
.section .text
.align	1
.syntax unified
.thumb
.global SysTick_Handler

.include "gpio_map.inc"
# r4 -> holds counter
# r6 -> holds mode

SysTick_Handler:
# NVIC automaticamente apila 8 registros: r0-r3, r12, lr, psr y pc
    # First we check the mode value
        cmp     r6, 0x0
        bne     _sub
        mov     r1, r4              @ Load the current value of the variable
        add     r1, r1, #1          @ Increment the value by 1 (or adjust as needed)
        mov     r4, r1              @ store in r4 the counter value 
        b       _show
_sub:    mov     r1, r4
        sub     r1, r1, #1
        mov     r4, r1
_show:   lsls    r1, r1, #6
        ldr     r0, =GPIOB_BASE
        str     r1, [r0, GPIOx_ODR_OFFSET]
        sub     r10, r10, #1
        bx lr   

.size   SysTick_Handler, .-SysTick_Handler


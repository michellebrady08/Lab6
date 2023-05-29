.cpu cortex-m3      @ Generates Cortex-M3 instructions
.include "systick_map.inc"
.include "exti_map.inc"
.section .text
.align	1
.syntax unified
.thumb
.global EXTI0_3_Handler

EXTI0_3_Handler:

        ldr     r0, =EXTI_BASE
        ldr     r0, [r0, EXTI_PR_OFFSET]
        ldr     r1, =0x1
        cmp     r0, r1                  @ if EXTI 0 bit is on
        beq     EXTI0_Handler
        ldr     r1, =0x4                @ if EXTI 3 bit is on
        cmp     r0, r1
        beq     EXTI3_Handler
        bx      lr
// If button 0 is pressed we speed the systick interrupt frequency

EXTI0_Handler:
        ldr     r0, =SYSTICK_BASE
        mov     r1, r5
        ldr     r2, =1250000
        cmp     r1, r2             @ Check if the speed is 8x
        beq     x1              @ if (!8x)
        lsrs    r1, r1, r1
        mov     r5, r1
        str     r1, [r0, STK_LOAD_OFFSET]
        b       end
x1:
        ldr     r1, =1000000 
        mov     r5, r1
        str     r1, [r0, STK_LOAD_OFFSET]
end:
        bx      lr

# r6 -> holds mode 

EXTI3_Handler:
        ldr     r1, =0x0
        cmp     r6, r1
        beq     sub
        mov     r6, 0x0
        b   epi 
sub:    
        mov     r6, 0x1
epi: 
        bx      lr

.size   EXTI3_Handler, .-EXTI3_Handler


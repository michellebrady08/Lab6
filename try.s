
.thumb              @ Assembles using thumb mode
.cpu cortex-m3      @ Generates Cortex-M3 instructions
.syntax unified

.include "ivt.s"
.include "gpio_map.inc"
.include "rcc_map.inc"
.include "scb_map.inc"
.include  "afio_map.inc"
.include  "exti_map.inc"
.include "nvic_reg_map.inc"

.extern delay
.extern SysTick_Initialize
.extern EXTI0_3_Handler

.section .text
.align 1
.syntax unified
.thumb
.global __main

# r4 -> counter
# r5 -> Stkloadvalue
# r6 -> mode

__main:

        push	{r7, lr}                                @ create frame
	sub	sp, sp, #8
	add	r7, sp, #0  

        mov     r6, #0

        # enabling clock in port B
        ldr     r0, =RCC_BASE                      @ move 0x40021018 to r0
        mov     r3, 0x8                                @ loads 8 in r1 to enable clock in port B (IOPB bit)
        str     r3, [r0, RCC_APB2ENR_OFFSET]                                @ M[RCC_APB2ENR] gets 8

        b       SysTick_Initialize

        #ENABLE SYSCFG clock
        ldr     r0, =RCC_BASE
        ldr     r1, [r0, RCC_APB2ENR_OFFSET] 
        orr     r1, r1, #1
        str     r1, [r0, RCC_APB2ENR_OFFSET]

        #SELECT PB.3 AS THE TRIGGER SOURCE OF EXTI 3
        ldr     r0, =AFIO_BASE
        eor     r1, r1
        str     r1, [r0, AFIO_EXTICR1_OFFSET]

        #DISABLE RISING EDGE TRIGGER FOR EXTI 0 and 3
        ldr     r0, =EXTI_BASE
        eor     r1, r1               
        str     r1, [r0, EXTI_RTST_OFFSET]
        #DISABLE FALLING EDGE TRIGGER FOR EXTI 0 and 3
        ldr     r1, =9
        str     r1, [r0, EXTI_FTST_OFFSET]
        str     r1, [r0, EXTI_IMR_OFFSET]

        #ENABLE EXTI 0 and 3 INTERUPT
        ldr     r0, =NVIC_BASE
        orr     r1, r1, #576                    @ store a 1 on the enable bit for the exti interrupt 3
        str     r1, [r0, NVIC_ISER0_OFFSET] 

        # set pin 8-15 as digital output
        ldr     r0, =GPIOB_BASE                      @ moves address of GPIOB_CRH register to r0
        ldr     r3, =0x33333333                         @ PB15 output push-pull, max speed 50 MHz
        str     r3, [r0, GPIOx_CRH_OFFSET]                                @ M[GPIOB_CRH] gets 

        # set pin 6-7 as digital input and pin 0 and 3 as digital input
        ldr     r3, =0x33448448                         @ PB0: input
        str     r3, [r0, GPIOx_CRL_OFFSET]
        # conf
        mov     r3, #0
        str     r3, [r0, GPIOx_ODR_OFFSET]

        mov     r4, 0x0                              @ counter initial value 
loop:
        b       delay
        
        b       loop


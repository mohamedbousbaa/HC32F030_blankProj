/**
  ******************************************************************************
  * @file      startup_hc32l110.s
  * @brief     HC32L110 devices vector table for GCC toolchain.
  *            This module performs:
  *                - Set the initial SP
  *                - Set the initial PC == Reset_Handler,
  *                - Set the vector table entries with the exceptions ISR address
  *                - Branches to main in the C library (which eventually calls main()).
  *            After Reset the Cortex-M0 processor is in Thread mode,
  *            priority is Privileged, and the Stack is set to Main.
  ******************************************************************************
  */

  .syntax unified
  .cpu cortex-m0plus
  .fpu softvfp
  .thumb

.global g_pfnVectors
.global Default_Handler

/* start address for the initialization values of the .data section.
defined in linker script */
.word _sidata
/* start address for the .data section. defined in linker script */
.word _sdata
/* end address for the .data section. defined in linker script */
.word _edata
/* start address for the .bss section. defined in linker script */
.word _sbss
/* end address for the .bss section. defined in linker script */
.word _ebss

  .section .text.Reset_Handler
  .weak Reset_Handler
  .type Reset_Handler, %function
Reset_Handler:
  ldr   r0, =_estack
  mov   sp, r0          /* set stack pointer */

/* Copy the data segment initializers from flash to SRAM */
  ldr r0, =_sdata
  ldr r1, =_edata
  ldr r2, =_sidata
  movs r3, #0
  b LoopCopyDataInit

CopyDataInit:
  ldr r4, [r2, r3]
  str r4, [r0, r3]
  adds r3, r3, #4

LoopCopyDataInit:
  adds r4, r0, r3
  cmp r4, r1
  bcc CopyDataInit
  
/* Zero fill the bss segment. */
  ldr r2, =_sbss
  ldr r4, =_ebss
  movs r3, #0
  b LoopFillZerobss

FillZerobss:
  str  r3, [r2]
  adds r2, r2, #4

LoopFillZerobss:
  cmp r2, r4
  bcc FillZerobss

/* Call the clock system intitialization function.*/
  bl  SystemInit
/* Call static constructors. Remove this line if compile with `-nostartfiles` reports error */
  bl __libc_init_array
/* Call the application's entry point.*/
  bl main

LoopForever:
    b LoopForever


.size Reset_Handler, .-Reset_Handler

/**
 * @brief  This is the code that gets called when the processor receives an
 *         unexpected interrupt.  This simply enters an infinite loop, preserving
 *         the system state for examination by a debugger.
 *
 * @param  None
 * @retval : None
*/
    .section .text.Default_Handler,"ax",%progbits
Default_Handler:
Infinite_Loop:
  b Infinite_Loop
  .size Default_Handler, .-Default_Handler
/******************************************************************************
*
* The minimal vector table for a Cortex M0.  Note that the proper constructs
* must be placed on this to ensure that it ends up at physical address
* 0x0000.0000.
*
******************************************************************************/
   .section .isr_vector,"a",%progbits
  .type g_pfnVectors, %object
  .size g_pfnVectors, .-g_pfnVectors


g_pfnVectors:
  .word  _estack
  .word  Reset_Handler
  .word  NMI_Handler
  .word  HardFault_Handler
  .word  0
  .word  0
  .word  0
  .word  0
  .word  0
  .word  0
  .word  0
  .word  SVC_Handler
  .word  0
  .word  0
  .word  PendSV_Handler
  .word  SysTick_Handler

  .word  PORTA_IRQHandler
  .word  PORTB_IRQHandler
  .word  PORTC_IRQHandler
  .word  PORTD_IRQHandler

  .word  DMAC_IRQHandler
  .word  TIM3_IRQHandler
  .word  UART0_IRQHandler
  .word  UART1_IRQHandler

  .word     Dummy_Handler            ; 
  .word     Dummy_Handler            ; 
                
  .word     SPI0_IRQHandler
  .word     SPI1_IRQHandler
  .word     I2C0_IRQHandler
  .word     I2C1_IRQHandler
  .word     TIM0_IRQHandler
  .word     TIM1_IRQHandler
  .word     TIM2_IRQHandler
  .word     Dummy_Handler            ; 
  .word     TIM4_IRQHandler
  .word     TIM5_IRQHandler
  .word     TIM6_IRQHandler
  .word     PCA_IRQHandler
  .word     WDT_IRQHandler
  .word     Dummy_Handler            ; 
  .word     ADC_IRQHandler
  .word     Dummy_Handler            ; 
  .word     VC0_IRQHandler
  .word     VC1_IRQHandler
  .word     LVD_IRQHandler
  .word     Dummy_Handler
  .word     FLASH_RAM_IRQHandler
  .word     CLKTRIM_IRQHandler


/*******************************************************************************
*
* Provide weak aliases for each Exception handler to the Default_Handler.
* As they are weak aliases, any function with the same name will override
* this definition.
*
*******************************************************************************/

  .weak      NMI_Handler
  .thumb_set NMI_Handler,Default_Handler

  .weak      HardFault_Handler
  .thumb_set HardFault_Handler,Default_Handler

  .weak      SVC_Handler
  .thumb_set SVC_Handler,Default_Handler

  .weak      PendSV_Handler
  .thumb_set PendSV_Handler,Default_Handler

  .weak      SysTick_Handler
  .thumb_set SysTick_Handler,Default_Handler

  .weak      PORTA_IRQHandler
  .thumb_set PORTA_IRQHandler,Default_Handler

  .weak      PORTB_IRQHandler
  .thumb_set PORTB_IRQHandler,Default_Handler

  .weak      PORTC_IRQHandler
  .thumb_set PORTC_IRQHandler,Default_Handler

  .weak      PORTD_IRQHandler
  .thumb_set PORTD_IRQHandler,Default_Handler

  .weak      DMAC_IRQHandler
  .thumb_set DMAC_IRQHandler,Default_Handler

  .weak      TIM3_IRQHandler
  .thumb_set TIM3_IRQHandler,Default_Handler

  .weak      UART0_IRQHandler
  .thumb_set UART0_IRQHandler,Default_Handler

  .weak      UART1_IRQHandler
  .thumb_set UART1_IRQHandler,Default_Handler

  .weak      Dummy_Handler
  .thumb_set Dummy_Handler,Default_Handler

  .weak      Dummy_Handler
  .thumb_set Dummy_Handler,Default_Handler

  .weak      SPI0_IRQHandler
  .thumb_set SPI0_IRQHandler,Default_Handler

  .weak      SPI1_IRQHandler
  .thumb_set SPI1_IRQHandler,Default_Handler

  .weak      I2C0_IRQHandler
  .thumb_set I2C0_IRQHandler,Default_Handler

  .weak      I2C1_IRQHandler
  .thumb_set I2C1_IRQHandler,Default_Handler

  .weak      TIM0_IRQHandler
  .thumb_set TIM0_IRQHandler,Default_Handler

  .weak      TIM1_IRQHandler
  .thumb_set TIM1_IRQHandler,Default_Handler

  .weak      TIM2_IRQHandler
  .thumb_set TIM2_IRQHandler,Default_Handler

  .weak      Dummy_Handler
  .thumb_set Dummy_Handler,Default_Handler

  .weak      TIM4_IRQHandler
  .thumb_set TIM4_IRQHandler,Default_Handler

  .weak      TIM5_IRQHandler
  .thumb_set TIM5_IRQHandler,Default_Handler

  .weak      TIM6_IRQHandler
  .thumb_set TIM6_IRQHandler,Default_Handler

  .weak      PCA_IRQHandler
  .thumb_set PCA_IRQHandler,Default_Handler

  .weak      WDT_IRQHandler
  .thumb_set WDT_IRQHandler,Default_Handler

  .weak      Dummy_Handler 
  .thumb_set Dummy_Handler ,Default_Handler

  .weak      ADC_IRQHandler
  .thumb_set ADC_IRQHandler,Default_Handler

  .weak      Dummy_Handler
  .thumb_set Dummy_Handler,Default_Handler

  .weak      VC0_IRQHandler
  .thumb_set VC0_IRQHandler,Default_Handler

  .weak      VC1_IRQHandler
  .thumb_set VC1_IRQHandler,Default_Handler

  .weak      LVD_IRQHandler
  .thumb_set LVD_IRQHandler,Default_Handler

  .weak      Dummy_Handler
  .thumb_set Dummy_Handler,Default_Handler

  .weak      FLASH_RAM_IRQHandler
  .thumb_set FLASH_RAM_IRQHandler,Default_Handler

  .weak      CLKTRIM_IRQHandler
  .thumb_set CLKTRIM_IRQHandler,Default_Handler

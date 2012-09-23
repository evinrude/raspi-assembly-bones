.section .text

;@ ############################################################
;@ UART Globals
;@ ############################################################
.globl GetGpioSel1Address
GetGpioSel1Address:
	ldr r0, =0x20200004
	mov pc, lr

;@ GPIO Pin Pull-up/down Enable 
.globl GetGpioPud
GetGpioPud:
    ldr r0, =0x20200094
    mov pc, lr

;@ GPIO Pin Pull-up/down Enable Clock 0 
.globl GetGpioPudClk0
GetGpioPudClk0:
    ldr r0, =0x20200098
    mov pc, lr

;@ Auxillary Enable
.globl GetAuxEnableAddress
GetAuxEnableAddress:
    ldr r0, =0x20215004
    mov pc, lr

;@ Mini Uart IO Register
.globl GetAuxMuIoRegister
GetAuxMuIoRegister:
    ldr r0, =0x20215040
    mov pc, lr

;@ Mini Uart Interrupt Enable 
.globl GetAuxMuIerAddress
GetAuxMuIerAddress:
    ldr r0, =0x20215044
    mov pc, lr

;@ Mini Uart Interrupt Identify
.globl GetAuxMuIntIdentAddress
GetAuxMuIntIdentAddress:
    ldr r0, =0x20215048
    mov pc, lr

;@ Mini Uart Line Control 
.globl GetAuxMuLineCntrlAddress
GetAuxMuLineCntrlAddress:
    ldr r0, =0x2021504C
    mov pc, lr

;@ Mini Uart Modem Control 
.globl GetAuxMuModemCntrlrRegister
GetAuxMuModemCntrlrRegister:
    ldr r0, =0x20215050
    mov pc, lr

;@ Mini Uart Line Status 
.globl GetAuxMuLineStatusRegister
GetAuxMuLineStatusRegister:
	ldr r0, =0x20215054
	mov pc, lr

;@ Mini Uart Extra Control 
.globl GetAuxMuExCntrlAddress
GetAuxMuExCntrlAddress:
    ldr r0, =0x20215060
    mov pc, lr

;@ Mini Uart Mini Uart Baudrate 
.globl GetAuxMuBaudRateAddress
GetAuxMuBaudRateAddress:
    ldr r0, =0x20215068
    mov pc, lr

;@ ############################################################
;@ UART FUNCTIONS
;@ ############################################################
.globl MiniUartInit
MiniUartInit:
	
	push { lr }
	
	;@ Set gpio14 as txd
	;@ Funtion5 = 010
	mov r0, #14
	mov r1, #2
	bl SetGpioFunction

	;@ Set the pull up/down to 0
	bl GetGpioPud
	mov r1, #0
	bl Put32
	
	;@ Enable Aux
	bl GetAuxEnableAddress
	mov r1, #1
	bl Put32
	
	;@ Clear the transmit interrupt bit
	bl GetAuxMuIerAddress
	mov r1, #0
	bl Put32

	;@ We do not need extra features enabled on the mini uart 
	bl GetAuxMuExCntrlAddress
	mov r1, #0
	bl Put32

	;@ Set the line size to 8 bits (ascii) and read (do not care)
    bl GetAuxMuLineCntrlAddress
    mov r1, #3
    bl Put32

	;@ Ignore the modem control
    bl GetAuxMuModemCntrlrRegister
    mov r1, #0
    bl Put32
	
	;@ Clear the transmit interrupt bit again
	bl GetAuxMuIerAddress
	mov r1, #0
	bl Put32

	;@ Set the IIR
	;@ Transmit holding register empty
	;@ Always read as zero as the mini UART has no timeout function
	;@ FIFOs are always enabled 
 	bl GetAuxMuIntIdentAddress
	ldr r1, =0xC6
	bl Put32

	;@ Establish the baud rate
	;@ 115200 @250Mhz is 270
	bl GetAuxMuBaudRateAddress
	ldr r1, =0x10E
	bl Put32

	;@ sleep for at least 150 cycles
	mov r4, #0
	one$:
        add r4, r4, #1
        bl cycle
        cmp r4, #150
        bne one$

	;@ arm the clock for gpio14
    bl GetGpioPudClk0
	mov r1, #1
    lsl r1, r1, #14
    bl Put32

	;@ 150 cycles
	mov r4, #0
	two$:
		add r4, r4, #1
		bl cycle
		cmp r4, #150
		bne two$ 

	;@ turn the clock off for gpio14
	bl GetGpioPudClk0
	mov r1, #0
	bl Put32

	;@ Transmit enabled
	bl GetAuxMuExCntrlAddress
	mov r1, #2
	bl Put32

	pop { pc }


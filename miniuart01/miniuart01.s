.section .init
.globl _start
_start:
main:
mov sp,#0x00008000
bl MiniUartInit
bl MiniUartSendLoop

.section .text
;@ Send A-Z continuosly
.globl MiniUartSendLoop
MiniUartSendLoop:
	mov r8, #0x41
	Send$:
		WaitForLine$:
			bl GetAuxMuLineStatusRegister
			bl Get32
			tst r0, #32
			beq WaitForLine$
		bl GetAuxMuIoRegister
		mov r1, r8
		bl Put32
		cmp r8, #0x0D
		moveq r1, #0x0A
		bleq Put32
		ldr r0, =0x2EE
		bl SleepUS
		cmp r8, #0x0D
		moveq r8, #0x40
		add r8, r8, #1
		cmp r8, #0x5A
		movgt r8, #0x0D
		b Send$
	


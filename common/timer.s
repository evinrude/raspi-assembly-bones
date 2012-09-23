.section .text
#Address 	Size / Bytes 	Name 				Description 															Read or Write
#20003000 	4 				Control / Status 	Register used to control and clear timer channel comparator matches. 	RW
#20003004 	8 				Counter 			A counter that increments at 1MHz. 										R
#2000300C 	4 				Compare 0 			0th Comparison register. 												RW
#20003010 	4 				Compare 1 			1st Comparison register. 												RW
#20003014 	4 				Compare 2 			2nd Comparison register. 												RW
#20003018 	4 				Compare 3 			3rd Comparison register. 												RW
#
#
#
#
# Load the counter into a register and then check to see if time has expired
#
# r0 = delay
# r1 = counter address
# r2 = lower 32 bits of counter
# r3 = upper 32 bits of counter
.globl GetTimerAddress
GetTimerAddress:
	ldr r0, =0x20003004
	mov pc, lr

.globl SleepUS
SleepUS:
	timer	.req r0
	delay	.req r1
	low		.req r2
	high	.req r3

	push {lr}
	mov delay,r0
	bl GetTimerAddress
	ldrd low,high,[timer]
	add delay,low,delay

	loopUS$:
		ldrd low,high,[timer]
		cmp low,delay
		bls loopUS$

	.unreq timer
	.unreq delay 
	.unreq low
	.unreq high

	pop {pc}

.globl Sleep
Sleep:
	timer	.req r0
	delay	.req r1
	low		.req r2
	high	.req r3

	push {lr}
	#0xf4240 = 1000000 microseconds
	ldr r3,=0xf4240
	mul delay,r3,r0
	bl GetTimerAddress
	ldrd low,high,[timer]
	add delay,low,delay

	loopSeconds$:
		ldrd low,high,[timer]
		cmp low,delay
		bls loopSeconds$

	.unreq timer
	.unreq delay 
	.unreq low
	.unreq high

	pop {pc}

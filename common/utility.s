.section .text
;@ ############################################################
;@ HELPER FUNCTIONS
;@ ############################################################

;@ 32 bit setter
;@ r0 = address
;@ r1 = 32 bit value
.globl Put32
Put32:
	str r1,[r0]
    mov pc, lr

;@ 32 bit getter
;@ r0 = return val
.globl Get32
Get32:
	ldr r0,[r0]
	mov pc, lr

.globl cycle
cycle:
	bx lr

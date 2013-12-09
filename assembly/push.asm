inc cpu.inc

call main

main:
	mova 0xff
	movaf PORTA
	push REGA
	call test
	pop REGA
	movaf PORTA
	ret

test:
	mova 0x7e
	movaf PORTA
	ret

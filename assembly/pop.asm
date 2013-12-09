def PORTA 0x0000

jmp main

main:
	mova 0xff
	push
	mova 0x55
	movaf PORTA
	pop
	movaf PORTA

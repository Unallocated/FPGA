def PORTA 0x0000

jmp main

main:
	mova 0xff
	xnora 0x7e
	movaf PORTA
	ret

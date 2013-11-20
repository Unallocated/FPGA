def PORTA 0x0000

jmp main

moo:
	mova 0x7e
	movaf PORTA
	ret

main:
	mova 0xff
	movaf PORTA
	call moo
	mova 0x55
	movaf PORTA

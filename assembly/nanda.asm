def PORTA 0x0000

jmp main

main:
	mova 0xff
	nanda 0x0f
	movaf PORTA
	ret

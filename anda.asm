def PORTA 0x0000

jmp main

main:
	mova 0xff
	anda 0x0f
	movaf PORTA
	ret

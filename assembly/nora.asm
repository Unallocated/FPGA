def PORTA 0x0000

jmp main

main:
	mova 0xfe
	nora 0x0e
	movaf PORTA
	ret

def PORTA 0x0000

jmp main

main:
	mova 0x81
	ora 0x02
	movaf PORTA
	ret

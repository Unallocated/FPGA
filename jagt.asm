def PORTA 0x0000

jmp main

main:
	mova 0x40
	jagt 0x40 moo
	movaf PORTA
	ret

moo:
	mova 0xff
	movaf PORTA
	ret

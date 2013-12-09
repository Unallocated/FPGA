def PORTA 0x0000

call main

	mova 0xff
	movaf PORTA

main:
	mova 0x7e
	movaf PORTA

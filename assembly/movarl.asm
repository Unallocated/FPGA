inc cpu.inc

call main

main:
	mova 0xff
	movarh R1
	mova 0x7e
	movarl R1
	mova 0xf0
	movaf PORTA
	movrla R1
	movaf PORTA
	ret

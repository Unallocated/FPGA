def PORTA 0x0000

def a 0x4000

jmp main

main:
	mova 0xff
	movaf a
	mova 0x7e
	xoraf a
	movaf PORTA
	ret

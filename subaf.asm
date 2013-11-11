def a 0x4000
def PORTA 0x0000

jmp main

main:
	mova 0x03
	movaf a
	mova 0x04
	subaf a
	movaf PORTA
	ret

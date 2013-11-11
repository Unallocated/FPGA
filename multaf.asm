def a 0x4000
def PORTA 0x0000

jmp main

main:
	mova 0x02
	movaf a
	mova 0x04
	multaf a
	movaf PORTA
	ret

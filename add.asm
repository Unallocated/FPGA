def PORTA 0x0000

def a 0x4000
def b 0x4001

jmp main


main:
	mova 0xff
	movaf a
	mova 0x03
	addaf a
	movaf PORTA
	ret

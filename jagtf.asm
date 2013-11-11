def a 0x4000
def PORTA 0x0000

jmp main

main:
	mova 0x40
	movaf a
	mova 0x80
	jagtf a moo
	movaf PORTA
	ret

moo:
	mova 0xff
	movaf PORTA
	ret

def PORTA 0x0000

def a 0x4000

jmp main

main:
	mova 0xcc
	movaf PORTA
	pusha
	mova 0xff
	movaf PORTA
	popa
	movaf PORTA
	ret

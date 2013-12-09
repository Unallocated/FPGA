def PORTA 0x0000
def a 0x4000

jmp main


main:
	mova 0xff
	movaf PORTA
	call test
	mova 0x7e
	movaf PORTA
	ret
test:
	ret

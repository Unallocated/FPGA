def PORTA 0x0000

def a 0x4000
def b 0x4001

jmp main

main:
	mova 0x00
	movaf a
moo:
	adda 0x01
	movaf a
	movfa b
	adda 0x01
	movaf b
	movaf PORTA
	jane 0xff moo
	jmp main

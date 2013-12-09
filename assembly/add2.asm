def PORTA 0x0000

def aH 0x4000
def aL 0x4001

def bH 0x4002
def bL 0x4003

def cH 0x4003
def cL 0x4004

jmp main

main:
	mova 0xff
	movaf aL
	mova 0x00
	movaf aH
	mova 0x04
	movaf bL
	mova 0x00
	movaf bH

	movfa aL
	addaf bL
	movaf cL
	movfa aH
	addca 0x00
	addaf bH
	movaf cH

	movfa cL
	movaf PORTA
	mova 0x00
moo:
	adda 0x01
	jane 0x10 moo
	
	movfa cH
	movaf PORTA
	ret

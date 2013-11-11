#pragma FREQ 100000000

def PORTA 0x0000
def a 0x4000

def multBy 0x4001

jmp main

multMethod:
	mova 

main:
	mova 0x02
	movaf a
	mova 0x04
	movaf multBy
	call multMethod

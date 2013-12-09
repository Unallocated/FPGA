def aHighByte 0x4000
def aLowByte 0x4001

def bHighByte 0x4002
def bLowByte 0x4003

def rHighByte 0x4004
def rLowByte 0x4005

def PORTA 0x0000
def PORTB 0x0001
def PORTC 0x0002

jmp main

add16:
	movfa aLowByte
	addaf bLowByte
	movaf rLowByte

	movfa aHighByte
	addca 0x00
	addaf bHighByte
	movaf rHighByte
	ret

main:
	mova 0x00
	movaf aHighByte
	mova 0x03
	movaf aLowByte

	mova 0x00
	movaf bHighByte
	mova 0xff
	movaf bLowByte

	call add16

	movfa rLowByte
	movaf PORTB
	movfa rHighByte
	movaf PORTC
	
	ret

inc cpu.inc

def LEDS 0x0000

jmp main

main:
	mova 0x00
	ora 0x04
	movaf LEDS
	xora 0x04
	movaf LEDS
	jmp main

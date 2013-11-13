def PORTA 0x0000

jmp main

main:
	mova 0x00
loop:
	adda 0x01
	movaf PORTA
	jane 0xff loop

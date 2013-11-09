def a 0x4000
def PORTA 0x0000

jmp start

test:
	mova 0xf0
	movaf PORTA
	mova 0x0f
	movaf PORTA
	movfa 0x80 0x00
	movaf PORTA
	movfa 0x80 0x01
	movaf PORTA
	mova 0xff
	movaf PORTA
	ret


start:
	mova 0x7e
	movaf a
	movaf PORTA
	mova 0x00
loop:
	adda 0x01
	jane 0xff loop
	movaf PORTA

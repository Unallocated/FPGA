def PORTA 0x0000

jmp start

start:
	mova 0x01
	call test
	movaf PORTA
	ret

test:
	mova 0xff
	movaf PORTA
	ret

def PORTA 0x0000

jmp start

branch2:
	mova 0x00
	movaf PORTA
loop2:
	adda 0x01
	movaf PORTA
	jane 0xff loop2
	ret

test:
	mova 0xff
loop1:
	suba 0x01
	movaf PORTA
	jane 0x00 loop1
	call branch2
	ret

start:
	mova 0x01
	call test
	movaf PORTA

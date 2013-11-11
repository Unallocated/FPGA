def a 0x4000
def b 0x4001

def PORTA 0x0000

jmp main


main:
	noop
	mova 0x40
	movaf a
	mova 0x01
	movaf b
	adda 0x01
	suba 0x01
	lsla 0x01
	lsra 0x01
	mula 0x02
	lrla 0x01
	lrra 0x01
	movfa a
	addca 0x00
	addaf b
	subaf b
	multaf b
	xora 0x00
	ora 0x00
	anda 0xff
	nora 0xff
	xnora 0xff
	nanda 0x00
	xoraf b
	oraf b
	andaf b
	noraf b
	xnoraf b
	nandaf b
	call test
	mova 0xff
	movaf PORTA
	ret
test:
	movaf PORTA
	ret

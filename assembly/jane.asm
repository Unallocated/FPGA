def PORTA 0x0000

jmp main

moo:
	mova 0x55
	movaf PORTA
	jmp end

main:
	mova 0xff
	adda 0x10
	jane 0xff moo
	movaf PORTA
end:
	noop

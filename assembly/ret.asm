def PORTA 0x0000

jmp main

main:
	mova 0xff
	movaf PORTA
	call moo
	mova 0x55
	movaf PORTA
	jmp end
moo:
	mova 0x7e
	movaf PORTA
	ret
end:
	noop


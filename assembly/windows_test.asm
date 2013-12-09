inc cpu.inc

call asdf

asdf:
	mova 0x0f
	movaf PORTA
	ret
inc cpu.inc

def DATA_BUS 0x0001
def ADDR_BUS 0x0002
def PINS_BUS 0x0003

def DATA_DIR 0x0005
def ADDR_DIR 0x0006
def PINS_DIR 0x0007

def WE_PIN 0x01
def OE_PIN 0x02

def DATA_BUF 0x4000
def ADDR_BUF 0x4001

jmp main

main:
	call setup
	mova 0x7e
	movaf DATA_BUF
	mova 0x01
	movaf ADDR_BUF
	call write
	mova 0xff
	movaf DATA_BUF
	mova 0x02
	movaf ADDR_BUF
	call write
	mova 0x01
	movaf ADDR_BUF
	call read
	movfa DATA_BUF
	movaf PORTA
	jmp end

write:
	call setAddr
	call setData
	call toggleWE
	ret

read:
	call setAddr ; set the address
	mova 0x00    ; prepare to make DATA_DIR an input
	movaf DATA_DIR ; set as input
	movfa PINS_BUS ; read the current pins value
	anda ~OE_PIN   ; turn off the OE bit
	movaf PINS_BUS ; set the new data on pins
	movfa DATA_BUS ; read the data bus (data from ram)
	movaf DATA_BUF ; move the value from mem, to the register
	movfa PINS_BUS ; read the value of the pins bus
	ora OE_PIN     ; turn on the OE bit
	movaf PINS_BUS ; move the new value to the pins bus
	ret ; return
	

setData:
	mova 0xff
	movaf DATA_DIR
	movfa DATA_BUF
	movaf DATA_BUS
	ret

toggleWE:
	movfa PINS_BUS
	anda ~WE_PIN
	movaf PINS_BUS
	ora WE_PIN
	movaf PINS_BUS
	ret

setAddr:
	movfa ADDR_BUF
	movaf ADDR_BUS
	ret

setup:
	mova 0xff
	movaf DATA_DIR
	movaf ADDR_DIR
	movaf PINS_DIR
	movaf TRISA
	mova 0x00
	movaf DATA_BUS
	movaf ADDR_BUS
	movaf PORTA
	ora WE_PIN
	ora OE_PIN
	movaf PINS_BUS
	ret

end:
	noop

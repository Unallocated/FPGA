def ARG_STARTING_ADDRESS 0x3000
def RET_STARTING_ADDRESS 0x2000

jmp main

main:
  call adder16Test
  jmp end

adder16Test:
  mova 0xff
  movaf ARG_STARTING_ADDRESS
  mova 0x03
  movaf ARG_STARTING_ADDRESS + 1
  mova 0x00
  movaf ARG_STARTING_ADDRESS + 2
  mova 0x44
  movaf ARG_STARTING_ADDRESS + 3
  call add16
  ret

add24:
  movfa ARG_STARTING_ADDRESSS + 2
  adda ARG_STARTING_ADDRESSS + 5
  movaf RET_STARTING_ADDRESS + 2
  movfa ARG_STARTING_ADDRESSS + 1
  addca ARG_STARTING_ADDRESSS + 4
  movaf RET_STARTING_ADDRESS + 1
  movfa ARG_STARTING_ADDRESSS
  addca ARG_STARTING_ADDRESSS + 3
  movaf RET_STARTING_ADDRESS
  ret

add32:
  movfa ARG_STARTING_ADDRESSS + 3
  adda ARG_STARTING_ADDRESSS + 6
  movaf RET_STARTING_ADDRESS + 3
  movfa ARG_STARTING_ADDRESSS + 2
  addca ARG_STARTING_ADDRESSS + 5
  movaf RET_STARTING_ADDRESS + 2
  movfa ARG_STARTING_ADDRESSS + 1
  addca ARG_STARTING_ADDRESSS + 4
  movaf RET_STARTING_ADDRESS + 1
  movfa ARG_STARTING_ADDRESSS
  addca ARG_STARTING_ADDRESSS + 3
  movaf RET_STARTING_ADDRESS
  ret

add16:
  movfa ARG_STARTING_ADDRESSS + 1 ;load in the low byte of the first number
  adda ARG_STARTING_ADDRESS + 3   ;add the low byte of the first with the low byte of the second
  movaf RET_STARTING_ADDRESS + 1  ;move the result to the low byte of the return address
  movfa ARG_STARTING_ADDRESS      ;load in the high byte of the first number
  addca ARG_STARTING_ADDRESS + 2  ;add the high byte of the first with the low byte of the second (and add the carry bit)
  movaf RET_STARTING_ADDRESS      ;move the result tp the high byte of the return address
  ret                             ;return

end: 
  noop

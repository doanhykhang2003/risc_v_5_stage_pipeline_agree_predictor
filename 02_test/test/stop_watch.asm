# Reset all value
reset:
andi x1, x1, 0
andi x2, x2, 0
andi x3, x3, 0
andi x4, x4, 0

andi x5, x5, 0
andi x6, x6, 0
andi x7, x7, 0
andi x8, x8, 0
andi x11, x11, 0
andi x12, x12, 0
andi x13, x13, 0

# Take address of HEX0, HEX1, HEX2, HEX3
li x14, 0x1C08

# Take address of HEX4, HEX5, HEX6, HEX7
li x15, 0x1C09

# Take address of Switch
li x16, 0x1E00

# Take address of Button
li x17, 0x1E04

# Starter conditer (DO NOT CHANGE)
li x9, 10
li x10, 6

li x18, 1

# Check for sw
check_sw_and_button:
lw x19, 0(x17)
andi x19, x19, 1
bne x19, x18 reset
lw x19, 0(x16)
andi x19, x19, 1
beq x19,x18 add_1_milisec
j check_sw_and_button


# Main stopwatch (x1-x8 is counter)(x9-x10 is branch condition)(x11-x13 is hex displace final value)
add_1_milisec:
addi x1, x1, 1
bne x1, x9, no_add_1
addi x2, x2, 1
andi x1, x1, 0
j next_1
no_add_1:
nop
nop
nop

next_1:
bne x2, x9, no_add_2
addi x3, x3, 1
andi x2, x2, 0
j next_2
no_add_2:
nop
nop
nop

next_2:
bne x3, x9, no_add_3
addi x4, x4, 1
andi x3, x3, 0
j next_3
no_add_3:
nop
nop
nop

next_3:
bne x4, x10, no_add_4
addi x5, x5, 1
andi x4, x4, 0
j next_4
no_add_4:
nop
nop
nop

next_4:
bne x5, x9, no_add_5
addi x6, x6, 1
andi x5, x5, 0
j next_5
no_add_5:
nop
nop
nop

next_5:
bne x6, x10, no_add_6
addi x7, x7, 1
andi x6, x6, 0
j next_6
no_add_6:
nop
nop
nop

next_6:
bne x7, x9, no_add_7
addi x8, x8, 1
andi x7, x7, 0
j next_7
no_add_7:
nop
nop
nop

next_7:
bne x8, x9, no_add_8
andi x8, x8, 0
j display
no_add_8:
nop
nop
j display

display:
addi x11, x1, 0
addi x13, x2, 0
slli x13, x13, 4
add x11, x13, x11
addi x13, x3, 0
slli x13, x13, 8
add x11, x13, x11
addi x13, x4, 0
slli x13, x13, 12
add x11, x13, x11
sw x11, 0(x14)

addi x12, x5, 0
addi x13, x6, 0
slli x13, x13, 4
add x12, x13, x12
addi x13, x7, 0
slli x13, x13, 8
add x12, x13, x12
addi x13, x8, 0
slli x13, x13, 12
add x12, x13, x12
sw x12, 0(x15)
j check_sw_and_button

halt: j halt
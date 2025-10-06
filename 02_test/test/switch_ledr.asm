# Take address of Switch
li x1, 0x1E00          # Switch address

li x7, 0x1C00

# check bit
li x2, 1
li x6, 0
li x5, 7

check_switch:
    lw x3, 0(x1)
    and x4, x3, x2
    beq x4, x2, turn_on
    beq x4, x6, turn_off

turn_on:
    sw x2, 0(x7)
    lw x8, 0(x7)
    j check_switch
    
turn_off:
    sw x6, 0(x7)
    lw x8, 0(x7)
    j check_switch
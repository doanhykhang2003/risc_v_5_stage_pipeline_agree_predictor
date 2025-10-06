# Take address of Switch
li x1, 0x1E00          # Switch address

li x2, 1
li x5, 7

check_switch:
lw x3, 0(x1)
and x4, x3, x2
beq x4, x2, stop
j check_switch

stop:
sw x5, 0(x1)
lw x6, 0(x1)
_start:
    lui x3, 0x80000         # (1) x3 = 0x80000000
    ori x1, x0, 0x1         # (1) x1 = 0x00000001
    jal x0, label1          # jump to label1
label0:
    ori x1, x0, 0x111
    ori x1, x0, 0x110
label1:
    ori x1, x0, 0x002       # (2) x1 = 0x00000002
    jal x5, label2          # jump to label2 and set x5 = 0x1c
    ori x1, x0, 0x110
    ori x1, x0, 0x111
    bne x1, x0, label3
    ori x1, x0, 0x110
    ori x1, x0, 0x111
label2:
    ori x1, x0, 0x003       # (3) x1 = 0x00000003
    or x2, x5, x0           # (3) x2 = 0x0000001c
    beq x3, x3, label3      # x3 == x3, jump to label3
    ori x1, x0, 0x111
    ori x1, x0, 0x110
label4:
    ori x1, x0, 0x005       # (5) x1 = 0x00000005
    bge x3, x1, label3      # (5) label3 < 0, not jump
    ori x1, x0, 0x006       # (6) x1 = 0x00000006
    bgeu x3, x1, label5     # (6) x3 > 0, jump to label5
label_bad:
    ori x1, x0, 0x111
label7:
    ori x1, x0, 0x010       # (10) x1 = 0x00000010
    bne x1, x3, label8      # (10) x1 != x3, jump to label8
label6:
    ori x1, x0, 0x008       # (8) x1 = 0x00000008
    blt x1, x0, label_bad   # (8) x1 > 0, not jump
    ori x1, x0, 0x009       # (9) x1 = 0x00000009
    bltu x1, x3, label7     # (9) x1 < x3, jump to label7
label5:
    ori x1, x0, 0x007       # (7) x1 = 0x00000007
    blt x3, x1, label6      # (7) x3 < 0, jump to label6
label3:
    ori x1, x0, 0x004       # (4) x1 = 0x00000004
    bge x1, x0, label4      # if x1 >= x0 then label4
label8:
    ori x1, x0, 0x011       # (11) x1 = 0x00000011
    bne x1, x1, label_bad   # (11) x1 == x1, not jump
    ori x1, x0, 0x012       # (12) x1 = 0x00000012
    ori x3, x0, 0x014       # (12) x3 = 0x00000014
_loop1:                     # for x1 = 0x12 to 0x14
    addi x1, x1, 0x1        # x1++
    blt x1, x3, _loop1
    # x1 = 0x00000014
    srli x3, x1, 0x1        # x3 = x1 / 2 = 0x0000000a
_loop2:                     # for x1 = 0x14 to -0x0a
    sub x1, x1, x3          # x1 -= x3
    bge x1, x0, _loop2
    # x1 = 0xfffffff6
    nop
    nop
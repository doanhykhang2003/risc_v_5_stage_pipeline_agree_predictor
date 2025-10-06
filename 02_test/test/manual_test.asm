li x1, 0x1C00
li x3, 32

loop:
    addi x4, x4, 1
    sw x4, 0(x1)
    bge x4, x3, reset
    j loop
reset:
    li x4, 0
    j loop
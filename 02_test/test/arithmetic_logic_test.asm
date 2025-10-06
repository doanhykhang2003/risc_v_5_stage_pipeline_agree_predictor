# Block 1: Addition
li x1, 10
li x2, 20
add x3, x1, x2                # x3 = 10 + 20 = 30

# Block 2: Subtraction
li x4, 30
li x5, 15
sub x6, x4, x5                 # x6 = 30 - 15 = 15

# Block 3: Logical AND
li x1, 5                            # 0b0101
li x2, 3                            # 0b0011
and x3, x1, x2                # x3 = 0b0001 = 1

# Block 4: Logical OR
li x4, 5                            # 0b0101
li x5, 3                            # 0b0011
or x6, x4, x5                   # x6 = 0b0111 = 7

# Block 5: Logical XOR
li x1, 0b1100                   # 12
li x2, 0b1010                   # 10
xor x3, x1, x2                  # x3 = 0b0110 = 6

# Block 6: Shift Left Logical
li x4, 1
li x5, 3
sll x6, x4, x5                    # x6 = 1 << 3 = 8

# Block 7: Shift Right Logical
li x1, 32
li x2, 2
srl x3, x1, x2                    # x3 = 32 >> 2 = 8

# Block 8: Set Less Than (signed)
li x4, -5
li x5, 3
slt x6, x4, x5                    # x6 = 1 (since -5 < 3)

# Block 9: Set Less Than Unsigned
li x1, -1                            # 0xFFFFFFFF
li x2, 1
sltu x3, x1, x2                  # x3 = 0 (since 0xFFFFFFFF > 1 when unsigned)

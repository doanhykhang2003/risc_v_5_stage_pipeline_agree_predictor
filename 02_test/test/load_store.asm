# Test Case 1: Addition
li x1, 15
li x2, 25
add x3, x1, x2   # x3 = x1 + x2 = 15 + 25 = 40

# Test Case 2: Subtraction
li x4, 40
li x5, 10
sub x6, x4, x5   # x6 = x4 - x5 = 40 - 10 = 30

# Test Case 3: Logical AND
li x1, 7
li x2, 3
and x3, x1, x2   # x3 = x1 & x2 = 7 & 3 = 3

# Test Case 4: Logical OR
li x4, 10
li x5, 6
or x6, x4, x5    # x6 = x4 | x5 = 10 | 6 = 14

# Test Case 5: Load and Store
li x7, 0x1C00
li x8, 0x1C04
sw x3, 0(x7)     # Store data to address 0x1C00
sw x6, 4(x8)     # Store data to address 0x1E08
lw x1, 0(x7)     # Load word from address in x7 + 0 into x1
nop
lw x2, 4(x8)     # Load word from address in x8 + 4 into x2
add x3, x1, x2   # Add the two loaded values
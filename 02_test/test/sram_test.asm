# Taka Data Memory address
li x1, 0x800

# Take HEX address
li x5, 0x1C08

# Take random value for testing
li x2, 0xBBBBAAAA
# Test store data at address 800
sw x2, 0(x1)

# Load data out for hex4, hex5, hex6, hex7
lw x3, 0(x1)
sw x3, 0(x5)

halt: j halt
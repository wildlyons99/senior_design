weights = [
    "00111010", "00011101", "00010000", "01010101", "01001001",
    "11101100", "00010111", "11010111", "10111101", "11101010",
    "11111010", "11000001", "00100010", "11001111", "11101000",
    "01001000"
]

zero_data = [
    "00000000",
    "00100101",
    "00100010",
    "00000000",
    "00000000",
    "01000110",
    "01010000",
    "00000000",
    "00000000",
    "01000001",
    "01010100",
    "00000000",
    "00000000",
    "00100111",
    "00111010",
    "00000000"    
]

one_data = [
    "00000000", "00000000", "00011000", "00000000", "00000000",
    "00000010", "00111110", "00000000", "00000000", "00110011",
    "00010001", "00000000", "00000000", "00100001", "00000000",
    "00000000"
]

# Binary to int
def bint(binary_string):
    # Check if the binary string represents a negative number in two's complement
    if binary_string[0] == '1':  # MSB is 1, so it's negative
        # Convert to negative value by subtracting from 2^number_of_bits
        return int(binary_string, 2) - (1 << len(binary_string))
    else:
        # Positive number
        return int(binary_string, 2)


# Do dot product
sum = 0
for i in range (0, 15):
    curr = bint(weights[i]) * bint(zero_data[i])
    print("weight: ", bint(weights[i]), "     data: ", bint(zero_data[i]))
    print(i, ":  ", curr, "       sum: ", sum, "\n")
    sum += curr
    


# Print the result
print("Dot product:", sum)

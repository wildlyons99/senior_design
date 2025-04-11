
output = ""
weight_val = 2
neuron_count_array = [16, 4, 4, 1]
layers = [1, 2, 3]


for layer in layers:
    for neuron in range(neuron_count_array[layer]):

        output += f"\n// layer {layer} neuron {neuron}\n"

        for weight in range(neuron_count_array[layer-1]):
            curr_layer = format(layer - 1, '02b')
            curr_neuron = format(neuron, '04b')
            curr_weight = format(weight, '010b')
            addr = curr_layer + curr_neuron + curr_weight
            addr = formatted_hex = format(int(addr, 2), '04X')
            output += f"weight_mem[16'h{addr}] <= {weight_val};\n"

print(output)
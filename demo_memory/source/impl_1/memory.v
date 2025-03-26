// memory.v

module memory (
    input wire clk,
    input wire [$clog2(30)-1:0] index_layer1,   // neuron index for layer 1
    input wire [$clog2(16)-1:0] index_layer2,   // neuron index for layer 2
    input wire [$clog2(10)-1:0] index_layer3,   // neuron index for layer 3

    output wire signed [3455:0] weights_layer1,  // 432 inputs * 8 bits
    output wire signed [239:0] weights_layer2,  // 30 inputs * 8 bits
    output wire signed [127:0] weights_layer3,  // 16 inputs * 8 bits

    output wire signed [7:0] bias_layer1,
    output wire signed [7:0] bias_layer2,
    output wire signed [7:0] bias_layer3
);

    // Layer 1 ROMs
    rom_layer1 u_rom_weights1 (
        .clk(clk),
        .neuron_index(index_layer1),
        .neuron_weights_flat(weights_layer1)
    );

    rom_bias1 u_rom_bias1 (
        .clk(clk),
        .neuron_index(index_layer1),
        .neuron_bias(bias_layer1)
    );

    // Layer 2 ROMs
    rom_layer2 u_rom_weights2 (
        .clk(clk),
        .neuron_index(index_layer2),
        .neuron_weights_flat(weights_layer2)
    );

    rom_bias2 u_rom_bias2 (
        .clk(clk),
        .neuron_index(index_layer2),
        .neuron_bias(bias_layer2)
    );

    // Layer 3 ROMs
    rom_layer3 u_rom_weights3 (
        .clk(clk),
        .neuron_index(index_layer3),
        .neuron_weights_flat(weights_layer3)
    );

    rom_bias3 u_rom_bias3 (
        .clk(clk),
        .neuron_index(index_layer3),
        .neuron_bias(bias_layer3)
    );

endmodule
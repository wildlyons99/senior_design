module rom_bias1 #(
    parameter NUM_NEURONS = 30
) (
    input wire clk,
    input wire [$clog2(NUM_NEURONS)-1:0] neuron_index,
    output reg signed [7:0] neuron_bias
);

    reg signed [7:0] bias_mem [0:NUM_NEURONS-1];

    initial begin
        $readmemh("layer1_0_biases.mem", bias_mem);
    end

    always @(posedge clk) begin
        neuron_bias <= bias_mem[neuron_index];
    end
endmodule
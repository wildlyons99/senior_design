module rom_layer2 #(
    parameter NUM_NEURONS = 16,
    parameter NUM_INPUTS = 30
) (
    input wire clk,
    input wire [$clog2(NUM_NEURONS)-1:0] neuron_index,
    output reg signed [NUM_INPUTS*8-1:0] neuron_weights_flat
);

    reg signed [7:0] weights [0:NUM_NEURONS-1][0:NUM_INPUTS-1];
    integer i;

    initial begin
        $readmemh("layer2_0_weights.mem", weights);
    end

    always @(posedge clk) begin
        for (i = 0; i < NUM_INPUTS; i = i + 1) begin
            neuron_weights_flat[i*8 +: 8] <= weights[neuron_index][i];
        end
    end
endmodule

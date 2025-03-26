module rom_weights #(
    parameter NUM_NEURONS = 30,
    parameter NUM_INPUTS  = 432,
    parameter TOTAL_WEIGHTS = NUM_NEURONS * NUM_INPUTS
)(
    input  wire clk,
    input  wire [$clog2(NUM_NEURONS)-1:0] neuron_index,
    output reg signed [NUM_INPUTS*8-1:0] neuron_weights_flat // flat signed output
);

    // Flat memory for all weights
    reg signed [7:0] rom_mem [0:TOTAL_WEIGHTS-1];
    integer i;

    initial begin
        $readmemh("layer1_0_weights.mem", rom_mem);
    end

    always @(posedge clk) begin
        for (i = 0; i < NUM_INPUTS; i = i + 1) begin
            neuron_weights_flat[8*i +: 8] <= rom_mem[neuron_index * NUM_INPUTS + i];
        end
    end

endmodule

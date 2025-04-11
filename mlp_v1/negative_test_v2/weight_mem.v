module weight_mem
    (
        input wire clk, 
        input wire reset,
        input wire [15:0] input_addr,
        output reg signed [7:0] weight_val
    );

    // 2^16 (size of neuron address) requires 65536 addresses
    reg signed [7:0] weight_mem[0:65535];

    // initializing input layer
    initial begin
        // layer 0 neuron 0 
        weight_mem[16'h0000] <= -3;
        weight_mem[16'h0001] <= 14;
        weight_mem[16'h0002] <= 3;
        weight_mem[16'h0003] <= -8;

        // layer 0 neuron 1
        weight_mem[16'h0400] <= 4;
        weight_mem[16'h0401] <= -6;
        weight_mem[16'h0402] <= 16;
        weight_mem[16'h0403] <= 8;

        // layer 1 neuron 0
        weight_mem[16'h4000] <= -4;
        weight_mem[16'h4001] <= -5;

        // layer 1 neuron 1
        weight_mem[16'h4400] <= 6;
        weight_mem[16'h4401] <= 2;

        // layer 2 neuron 0
        weight_mem[16'h8000] <= 3;
        weight_mem[16'h8001] <= 2;     
    end

    always @(posedge clk) begin
        if (reset) begin
            weight_val <= 0;
        end else begin 
            weight_val <= weight_mem[input_addr];
        end
    end

endmodule

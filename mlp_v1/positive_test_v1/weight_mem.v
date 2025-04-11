module weight_mem
    (
        input wire clk, 
        input wire [15:0] input_addr,
        output reg signed [7:0] weight_val
    );

    // 2^16 (size of neuron address) requires 65536 addresses
    reg [7:0] weight_mem[0:65535];

    // initializing input layer
    initial begin
        // layer 0 neuron 0 
        weight_mem[16'h0000] <= 16'h06;
        weight_mem[16'h0001] <= 16'h03;
        weight_mem[16'h0002] <= 16'h0d;
        weight_mem[16'h0003] <= 16'h07;

        // layer 0 neuron 1
        weight_mem[16'h0400] <= 16'h09;
        weight_mem[16'h0401] <= 16'h04;
        weight_mem[16'h0402] <= 16'h04;
        weight_mem[16'h0403] <= 16'h03;

        // layer 1 neuron 0
        weight_mem[16'h4000] <= 16'h0e;
        weight_mem[16'h4001] <= 16'h03;

        // layer 1 neuron 1
        weight_mem[16'h4400] <= 16'h08;
        weight_mem[16'h4401] <= 16'h04;

        // layer 2 neuron 0
        weight_mem[16'h8000] <= 16'h02;
        weight_mem[16'h8001] <= 16'h03;

        weight_val <= 16'h00;        
    end

    always @(negedge clk) begin
        weight_val = weight_mem[input_addr];
    end

endmodule

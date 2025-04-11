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
        // layer 1 neuron 0
        weight_mem[16'h0000] <= 2;
        weight_mem[16'h0001] <= 2;
        weight_mem[16'h0002] <= 2;
        weight_mem[16'h0003] <= 2;
        weight_mem[16'h0004] <= 2;
        weight_mem[16'h0005] <= 2;
        weight_mem[16'h0006] <= 2;
        weight_mem[16'h0007] <= 2;
        weight_mem[16'h0008] <= 2;
        weight_mem[16'h0009] <= 2;
        weight_mem[16'h000A] <= 2;
        weight_mem[16'h000B] <= 2;
        weight_mem[16'h000C] <= 2;
        weight_mem[16'h000D] <= 2;
        weight_mem[16'h000E] <= 2;
        weight_mem[16'h000F] <= 2;

        // layer 1 neuron 1
        weight_mem[16'h0400] <= 2;
        weight_mem[16'h0401] <= 2;
        weight_mem[16'h0402] <= 2;
        weight_mem[16'h0403] <= 2;
        weight_mem[16'h0404] <= 2;
        weight_mem[16'h0405] <= 2;
        weight_mem[16'h0406] <= 2;
        weight_mem[16'h0407] <= 2;
        weight_mem[16'h0408] <= 2;
        weight_mem[16'h0409] <= 2;
        weight_mem[16'h040A] <= 2;
        weight_mem[16'h040B] <= 2;
        weight_mem[16'h040C] <= 2;
        weight_mem[16'h040D] <= 2;
        weight_mem[16'h040E] <= 2;
        weight_mem[16'h040F] <= 2;

        // layer 1 neuron 2
        weight_mem[16'h0800] <= 2;
        weight_mem[16'h0801] <= 2;
        weight_mem[16'h0802] <= 2;
        weight_mem[16'h0803] <= 2;
        weight_mem[16'h0804] <= 2;
        weight_mem[16'h0805] <= 2;
        weight_mem[16'h0806] <= 2;
        weight_mem[16'h0807] <= 2;
        weight_mem[16'h0808] <= 2;
        weight_mem[16'h0809] <= 2;
        weight_mem[16'h080A] <= 2;
        weight_mem[16'h080B] <= 2;
        weight_mem[16'h080C] <= 2;
        weight_mem[16'h080D] <= 2;
        weight_mem[16'h080E] <= 2;
        weight_mem[16'h080F] <= 2;

        // layer 1 neuron 3
        weight_mem[16'h0C00] <= 2;
        weight_mem[16'h0C01] <= 2;
        weight_mem[16'h0C02] <= 2;
        weight_mem[16'h0C03] <= 2;
        weight_mem[16'h0C04] <= 2;
        weight_mem[16'h0C05] <= 2;
        weight_mem[16'h0C06] <= 2;
        weight_mem[16'h0C07] <= 2;
        weight_mem[16'h0C08] <= 2;
        weight_mem[16'h0C09] <= 2;
        weight_mem[16'h0C0A] <= 2;
        weight_mem[16'h0C0B] <= 2;
        weight_mem[16'h0C0C] <= 2;
        weight_mem[16'h0C0D] <= 2;
        weight_mem[16'h0C0E] <= 2;
        weight_mem[16'h0C0F] <= 2;

        // layer 2 neuron 0
        weight_mem[16'h4000] <= 2;
        weight_mem[16'h4001] <= 2;
        weight_mem[16'h4002] <= 2;
        weight_mem[16'h4003] <= 2;

        // layer 2 neuron 1
        weight_mem[16'h4400] <= 2;
        weight_mem[16'h4401] <= 2;
        weight_mem[16'h4402] <= 2;
        weight_mem[16'h4403] <= 2;

        // layer 2 neuron 2
        weight_mem[16'h4800] <= 2;
        weight_mem[16'h4801] <= 2;
        weight_mem[16'h4802] <= 2;
        weight_mem[16'h4803] <= 2;

        // layer 2 neuron 3
        weight_mem[16'h4C00] <= 2;
        weight_mem[16'h4C01] <= 2;
        weight_mem[16'h4C02] <= 2;
        weight_mem[16'h4C03] <= 2;

        // layer 3 neuron 0
        weight_mem[16'h8000] <= 2;
        weight_mem[16'h8001] <= 2;
        weight_mem[16'h8002] <= 2;
        weight_mem[16'h8003] <= 2;     
    end

    always @(posedge clk) begin
        if (reset) begin
            weight_val <= 0;
        end else begin 
            weight_val <= weight_mem[input_addr];
        end
    end

endmodule

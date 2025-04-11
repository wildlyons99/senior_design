module neuron_mem
    (
        input wire clk, 
        input wire write_enable,
        input wire [11:0] input_addr,
        input wire signed [15:0] data,
        input wire [11:0] output_addr,
        output reg signed [15:0] neuron_val
    );

    // 2^12 (size of neuron address) requires 4096 addresses
    reg [15:0] neuron_mem[0:4095];

    // initializing input layer
    initial begin
        neuron_val <=  16'h00;

        neuron_mem[0] <= 16'h07;
        neuron_mem[1] <= 16'h05;
        neuron_mem[2] <= 16'h09;
        neuron_mem[3] <= 16'h04;
    end

    always @(negedge clk) begin
        if (write_enable) begin
            neuron_mem[output_addr] = data;
        end

        neuron_val = neuron_mem[input_addr];
    end

endmodule

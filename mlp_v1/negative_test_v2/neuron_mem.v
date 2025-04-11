module neuron_mem
    (
        input wire clk, 
        input wire reset,
        input wire write_enable,
        input wire [11:0] input_addr,
        input wire signed [15:0] data,
        input wire [11:0] output_addr,
        output reg signed [15:0] neuron_val
    );

    // 2^12 (size of neuron address) requires 4096 addresses
    reg signed [15:0] neuron_mem[0:4095];

    // initializing input layer
    initial begin
        neuron_val <= 0;

        neuron_mem[0] <= 7;
        neuron_mem[1] <= 3;
        neuron_mem[2] <= -8;
        neuron_mem[3] <= 5;
    end

    always @(posedge clk) begin
        if (reset) begin
            neuron_val <= 0;
        end else begin 
            if (write_enable) begin
                neuron_mem[output_addr] <= data;
            end

            neuron_val <= neuron_mem[input_addr];
        end
    end

endmodule

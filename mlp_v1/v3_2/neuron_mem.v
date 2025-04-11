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
        neuron_mem[0] <= 4;
        neuron_mem[1] <= 4;
        neuron_mem[2] <= 4;
        neuron_mem[3] <= 4;
        neuron_mem[4] <= 4;
        neuron_mem[5] <= 4;
        neuron_mem[6] <= 4;
        neuron_mem[7] <= 4;
        neuron_mem[8] <= -3;
        neuron_mem[9] <= -3;
        neuron_mem[10] <= -3;
        neuron_mem[11] <= -3;
        neuron_mem[12] <= -3;
        neuron_mem[13] <= -3;
        neuron_mem[14] <= -3;
        neuron_mem[15] <= -3;
        
    end

    always @(posedge clk) begin
        if (reset) begin
            neuron_val <= 0;
        end else begin 
            if (input_addr == output_addr && write_enable) begin
                neuron_val <= data;
            end else begin
                neuron_val <= neuron_mem[input_addr];
            end 

            if (write_enable) begin
                neuron_mem[output_addr] <= data;
            end
        end
    end

endmodule

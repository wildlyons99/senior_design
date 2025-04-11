module bias_mem
    (
        input wire clk,
        input wire[15:0] input_addr,
        output reg signed [7:0] bias_val
    );

    wire [5:0] bias_addr = input_addr[15:10];

    // 3 * 16 + 1 (maximum number of possible output neurons)
    reg signed [7:0] bias_mem[0:48];

    initial begin 
        bias_mem[6'b000000] = 0;
        bias_mem[6'b000001] = 0;

        bias_mem[6'b010000] = 0;
        bias_mem[6'b010001] = 0;

        bias_mem[6'b100000] = 0;
    end

    always @(negedge clk) begin
        bias_val = bias_mem[bias_addr];
    end

endmodule
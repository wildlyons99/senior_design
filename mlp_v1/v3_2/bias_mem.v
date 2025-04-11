module bias_mem
    (
        input wire clk,
        input wire reset,
        input wire[15:0] input_addr,
        output reg signed [7:0] bias_val
    );

    wire [5:0] bias_addr = input_addr[15:10];

    // 3 * 16 + 1 (maximum number of possible output neurons)
    reg signed [7:0] bias_mem[0:48];

    initial begin 
        bias_mem[0] = 2;
        bias_mem[1] = 2;
        bias_mem[2] = 2;
        bias_mem[3] = 2;

        bias_mem[16] = 2;
        bias_mem[17] = 2;
        bias_mem[18] = 2;
        bias_mem[19] = 2;

        bias_mem[32] = 2;
    end

    always @(posedge clk) begin
        if (reset) begin
            bias_val <= 0;
        end else begin
            bias_val <= bias_mem[bias_addr];
        end
    end

endmodule
module bias_mem
    (
        input wire clk,
        input wire reset,
        input wire[15:0] input_addr,
        output reg signed [7:0] bias_val
    );

    wire [6:0] bias_addr = input_addr[15:9];

    // 3 * 16 + 1 (maximum number of possible output neurons)
    reg signed [7:0] bias_mem[0:128];

    initial begin 
        // layer 1
        bias_mem[7'b0000000] <= 0;
        bias_mem[7'b0000001] <= 0;
        bias_mem[7'b0000010] <= 0;
        bias_mem[7'b0000011] <= 0;
        bias_mem[7'b0000100] <= 0;
        bias_mem[7'b0000101] <= 0;
        bias_mem[7'b0000110] <= 0;
        bias_mem[7'b0000111] <= 0;
        bias_mem[7'b0001000] <= 0;
        bias_mem[7'b0001001] <= 0;
        bias_mem[7'b0001010] <= 0;
        bias_mem[7'b0001011] <= 0;
        bias_mem[7'b0001100] <= 0;
        bias_mem[7'b0001101] <= 0;
        bias_mem[7'b0001110] <= 0;
        bias_mem[7'b0001111] <= 0;
        bias_mem[7'b0010000] <= 0;
        bias_mem[7'b0010001] <= 0;
        bias_mem[7'b0010010] <= 0;
        bias_mem[7'b0010011] <= 0;
        bias_mem[7'b0010100] <= 0;
        bias_mem[7'b0010101] <= 0;
        bias_mem[7'b0010110] <= 0;
        bias_mem[7'b0010111] <= 0;
        bias_mem[7'b0011000] <= 0;
        bias_mem[7'b0011001] <= 0;
        bias_mem[7'b0011010] <= 0;
        bias_mem[7'b0011011] <= 0;
        bias_mem[7'b0011100] <= 0;
        bias_mem[7'b0011101] <= 0;

        // layer 2
        bias_mem[7'b0100000] <= 0;
        bias_mem[7'b0100001] <= 0;
        bias_mem[7'b0100010] <= 0;
        bias_mem[7'b0100011] <= 0;
        bias_mem[7'b0100100] <= 0;
        bias_mem[7'b0100101] <= 0;
        bias_mem[7'b0100110] <= 0;
        bias_mem[7'b0100111] <= 0;
        bias_mem[7'b0101000] <= 0;
        bias_mem[7'b0101001] <= 0;
        bias_mem[7'b0101010] <= 0;
        bias_mem[7'b0101011] <= 0;
        bias_mem[7'b0101100] <= 0;
        bias_mem[7'b0101101] <= 0;
        bias_mem[7'b0101110] <= 0;
        bias_mem[7'b0101111] <= 0;

        // layer 3
        bias_mem[7'b1000000] <= 1;
        bias_mem[7'b1000001] <= 1;
        bias_mem[7'b1000010] <= 1;
        bias_mem[7'b1000011] <= 1;
        bias_mem[7'b1000100] <= 1;
        bias_mem[7'b1000101] <= 1;
        bias_mem[7'b1000110] <= 1;
        bias_mem[7'b1000111] <= 1;
        bias_mem[7'b1001000] <= 1;
        bias_mem[7'b1001001] <= 1;
    end

    always @(posedge clk) begin
        if (reset) begin
            bias_val <= 0;
        end else begin
            bias_val <= bias_mem[bias_addr];
        end
    end

endmodule
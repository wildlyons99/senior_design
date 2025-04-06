module softmax(
    input clk, 
    input done,
    input [15:0] in, 
    output reg finished, 
    output reg [15:0] result
);

initial begin
    result <= 0;
end

always @(negedge clk) begin
    if (done) begin
        result = in;
        finished = 1;
    end

    if (finished) begin
        finished = 0;
    end 
end

endmodule
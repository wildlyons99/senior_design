module multiply_unit 
    (   
        input wire clk,
        input wire reset,
        input wire signed [15:0] op1,
        input wire signed [7:0] op2,
        input wire signed [7:0] bias,
        output reg signed [15:0] out
    );

    reg signed [15:0] product;
    reg signed [15:0] sum;

    initial begin
        sum <= 0;
        product <= 0;
        out <= 0;
    end 

    always @(posedge clk) begin
        product = op1 * op2;

        if (reset) begin
            sum = 0 + product;
        end else begin
            sum = sum + product;
        end

        out = sum + bias;
    end
    
endmodule


// what to do in case of overflows???
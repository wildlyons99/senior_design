module relu 
    (   
        input wire signed [15:0] in,
        input wire signed [7:0] bias,
        output reg signed [15:0] out
    );

    always @* begin
        if ((in + bias) < 0)
            out = 0;
        else
            out = in;
    end

endmodule

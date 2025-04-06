module relu 
    (   
        input wire signed [15:0] in,
        output reg signed [15:0] out
    );

    always @* begin
        if (in < 0)
            out = 0;
        else
            out = in;
    end

endmodule

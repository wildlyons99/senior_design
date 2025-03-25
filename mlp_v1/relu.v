module control_unit 
    (   
        input reg [7:0] val,
        output reg [7:0] rectified_val
    );

    always @* begin
        if (val[7] == 0) begin
            rectified_val = val
        end else begin
            rectified_val = 8'b00000000;
        end
    end

endmodule

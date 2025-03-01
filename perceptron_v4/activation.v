// simple combinational activation function
// date comes from sequential logic

module activation (
    input  signed      [15:0] input_vector,
    output reg         prediction
);

// TODO add a clock (Potentially?)
always @(*) begin
    prediction = (input_vector > 16'd0) ? 1'b1 : 1'b0;
end

endmodule

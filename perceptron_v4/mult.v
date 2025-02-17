module mult (
    input  wire       clk,
    input  wire       reset,
    input  wire [7:0] image_data,
    input  wire [7:0] weight,
    output reg [15:0] product
);
    
    always @(posedge clk) begin
        if (reset)
            product <= 16'd0;
        else
            product <= image_data * weight;
    end
endmodule
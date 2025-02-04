(* dsp_pack = "yes" *)
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

// (* dsp_pack = "yes" *)
// module dual_mult (
//     input  wire       clk,
//     input  wire       reset,
//     input  wire [7:0] image_data0,
//     input  wire [7:0] weight0,
//     input  wire [7:0] image_data1,
//     input  wire [7:0] weight1,
//     output reg [15:0] product0,
//     output reg [15:0] product1
// );
//     always @(posedge clk) begin
//         if (reset) begin
//             product0 <= 16'd0;
//             product1 <= 16'd0;
//         end else begin
//             product0 <= image_data0 * weight0;
//             product1 <= image_data1 * weight1;
//         end
//     end
// endmodule

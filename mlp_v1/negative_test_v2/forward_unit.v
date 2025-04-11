module forward_unit
    (
        input wire clk, 
        input wire reset,
        input wire write_enable,
        input wire [11:0] input_addr,
        input wire [11:0] output_addr,
        input wire signed [15:0] forwarded_data,
        input wire signed [15:0] original_data,
        output reg signed [15:0] out
    );

    reg [11:0] prev_input_addr;
    reg newval;

    // initializing input layer
    initial begin
        out <= 0;

        prev_input_addr <= 0;
        newval <= 0;
    end

    always @(posedge clk) begin
        if (reset) begin
            out <= 0;
            prev_input_addr <= 0;
        end else begin 
            if (prev_input_addr == output_addr && write_enable) begin
                out <= forwarded_data;
                newval <= 1;
            end else begin
                out <= original_data;
                newval <= 0;
            end 

            prev_input_addr <= input_addr;
        end
    end

endmodule

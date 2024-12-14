module top (
    input [1:0] operate,
    output reg led
);
    // Internal signal
    wire clk;

    // Oscillator instantiation
    SB_HFOSC #(
        .CLKHF_DIV("0b00")
    ) osc (
        .CLKHFPU(1'b1),
        .CLKHFEN(1'b1),
        .CLKHF(clk)
    );

    // LED control logic
    always @(*) begin
        case (operate)
            // 2'b11: led = 1'b1;
            // 2'b10: led = clk;
            default: led = 1'b1;
        endcase
    end
endmodule

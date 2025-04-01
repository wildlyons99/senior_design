module vga (
    input wire       clk, // 25Hz
    output wire      HSYNC, 
    output wire      VSYNC, 
    output wire      valid, 
    output reg [9:0] row, 
    output reg [9:0] col
);

    always @(posedge clk) begin
        // Row logic: counts 0-799 (800 total cols), then increments row
        if (col == 799) begin
            col <= 0;

            if (row == 524) begin
                row <= 0;
            end else begin
                row <= row + 1;
            end

        end else begin
            col <= col + 1;
        end
    end
    
    // HORIZONTAL: Visible from 0-639 pixels. Front porch 640-655 pixels. 
    // HSYNC 656-751 pixels. Back porch 752-799
    // HSYNC is low during the sync time, otherwise high
    assign HSYNC = (col >= 656) && (col <= 751);

    // VERTICAL: Visible during 0-479 rows. Then front porch 480-489 rows. 
    // Then VSYNC 490-491 rows. Then back porch 492-524 rows.
    // VSYNC is low during sync time, otherwise high
    assign VSYNC = (row <= 490) || (row >= 492);

    assign valid = (row <= 479) && (col <= 639);
    
endmodule
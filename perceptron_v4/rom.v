module rom (
    input  wire       clk,
    input  wire [7:0] image_address, // Not used in this simple example
    output reg  [16*8-1:0] output_array  // 16 bytes = 128 bits
);
    // Create a one-dimensional memory with 16 bytes.
    reg [7:0] rom_mem [0:15];
    integer i;

    // Initialize the memory from an external file.
    // The file should contain 16 hexadecimal numbers (one per line).
    initial begin
        $readmemh("rom_data.mem", rom_mem);
    end

    // On each clock, pack the 16 bytes into the flat output vector.
    always @(posedge clk) begin
        for (i = 0; i < 16; i = i + 1) begin
            // Each byte occupies 8 bits. Element 0 appears in bits [7:0].
            output_array[8*i+7 -: 8] <= rom_mem[i];
        end
    end
endmodule


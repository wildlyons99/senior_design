module perceptron_v3 (
    input  wire       clk_12MHz,
    input  wire [7:0] image_address,
    output wire [6:0] prediction
);

    parameter NUM_MULTS = 16;

    // (the ROM output): a flat vector of 16 bytes (128 bits)
    wire [NUM_MULTS*8-1:0] rom_data_flat;

    // Used to detect changes in image_address for generating reset
    reg [7:0]   prev_image_address = 8'd0;
    reg         rst = 1'b0;
    
    // Instantiate the ROM
    rom my_rom (
        .clk(clk_12MHz),
        .image_address(image_address),
        .output_array(rom_data_flat)
    );
    
    // Define weights as a flattened 128-bit constant.
    // The least-significant byte (bits [7:0]) is for mult0.
    reg [NUM_MULTS * 8 - 1:0] weights;
    initial begin
        weights = {8'b01001000, 8'b11101000, 8'b11001111, 8'b00100010,
                        8'b11000001, 8'b11111010, 8'b11101010, 8'b10111101,
                        8'b11010111, 8'b00010111, 8'b11101100, 8'b01001001,
                        8'b01010101, 8'b00010000, 8'b00011101, 8'b00111010};
        // Note: The weight for mult15 is at the MSB
        //       and the weight for mult0 is in bits [7:0].
    end
    
    // Instantiate 16 mult modules.
    // Each mult gets an 8-bit slice of the ROM data and the weights.
    wire [15:0] product [0:NUM_MULTS-1];

    always @(posedge clk) begin
        if (prev_image_address != image_address)
            rst <= 1'b1;
        else
            rst <= 1'b0;
        prev_image_address <= image_address;
    end
    
    genvar i;
    generate
        for (i = 0; i < NUM_MULTS; i = i + 1) begin : mult_array
            wire [7:0] image_byte;
            wire [7:0] weight;
            
            // Extract the i-th 8-bit slice.
            // Element 0 is in bits [7:0], element 1 in [15:8], etc.
            assign image_byte = rom_data_flat[8 * i + 7 : 8 * i];
            assign weight     = weights[8 * i + 7 : 8 * i];
            
            mult p_inst (
                .clk(clk_12MHz),
                .reset(rst),
                .image_data(image_byte),
                .weight(weight),
                .product(product[i])
            );
        end
    endgenerate

    // combinational sum
    // Sum all of the 16-bit products and add a bias of 16'h0800.
    // Note: 16 mult products can sum to more than 16 bits.i
    reg [21:0] dot_sum; // use a 22-bit register for the sum.
    integer j;
    always @(*) begin
        dot_sum = 22'd0;
        for (j = 0; j < NUM_MULTS; j = j + 1) begin
            dot_sum = dot_sum + product[j];
        end
        dot_sum = dot_sum + 16'h0800;  // Add bias.
    end

    // For the activation function, we pass the lower 16 bits of the sum.
    wire [15:0] activation_input;
    assign activation_input = dot_sum[15:0];

    //-------------------------------------------------------------------------
    // Activation Module and Seven-Segment Display
    //-------------------------------------------------------------------------
    // The activation module produces a 1-bit prediction from the 16-bit input.
    wire prediction_bit;
    activation activator (
        .input_vector(activation_input),
        .prediction(prediction_bit)
    );
    
    wire [3:0] result_to_sevseg;
    assign result_to_sevseg = {3'b000, prediction_bit};
    
    sevenseg seven_map (
        .S(result_to_sevseg),
        .segments(prediction)
    );
    
endmodule
`timescale 1ns / 1ps

module top
#(
    parameter CLK_FREQ = 25000000
)
(
    input  wire clk_12MHz,
    input  wire start, // active low when pressed

    // Camera Inputs
    input  wire CAMERA_VSYNC_IN,
    input  wire CAMERA_HREF_IN,
    input  wire [7:0] CAMERA_DATA_IN,
    input  wire CAMERA_PCLOCK,
    output wire sioc,
    output wire siod,
    output wire done,
    output wire frame_done,
    output wire pixel_valid,
    
    output wire [1:0] debug_state,
    
    // VGA Outputs 
    output wire [5:0]   RGB, 
    output wire         VGA_HSYNC,
    output wire         VGA_VSYNC,
	output wire 		clk_25MHz,
	
	output wire 		TEST
);
	
    
    // SCCB Configuration signals
    wire [7:0] rom_addr;
    wire [15:0] rom_dout;
    wire [7:0] SCCB_addr;
    wire [7:0] SCCB_data;
    wire SCCB_start;
    wire SCCB_ready;
    wire SCCB_SIOC_oe;
    wire SCCB_SIOD_oe;
	reg start_config;
    
    assign sioc = SCCB_SIOC_oe ? 1'b0 : 1'bZ;
    assign siod = SCCB_SIOD_oe ? 1'b0 : 1'bZ;
    
    // Clock and VGA timing signals
    wire valid; 
    wire [9:0] row; 
    wire [9:0] col; 
	
	// Camera reader outputs
    wire [15:0] pixel_data;

    // SPRAM interface signals
    reg WR; 
    reg  [15:0] address_counter; // used to build the SPRAM address for capture
    reg  [15:0] spram_data_in;
    wire [15:0] data_out;
    reg  [3:0] spram_maskwe; // dynamic write mask for SPRAM.
	
	reg pixel_toggle; 
    
    // Instantiate the configuration ROM, configuration module and SCCB interface
    OV7670_config_rom rom1(
        .clk(clk_25MHz),
        .addr(rom_addr),
        .dout(rom_dout)
    );
    
	// configure camera
    OV7670_config #(
        .CLK_FREQ(CLK_FREQ)
    ) 
    config_1(
        .clk(clk_25MHz),
        .SCCB_interface_ready(SCCB_ready),
        .rom_data(rom_dout),
		.start(start_config),
        .rom_addr(rom_addr),
        .done(done),
        .SCCB_interface_addr(SCCB_addr),
        .SCCB_interface_data(SCCB_data),
        .SCCB_interface_start(SCCB_start)
    );
    
    SCCB_interface #( 
        .CLK_FREQ(CLK_FREQ)
    ) SCCB1(
        .clk(clk_25MHz),
        .start(SCCB_start),
        .address(SCCB_addr),
        .data(SCCB_data),
        .ready(SCCB_ready),
        .SIOC_oe(SCCB_SIOC_oe),
        .SIOD_oe(SCCB_SIOD_oe)
    );
    
	// pll
    mypll my_pll(
        .ref_clk_i(clk_12MHz), 
        .rst_n_i(1'b1),
        .outcore_o(clk_25MHz),
        .outglobal_o()
    );
    
    camera_read reader(
        .p_clock(CAMERA_PCLOCK),
        .vsync(CAMERA_VSYNC_IN),
        .href(CAMERA_HREF_IN),
        .p_data(CAMERA_DATA_IN),
        .pixel_data(pixel_data),
        .pixel_valid(pixel_valid),
        .frame_done(frame_done)
    );
    
    // VGA module instantiation
    vga vga_inst (
         .clk(clk_25MHz),
         .HSYNC(VGA_HSYNC),
         .VSYNC(VGA_VSYNC),
         .valid(valid),
         .row(row),
         .col(col)
    );
     
    // FSM definition
    localparam CONFIG     = 3'b000,
			   IDLE       = 3'b001,
               WAIT_FRAME = 3'b010,
               CAPTURE    = 3'b011,
               COMPLETE   = 3'b100;
               
    reg [2:0] fsm_state = CONFIG;
	
	reg start_prev;
    reg prev_pixel_valid;
    
	
	// Split into module select and local address:
    wire [1:0] write_spram_select = address_counter[15:14];      // 2-bit module selector
    wire [13:0] write_local_addr = address_counter[13:0];        // Address within a module
 
 
	wire [15:0] vga_read_address;
	wire [1:0] read_spram_select;
    //assign vga_read_address = ((row >> 1) * (320 >> 1)) + (col >> 1);
	assign vga_read_address = ((row) * (640 >> 1)) + (col); // vga 
    assign read_spram_select = vga_read_address[15:14];
	
	wire [13:0] vga_local_address = vga_read_address[13:0];
 
    
    // Multiplexer for the SPRAM address:
    // Use write address when writing, read addr when reading
    wire [13:0] spram_addr;
    assign spram_addr = (fsm_state == COMPLETE) ? vga_local_address : write_local_addr;
	
	
	wire WR0, WR1, WR2;
    assign WR0 = (write_spram_select == 2'b00) ? WR : 1'b0;
    assign WR1 = (write_spram_select == 2'b01) ? WR : 1'b0;
    assign WR2 = (write_spram_select == 2'b10) ? WR : 1'b0;
	
	wire [15:0] data_out0, data_out1, data_out2;
    
    // SP256K SPRAM instance (single-port):
    SP256K SPRAM0 (
      .AD       (spram_addr),     // Address: multiplexed between capture and read modes
      .DI       (spram_data_in),  // Data input for writing
      .MASKWE   (spram_maskwe),  
      .WE       (WR0),             // Write enable active during capture
      .CS       (1'b1),  
      .CK       (clk_25MHz),  
      .STDBY    (1'b0),  
      .SLEEP    (1'b0),  
      .PWROFF_N (1'b1),  
      .DO       (data_out0)        // Data output for VGA read mode
    ); 
	
	// SP256K SPRAM instance (single-port):
    SP256K SPRAM1 (
      .AD       (spram_addr),     // Address: multiplexed between capture and read modes
      .DI       (spram_data_in),  // Data input for writing
      .MASKWE   (spram_maskwe),  
      .WE       (WR1),             // Write enable active during capture
      .CS       (1'b1),  
      .CK       (clk_25MHz),  
      .STDBY    (1'b0),  
      .SLEEP    (1'b0),  
      .PWROFF_N (1'b1),  
      .DO       (data_out1)        // Data output for VGA read mode
    ); 
	
	// SP256K SPRAM instance (single-port):
    SP256K SPRAM2 (
      .AD       (spram_addr),     // Address: multiplexed between capture and read modes
      .DI       (spram_data_in),  // Data input for writing
      .MASKWE   (spram_maskwe),  
      .WE       (WR2),             // Write enable active during capture
      .CS       (1'b1),  
      .CK       (clk_25MHz),  
      .STDBY    (1'b0),  
      .SLEEP    (1'b0),  
      .PWROFF_N (1'b1),  
      .DO       (data_out2)        // Data output for VGA read mode
    ); 
	
	// When in read mode (fsm_state == COMPLETE) the global VGA read address selects
    // which module’s data output to use.
	reg [15:0] muxed_data_out;
    always @(*) begin
      case (vga_read_address[15:14])
        2'b00: muxed_data_out = data_out0;
        2'b01: muxed_data_out = data_out1;
        2'b10: muxed_data_out = data_out2;
        default: muxed_data_out = 16'd0;
      endcase
    end
    
    // Main State Machine: Button control and frame capture
    always @(posedge clk_25MHz) begin 
		
        case (fsm_state)
            CONFIG: begin
				// wait for SCCB to be ready
				if (~SCCB_ready) begin
					start_config <= 1'b1; 
				end else begin 
					start_config <= 1'b0; 
					fsm_state <= IDLE;
					
				end
					
			end
			IDLE: begin
				start_prev <= start;
				
				// Wait for the start button to be pressed (active low)
                WR <= 0;
                address_counter <= 0;
				
                spram_data_in <= 16'hFFFF; // default value
				 pixel_toggle <= 1'b0;     // First pixel goes to upper half
                prev_pixel_valid <= 0;
                if (start_prev && !start) begin
                    fsm_state <= WAIT_FRAME;
                end
            end
            
            WAIT_FRAME: begin
                // Button pressed; now wait until a new frame starts.
                // Here we assume that CAMERA_VSYNC_IN going high indicates the start of a new frame.
                WR <= 0;
                address_counter <= 0;
                if (CAMERA_VSYNC_IN) begin
                    fsm_state <= CAPTURE;
                end
            end
            
            CAPTURE: begin
                // Grab pizel on rising edge of pixel_valid
                if (pixel_valid && ~prev_pixel_valid) begin
                    WR <= 1;
                    if (pixel_toggle == 1'b0) begin
                        // Place first pixel is MSB
                        spram_data_in <= {pixel_data[7:0], 8'b0};
						// Write mask: update DATAIN(15:8) only.
                        spram_maskwe <= 4'b1100;
                    end
                    else begin
                        // Place the pixel into the lower 8 bits.
                        spram_data_in <= {8'b0, pixel_data[7:0]};
                        // Write mask: update DATAIN(7:0) only.
                        spram_maskwe <= 4'b0011;
                        
						// increment the address after both halves have been added.
                        address_counter <= address_counter + 1;
                    end
                    // Toggle for next pixel
                    pixel_toggle <= ~pixel_toggle;
                end
                prev_pixel_valid <= pixel_valid;
                
				//if (address_counter[15:14] == 2'b11)
                    //fsm_state <= COMPLETE;
					
				if (address_counter == 38399) // 320 * 240 / 2 - 1
                    fsm_state <= COMPLETE;
            end
            
            COMPLETE: begin
				start_prev <= start;
                // In COMPLETE: Stop capturing. The VGA will now read from SPRAM 
                WR <= 0;
                // Remain in COMPLETE until new capture sequence.
				if (start_prev && !start) begin
                    fsm_state <= WAIT_FRAME;
                end
            end
            
            default: fsm_state <= IDLE; 
        endcase
    end
    
    // VGA Output Logic:
    // If the frame is not yet captured (IDLE/WAIT_FRAME/CAPTURE), output red.
    // When capture is complete, display the stored image from SPRAM.
	
	wire pixel_select = col[1];  // even vs odd column on the 640-pixel line
	wire [1:0] grayscale_value = pixel_select ? muxed_data_out[7:6] : muxed_data_out[15:14];
	
	
    assign RGB = valid ? ((fsm_state == COMPLETE) ? 
						 {grayscale_value, grayscale_value, grayscale_value} :
                         ((fsm_state == WAIT_FRAME) ? 6'b111100 : 6'b110000)) : 
						 6'b000000;
	   
	assign debug_state = fsm_state;

     
endmodule

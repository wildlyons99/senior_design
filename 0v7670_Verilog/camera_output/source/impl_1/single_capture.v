`timescale 1ns / 1ps
// Revised top-level module for capturing a frame on button press
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

	
    
    // SCCB/Configuration signals
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
    //wire clk_25MHz;
    wire valid; 
    wire [9:0] row; 
    wire [9:0] col; 

    // SPRAM interface signals
    reg WR; 
    reg [15:0] address_counter; // used to build the SPRAM address for capture
    reg [15:0] spram_data_in;
    wire [15:0] data_out;
    
    // Camera reader outputs
    wire [15:0] pixel_data;
    
    // Instantiate the configuration ROM, configuration module and SCCB interface (unchanged)
    OV7670_config_rom rom1(
        .clk(clk_25MHz),
        .addr(rom_addr),
        .dout(rom_dout)
    );
        
    OV7670_config #(
        .CLK_FREQ(CLK_FREQ)
    ) 
    config_1(
        .clk(clk_25MHz),
        .SCCB_interface_ready(SCCB_ready),
        .rom_data(rom_dout),
        //.start(~start),  // note: inverted if your configuration expects active high
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
    
    // For edge detection on pixel_valid
    reg prev_pixel_valid;
    
    // Compute the VGA read address based on QVGA (using 160 columns)
    // This implements: address = row * 160 + col.
    // (Assuming that 'row' and 'col' are limited to the QVGA display region.)
    wire [13:0] vga_read_address;
	wire [15:0] vga_read_address_raw;
    assign vga_read_address_raw = ((row >> 0) * 320) + (col >> 0);
	
	assign vga_read_address = (vga_read_address_raw < 16000) ? vga_read_address_raw : (14'd0); 
    
    // Multiplexer for the SPRAM address:
    // While capturing, use the lower 14 bits of address_counter.
    // After capture, use the VGA read address.
    wire [13:0] spram_addr;
    assign spram_addr = (fsm_state == COMPLETE) ? vga_read_address : 
		                 (address_counter < 16000) ? address_counter[13:0] : (14'd0);
    
    // SP256K SPRAM instance (assumed single-port):
    SP256K SPRAM1 (
      .AD       (spram_addr),     // Address: multiplexed between capture and read modes
      .DI       (spram_data_in),  // Data input for writing
      .MASKWE   (4'b1111),  
      .WE       (WR),             // Write enable active during capture
      .CS       (1'b1),  
      .CK       (clk_25MHz),  
      .STDBY    (1'b0),  
      .SLEEP    (1'b0),  
      .PWROFF_N (1'b1),  
      .DO       (data_out)        // Data output for VGA read mode
    ); 
    
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
                // Capture frame data from the camera.
                // Write a pixel each time pixel_valid rises.
                if (pixel_valid && ~prev_pixel_valid) begin
                    WR <= 1;
                    // Store the upper 8 bits (modify if you wish to store more)
                    spram_data_in <= pixel_data[15:8];
                    address_counter <= address_counter + 1;
                end 
				//else begin
                    //WR <= 0;
                //end
                prev_pixel_valid <= pixel_valid;
                
                // When frame capture is complete, detected by 'frame_done',
                // transition to COMPLETE state.
                //if (frame_done) begin
                    //fsm_state <= COMPLETE;
                //end
				if (address_counter[14]) begin
					fsm_state <= COMPLETE;
				end 
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
    assign RGB = valid ? ((fsm_state == COMPLETE) ? {data_out[7:6], data_out[7:6], data_out[7:6]} :
                         ((fsm_state == WAIT_FRAME) ? 6'b111100 : 6'b110000)) : 
						 6'b000000;
	   
	   
	assign debug_state = fsm_state;

     
endmodule

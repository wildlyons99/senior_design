module top
#(
    parameter CLK_FREQ = 25000000, 
	parameter VGA_WIDTH  = 640,
    parameter VGA_HEIGHT = 480
)
(
    input  wire clk_12MHz,
    input  wire start, // active low when pressed

    // Camera Inputs
    input  wire CAMERA_VSYNC_IN,
    input  wire CAMERA_HREF_IN,
    input  wire [7:0] CAMERA_DATA_IN,
    input  wire CAMERA_PCLOCK,
    
    output wire [1:0] debug_state,
    
    // VGA Outputs 
    output wire [5:0]   RGB, 
    output wire         VGA_HSYNC,
    output wire         VGA_VSYNC,
	output wire 		clk_25MHz
);	

	// FSM definition
    localparam CONFIG     = 3'b000,
			   IDLE       = 3'b001,
               WAIT_FRAME = 3'b010,
               CAPTURE    = 3'b011,
               COMPLETE   = 3'b100;
			   
	reg [2:0] fsm_state = CONFIG; // initialize state to 3'b000 - happens already on fpga

	// Clock and VGA timing signals
    wire valid; 
    wire [9:0] row; 
    wire [9:0] col; 
	
	// Camera reader outputs
    wire [15:0] pixel_data;
	wire frame_done;
    wire pixel_valid; 
    
	
    ////////////////////////////////////////
	////////// Module instantiations ///////
	////////////////////////////////////////
	// pll
    mypll my_pll(
        .ref_clk_i(clk_12MHz), 
        .rst_n_i(1'b1),
        .outcore_o(clk_25MHz),
        .outglobal_o()
    );	
    
	// read camera data 
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
	
	
	
	////////////////////////////////
	/////////// SPRAM //////////////
	////////////////////////////////
	
	// SPRAM interface signals
	// bit addressable address
	wire [19:0] spram_address; // 14 bit addr line, 2 bit spram sel, 4 bit bit select
    wire [13:0] local_spram_address = spram_address[17:4]; 
	
	reg  [15:0] spram_data_in;
    wire [15:0] spram_data_out;
	
	wire [1:0] spram_block_select = spram_address[19:18]; 
	
	reg WR; 
	wire WR0, WR1, WR2, WR3;
    assign WR0 = (spram_block_select == 2'b00) ? WR : 1'b0;
    assign WR1 = (spram_block_select == 2'b01) ? WR : 1'b0;
    assign WR2 = (spram_block_select == 2'b10) ? WR : 1'b0;
	assign WR3 = (spram_block_select == 2'b11) ? WR : 1'b0;
	
	
	wire [19:0] read_address; 
	reg  [19:0] write_address; 
	assign spram_address = (fsm_state == COMPLETE) ? read_address : write_address;

	assign read_address  = (row * 640) + col; // vga 
	// write address is assigned while writing in fsm 
	
	
	wire [15:0] data_out0, data_out1, data_out2, data_out3;
	assign spram_data_out = (spram_block_select == 2'b00) ? data_out0 :
                            (spram_block_select == 2'b01) ? data_out1 :
                            (spram_block_select == 2'b10) ? data_out2 :
                          /* spram_block_select == 2'b11 */ data_out3;
	
	
	// SP256K SPRAM instance (single-port):
    SP256K SPRAM0 (
      .AD       (local_spram_address), // Address: multiplexed between capture and read modes
      .DI       (spram_data_in),       // Data input for writing
      .MASKWE   (4'b1111),              // write to all bits of 16 bit word
      .WE       (WR0),                 // Write enable active during capture
      .CS       (1'b1),  
      .CK       (clk_25MHz),  
      .STDBY    (1'b0),  
      .SLEEP    (1'b0),  
      .PWROFF_N (1'b1),  
      .DO       (data_out0)            // Data output for VGA read mode
    ); 
	
	SP256K SPRAM1 (
      .AD       (local_spram_address), // Address: multiplexed between capture and read modes
      .DI       (spram_data_in),       // Data input for writing
      .MASKWE   (4'b1111),  		       // write to all bits of 16 bit word
      .WE       (WR1),                 // Write enable active during capture
      .CS       (1'b1),  
      .CK       (clk_25MHz),  
      .STDBY    (1'b0),  
      .SLEEP    (1'b0),  
      .PWROFF_N (1'b1),  
      .DO       (data_out1)            // Data output for VGA read mode
    ); 
	
	SP256K SPRAM2 (
      .AD       (local_spram_address), // Address: multiplexed between capture and read modes
      .DI       (spram_data_in),       // Data input for writing
      .MASKWE   (4'b1111),  		       // write to all bits of 16 bit word
      .WE       (WR2),                 // Write enable active during capture
      .CS       (1'b1),  
      .CK       (clk_25MHz),  
      .STDBY    (1'b0),  
      .SLEEP    (1'b0),  
      .PWROFF_N (1'b1),  
      .DO       (data_out2)            // Data output for VGA read mode
    ); 
	
	SP256K SPRAM3 (
      .AD       (local_spram_address), // Address: multiplexed between capture and read modes
      .DI       (spram_data_in),       // Data input for writing
      .MASKWE   (4'b1111),  		       // write to all bits of 16 bit word
      .WE       (WR3),                 // Write enable active during capture
      .CS       (1'b1),  
      .CK       (clk_25MHz),  
      .STDBY    (1'b0),  
      .SLEEP    (1'b0),  
      .PWROFF_N (1'b1),  
      .DO       (data_out3)             // Data output for VGA read mode
    ); 
	
	
	
	///////////////////////////////////////////
	////////// Finite State Machine /////////// 
	///////////////////////////////////////////
	// previous button state for rising edge detection
	reg start_prev;
	
	// previous "pixel valid" state 
    reg prev_pixel_valid;
	
	// Registers for threshold accumulation
	reg [15:0] pixel_accum = 16'd0;  // 16-bit accumulator for threshold bits
	reg [3:0]  bit_count   = 4'd0;   // Counter: 0 to 15
    
    // state machine - frame capture 
    always @(posedge clk_25MHz) begin 
		
        case (fsm_state)
            CONFIG: begin
				// doesn't do anything rn with no SCCB - can delete later 
				fsm_state <= IDLE;

			end
			IDLE: begin
				start_prev <= start;
				
				// initialize to start of SPRAM 
                WR <= 0;
                write_address <= 0;
				
                //spram_data_in <= 16'hFFFF; // default value
				// pixel_toggle <= 1'b0;     // First pixel goes to upper half
                prev_pixel_valid <= 0;
                
				// wait for the start button to be pressed (active low)
				if (start_prev && !start) begin
                    fsm_state <= WAIT_FRAME;
                end
            end
            
            WAIT_FRAME: begin
                // Button pressed - now wait until a new frame starts.
                // CAMERA_VSYNC_IN going high indicates the start of a new frame.
                WR <= 0;
                write_address <= 0;
                if (CAMERA_VSYNC_IN) begin
                    fsm_state <= CAPTURE;
                end
            end
            
            CAPTURE: begin
                prev_pixel_valid <= pixel_valid;
				if (pixel_valid && !prev_pixel_valid) begin
					
					if (bit_count == 4'd15) begin
						// For the 16th pixel, update accumulator with the MSB bit.
						// the current sample forms bit 15 (MSB) via a left shift.
						spram_data_in <= pixel_accum | (((pixel_data[7:0] > 8'd128) ? 1'b1 : 1'b0) << bit_count);
						WR <= 1; //  SPRAM write.
						
						write_address <= write_address + 1;
						
						// Reset for the next 16-bit word.
						bit_count <= 0;
						pixel_accum <= 16'd0;
					end else begin
						// For pixels 1 to 15, store the threshold bit at the proper position.
						pixel_accum <= pixel_accum | (((pixel_data[7:0] > 8'd128) ? 1'b1 : 1'b0) << bit_count);
						bit_count <= bit_count + 1;
						WR <= 0;
					end
					
				end else begin
					WR <= 0; // Ensure WR is low when no new pixel is processed.
				end
			
					
				if (write_address >= 307199) // (VGA_WIDTH * VGA_HEIGHT) - 1
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
    // Waiting for button press:              output red.
	// Waiting for frame start in WAIT_FRAME: output yellow
    // When capture is complete, display the stored image from SPRAM.
	wire grayscale_value = spram_data_out[spram_address[3:0]]; 
	
	
    assign RGB = valid ? ((fsm_state == COMPLETE) ? 
						 {grayscale_value, grayscale_value, grayscale_value, grayscale_value, grayscale_value, grayscale_value} :
                         ((fsm_state == WAIT_FRAME) ? 6'b111100 : 6'b110000)) : 
						 6'b000000;
	   
	assign debug_state = fsm_state;

     
endmodule

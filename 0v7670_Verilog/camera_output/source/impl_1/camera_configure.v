`timescale 1ns / 1ps
// https://www.eevblog.com/forum/microcontrollers/lattice-radiant-for-ice40up-fpga-series/25/

module top
#(
	parameter CLK_FREQ=25000000
)
(
	input  wire clk_12MHz,
	input  wire start,
	
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
	
	output reg TEST,
	
	// VGA Outputs 
	output wire [5:0]   RGB, 
	output wire         VGA_HSYNC,
	output wire         VGA_VSYNC
	//output wire [6:0]   seven_seg_out

);
    
    wire [7:0] rom_addr;
    wire [15:0] rom_dout;
    wire [7:0] SCCB_addr;
    wire [7:0] SCCB_data;
    wire SCCB_start;
    wire SCCB_ready;
    wire SCCB_SIOC_oe;
    wire SCCB_SIOD_oe;
	wire fast_clk;
    
    assign sioc = SCCB_SIOC_oe ? 1'b0 : 1'bZ;
    assign siod = SCCB_SIOD_oe ? 1'b0 : 1'bZ;
	
	wire clk_25MHz;
	wire valid; 
	wire [9:0] row; 
	wire [9:0] col; 
	
	// SPRAM 
	reg WR; 
	
	// Register to hold the previous state of 'start'
    reg start_prev;
	reg [13:0] spram_address_in;
	reg [15:0] spram_data_in;
	wire [15:0] data_out;
	
	// Camera reader outputs
	//wire pixel_valid;
	wire [15:0] pixel_data;
	//wire frame_done;
	
	wire vga_output; 
    
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
        .start(~start),
        .rom_addr(rom_addr),
        .done(done),
        .SCCB_interface_addr(SCCB_addr),
        .SCCB_interface_data(SCCB_data),
        .SCCB_interface_start(SCCB_start)
    );
    
    SCCB_interface #( 
		.CLK_FREQ(CLK_FREQ)) SCCB1(
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
	
	// Instantiate the VGA module
     vga vga_inst (
         .clk(clk_25MHz),
         .HSYNC(VGA_HSYNC),
         .VSYNC(VGA_VSYNC),
         .valid(valid),
         .row(row),
         .col(col)
     );
	 //wire [5:0] temp; 
	 //pattern_gen map_rgb(
		 //.clk(clk_25MHz),
		 //.y(row),
		 //.x(col),
		 //.RGB(RGB) 
	 //); 
	 
	SP256K SPRAM1 (
	  .AD       (spram_address_in),  // I
	  .DI       (spram_data_in),  // I
	  .MASKWE   (4'b1111),  // I
	  .WE       (WR),  // I
	  .CS       (1'b1),  // I
	  .CK       (clk_25MHz),  // I
	  .STDBY    (1'b0),  // I
	  .SLEEP    (1'b0),  // I
	  .PWROFF_N (1'b1),  // I
	  .DO       (data_out)   // O
	); 
	
	// seven seg 
	//sevenseg count_display ( 
		//.S(address_out[3:0]),
		//.segments(seven_seg_out)
	//); 

	//assign RGB = valid ? ((col > 240) ? data_out[5:0] : 6'b000011): 6'b000000; 
	//reg [2:0] count;
     //Edge detection and counter update
    //always @(posedge clk_25MHz) begin
		 //Update previous state 
		//spram_address_in <= 0;
		//start_prev <= start;
		//WR <= 0; 
		//RGB <= data_out[5:0]; 
		//RGB <= 6'b000011;
		 //Check for rising edge: current 'start' is high and previous was low
		//if (!start && start_prev) begin
			//count <= count + 1;
            //WR <= 1; 
			//RGB <= 6'b110000;
        //end
    //end
	
	// Create state names
	localparam  INIT = 2'b00,
				WAIT_FOR_PIXEL_VALID = 2'b01,
				UPDATE_SPRAM = 2'b10;
		
	reg [1:0] STATE = INIT;
	
	// Spram address counter
	reg [15:0] address_counter;
	
	reg prev_pixel_valid;
	
	always @(posedge clk_25MHz) begin
		case(STATE)
			INIT:begin
				//Begin I2C Communication
				//Reset SPRAM Address Counter
				//Loading Screen Graphic????
				prev_pixel_valid <= 0;
				address_counter <= 0;
				WR <= 0;
				spram_data_in <= 8'b11111111;
				spram_address_in <= 0;
				if (done) begin
					STATE <= WAIT_FOR_PIXEL_VALID;
				end
			end
			
			WAIT_FOR_PIXEL_VALID: begin
				//Set Spram read
				//Wait for pixel_valid to go high
				WR <= 0;
				address_counter <= frame_done ? 0 : address_counter;
				if (pixel_valid && !prev_pixel_valid) STATE <= UPDATE_SPRAM;
				prev_pixel_valid <= pixel_valid;
			end
			
			UPDATE_SPRAM:begin
				//Set Spram write
				//Write most significant 8 bits of camera data
				//Increment address counter
				WR <= 1;
				spram_data_in <= pixel_data[15:8];
				spram_address_in <= address_counter[13:0];
				address_counter <= address_counter + 1;
				STATE <= WAIT_FOR_PIXEL_VALID;
			end
		endcase
	end
	
	// convert greyscale to RGB using the most significant 2 bits of greyscale for R, G, and B
	//assign vga_output = address_counter[14] ? 6'b000000 : (data_out[7:6] & data_out[7:6] & data_out[7:6]);
	assign vga_output = address_counter[14] ? 6'b000000 : data_out;
	//assign color
	assign RGB = valid ? vga_output : 6'b000000;
	 
    
endmodule

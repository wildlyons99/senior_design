`timescale 1ns / 1ps
module camera_configure
    #(
    parameter CLK_FREQ=25000000
    )
    (
    input wire clk,
    input wire start,
	input wire vsync_in,
	input wire href_in,
	input wire [7:0] data_in,
    output wire sioc,
    output wire siod,
    output wire done,
	output wire frame_done,
	output wire pixel_valid,
	output wire clk_25MHz,
	
	output wire TEST
    );
    
    wire [7:0] rom_addr;
    wire [15:0] rom_dout;
    wire [7:0] SCCB_addr;
    wire [7:0] SCCB_data;
    wire SCCB_start;
    wire SCCB_ready;
    wire SCCB_SIOC_oe;
    wire SCCB_SIOD_oe;
    
    assign sioc = SCCB_SIOC_oe ? 1'b0 : 1'bZ;
    assign siod = SCCB_SIOD_oe ? 1'b0 : 1'bZ;
	
	reg prev_start;
	reg [5:0] pulse_counter;
	reg config_trig;

	assign TEST = SCCB_start;

	always @(posedge clk_25MHz) begin
		if (prev_start && !start) begin
			config_trig <= 1;
			pulse_counter <= 63; // number of cycles to keep the pulse high
		end
		else if (pulse_counter != 0) begin
			pulse_counter <= pulse_counter - 1;
			config_trig <= 1; // remain high
		end
		else begin
			config_trig <= 0;
		end
			
		prev_start <= start;
	end

	
    
    OV7670_config_rom rom1(
        .clk(clk_25MHz),
        .addr(rom_addr),
        .dout(rom_dout)
        );
        
    OV7670_config #(.CLK_FREQ(CLK_FREQ)) config_1(
        .clk(clk_25MHz),
        .SCCB_interface_ready(SCCB_ready),
        .rom_data(rom_dout),
        .start(config_trig),
        .rom_addr(rom_addr),
        .done(done),
        .SCCB_interface_addr(SCCB_addr),
        .SCCB_interface_data(SCCB_data),
        .SCCB_interface_start(SCCB_start)
        );
    
    SCCB_interface #( .CLK_FREQ(CLK_FREQ)) SCCB1(
        .clk(clk_25MHz),
        .start(SCCB_start),
        .address(SCCB_addr),
        .data(SCCB_data),
        .ready(SCCB_ready),
        .SIOC_oe(SCCB_SIOC_oe),
        .SIOD_oe(SCCB_SIOD_oe)
        );
		
	mypll cory_pll(.ref_clk_i(clk),
        .rst_n_i(1),
        .outcore_o(clk_25MHz),
        .outglobal_o()
		);
		
	//camera_read reader(.p_clock(clk_25MHz),
		//.vsync(vsync_in),
		//.href(href_in),
		//.p_data(data_in),
		//.pixel_data(),
		//.pixel_valid(pixel_valid),
		//.frame_done(frame_done)
		//);
    
endmodule

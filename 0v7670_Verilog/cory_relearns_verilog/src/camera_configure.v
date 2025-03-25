`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2015 10:20:20 AM
// Design Name: 
// Module Name: camera_configure
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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
	output wire test_clk
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
	
	assign test_clk = fast_clk;
    
    OV7670_config_rom rom1(
        .clk(fast_clk),
        .addr(rom_addr),
        .dout(rom_dout)
        );
        
    OV7670_config #(.CLK_FREQ(CLK_FREQ)) config_1(
        .clk(fast_clk),
        .SCCB_interface_ready(SCCB_ready),
        .rom_data(rom_dout),
        .start(start),
        .rom_addr(rom_addr),
        .done(done),
        .SCCB_interface_addr(SCCB_addr),
        .SCCB_interface_data(SCCB_data),
        .SCCB_interface_start(SCCB_start)
        );
    
    SCCB_interface #( .CLK_FREQ(CLK_FREQ)) SCCB1(
        .clk(fast_clk),
        .start(SCCB_start),
        .address(SCCB_addr),
        .data(SCCB_data),
        .ready(SCCB_ready),
        .SIOC_oe(SCCB_SIOC_oe),
        .SIOD_oe(SCCB_SIOD_oe)
        );
		
	mypll cory_pll(.ref_clk_i(clk),
        .rst_n_i(1),
        .outcore_o(fast_clk),
        .outglobal_o()
		);
		
	camera_read reader(.p_clock(fast_clk),
		.vsync(vsync_in),
		.href(href_in),
		.p_data(data_in),
		.pixel_data(),
		.pixel_valid(pixel_valid),
		.frame_done(frame_done)
		);
    
endmodule

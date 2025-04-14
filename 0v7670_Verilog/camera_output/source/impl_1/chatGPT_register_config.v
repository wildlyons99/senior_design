`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025
// Design Name: 
// Module Name: OV7670_config_rom
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: OV7670 config for QVGA resolution with YUV422 output
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module OV7670_config_rom(
    input wire clk,
    input wire [7:0] addr,
    output reg [15:0] dout
    );
    // FFFF is end of ROM, FFF0 is delay
    always @(posedge clk) begin
    case(addr)
    0:  dout <= 16'h12_80; // COM7 reset
    1:  dout <= 16'hFF_F0; // delay

    2:  dout <= 16'h12_00; // COM7 - YUV mode
    3:  dout <= 16'h17_16; // HSTART
    4:  dout <= 16'h18_60; // HSIZE
    5:  dout <= 16'h19_12; // VSTART
    6:  dout <= 16'h1A_F0; // VSIZE
    7:  dout <= 16'h32_00; // HREF

    8:  dout <= 16'h11_01; // CLKRC
    9:  dout <= 16'h0C_00; // COM3 - enable scaling
    10: dout <= 16'h3E_19; // COM14 - manual scaling, PCLK controlled
    11: dout <= 16'h70_3A; // SCALING_XSC
    12: dout <= 16'h71_35; // SCALING_YSC
    13: dout <= 16'h72_11; // SCALING_DCWCTR
    14: dout <= 16'h73_F1; // SCALING_PCLK_DIV

    15: dout <= 16'h3A_04; // TSLB - YUYV ordering
    16: dout <= 16'h3D_80; // COM13 - enable UV saturation auto adjust
    17: dout <= 16'h8C_00; // RGB444 - disable RGB444
    18: dout <= 16'hC3_6A; // COM9 - AGC gain ceiling x4
    19: dout <= 16'h6B_0A; // DBLV - PLL control
    20: dout <= 16'h15_00; // COM10 - VSYNC and HREF output control

    21: dout <= 16'h13_E7; // COM8 - AGC, AEC, AWB enable
    22: dout <= 16'hFF_FF; // end of ROM
    default: dout <= 16'hFF_FF;
    endcase
    end
endmodule

module top (
    input wire          clk_12MHz,
    output wire [5:0]   RGB, 
    output wire         HSYNC,
    output wire         VSYNC, 
    output wire         clk_25Mhz
);  
    // wire global_clk;
	
	wire [9:0] row; 
	wire [9:0] col; 
	wire valid; 

    // Instantiate the PLL
	mypll pll_instantiation(
	    .ref_clk_i(clk_12MHz),
        .rst_n_i(1'b1),
        .outcore_o(clk_25Mhz),
        .outglobal_o()
	);
    
    // Instantiate the VGA module
     vga vga_inst (
         .clk(clk_25Mhz),
         .HSYNC(HSYNC),
         .VSYNC(VSYNC),
         .valid(valid),
         .row(row),
         .col(col)
     );
	
	pattern_gen map_rgb(
		 .clk(clk_25Mhz),
		 .y(row),
		 .x(col),
		 .RGB(RGB) 
	); 
    
endmodule
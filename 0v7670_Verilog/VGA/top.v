module top (
    input wire          clk_12MHz,
    // output wire [5:0]   RGB, 
    // output wire         HSYNC,
    // output wire         VSYNC
    output wire global_clk
);  

    wire clk_25Mhz;
    // wire global_clk;

    // Instantiate the PLL
    my_pll pll_instance(.ref_clk_i(clk_12MHz),
        .rst_n_i(1),
        .outcore_o(clk_25Mhz),
        .outglobal_o(global_clk));
    
    // Instantiate the VGA module
    // vga vga_inst (
    //     .clk(clk_25Hz),
    //     .HSYNC(HSYNC),
    //     .VSYNC(VSYNC),
    //     .valid(valid),
    //     .row(row),
    //     .col(col)
    // );


    
endmodule
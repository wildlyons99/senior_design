// clk_gen.v
// This module uses the internal PLL of the Lattice iCE40UP5k to generate
// a 25.125 MHz clock from a 12 MHz reference clock.

module my_pll (
    input  wire ref_clk_i,  // 12 MHz reference oscillator input
    input  wire rst_n_i,  
    output wire outcore_o, // 25.125 MHz output clock
    output wire outglobal_o, // 25.125 MHz output clock
    // output wire pll_locked     // PLL lock status indicator
);
    wire pll_locked; 

    // Instantiate the PLL primitive.
    // The parameters are chosen so that:
    //   f_out = 12MHz / (DIVR+1) * (DIVF+1) / (2^(DIVQ))
    //         = 12MHz / (3+1) * (66+1) / (2^3)
    //         = 12MHz/4 * 67/8 = 25.125MHz
    SB_PLL40_CORE #(
        .FEEDBACK_PATH("SIMPLE"),
        .DIVR(4'd3),       // DIVR = 3: Divide input clock by (3+1)=4
        .DIVF(7'd66),      // DIVF = 66: Multiply factor (66+1)=67
        .DIVQ(3'd3),       // DIVQ = 3: Divide by 2^3=8
        .FILTER_RANGE(3)   // Filter setting, adjust as necessary per documentation
    ) pll_inst (
        .REFERENCECLK(ref_clk_i),
        .PLLOUTCORE(outcore_o),
        .PLLOUTGLOBAL(outglobal_o),

        .LOCK(pll_locked),
        .RESETB(rst_n_i),
        .BYPASS(1'b0)
    );

endmodule

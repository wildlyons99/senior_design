// =============================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// -----------------------------------------------------------------------------
//   Copyright (c) 2018 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED
// --------------------------------------------------------------------
//
//   Permission:
//
//      Lattice SG Pte. Ltd. grants permission to use this code
//      pursuant to the terms of the Lattice Reference Design License Agreement.
//
//
//   Disclaimer:
//
//      This VHDL or Verilog source code is intended as a design reference
//      which illustrates how these types of functions can be implemented.
//      It is the user's responsibility to verify their design for
//      consistency and functionality through the use of formal
//      verification methods.  Lattice provides no warranty
//      regarding the use or functionality of this code.
//
// -----------------------------------------------------------------------------
//
//                  Lattice SG Pte. Ltd.
//                  101 Thomson Road, United Square #07-02
//                  Singapore 307591
//
//
//                  TEL: 1-800-Lattice (USA and Canada)
//                       +65-6631-2000 (Singapore)
//                       +1-503-268-8001 (other locations)
//
//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com
//
// -----------------------------------------------------------------------------
//
// =============================================================================
//                         FILE DETAILS
// Project               :
// File                  : tb_top.v
// Title                 : Testbench for Multiply - Accumulate.
// Dependencies          : 1.
//                       : 2.
// Description           :
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.0
// Author(s)             :
// Mod. Date             : 
// Changes Made          : Initial version of testbench for Multiply Accumulate.
//						 : 
// =============================================================================

`ifndef TB_TOP
`define TB_TOP
//==========================================================================
// Module : tb_top
//==========================================================================
`timescale 1ns/1ps
module tb_top();

`include "dut_params.v"

// -----------------------------------------------------------------------------
// ----- TB Limited Configurations -----
// -----------------------------------------------------------------------------
localparam integer SYS_CLK_PERIOD = (FAMILY == "iCE40UP") ? 40 : 10;
localparam integer A_WDT = A_WIDTH;
localparam integer B_WDT = B_WIDTH;
localparam integer ACC_WDT = ACC_WIDTH;

// -----------------------------------------------------------------------------
// ----- DUT Configurations -----
// -----------------------------------------------------------------------------
parameter [0:0]   SIGNED_A  = (A_SIGNED == "on") ? 1 : 0;
parameter [0:0]   SIGNED_B  = (B_SIGNED == "on") ? 1 : 0;

parameter [0:0]   I_REG     = (USE_IREG == "on") ? 1 : 0;
parameter [0:0]   O_REG     = (USE_OREG == "on") ? 1 : 0;

// -----------------------------------------------------------------------------
// ----- Internal Derivations/Computations -----
// -----------------------------------------------------------------------------
localparam integer    M_WDT = (A_WDT +   B_WDT);
localparam integer    O_WDT = (M_WDT + ACC_WDT);

localparam [0:0] A_WDT_GT_B_WDT = (A_WDT > B_WDT);

localparam integer MAX_WDT = A_WDT_GT_B_WDT ? A_WDT :
                                              B_WDT ;


localparam integer MULT_STAGES = (I_REG + O_REG + PIPELINES);

localparam [0:0] M_SIGNED = (SIGNED_A | SIGNED_B);

localparam [O_WDT-1:0] O_VAL_0 = {O_WDT{1'b0}};


reg              clk_i      ;
reg              clk_en_i   ;
reg              rst_i      ;
reg              rst_n_i    ;

// ----- Monitor & Scoreboard -----
reg  [A_WDT-1:0] data_a_i      ;
reg  [B_WDT-1:0] data_b_i      ;
wire [ACC_WDT-1:0] result_o;
wire [ACC_WDT-1:0] tb_result;

reg   test_done              ;
reg   test_sts               ;
reg [10:0]test_count         ;
reg   vld_sts [MULT_STAGES:0];
wire  opr_sts = (vld_sts[0] | (tb_result === result_o));


// -----------------------------------------------------------------------------
// Clock Generator
// -----------------------------------------------------------------------------
initial begin
  clk_i     = 0;
  clk_en_i  = 1;
end

always #(SYS_CLK_PERIOD/2) clk_i = ~clk_i;

// -----------------------------------------------------------------------------
// Reset Signals
// -----------------------------------------------------------------------------
initial begin
  rst_i     = 1;
  rst_n_i   = 0;
  #(10*SYS_CLK_PERIOD)
  rst_i     = 0;
  rst_n_i   = 1;
end

initial
begin
  // ----- Test/Scenario Print -----
  $display();
  $display("---------------------------------------");
  $display("----- Test/Scenario Configuration -----");
  $display("---------------------------------------");
  $display(                                         );
  $display("Addition/Subtraction   : %s", ADD_SUB   );
  $display("A           Width      : %d", A_WIDTH   );
  $display("B           Width      : %d", B_WIDTH   );
  $display("Accumulator Width      : %d", ACC_WIDTH );
  $display("A Signed               : %s", A_SIGNED  );
  $display("B Signed               : %s", B_SIGNED  );
  $display("Input Registered       : %s", USE_IREG  );
  $display("Output Registered      : %s", USE_OREG  );
  $display("Pipelines              : %d", PIPELINES );
  $display("Implementation         : %s", IMPL      );
  $display("Device Family          : %s", FAMILY    );
  $display("---------------------------------------");
end

always @(posedge clk_i or negedge rst_n_i)
begin
  if(!rst_n_i)
  begin
    test_done <= 1'b0;
    test_sts  <= 1'b1;
  end
  else if(!test_done)
  begin
    test_done <= (test_count === 1000) ;
    test_sts  <= (test_sts & opr_sts);
  end
end

// ----- Input Generation -----
always @ (posedge clk_i or negedge rst_n_i) begin
 if (!rst_n_i)begin
  data_a_i <= {A_WDT{1'b0}};
  data_b_i <= {B_WDT{1'b0}};
 end
 else begin
  data_a_i <= $urandom_range({A_WDT{1'b0}}, {A_WDT{1'b1}});
  data_b_i <= $urandom_range({B_WDT{1'b0}}, {B_WDT{1'b1}});
 end
end

// ----- TB Calculations -----
wire A_neg = (SIGNED_A & data_a_i[A_WDT-1]);
wire B_neg = (SIGNED_B & data_b_i[B_WDT-1]);

wire signed [A_WDT:0] A_se = {A_neg, data_a_i};
wire signed [B_WDT:0] B_se = {B_neg, data_b_i};

wire [M_WDT-1:0] AxB = (A_se * B_se);

// ----- Sign Extension -----
wire AxB_neg = (M_SIGNED & AxB[M_WDT-1]);

wire [O_WDT-1:0] AxB_se = {{ACC_WDT{AxB_neg}}, AxB};

// ----- Accumulation -----
reg  [O_WDT-1:0] result_r [MULT_STAGES:0]                            ;
wire [O_WDT-1:0] result_c = (ADD_SUB == "add") ? {result_r[MULT_STAGES-1] + AxB_se} :
                                                 {result_r[MULT_STAGES-1] - AxB_se} ;

generate
if(MULT_STAGES > 1)
begin : STAGES_GT_1
  integer i;
  always @(posedge clk_i or negedge rst_n_i)
  begin
    if(!rst_n_i)
    begin
      for(i = MULT_STAGES ; i > 0 ; i = i - 1)
      begin
        vld_sts [i-1] <= 1'b1   ;
        result_r[i-1] <= O_VAL_0;
      end
    end
    else
    begin
      vld_sts [MULT_STAGES-1] <= 1'b0    ;
      result_r[MULT_STAGES-1] <= result_c;
      for(i =  MULT_STAGES-1 ; i > 0 ; i = i - 1)
      begin
        vld_sts [i-1] <= vld_sts [i];
        result_r[i-1] <= result_r[i];
      end
    end
  end
end  // STAGES_GT_1
else
begin : STAGES_EQ_1
  always @(posedge clk_i or negedge rst_n_i)
  begin
    if(!rst_n_i)
    begin
      vld_sts [0] <= 1'b1   ;
      result_r[0] <= O_VAL_0;
    end
    else
    begin
      vld_sts [0] <= 1'b0    ;
      result_r[0] <= result_c;
    end
  end
end  // STAGES_EQ_1
endgenerate

assign tb_result = result_r[0];

// ----------------------------
// GSR instance
// ----------------------------
`ifndef iCE40UP
GSR GSR_INST ( .GSR_N(1'b1), .CLK(1'b0));
`endif

`include "dut_inst.v"

// ----- Limiting TEST COUNT -----
always @(posedge clk_i or posedge rst_i)
begin
  if(rst_i) begin
	test_count <= {10{1'b0}};
  end
  else begin
	test_count <= test_count + 1'b1;
  end
end

always @* begin
 if (rst_i) begin
	  test_done = 0;
	end
	 else begin
	    if (test_count === 1000) begin
		  test_done = 1;
		end
	 end
end

//Declaration of Signed inputs for the Log file
reg signed [A_WDT-1:0] data_a;
reg signed [B_WDT-1:0] data_b;

wire signed [ACC_WDT-1:0]result;

assign result = result_o;

always @* begin
	data_a = data_a_i[A_WDT-1:0];
	data_b = data_b_i[B_WDT-1:0];
end

// ----- Display Debug Log -----
initial begin
 if ((A_SIGNED == "on") && (B_SIGNED == "on")) begin
 $monitor("Test Count: %d, data_a_i: %d, data_b_i : %d, result_o : %d", test_count, data_a, data_b, result);
 end
 else if ((A_SIGNED == "off") && (B_SIGNED == "on")) begin
 $monitor("Test Count: %d, data_a_i: %d, data_b_i : %d, result_o : %d", test_count, data_a_i, data_b, result);
 end
 else if ((A_SIGNED == "on") && (B_SIGNED == "off")) begin
 $monitor("Test Count: %d, data_a_i: %d, data_b_i : %d, result_o : %d", test_count, data_a, data_b_i, result);
 end
 else begin // ((A_SIGNED == "off") && (B_SIGNED == "off"))
 $monitor("Test Count: %d, data_a_i: %d, data_b_i : %d, result_o : %d", test_count, data_a_i, data_b_i, result_o);
 end
end

// ----- Display Test Status -----
initial
begin
  wait(test_done);

  repeat(MULT_STAGES+1) @(posedge clk_i);
  $display();
        $write  ("------ TEST DONE @Time: %t ------- ", $time);
  $display();
  if(test_sts) begin
		$display("-----------------------------------------");
		$display("------------ SIMULATION PASSED ----------");
		$display("-----------------------------------------");
  end 
  else begin
		$display("-----------------------------------------");
		$display("---------!!! SIMULATION FAILED !!!-------");
		$display("-----------------------------------------");
  end

  $finish();
end

endmodule  // tb_top
`endif

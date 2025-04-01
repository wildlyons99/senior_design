module pattern_gen (
     input wire          clk,
	 input wire   [9:0]   y,
     input wire   [9:0]   x,
     output wire [5:0]   RGB 
);  

	assign RGB = (x > 240) ? 6'b001100 : 6'b110011; 
	
endmodule  
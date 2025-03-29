module top (
	input		[3:0]	input1,
	input		[3:0]	input2,
	output  	[3:0]	out
);

max	#(.DATA_WIDTH (4), .DATA_NUM (2))	genericMax	(.data_in ({input1, input2}), .max_out (out));

endmodule
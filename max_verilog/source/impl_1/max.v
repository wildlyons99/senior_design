module max #(
    parameter DATA_WIDTH = 8,
    parameter DATA_NUM = 16
)
(
    input	wire	[DATA_WIDTH*DATA_NUM-1:0]	data_in,
    output	reg 	[DATA_WIDTH-1:0]			max_out,
	output	reg		[7:0]						max_num
);
integer i;
always @* begin

    max_out = data_in[DATA_WIDTH - 1 : 0];
	max_num = 0;
    for (i = 1; i<DATA_NUM; i = i + 1) begin
        if(data_in[DATA_WIDTH*i + (DATA_WIDTH - 1) -: DATA_WIDTH] > max_out) begin
            max_out = data_in[DATA_WIDTH*i + (DATA_WIDTH - 1) -: DATA_WIDTH];
			max_num = i;
        end
    end
end
endmodule
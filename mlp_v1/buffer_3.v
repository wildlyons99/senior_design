module buffer_3 (   
        input clk, 
        input run,
        
        input done_3,
        input [15:0] out_3,
        input [11:0] out_neuron_addr_3,
        input write_neuron_3,

        output reg done_4,
        output reg [15:0] out_4,
        output reg [11:0] out_neuron_addr_4,
        output reg write_neuron_4
    );

    initial begin
        done_4 <= 0;
        out_4 <= 16'b0;
        out_neuron_addr_4 <= 12'b0;
        write_neuron_4 <= 0;
    end

    always @(posedge clk) begin
        if (!run) begin
            done_4 <= 0;
            out_4 <= 16'b0;
            out_neuron_addr_4 <= 12'b0;
            write_neuron_4 <= 0;
        end else begin
            done_4 <= done_3;
            out_4 <= out_3;
            out_neuron_addr_4 <= out_neuron_addr_3;
            write_neuron_4 <= write_neuron_3;
        end
    end

endmodule
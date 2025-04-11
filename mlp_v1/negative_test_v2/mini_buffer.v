module mini_buffer (   
        input clk, 
        input reset,

        input reset_mult_acc_in,
        input [11:0] out_neuron_addr_in,

        output reg reset_mult_acc_out,
        output reg [11:0] out_neuron_addr_out
    );

    initial begin
        reset_mult_acc_out <= 0;
        out_neuron_addr_out <= 0;
    end

    always @(posedge clk) begin
        if (reset) begin
            reset_mult_acc_out <= 0;
            out_neuron_addr_out <= 0;
        end else begin 
            reset_mult_acc_out <= reset_mult_acc_in;
            out_neuron_addr_out <= out_neuron_addr_in;
        end
    end
    
endmodule


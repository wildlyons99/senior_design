module buffer (   
        input clk, 
        input reset,

        input reset_mu_in,
        input done_in,
        input write_neuron_in,
        input [11:0] out_neuron_addr_in,

        output reg reset_mu_out,
        output reg done_out,
        output reg write_neuron_out,
        output reg [11:0] out_neuron_addr_out
    );

    always @(posedge clk) begin
        if (reset) begin
            reset_mu_out <= 0;
            done_out <= 0;
            write_neuron_out <= 0;
            out_neuron_addr_out <= 0;
        end else begin 
            reset_mu_out <= reset_mu_in;
            done_out <= done_in;
            write_neuron_out <= write_neuron_in;
            out_neuron_addr_out <= out_neuron_addr_in;
        end
    end
    
endmodule


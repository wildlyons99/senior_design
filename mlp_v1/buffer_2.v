module buffer_2 (   
        input clk, 
        input run,
        
        input done_2,
        input [15:0] neuron_val_2,
        input [7:0] weight_val_2,
        input reset_mult_acc_2,
        input [11:0] out_neuron_addr_2,
        input write_neuron_2,

        output reg done_3,
        output reg [15:0] neuron_val_3,
        output reg [7:0] weight_val_3,
        output reg reset_mult_acc_3,
        output reg [11:0] out_neuron_addr_3,
        output reg write_neuron_3
    );

    initial begin
        done_3 <= 0;
        neuron_val_3 <= 16'b0;
        weight_val_3 <= 8'b0;
        reset_mult_acc_3 <= 0;
        out_neuron_addr_3 <= 12'b0;
        write_neuron_3 <= 0;
    end

    always @(posedge clk) begin
        if (!run) begin
            done_3 <= 0;
            neuron_val_3 <= 16'b0;
            weight_val_3 <= 8'b0;
            reset_mult_acc_3 <= 0;
            out_neuron_addr_3 <= 12'b0;
            write_neuron_3 <= 0;
        end else begin
            done_3 <= done_2;
            neuron_val_3 <= neuron_val_2;
            weight_val_3 <= weight_val_2;
            reset_mult_acc_3 <= reset_mult_acc_2;
            out_neuron_addr_3 <= out_neuron_addr_2;
            write_neuron_3 <= write_neuron_2;
        end
    end

endmodule

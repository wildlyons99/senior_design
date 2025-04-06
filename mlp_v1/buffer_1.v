module buffer_1 (   
        input clk, 
        input run,

        input done_1,
        input [11:0] neuron_addr_1,
        input [15:0] weight_addr_1,
        input reset_mult_acc_1,
        input [11:0] out_neuron_addr_1,
        input write_neuron_1,

        output reg done_2,
        output reg [11:0] neuron_addr_2,
        output reg [15:0] weight_addr_2,
        output reg reset_mult_acc_2,
        output reg [11:0] out_neuron_addr_2,
        output reg write_neuron_2
    );

    initial begin
        done_2 <= 0;
        neuron_addr_2 <= 0;
        weight_addr_2 <= 0;
        reset_mult_acc_2 <= 0;
        out_neuron_addr_2 <= 0;
        write_neuron_2 <= 0;
    end

    always @(posedge clk) begin
        if (!run) begin
            done_2 <= 0;
            neuron_addr_2 <= 0;
            weight_addr_2 <= 0;
            reset_mult_acc_2 <= 0;
            out_neuron_addr_2 <= 0;
            write_neuron_2 <= 0;
        end else begin 
            done_2 <= done_1;
            neuron_addr_2 <= neuron_addr_1;
            weight_addr_2 <= weight_addr_1;
            reset_mult_acc_2 <= reset_mult_acc_1;
            out_neuron_addr_2 <= out_neuron_addr_1;
            write_neuron_2 <= write_neuron_1;
        end
    end
    
endmodule


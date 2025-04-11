module top 
    (
        input clk, 
        input reset, 
        output wire signed [15:0] out,
        output wire finished
    );

    // Internal signals
    wire [11:0] neuron_addr_1;
    wire [11:0] neuron_addr_2;
    wire [15:0] weight_addr_1;
    wire [15:0] weight_addr_2;
    wire [7:0] bias_addr_1;
    wire [7:0] bias_addr_2;

    wire [11:0] out_neuron_addr_1;
    wire [11:0] out_neuron_addr_2;
    wire [11:0] out_neuron_addr_3;
    wire [11:0] out_neuron_addr_4;

    wire reset_mult_acc_1;
    wire reset_mult_acc_2;
    wire reset_mult_acc_3;

    wire write_neuron_1;
    wire write_neuron_2;
    wire write_neuron_3;
    wire write_neuron_4;

    wire done_1;
    wire done_2;
    wire done_3;
    wire done_4;
    
    wire [15:0] neuron_val_2;
    wire [15:0] neuron_val_3;
    wire [7:0] weight_val_2;
    wire [7:0] weight_val_3;
    wire [7:0] bias_val_2;
    wire [7:0] bias_val_3;

    wire [15:0] mult_out_3;
    wire [15:0] out_3;
    wire [15:0] out_4;

    control_unit cu (
        .clk(clk),
        .reset(reset),
        .input_neuron_addr(neuron_addr_1),
        .output_neuron_addr(out_neuron_addr_1),
        .input_weight_addr(weight_addr_1),
        .reset_mult_acc(reset_mult_acc_1),
        .write_neuron(write_neuron_1),
        .done(done_1)
    );

    neuron_mem nm (
        .clk(clk),
        .write_enable(reset_mult_acc_3),
        .input_addr(neuron_addr_2),
        .data(out_4),
        .output_addr(out_neuron_addr_4),
        .neuron_val(neuron_val_2)
    );

    weight_mem wm (
        .clk(clk),
        .input_addr(weight_addr_2),
        .weight_val(weight_val_2)
    );

    bias_mem bm (
        .clk(clk),
        .input_addr(weight_addr_2),
        .bias_val(bias_val_2)
    );

    multiply_unit mu (   
        .clk(clk),
        .reset(reset_mult_acc_3 || reset),
        .op1(neuron_val_3),
        .op2(weight_val_3),
        .out(mult_out_3)
    );

    relu ru(
        .in(mult_out_3),
        .bias(bias_val_3),
        .out(out_3)
    );

    softmax su(
        .clk(clk), 
        .done(done_3),
        .in(out_4), 
        .finished(finished),
        .result(out)
    );

    buffer_1 b1 (
        .clk(clk), 
        .reset(reset),
        
        .done_1(done_1),
        .neuron_addr_1(neuron_addr_1),
        .weight_addr_1(weight_addr_1),
        .reset_mult_acc_1(reset_mult_acc_1),
        .out_neuron_addr_1(out_neuron_addr_1),
        .write_neuron_1(write_neuron_1),

        .done_2(done_2),
        .neuron_addr_2(neuron_addr_2),
        .weight_addr_2(weight_addr_2),
        .reset_mult_acc_2(reset_mult_acc_2),
        .out_neuron_addr_2(out_neuron_addr_2),
        .write_neuron_2(write_neuron_2)
    );

    buffer_2 b2 (
        .clk(clk), 
        .reset(reset),
        
        .done_2(done_2),
        .neuron_val_2(neuron_val_2),
        .weight_val_2(weight_val_2),
        .bias_val_2(bias_val_2),
        .reset_mult_acc_2(reset_mult_acc_2),
        .out_neuron_addr_2(out_neuron_addr_2),
        .write_neuron_2(write_neuron_2),

        .done_3(done_3),
        .neuron_val_3(neuron_val_3),
        .weight_val_3(weight_val_3),
        .bias_val_3(bias_val_3),
        .reset_mult_acc_3(reset_mult_acc_3),
        .out_neuron_addr_3(out_neuron_addr_3),
        .write_neuron_3(write_neuron_3)
    );

    buffer_3 b3 (
        .clk(clk), 
        .reset(reset),
        
        .done_3(done_3),
        .out_3(out_3),
        .out_neuron_addr_3(out_neuron_addr_3),
        .write_neuron_3(write_neuron_3),

        .done_4(done_4),
        .out_4(out_4),
        .out_neuron_addr_4(out_neuron_addr_4),
        .write_neuron_4(write_neuron_4)
    );

endmodule



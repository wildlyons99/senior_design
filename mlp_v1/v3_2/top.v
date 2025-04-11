module top 
    (
        input clk, 
        input reset, 
        output wire signed [15:0] out,
        output wire finished
    );

    // Internal signals
    wire [11:0] neuron_addr;
    wire [15:0] weight_addr;
    wire [7:0] bias_addr;

    wire [11:0] out_neuron_addr_1;
    wire [11:0] out_neuron_addr_2;
    wire [11:0] out_neuron_addr_3;

    wire reset_mu_1;
    wire reset_mu_2;
    wire reset_mu_3;

    wire write_neuron_1;
    wire write_neuron_2;
    wire write_neuron_3;

    wire done_1;
    wire done_2;
    wire done_3;

    wire [15:0] neuron_val;
    wire [7:0] weight_val;
    wire [7:0] bias_val;

    wire [15:0] mu_out;
    wire [15:0] ru_out;

    control_unit cu (
        .clk(clk),
        .reset(reset),
        .input_neuron_addr(neuron_addr),
        .output_neuron_addr(out_neuron_addr_1),
        .input_weight_addr(weight_addr),
        .reset_mult_acc(reset_mu_1),
        .write_neuron(write_neuron_1),
        .done(done_1)
    );

    neuron_mem nm (
        .clk(clk),
        .reset(reset),
        .write_enable(write_neuron_3),
        .input_addr(neuron_addr),
        .data(ru_out),
        .output_addr(out_neuron_addr_3),
        .neuron_val(neuron_val)
    );

    weight_mem wm (
        .clk(clk),
        .reset(reset),
        .input_addr(weight_addr),
        .weight_val(weight_val)
    );

    bias_mem bm (
        .clk(clk),
        .reset(reset),
        .input_addr(weight_addr),
        .bias_val(bias_val)
    );

    multiply_unit mu (   
        .clk(clk),
        .reset(reset_mu_3 || reset),
        .op1(neuron_val),
        .op2(weight_val),
        .bias(bias_val),
        .out(mu_out)
    );

    relu ru(
        .in(mu_out),
        .out(ru_out)
    );

    softmax su(
        .clk(clk), 
        .reset(reset),
        .done(done_3),
        .in(ru_out), 
        .finished(finished),
        .result(out)
    );

    buffer b1(
        .clk(clk), 
        .reset(reset),

        .reset_mu_in(reset_mu_1),
        .done_in(done_1),
        .write_neuron_in(write_neuron_1),
        .out_neuron_addr_in(out_neuron_addr_1),

        .reset_mu_out(reset_mu_2),
        .done_out(done_2),
        .write_neuron_out(write_neuron_2),
        .out_neuron_addr_out(out_neuron_addr_2)
    );

    buffer b2(
        .clk(clk), 
        .reset(reset),

        .reset_mu_in(reset_mu_2),
        .done_in(done_2),
        .write_neuron_in(write_neuron_2),
        .out_neuron_addr_in(out_neuron_addr_2),

        .reset_mu_out(reset_mu_3),
        .done_out(done_3),
        .write_neuron_out(write_neuron_3),
        .out_neuron_addr_out(out_neuron_addr_3)
    );

endmodule



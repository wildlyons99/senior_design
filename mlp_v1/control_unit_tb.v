`timescale 1ns / 1ps

module control_unit_tb;

    // Declare testbench signals
    reg clk;
    reg start;
    wire [11:0] input_neuron_addr;
    wire [11:0] output_neuron_addr;
    wire [15:0] input_weight_addr;
    wire reset_mult_acc;
    wire write_neuron;
    wire done;

    // Instantiate the DUT (Device Under Test)
    control_unit uut (
        .clk(clk),
        .start(start),
        .input_neuron_addr(input_neuron_addr),
        .output_neuron_addr(output_neuron_addr),
        .input_weight_addr(input_weight_addr),
        .reset_mult_acc(reset_mult_acc),
        .write_neuron(write_neuron),
        .done(done)
    );

    // Clock generation (50 MHz => 10 ns period)
    always #5 clk = ~clk; 
    integer counter;

    initial begin
        counter = 0;
        clk = 0;
        start = 0;

        // Wait some time before starting
        #100;
        

        start = 1;

        // Run for a few clock cycles
        while (!done) begin 
            // Wait for clock
            #10; 

            $display("count = %h | input neuron = %b | output neuron = %b | input weight addr = %b | done = %b ", counter, input_neuron_addr, output_neuron_addr, input_weight_addr, done);

            counter = counter + 1;
        end

        $display("Simulation finished. Total Iterations: %0d", counter);
        $finish;
    end

    initial begin
        $dumpfile("dump.vcd");  // Specifies the output file for waveform data
        $dumpvars(0, control_unit_tb);
    end

endmodule

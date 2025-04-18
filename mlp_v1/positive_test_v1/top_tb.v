`timescale 1ns / 1ps

module top_tb;

    // Declare testbench signals
    reg clk;
    reg reset;
    wire [15:0] out;
    wire finished;

    // Instantiate the DUT (Device Under Test)
    top uut (
        .clk(clk),
        .reset(reset),
        .out(out),
        .finished(finished)
    );

    always #10 clk = ~clk; 

    initial begin
        clk = 0;
        reset = 1;

        #10
        reset = 0;
        
        // Wait and observe outputs
        #400; 

        reset = 1;

        #30;

        reset = 0;

        #400;

        $finish;
    end

    initial begin
        $dumpfile("wave.vcd");  
        $dumpvars(0, uut);
    end

endmodule






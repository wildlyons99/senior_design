`timescale 1ns / 1ps

module top_tb;

    // Declare testbench signals
    reg clk;
    reg run;
    wire [15:0] out;
    wire finished;

    // Instantiate the DUT (Device Under Test)
    top uut (
        .clk(clk),
        .run(run),
        .out(out),
        .finished(finished)
    );

    always #10 clk = ~clk; 

    initial begin
        clk = 0;
        run = 0;

        #10
        run = 1;
        
        // Wait and observe outputs
        #400; 

        run = 0;

        #40;

        run = 1;

        #400;

        $finish;
    end

    initial begin
        $dumpfile("wave.vcd");  
        $dumpvars(0, uut);
    end

endmodule






`timescale 1ns / 1ps

module tb();

    reg a, b;
    wire y;

    and_gate dut (.a(a), .b(b), .y(y));

    initial begin

        $monitor("Time = %0t | a = %b | b = %b | y = %b", $time, a, b, y);

        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        $finish;

    end


endmodule
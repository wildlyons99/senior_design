// Testbench for layer1 weights

module testbench;

    reg clk;
    reg [4:0] neuron_index; // 5 bits for 30 neurons
    wire signed [432*8-1:0] neuron_weights_flat;

    // Instantiate the DUT
    rom_weights uut (
        .clk(clk),
        .neuron_index(neuron_index),
        .neuron_weights_flat(neuron_weights_flat)
    );

    // Clock generation
    always #5 clk = ~clk;

    integer i;

    initial begin
        clk = 0;
        neuron_index = 0;

        // Wait a few clock cycles
        #10;

        // Read and print weights for neuron 0
        $display("Weights for neuron 0:");
        for (i = 0; i < 432; i = i + 1) begin
            $display("Weight[%0d] = %0d", i, $signed(neuron_weights_flat[8*i +: 8]));
        end

        $finish;
    end

endmodule

module top;

    //////// neuron count array ////////
    parameter layers = 4;    // number of layers including input/output
    reg [7:0] neuron_count_array [0: layers - 1];  

    // neuron count array
    initial begin
        my_array[0] = 8'h10;
        my_array[1] = 8'h02;
        my_array[2] = 8'h02;
        my_array[3] = 8'h01;
    end

    ////////////////

end module
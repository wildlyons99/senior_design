module control_unit 
    (   
        input clk, 
        input start,
        output reg [5:0] input_neuron_addr,
        output reg [10:0] output_neuron_addr,
        // 16 bits
        output reg [15:0] input_weight_addr,
        output reg reset_mult_acc,
        output reg write_neuron,
        output reg done
    );



    //////// initialize outputs ////////
    initial begin
        reset_mult_acc = 0;            
        write_neuron = 0;              
        done = 0;      
    end
    ////////////////////////////////////


    //////// neuron count array ////////
    parameter layers = 4;    // number of layers including input/output
    reg [7:0] neuron_count_array [layers - 1 : 0];  

    // providing values to neuron count array
    initial begin
        neuron_count_array[0] = 8'h04;
        neuron_count_array[1] = 8'h02;
        neuron_count_array[2] = 8'h02;
        neuron_count_array[3] = 8'h01;
    end
    ///////////////////////////////////



    //////// variables ////////
    reg [9:0] weight_ptr;
    reg [3:0] neuron_ptr;
    reg [1:0] layer_ptr;

    initial begin
        weight_ptr = 10'b0;
        neuron_ptr = 4'b0;
        layer_ptr = 2'b0;
    end
    ///////////////////////////



    //////// logic ////////
    always @(posedge clk) begin
        if (start && ~done) begin 
            // done with curr neuron, move to next
            if (weight_ptr == neuron_count_array[layer_ptr]) begin
                neuron_ptr <= neuron_ptr + 1;
                weight_ptr <= 8'h00;
                write_neuron <= 1;
                reset_mult_acc <= 1;
            end else begin
                write_neuron <= 0;
                reset_mult_acc <= 0;
            end

            // done with curr layer, move to next
            if (neuron_ptr == neuron_count_array[layer_ptr]) begin
                layer_ptr <= layer_ptr + 1;
                neuron_ptr <= 8'h00;
            end

            // done w mlp calculations, do softmax
            if (neuron_count_array[layer_ptr] == 1) begin
                done <= 1;
            end else begin 
                done <= 0;
            end

        // set addresses      - can be optimized with address bases 

        // neuron address = layer | neuron 
        input_neuron_addr <= {layer_ptr, neuron_ptr};
        output_neuron_addr <= {layer_ptr + 1, neuron_ptr};

        input_weight_addr <= {layer_ptr, neuron_ptr, weight_ptr};

        weight_ptr <= weight_ptr + 1;

        end 

    ///////////////////////


end module
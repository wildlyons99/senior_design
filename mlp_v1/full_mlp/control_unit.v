module control_unit 
    (   
        input clk, 
        input reset,
        output reg [11:0] input_neuron_addr,
        output reg [11:0] output_neuron_addr,
        // 16 bits
        output reg [15:0] input_weight_addr,
        output reg reset_mult_acc,
        output reg write_neuron,
        output reg done
    );

    //////// neuron count array ////////
    parameter layers = 4;    // number of layers including input/output
    reg [8:0] neuron_count_array [layers - 1 : 0];  

    //////// variables ////////
    reg [8:0]  weight_ptr;
    reg [4:0]  neuron_ptr;
    reg [1:0]  layer_ptr;

    always @(posedge clk) begin
        if (reset) begin 
            neuron_count_array[0] <= 432;
            neuron_count_array[1] <= 30;
            neuron_count_array[2] <= 16;
            neuron_count_array[3] <= 10;

            weight_ptr <= 0;
            neuron_ptr <= 0;
            layer_ptr <= 0;

            input_neuron_addr <= 0;
            output_neuron_addr <= 0;
            input_weight_addr <= 0;
            
            done <= 0;
            write_neuron <= 0;
            reset_mult_acc <= 1; 
        end else begin
            if (~done) begin
                // Last weight for current neuron, move to the next neuron 
                if (weight_ptr == neuron_count_array[layer_ptr] - 1) begin
            
                    // Last neuron in current layer, move to the next layer
                    if ((neuron_ptr + 1) == neuron_count_array[(layer_ptr + 1)]) begin
                        // Finished MLP calculations, proceed to softmax
                        // if (neuron_count_array[(layer_ptr)] == 10) begin 
                        if (layer_ptr + 1 == 2'b11) begin 
                            done <= 1;
                            write_neuron <= 0;
                        end else begin 
                            done <= 0;
                            neuron_ptr <= 0;
                        end

                        layer_ptr <= layer_ptr + 1;
                    end else begin 
                        neuron_ptr <= neuron_ptr + 1;
                    end

                    weight_ptr <= 0;
                    write_neuron <= 1;
                    reset_mult_acc <= 1; 
                end else begin
                    weight_ptr <= weight_ptr + 1;
                    write_neuron <= 0;
                    reset_mult_acc <= 0;
                end

            end else begin
                write_neuron <= 0;
            end


            // input neuron address = layer_ptr | 1 empty bit | weight_ptr, 12 bits 
            input_neuron_addr <= {layer_ptr, 1'b0, weight_ptr};

            // output neuron address = layer_ptr + 1| neuron_ptr, 5 empty bits, 5 bits for neuron_ptr
            output_neuron_addr <= {(layer_ptr + 2'b01), 5'b00000, neuron_ptr};

            // weight address = layer_ptr (2)| neuron_ptr (5)| weight_ptr (9), 16 bits
            input_weight_addr <= {layer_ptr, neuron_ptr, weight_ptr};
        end  
    end

endmodule

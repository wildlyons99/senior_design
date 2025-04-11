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
    reg [7:0] neuron_count_array [layers - 1 : 0];  

    //////// variables ////////
    reg [9:0]  weight_ptr;
    reg [3:0]  neuron_ptr;
    reg [1:0]  layer_ptr;
    

    always @(posedge clk) begin
        if (reset) begin 
            neuron_count_array[0] = 8'h04;
            neuron_count_array[1] = 8'h02;
            neuron_count_array[2] = 8'h02;
            neuron_count_array[3] = 8'h01;

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
            // Last weight for current neuron, move to the next neuron 
            if (weight_ptr == neuron_count_array[layer_ptr] - 1) begin
        
                // Last neuron in current layer, move to the next layer
                if ((neuron_ptr + 1) == neuron_count_array[(layer_ptr + 1)]) begin

                    // Finished MLP calculations, proceed to softmax
                    if (neuron_count_array[(layer_ptr + 1)] == 1) begin 
                        done <= 1;
                    end else begin 
                        done <= 0;
                        layer_ptr <= layer_ptr + 1;
                        neuron_ptr <= 0;
                    end
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

            // input neuron address = layer_ptr | weight_ptr, 12 bits 
            input_neuron_addr <= {layer_ptr, weight_ptr};

            // output neuron address = layer_ptr + 1| neuron_ptr, 12 bits
            output_neuron_addr <= {(layer_ptr + 2'b01), 6'b000000, neuron_ptr};

            // weight address = layer_ptr | neuron_ptr | weight_ptr, 16 bits
            input_weight_addr <= {layer_ptr, neuron_ptr, weight_ptr};
        end  
    end

endmodule

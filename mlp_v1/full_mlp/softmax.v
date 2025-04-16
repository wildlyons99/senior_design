module softmax(
        input clk, 
        input reset,
        input done,
        input [15:0] in, 
        output reg finished, 
        output reg [15:0] result
    );

    reg prev_done;

    always @(posedge clk) begin    
        prev_done <= done;

        if (reset) begin
            result <= 0;
            finished <= 0;
            prev_done <= 0;
        end else begin 
            if (done && ~prev_done) begin
                finished <= 1;
                result <= in;
            end else begin
                finished <= 0;
            end
        end
    end

endmodule


[10:0] output_slots
if write_neuron_addr = C00 
    output_slot[0] = in

... for each output 0-9 and so on

- find maximum output when done is high 
- output the value, corresponding output slot

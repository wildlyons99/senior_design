# Makefile for Verilog MLP project

# Compiler and simulator
IVERILOG = iverilog
VVP = vvp

# Output binary
OUT = mlp

# Source files
SRC = top.v control_unit.v forward_unit.v neuron_mem.v weight_mem.v bias_mem.v multiply_unit.v relu.v softmax.v mini_buffer.v buffer_1.v buffer_2.v buffer_3.v top_tb.v

# Default target
all: $(OUT)
	$(VVP) $(OUT)

# Compile
$(OUT): $(SRC)
	$(IVERILOG) -o $(OUT) $(SRC)

# Clean up
clean:
	rm -f $(OUT) *.vcd

GHDL=ghdl
VERS="--std=08"
FLAG="--ieee=synopsys"

all: multiply 3x3

perceptron1:
	@$(GHDL) -a $(VERS) perceptron_1map.vhd OneBinaryRom.vhd WeightsRom.vhd perceptron1_tb.vhd
	@$(GHDL) -e $(VERS) perceptron1_testbench
	@$(GHDL) -r $(VERS) perceptron1_testbench

perceptron:
	@$(GHDL) -a $(VERS) perceptron.vhd ZeroBinaryRom.vhd WeightsRom.vhd perceptron1_tb.vhd
	@$(GHDL) -e $(VERS) perceptron_testbench
	@$(GHDL) -r $(VERS) perceptron_testbench

BinaryRom:
	@$(GHDL) -a $(VERS) BinaryRom.vhd 
	@$(GHDL) -e $(VERS) image
	@$(GHDL) -r $(VERS) image


# dmem:
# 	@$(GHDL) -a $(VERS) dmem.vhd dmem_tb.vhd
# 	@$(GHDL) -e $(VERS) dmem_tb
# 	@$(GHDL) -r $(VERS) dmem_tb --wave=dmem.ghw # saving for waves reference

clean:
	rm *_sim.out *.cf *.ghw
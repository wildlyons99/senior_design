GHDL=ghdl
VERS="--std=08"
FLAG="--ieee=synopsys"

all: multiply 3x3

hello:
	@$(GHDL) -a $(VERS) hello_world_tb.vhd
	@$(GHDL) -e $(VERS) hello_world
	@$(GHDL) -r $(VERS) hello_world

multiply:
	@$(GHDL) -a $(VERS) multiply.vhd multiply_tb.vhd
	@$(GHDL) -e $(VERS) multiply_tb
	@$(GHDL) -r $(VERS) multiply_tb

3x3:
	@$(GHDL) -a $(VERS) threeXthree.vhd threeXthree_tb.vhd
	@$(GHDL) -e $(VERS) threeXthree_testbench
	@$(GHDL) -r $(VERS) threeXthree_testbench


# dmem:
# 	@$(GHDL) -a $(VERS) dmem.vhd dmem_tb.vhd
# 	@$(GHDL) -e $(VERS) dmem_tb
# 	@$(GHDL) -r $(VERS) dmem_tb --wave=dmem.ghw # saving for waves reference

clean:
	rm *_sim.out *.cf *.ghw
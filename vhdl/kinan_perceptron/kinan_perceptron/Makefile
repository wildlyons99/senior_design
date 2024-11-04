GHDL=ghdl
# VERS="--std=08"

# IMPORTANT: do not change the names of the testbench files or entities here
# instead, ensure that YOUR testbench files and entity names match the ones here

all: compile run

compile:
	@$(GHDL) -a array_pkg.vhd
	@$(GHDL) -a mult.vhd mult_tb.vhd 
	@$(GHDL) -e mult_tb

run: 
	@$(GHDL) -r mult_tb 
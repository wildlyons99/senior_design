GHDL=ghdl

all: percept mult

# Target for mult
mult: 
	@$(GHDL) -a array_pkg.vhd
	@$(GHDL) -a mult.vhd mult_tb.vhd 
	@$(GHDL) -e mult_tb
	@$(GHDL) -r mult_tb 

# Target for percept
percept:
	@$(GHDL) -a array_pkg.vhd mult.vhd rom.vhd activation.vhd
	@$(GHDL) -a perceptron_v1.vhd perceptron_v1_tb.vhd
	@$(GHDL) -e perceptron_v1_tb
	@$(GHDL) -r perceptron_v1_tb --wave=wave=percept.ghw
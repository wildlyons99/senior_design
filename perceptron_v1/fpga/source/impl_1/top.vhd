library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity top is
    port(
		clk_12MHz : in std_logic; 
        --A    : in  unsigned(31 downto 0);
        --B    : in  unsigned(31 downto 0);
        C    : out unsigned(31 downto 0)
    );
end top;


architecture structural of top is
component multiplier_acc_v2 is
    port(
        clk_i: in std_logic;
        clk_en_i: in std_logic;
        rst_i: in std_logic;
        data_a_i: in std_logic_vector(17 downto 0);
        data_b_i: in std_logic_vector(17 downto 0);
        result_o: out std_logic_vector(36 downto 0)
    );
end component;

signal A : std_logic_vector(17 downto 0); 
signal B : std_logic_vector(17 downto 0); 
signal temp_C : std_logic_vector(17 downto 0); 

signal clk : std_logic; 

begin

	-- Generate 100KHz clock
	process(clk_12MHz)
	begin
		if rising_edge(clk_12MHz) then
			if clkCount = 7d"59" then 
				clkCount <= 7d"0"; 
				clk <= not clk;
			else 
                clkCount <= clkCount + 1;
			end if;
			
		end if;
	end process;
	
	
    mult_lut_test : multiplier_acc_v2 port map (
		in0 => A, 
		in1 => B, 
		output => temp_C
	); 
	
	c <= temp_c(31 downto 0); 
    
end structural; 
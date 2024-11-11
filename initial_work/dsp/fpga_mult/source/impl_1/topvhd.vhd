library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity top is
    port(
        --A    : in  unsigned(31 downto 0);
        --B    : in  unsigned(31 downto 0);
        C    : out unsigned(31 downto 0)
    );
end top;
    
architecture structural of top is
-- 8 bit mult (Radiant creates DSP) 
--component multiply8 is
    --port(
        --in0    : in  unsigned(7 downto 0);
        --in1    : in  unsigned(7 downto 0);
        --output : out unsigned(15 downto 0)
    --);
--end component;

signal A : unsigned(31 downto 0) := 32x"ffff";
signal B : unsigned(31 downto 0) := x"1234abcd";
signal temp_C : unsigned(63 downto 0); 


-- creates 
component multiply32 is
    port(
        in0    : in  unsigned(31 downto 0);
        in1    : in  unsigned(31 downto 0);
        output : out unsigned(63 downto 0)
    );
end component;

--signal 

begin
    mult_lut_test : multiply32 port map (
		in0 => A, 
		in1 => B, 
		output => temp_C
	); 
	
	c <= temp_c(31 downto 0); 
    
end structural; 
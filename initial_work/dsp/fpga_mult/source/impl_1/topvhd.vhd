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
    
architecture structural of top is-- 8 bit mult (Radiant creates DSP) 
component multiply8 is
    port(
        in0    : in  unsigned(7 downto 0);
        in1    : in  unsigned(7 downto 0);
        output : out unsigned(15 downto 0)
    );
end component;

--component multa
 --input clk_i ; 
    --input clk_en_i ; 
    --input rst_i ; 
    --input [7:0] data_a_i ; 
    --input [7:0] data_b_i ; 
    --output [16:0] result_o ; 

signal A : unsigned(31 downto 0) := 32x"ffff";
signal B : unsigned(31 downto 0) := x"1234abcd";
signal temp_C0 : unsigned(15 downto 0); 
signal temp_C1 : unsigned(15 downto 0); 
signal temp_C2 : unsigned(15 downto 0); 
signal temp_C3 : unsigned(15 downto 0); 
signal temp_C4 : unsigned(15 downto 0); 
signal temp_C5 : unsigned(15 downto 0); 
signal temp_C6 : unsigned(15 downto 0); 
signal temp_C7 : unsigned(15 downto 0); 
signal temp_C8 : unsigned(15 downto 0); 
signal temp_C9 : unsigned(15 downto 0); 
signal temp_C10 : unsigned(15 downto 0); 
signal temp_C11 : unsigned(15 downto 0); 
signal temp_C12 : unsigned(15 downto 0); 
signal temp_C13 : unsigned(15 downto 0); 
signal temp_C14 : unsigned(15 downto 0); 
signal temp_C15 : unsigned(15 downto 0); 



begin
    mult_lut_test0 : multiply8 port map (
		in0 => 8d"10", 
		in1 =>  8d"10", 
		output => temp_C0
	); 
	
	mult_lut_test1 : multiply8 port map (
		in0 => 8d"11", 
		in1 =>  8d"10", 
		output => temp_C1
	); 
	
	mult_lut_test2 : multiply8 port map (
		in0 => 8d"12", 
		in1 =>  8d"10", 
		output => temp_C2
	); 
	
	mult_lut_test3 : multiply8 port map (
		in0 => 8d"13", 
		in1 =>  8d"10", 
		output => temp_C3
	); 
	
	 mult_lut_test4 : multiply8 port map (
		in0 => 8d"14", 
		in1 =>  8d"10", 
		output => temp_C4
	); 
	
	mult_lut_test5 : multiply8 port map (
		in0 => 8d"15", 
		in1 =>  8d"10", 
		output => temp_C5
	); 
	
	mult_lut_test6 : multiply8 port map (
		in0 => 8d"16", 
		in1 =>  8d"10", 
		output => temp_C6
	); 
	
	mult_lut_test7 : multiply8 port map (
		in0 => 8d"17", 
		in1 =>  8d"10", 
		output => temp_C7
	); 
	
	 mult_lut_test8 : multiply8 port map (
		in0 => 8d"18", 
		in1 =>  8d"10", 
		output => temp_C8
	); 
	
	mult_lut_test9 : multiply8 port map (
		in0 => 8d"19", 
		in1 =>  8d"10", 
		output => temp_C9
	); 
	
	mult_lut_test10 : multiply8 port map (
		in0 => 8d"110", 
		in1 =>  8d"10", 
		output => temp_C10
	); 
	
	mult_lut_test11 : multiply8 port map (
		in0 => 8d"111", 
		in1 =>  8d"10", 
		output => temp_C11
	); 
	
	 mult_lut_test12 : multiply8 port map (
		in0 => 8d"112", 
		in1 =>  8d"10", 
		output => temp_C12
	); 
	
	mult_lut_test13 : multiply8 port map (
		in0 => 8d"113", 
		in1 =>  8d"10", 
		output => temp_C13
	); 
	
	mult_lut_test14 : multiply8 port map (
		in0 => 8d"114", 
		in1 =>  8d"10", 
		output => temp_C14
	); 
	
	mult_lut_test15 : multiply8 port map (
		in0 => 8d"115", 
		in1 =>  8d"10", 
		output => temp_C15
	); 
	
	c <=  temp_c0(1 downto 0)
	& temp_c1(1 downto 0)
	& temp_c2(1 downto 0)
	& temp_c3(1 downto 0)
	& temp_c4(1 downto 0)
	& temp_c5(1 downto 0)
	& temp_c6(1 downto 0)
	& temp_c7(1 downto 0)
	& temp_c8(1 downto 0)
	& temp_c9(1 downto 0)
	& temp_c10(1 downto 0)
	& temp_c11(1 downto 0)
	& temp_c12(1 downto 0)
	& temp_c13(1 downto 0)
	& temp_c14(1 downto 0)
	& temp_c15(1 downto 0); 
    
end structural; 
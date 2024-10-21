-- simple multiplication testbench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity multiply_tb is
    -- empty 
end multiply_tb;
architecture behavioral of multiply_tb is
    component multiply is
        port(
            in0    : in  unsigned(7 downto 0);
            in1    : in  unsigned(7 downto 0);
            output : out unsigned(15 downto 0)
        );
    end component;
        
    signal test_in0 : unsigned(7 downto 0);
    signal test_in1 : unsigned(7 downto 0);
    signal test_output : unsigned(15 downto 0);
    begin
        uut : multiply port map (
            in0 => test_in0,
            in1 => test_in1,
            output => test_output
        );
        
        testbench : process begin
            test_in0 <= 8d"1"; 
            test_in1 <= 8d"4"; 
            
            wait for 1 ns; 
            assert test_output <= 16d"4" report "unexpected value"; 
            wait;
        end process;
    end architecture; 
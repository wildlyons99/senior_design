library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity threeXthree_testbench is
    -- empty
end threeXthree_testbench; 

architecture behav of threeXthree_testbench is

component threeXthree is
    port(
        clk        : in  std_logic; 
        rst        : in  std_logic; 
        -- 1 bit 3x3 vectors
        matrixA    : in  unsigned(8 downto 0);
        matrixB    : in  unsigned(8 downto 0);
        
        -- 2 bit 3x3 vectors to handle multiplication
        matrixC    : out unsigned(8 downto 0)
    );
end component;

signal testA : unsigned(8 downto 0); 
signal testB : unsigned(8 downto 0); 
signal testC : unsigned(8 downto 0); 

signal clk : std_logic; 
signal rst : std_logic; 

type matType is array(0 to 2, 0 to 2) of std_logic;
signal matC : matType := (others => (others => '0')); 

begin

matrix_multiplier : threeXthree port map 
    (clk => test_clock, 
     rst => test_reset, 
     matrixA => testA, 
     matrixB => testB, 
     matrixC => testC
    );

uut : process begin
    reset <= '1';
    wait for 1 ns;

    reset <= '0';
    wait for 1 ns;

    testA <= "110100110";
    testB <= "000110101";
    wait for 1 ns;
    -- assert testC <= "01" & "01" & "00" 
                --   & "00" & "00" & "00" 
                --   & "01" & "01" & "00" 
    assert testC <= "1" & "1" & "0" 
                  & "0" & "0" & "0" 
                  & "1" & "1" & "0" 
    report "Incorrect marix multiplication! :(";  
end process;

end behav;
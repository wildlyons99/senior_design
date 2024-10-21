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
        -- 2 bit 3x3 vectors
        matrixA    : in  unsigned(17 downto 0);
        matrixB    : in  unsigned(17 downto 0);
        matrixC    : out unsigned(17 downto 0)
    );
end component;

signal testA : unsigned(17 downto 0); 
signal testB : unsigned(17 downto 0); 
signal testC : unsigned(17 downto 0); 

signal test_clk : std_logic; 
signal test_rst : std_logic; 

type matType is array(0 to 2, 0 to 2) of std_logic;
signal matC : matType := (others => (others => '0')); 

begin

matrix_multiplier : threeXthree port map 
    (clk => test_clk, 
     rst => test_rst, 
     matrixA => testA, 
     matrixB => testB, 
     matrixC => testC
    );

uut : process begin
    test_rst <= '1';
    wait for 10 ns;

    test_rst <= '0';
    test_clk <= '0'; 
    wait for 10 ns;

    testA <= "010100010000010100";
    testB <= "000000010100010001";
    wait for 10 ns; 

    -- trigger rising edge
    test_clk <= '1'; 
    wait for 10 ns;

    assert testC = "01" & "01" & "00" 
                  & "00" & "00" & "00" 
                  & "01" & "01" & "00" 
 
    report "Incorrect marix multiplication! :(";  

    wait; 
end process;

end behav;
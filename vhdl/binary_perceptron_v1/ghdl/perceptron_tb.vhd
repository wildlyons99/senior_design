library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity perceptron_testbench is
    -- empty
end perceptron_testbench; 

architecture behav of perceptron_testbench is

component perceptron is port(
    clk    : in std_logic; 
    enable : in std_logic; 
    binary_class : out std_logic 
    );
end component;

signal test_clk : std_logic; 
signal test_enable: std_logic; 

signal test_binary_class : std_logic; 

begin 
percept : perceptron port map(
    clk    => test_clk,
    enable => test_enable,
    binary_class => test_binary_class
    );

uut : process
    constant NUM_CYCLES : integer := 100;
begin 
    test_enable <= '1'; 
    test_clk <= '0'; 
    wait for 10 ns; 

    test_clk <= '1'; 
    wait for 1 ns; 

    -- 1
    for i in 0 to NUM_CYCLES loop
        test_clk <= '0';
        wait for 1 ns;
        test_clk <= '1';
        wait for 1 ns;
    end loop;

    report "Output value: " & std_logic'image(test_binary_class);


    -- report 
    wait; 

end process; 

end behav; 
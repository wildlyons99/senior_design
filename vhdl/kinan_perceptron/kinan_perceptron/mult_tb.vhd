library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.array_pkg.all;

entity mult_tb is
end mult_tb;

architecture structural of mult_tb is 
    component mult is
        port(
            clk : in std_logic;
            input : in byte_array;
            output : out std_logic_vector(15 downto 0)
        );
    end component mult;

    signal clk : std_logic;
    signal input_test : byte_array := (
        x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF",
        x"01", x"01", x"01", x"01", x"01", x"01", x"01", x"01"
    );
    signal output_test : std_logic_vector(15 downto 0) := x"0000";

begin 
    uut : mult port map(
        clk => clk,
        input => input_test,
        output => output_test
    );
    
stimulus_process: process
    begin   

    for i in 0 to 18 loop
        clk <= '0';
        wait for 10 ns; 
        clk <= '1';
        wait for 10 ns; 
        report "Output value: " & integer'image(to_integer(signed(output_test))) severity note;
    end loop;


    

assert false report "Test done." severity note;

wait; -- wait indefinitely; otherwise this code loop
end process;
end structural;
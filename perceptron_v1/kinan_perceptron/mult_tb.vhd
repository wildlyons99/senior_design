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
            reset : in std_logic;
            input : in byte_array;
            output : out std_logic_vector(15 downto 0)
        );
    end component mult;

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal zero_data : byte_array := (
        "00000000",
        "00100101",
        "00100010",
        "00000000",
        "00000000",
        "01000110",
        "01010000",
        "00000000",
        "00000000",
        "01000001",
        "01010100",
        "00000000",
        "00000000",
        "00100111",
        "00111010",
        "00000000"
    );

    signal one_data : byte_array := (
        "00000000",
        "00000000",
        "00011000",
        "00000000",
        "00000000",
        "00000010",
        "00111110",
        "00000000",
        "00000000",
        "00110011",
        "00010001",
        "00000000",
        "00000000",
        "00100001",
        "00000000",
        "00000000"
    );


    signal output_test : std_logic_vector(15 downto 0) := x"0000";
    signal curr_data : byte_array;
    begin 
    uut : mult port map(
        clk => clk,
        reset => rst,
        input => curr_data,
        output => output_test
    );

    stimulus_process: process
        begin 


        wait for 10 ns;
        rst <= '1';
        wait for 10 ns;
        curr_data <= zero_data;
        rst <= '0';

        for i in 0 to 15 loop
            clk <= '0';
            wait for 10 ns; 
            clk <= '1';
            wait for 10 ns; 
            report "Output value: " & integer'image(to_integer(signed(output_test))) severity note;
        end loop;



        report "Zero Output value: " & integer'image(to_integer(signed(output_test))) severity note;
        
        rst <= '1';
        wait for 10 ns;
        
        curr_data <= one_data;
        rst <= '0';

        for i in 0 to 15 loop
            clk <= '0';
            wait for 10 ns; 
            clk <= '1';
            wait for 10 ns; 
            report "Output value: " & integer'image(to_integer(signed(output_test))) severity note;
        end loop;


        report "One Output value: " & integer'image(to_integer(signed(output_test))) severity note;


        assert false report "Test done." severity note;

        wait; -- wait indefinitely; otherwise this code loop
        end process;
end structural;

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
        "00000100",
        "00011101",
        "00000000",
        "00000000",
        "00101100",
        "00000000",
        "00001011",
        "00000111",
        "00100111",
        "00001000",
        "00100010",
        "00000000",
        "00010000",
        "00011001",
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

    signal two_data : byte_array := (
        "00000000",
        "00000100",
        "00000001",
        "00000000",
        "00000000",
        "00010010",
        "00010001",
        "00000000",
        "00000000",
        "00010001",
        "00001111",
        "00000000",
        "00000000",
        "00000100",
        "00001100",
        "00000000"
    );

    signal three_data : byte_array := (
        "00000000",
        "00000000",
        "00001101",
        "00000000",
        "00000000",
        "00010110",
        "01000011",
        "00000000",
        "00000000",
        "00100111",
        "00001100",
        "00000000",
        "00000000",
        "00011101",
        "00000000",
        "00000000"
    );

    signal four_data : byte_array := (
        "00000000",
        "00000000",
        "00100001",
        "00000000",
        "00000000",
        "00110000",
        "01011011",
        "00010010",
        "00001100",
        "00111010",
        "00101010",
        "00010001",
        "00000001",
        "00101110",
        "00010111",
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

        for i in 0 to 16 loop
            clk <= '0';
            wait for 10 ns; 
            clk <= '1';
            wait for 10 ns; 
            -- report "Output value: " & integer'image(to_integer(signed(output_test))) severity note;
        end loop;



        report "Zero Output value: " & integer'image(to_integer(signed(output_test))) severity note;
        
        wait for 10 ns;
        
        curr_data <= one_data;

        for i in 0 to 16 loop
            clk <= '0';
            wait for 10 ns; 
            clk <= '1';
            wait for 10 ns; 
            -- report "Output value: " & integer'image(to_integer(signed(output_test))) severity note;
        end loop;


        report "One Output value: " & integer'image(to_integer(signed(output_test))) severity note;


        wait for 10 ns;
        
        curr_data <= two_data;

        for i in 0 to 16 loop
            clk <= '0';
            wait for 10 ns; 
            clk <= '1';
            wait for 10 ns; 
            -- report "Output value: " & integer'image(to_integer(signed(output_test))) severity note;
        end loop;


        report "2 Output value: " & integer'image(to_integer(signed(output_test))) severity note;

        wait for 10 ns;
        
        curr_data <= three_data;

        for i in 0 to 16 loop
            clk <= '0';
            wait for 10 ns; 
            clk <= '1';
            wait for 10 ns; 
            -- report "Output value: " & integer'image(to_integer(signed(output_test))) severity note;
        end loop;


        report "3 Output value: " & integer'image(to_integer(signed(output_test))) severity note;

        wait for 10 ns;
        
        curr_data <= four_data;

        for i in 0 to 16 loop
            clk <= '0';
            wait for 10 ns; 
            clk <= '1';
            wait for 10 ns; 
            -- report "Output value: " & integer'image(to_integer(signed(output_test))) severity note;
        end loop;


        report "4 Output value: " & integer'image(to_integer(signed(output_test))) severity note;




        assert false report "Test done." severity note;

        wait; -- wait indefinitely; otherwise this code loop
        end process;
end structural;

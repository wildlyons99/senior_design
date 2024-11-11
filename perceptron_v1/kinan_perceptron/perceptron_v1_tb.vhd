library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.array_pkg.all;

entity perceptron_v1_tb is
end perceptron_v1_tb;

architecture structural of perceptron_v1_tb is 
    component perceptron_v1 is 
        port(
            clk : in std_logic;
            image_address : in std_logic_vector(3 downto 0);
            prediction : out std_logic
        );
    end component perceptron_v1;

    signal clk : std_logic;
    signal img_adr : std_logic_vector(3 downto 0);
    signal prediction : std_logic;

    begin 
    uut : perceptron_v1 port map(
        clk => clk,
        image_address => img_adr,
        prediction => prediction
    );

    stimulus_process: process
        begin 

        -- zero test
        img_adr <= b"0000";
        wait for 10 ns;

        for i in 0 to 15 loop
            clk <= '0';
            wait for 10 ns; 
            clk <= '1';
            wait for 10 ns; 
        end loop;

        wait for 10 ns;

        assert prediction = '0' report "failed zero test";
        
        -- one test
        img_adr <= b"0001";
        wait for 10 ns;

        for i in 0 to 15 loop
            clk <= '0';
            wait for 10 ns; 
            clk <= '1';
            wait for 10 ns; 
        end loop;

        wait for 10 ns;

        assert prediction = '0' report "failed one test";


        assert false report "Test done." severity note;

        wait; -- wait indefinitely; otherwise this code loop
        end process;
end structural;


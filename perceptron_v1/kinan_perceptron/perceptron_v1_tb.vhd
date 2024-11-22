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
            rst : in std_logic;
            image_address : in std_logic_vector(3 downto 0);
            prediction : out std_logic
        );
    end component perceptron_v1;

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal img_adr : std_logic_vector(3 downto 0) := (others => '0');
    signal prediction : std_logic := '0';
    signal expected_output : std_logic_vector(7 downto 0) := "01110100";

    begin 
        uut : perceptron_v1 port map(
            clk => clk,
            rst => rst,
            image_address => img_adr,
            prediction => prediction
        );

    stimulus_process: process
        begin 

        for it in 0 to 7 loop 
            wait for 10 ns;

            for i in 0 to 16 loop
                clk <= '0';
                wait for 10 ns; 
                clk <= '1';
                wait for 10 ns; 
            end loop;

            img_adr <= std_logic_vector(to_unsigned(it, 4));

            wait for 10 ns;
            report "Output value: " & std_logic'image(prediction) severity note;
            assert prediction = expected_output(it) report "failed test" & integer'image(it) severity note;

        end loop;

        -- ------------------------------------------------------------
        -- wait for 10 ns;
        -- img_adr <= x"0";


        -- for i in 0 to 16 loop
        --     clk <= '0';
        --     wait for 10 ns; 
        --     clk <= '1';
        --     wait for 10 ns; 
        -- end loop;

        -- wait for 10 ns;
        -- -- report "Output value: " & std_logic'image(prediction) severity note;
        -- assert prediction = '0' report "failed test 0"  severity note;


        -- ------------------------------------------------------------
        -- wait for 10 ns;
        -- img_adr <= x"1";


        -- for i in 0 to 16 loop
        --     clk <= '0';
        --     wait for 10 ns; 
        --     clk <= '1';
        --     wait for 10 ns; 
        -- end loop;

        -- wait for 10 ns;
        -- -- report "Output value: " & std_logic'image(prediction) severity note;
        -- assert prediction = '1' report "failed test 1" severity note;


        
        -- ------------------------------------------------------------
        -- wait for 10 ns;
        -- img_adr <= x"2";


        -- for i in 0 to 16 loop
        --     clk <= '0';
        --     wait for 10 ns; 
        --     clk <= '1';
        --     wait for 10 ns; 
        -- end loop;

        -- wait for 10 ns;
        -- -- report "Output value: " & std_logic'image(prediction) severity note;
        -- assert prediction = '1' report "failed test 2" severity note;


        -- ------------------------------------------------------------
        -- wait for 10 ns;
        -- img_adr <= x"3";

        -- clk <= '0';
        -- wait for 10 ns; 
        -- clk <= '1';
        -- wait for 10 ns; 



        -- for i in 0 to 16 loop
        --     clk <= '0';
        --     wait for 10 ns; 
        --     clk <= '1';
        --     wait for 10 ns; 
        -- end loop;

        -- wait for 10 ns;
        -- -- report "Output value: " & std_logic'image(prediction) severity note;
        -- assert prediction = '1' report "failed test 3" severity note;




        -- ------------------------------------------------------------
        -- wait for 10 ns;
        -- img_adr <= x"4";


        -- for i in 0 to 16 loop
        --     clk <= '0';
        --     wait for 10 ns; 
        --     clk <= '1';
        --     wait for 10 ns; 
        -- end loop;

        -- wait for 10 ns;
        -- -- report "Output value: " & std_logic'image(prediction) severity note;
        -- assert prediction = '0' report "failed test 4" severity note;






        report "Test done." severity note;

        wait; -- wait indefinitely; otherwise this code loop
        end process;
end structural;
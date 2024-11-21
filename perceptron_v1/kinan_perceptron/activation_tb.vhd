library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity activation_tb is
end activation_tb;

architecture behavior of activation_tb is
    component activation is
        port(
            input_vector : in std_logic_vector(15 downto 0);
            prediction   : out std_logic
        );
    end component;

    signal input_vector : std_logic_vector(15 downto 0) := (others => '0');
    signal prediction   : std_logic;
begin
    uut: activation
        port map(
            input_vector => input_vector,
            prediction   => prediction
        );

        stimulus_process: process
    begin
        -- Test zero value
        input_vector <= x"0000";
        wait for 10 ns;
        assert prediction = '0' report "Test failed for input = 0" severity error;

        -- Test positive value
        input_vector <= x"0004";
        wait for 10 ns;
        assert prediction = '1' report "Test failed for positive input = 10" severity error;

        -- Test negative value
        input_vector <= x"8004";
        wait for 10 ns;
        assert prediction = '0' report "Test failed for negative input = -10" severity error;

        -- Stop simulation
        report "All tests passed!";
        wait;
    end process;

end behavior;

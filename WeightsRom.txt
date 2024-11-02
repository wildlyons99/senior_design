library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;entity WeightRom is    port(
        clk : in std_logic;
        xadr: in unsigned(1 downto 0);
        yadr : in unsigned(1 downto 0); -- 0-1023
        weight : out signed(7 downto 0)
        );
end WeightRom;

architecture synth of WeightRom is
signal totaladr : std_logic_vector(3 downto 0);
begin
    process (clk) begin
        if rising_edge(clk) then
            case totaladr is
                when "0000" => weight <= "00111010";
                when "0001" => weight <= "00011101";
                when "0010" => weight <= "00010000";
                when "0011" => weight <= "01010101";
                when "0100" => weight <= "01001001";
                when "0101" => weight <= "11101100";
                when "0110" => weight <= "00010111";
                when "0111" => weight <= "11010111";
                when "1000" => weight <= "10111101";
                when "1001" => weight <= "11101010";
                when "1010" => weight <= "11111010";
                when "1011" => weight <= "11000001";
                when "1100" => weight <= "00100010";
                when "1101" => weight <= "11001111";
                when "1110" => weight <= "11101000";
                when others => weight <= "00000000";
        end case;
    end if;
    end process;
    totaladr <= std_logic_vector(yadr) & std_logic_vector(xadr);
end;

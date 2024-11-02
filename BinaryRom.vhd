library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;entity BinaryRom is    port(
        clk : in std_logic;
        xadr: in unsigned(1 downto 0);
        yadr : in unsigned(1 downto 0); -- 0-1023
        grayScale : out std_logic_vector(7 downto 0)
        );
end BinaryRom;

architecture synth of BinaryRom is
signal totaladr : std_logic_vector(3 downto 0);
begin
    process (clk) begin
        if rising_edge(clk) then
            case totaladr is
                when "0000" => rgb <= "00000000";
                when "0001" => rgb <= "00100101";
                when "0010" => rgb <= "00100010";
                when "0011" => rgb <= "00000000";
                when "0100" => rgb <= "00000000";
                when "0101" => rgb <= "01000110";
                when "0110" => rgb <= "01010000";
                when "0111" => rgb <= "00000000";
                when "1000" => rgb <= "00000000";
                when "1001" => rgb <= "01000001";
                when "1010" => rgb <= "01010100";
                when "1011" => rgb <= "00000000";
                when "1100" => rgb <= "00000000";
                when "1101" => rgb <= "00100111";
                when "1110" => rgb <= "00111010";
                when "1111" => rgb <= "00000000";
                when others => rgb <= "111111";
        end case;
    end if;
    end process;
    totaladr <= std_logic_vector(yadr) & std_logic_vector(xadr);
end;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;entity im8_0 is    port(
        clk : in std_logic;
        totaladr: in unsigned(3 downto 0);
        grayScale : out std_logic_vector(7 downto 0)
        );
end im8_0;

architecture synth of im8_0 is
begin
    process (clk) begin
        if rising_edge(clk) then
            case totaladr is
                when "0000" => grayScale <= "00000000";
                when "0001" => grayScale <= "00000000";
                when "0010" => grayScale <= "00000000";
                when "0011" => grayScale <= "00000000";
                when "0100" => grayScale <= "00000000";
                when "0101" => grayScale <= "01001000";
                when "0110" => grayScale <= "01001011";
                when "0111" => grayScale <= "00100001";
                when "1000" => grayScale <= "00101000";
                when "1001" => grayScale <= "00011001";
                when "1010" => grayScale <= "00101111";
                when "1011" => grayScale <= "00010100";
                when "1100" => grayScale <= "00000101";
                when "1101" => grayScale <= "00011101";
                when "1110" => grayScale <= "00000100";
                when "1111" => grayScale <= "00000000";
                when others => grayScale <= "00000000";
        end case;
    end if;
    end process;
end;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity zero_image is port(
    clk : in std_logic;
    totaladr : in unsigned(3 downto 0);
    grayScale : out signed(7 downto 0)
    );
end zero_image;

architecture synth of zero_image is
begin
    process (clk) begin
        if rising_edge(clk) then
            case totaladr is
                when "0000" => grayScale <= "00000000";
                when "0001" => grayScale <= "00100101";
                when "0010" => grayScale <= "00100010";
                when "0011" => grayScale <= "00000000";
                when "0100" => grayScale <= "00000000";
                when "0101" => grayScale <= "01000110";
                when "0110" => grayScale <= "01010000";
                when "0111" => grayScale <= "00000000";
                when "1000" => grayScale <= "00000000";
                when "1001" => grayScale <= "01000001";
                when "1010" => grayScale <= "01010100";
                when "1011" => grayScale <= "00000000";
                when "1100" => grayScale <= "00000000";
                when "1101" => grayScale <= "00100111";
                when "1110" => grayScale <= "00111010";
                when "1111" => grayScale <= "00000000";
                when others => grayScale <= "11111111";
        end case;
    end if;
    end process;
end;

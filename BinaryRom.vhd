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
                when "0000" => grayScale <= "00000000";
                when "0001" => grayScale <= "00010010";
                when "0010" => grayScale <= "00010001";
                when "0011" => grayScale <= "00000000";
                when "0100" => grayScale <= "00000000";
                when "0101" => grayScale <= "00100011";
                when "0110" => grayScale <= "00101000";
                when "0111" => grayScale <= "00000000";
                when "1000" => grayScale <= "00000000";
                when "1001" => grayScale <= "00100000";
                when "1010" => grayScale <= "00101010";
                when "1011" => grayScale <= "00000000";
                when "1100" => grayScale <= "00000000";
                when "1101" => grayScale <= "00010011";
                when "1110" => grayScale <= "00011101";
                when "1111" => grayScale <= "00000000";
                when others => grayScale <= "00000000";
        end case;
    end if;
    end process;
    totaladr <= std_logic_vector(yadr) & std_logic_vector(xadr);
end;

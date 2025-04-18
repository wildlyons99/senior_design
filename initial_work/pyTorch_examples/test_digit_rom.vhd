library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity digits_rom is
    Port ( address : in  STD_LOGIC_VECTOR(8 downto 0);
           data : out STD_LOGIC_VECTOR(5 downto 0));
end rom;

architecture Behavioral of rom is
begin
    process(address)
    begin
        case address is
            when "000000000" => data <= 000000;
            when "000000001" => data <= 000000;
            when "000000010" => data <= 000000;
            when "000000011" => data <= 000000;
            when "000000100" => data <= 000000;
            when "000000101" => data <= 000000;
            when "000000110" => data <= 000000;
            when "000000111" => data <= 000000;
            when "000001000" => data <= 000000;
            when "000001001" => data <= 000000;
            when "000001010" => data <= 000000;
            when "000001011" => data <= 000000;
            when "000001100" => data <= 000000;
            when "000001101" => data <= 000000;
            when "000001110" => data <= 000000;
            when "000001111" => data <= 000000;
            when "000010000" => data <= 000000;
            when "000010001" => data <= 000000;
            when "000010010" => data <= 000000;
            when "000010011" => data <= 000000;
            when "000100000" => data <= 000000;
            when "000100001" => data <= 000000;
            when "000100010" => data <= 000000;
            when "000100011" => data <= 000000;
            when "000100100" => data <= 000000;
            when "000100101" => data <= 000000;
            when "000100110" => data <= 000000;
            when "000100111" => data <= 000000;
            when "000101000" => data <= 000000;
            when "000101001" => data <= 000000;
            when "000101010" => data <= 111111;
            when "000101011" => data <= 000000;
            when "000101100" => data <= 000000;
            when "000101101" => data <= 000000;
            when "000101110" => data <= 000000;
            when "000101111" => data <= 000000;
            when "000110000" => data <= 000000;
            when "000110001" => data <= 000000;
            when "000110010" => data <= 000000;
            when "000110011" => data <= 000000;
            when "001000000" => data <= 000000;
            when "001000001" => data <= 000000;
            when "001000010" => data <= 000000;
            when "001000011" => data <= 000000;
            when "001000100" => data <= 000000;
            when "001000101" => data <= 000000;
            when "001000110" => data <= 000000;
            when "001000111" => data <= 000000;
            when "001001000" => data <= 000000;
            when "001001001" => data <= 111111;
            when "001001010" => data <= 111111;
            when "001001011" => data <= 000000;
            when "001001100" => data <= 000000;
            when "001001101" => data <= 000000;
            when "001001110" => data <= 000000;
            when "001001111" => data <= 000000;
            when "001010000" => data <= 000000;
            when "001010001" => data <= 000000;
            when "001010010" => data <= 000000;
            when "001010011" => data <= 000000;
            when "001100000" => data <= 000000;
            when "001100001" => data <= 000000;
            when "001100010" => data <= 000000;
            when "001100011" => data <= 000000;
            when "001100100" => data <= 000000;
            when "001100101" => data <= 000000;
            when "001100110" => data <= 000000;
            when "001100111" => data <= 000000;
            when "001101000" => data <= 111111;
            when "001101001" => data <= 111111;
            when "001101010" => data <= 000000;
            when "001101011" => data <= 000000;
            when "001101100" => data <= 000000;
            when "001101101" => data <= 000000;
            when "001101110" => data <= 000000;
            when "001101111" => data <= 000000;
            when "001110000" => data <= 000000;
            when "001110001" => data <= 000000;
            when "001110010" => data <= 000000;
            when "001110011" => data <= 000000;
            when "010000000" => data <= 000000;
            when "010000001" => data <= 000000;
            when "010000010" => data <= 000000;
            when "010000011" => data <= 000000;
            when "010000100" => data <= 000000;
            when "010000101" => data <= 000000;
            when "010000110" => data <= 000000;
            when "010000111" => data <= 111111;
            when "010001000" => data <= 111111;
            when "010001001" => data <= 000000;
            when "010001010" => data <= 000000;
            when "010001011" => data <= 000000;
            when "010001100" => data <= 000000;
            when "010001101" => data <= 000000;
            when "010001110" => data <= 000000;
            when "010001111" => data <= 000000;
            when "010010000" => data <= 000000;
            when "010010001" => data <= 000000;
            when "010010010" => data <= 000000;
            when "010010011" => data <= 000000;
            when "010100000" => data <= 000000;
            when "010100001" => data <= 000000;
            when "010100010" => data <= 000000;
            when "010100011" => data <= 000000;
            when "010100100" => data <= 000000;
            when "010100101" => data <= 000000;
            when "010100110" => data <= 000000;
            when "010100111" => data <= 111111;
            when "010101000" => data <= 111111;
            when "010101001" => data <= 000000;
            when "010101010" => data <= 000000;
            when "010101011" => data <= 000000;
            when "010101100" => data <= 000000;
            when "010101101" => data <= 000000;
            when "010101110" => data <= 000000;
            when "010101111" => data <= 000000;
            when "010110000" => data <= 000000;
            when "010110001" => data <= 000000;
            when "010110010" => data <= 000000;
            when "010110011" => data <= 000000;
            when "011000000" => data <= 000000;
            when "011000001" => data <= 000000;
            when "011000010" => data <= 000000;
            when "011000011" => data <= 000000;
            when "011000100" => data <= 000000;
            when "011000101" => data <= 000000;
            when "011000110" => data <= 111111;
            when "011000111" => data <= 111111;
            when "011001000" => data <= 000000;
            when "011001001" => data <= 000000;
            when "011001010" => data <= 000000;
            when "011001011" => data <= 000000;
            when "011001100" => data <= 000000;
            when "011001101" => data <= 000000;
            when "011001110" => data <= 000000;
            when "011001111" => data <= 000000;
            when "011010000" => data <= 000000;
            when "011010001" => data <= 000000;
            when "011010010" => data <= 000000;
            when "011010011" => data <= 000000;
            when "011100000" => data <= 000000;
            when "011100001" => data <= 000000;
            when "011100010" => data <= 000000;
            when "011100011" => data <= 000000;
            when "011100100" => data <= 000000;
            when "011100101" => data <= 000000;
            when "011100110" => data <= 111111;
            when "011100111" => data <= 111111;
            when "011101000" => data <= 000000;
            when "011101001" => data <= 000000;
            when "011101010" => data <= 000000;
            when "011101011" => data <= 000000;
            when "011101100" => data <= 000000;
            when "011101101" => data <= 000000;
            when "011101110" => data <= 000000;
            when "011101111" => data <= 000000;
            when "011110000" => data <= 000000;
            when "011110001" => data <= 000000;
            when "011110010" => data <= 000000;
            when "011110011" => data <= 000000;
            when "100000000" => data <= 000000;
            when "100000001" => data <= 000000;
            when "100000010" => data <= 000000;
            when "100000011" => data <= 000000;
            when "100000100" => data <= 000000;
            when "100000101" => data <= 000000;
            when "100000110" => data <= 111111;
            when "100000111" => data <= 111111;
            when "100001000" => data <= 000000;
            when "100001001" => data <= 111111;
            when "100001010" => data <= 111111;
            when "100001011" => data <= 111111;
            when "100001100" => data <= 111111;
            when "100001101" => data <= 000000;
            when "100001110" => data <= 000000;
            when "100001111" => data <= 000000;
            when "100010000" => data <= 000000;
            when "100010001" => data <= 000000;
            when "100010010" => data <= 000000;
            when "100010011" => data <= 000000;
            when "100100000" => data <= 000000;
            when "100100001" => data <= 000000;
            when "100100010" => data <= 000000;
            when "100100011" => data <= 000000;
            when "100100100" => data <= 000000;
            when "100100101" => data <= 000000;
            when "100100110" => data <= 111111;
            when "100100111" => data <= 111111;
            when "100101000" => data <= 111111;
            when "100101001" => data <= 111111;
            when "100101010" => data <= 000000;
            when "100101011" => data <= 000000;
            when "100101100" => data <= 111111;
            when "100101101" => data <= 111111;
            when "100101110" => data <= 000000;
            when "100101111" => data <= 000000;
            when "100110000" => data <= 000000;
            when "100110001" => data <= 000000;
            when "100110010" => data <= 000000;
            when "100110011" => data <= 000000;
            when "101000000" => data <= 000000;
            when "101000001" => data <= 000000;
            when "101000010" => data <= 000000;
            when "101000011" => data <= 000000;
            when "101000100" => data <= 000000;
            when "101000101" => data <= 000000;
            when "101000110" => data <= 111111;
            when "101000111" => data <= 111111;
            when "101001000" => data <= 111111;
            when "101001001" => data <= 000000;
            when "101001010" => data <= 000000;
            when "101001011" => data <= 000000;
            when "101001100" => data <= 111111;
            when "101001101" => data <= 111111;
            when "101001110" => data <= 000000;
            when "101001111" => data <= 000000;
            when "101010000" => data <= 000000;
            when "101010001" => data <= 000000;
            when "101010010" => data <= 000000;
            when "101010011" => data <= 000000;
            when "101100000" => data <= 000000;
            when "101100001" => data <= 000000;
            when "101100010" => data <= 000000;
            when "101100011" => data <= 000000;
            when "101100100" => data <= 000000;
            when "101100101" => data <= 000000;
            when "101100110" => data <= 000000;
            when "101100111" => data <= 111111;
            when "101101000" => data <= 111111;
            when "101101001" => data <= 000000;
            when "101101010" => data <= 000000;
            when "101101011" => data <= 000000;
            when "101101100" => data <= 111111;
            when "101101101" => data <= 111111;
            when "101101110" => data <= 000000;
            when "101101111" => data <= 000000;
            when "101110000" => data <= 000000;
            when "101110001" => data <= 000000;
            when "101110010" => data <= 000000;
            when "101110011" => data <= 000000;
            when "110000000" => data <= 000000;
            when "110000001" => data <= 000000;
            when "110000010" => data <= 000000;
            when "110000011" => data <= 000000;
            when "110000100" => data <= 000000;
            when "110000101" => data <= 000000;
            when "110000110" => data <= 000000;
            when "110000111" => data <= 000000;
            when "110001000" => data <= 111111;
            when "110001001" => data <= 111111;
            when "110001010" => data <= 111111;
            when "110001011" => data <= 111111;
            when "110001100" => data <= 111111;
            when "110001101" => data <= 000000;
            when "110001110" => data <= 000000;
            when "110001111" => data <= 000000;
            when "110010000" => data <= 000000;
            when "110010001" => data <= 000000;
            when "110010010" => data <= 000000;
            when "110010011" => data <= 000000;
            when "110100000" => data <= 111111;
            when "110100001" => data <= 000000;
            when "110100010" => data <= 000000;
            when "110100011" => data <= 000000;
            when "110100100" => data <= 000000;
            when "110100101" => data <= 000000;
            when "110100110" => data <= 000000;
            when "110100111" => data <= 000000;
            when "110101000" => data <= 000000;
            when "110101001" => data <= 000000;
            when "110101010" => data <= 000000;
            when "110101011" => data <= 000000;
            when "110101100" => data <= 000000;
            when "110101101" => data <= 000000;
            when "110101110" => data <= 000000;
            when "110101111" => data <= 000000;
            when "110110000" => data <= 000000;
            when "110110001" => data <= 000000;
            when "110110010" => data <= 000000;
            when "110110011" => data <= 000000;
            when "111000000" => data <= 111111;
            when "111000001" => data <= 111111;
            when "111000010" => data <= 000000;
            when "111000011" => data <= 000000;
            when "111000100" => data <= 000000;
            when "111000101" => data <= 000000;
            when "111000110" => data <= 000000;
            when "111000111" => data <= 000000;
            when "111001000" => data <= 000000;
            when "111001001" => data <= 000000;
            when "111001010" => data <= 000000;
            when "111001011" => data <= 000000;
            when "111001100" => data <= 000000;
            when "111001101" => data <= 000000;
            when "111001110" => data <= 000000;
            when "111001111" => data <= 000000;
            when "111010000" => data <= 000000;
            when "111010001" => data <= 000000;
            when "111010010" => data <= 000000;
            when "111010011" => data <= 000000;
            when others => data <= "000000";
        end case;
    end process;
end Behavioral;
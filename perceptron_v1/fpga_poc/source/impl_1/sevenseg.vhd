library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sevenseg is
  port(
	  S : in std_logic_vector(3 downto 0);
	  segments : out std_logic_vector(6 downto 0)
  );
end sevenseg;

architecture synth of sevenseg is 
begin 
  segments <= "0000001" when S = "0000" else
              "1001111" when S = "0001" else
              "0010010" when S = "0010" else
              "0000110" when S = "0011" else
              "1001100" when S = "0100" else
              "0100100" when S = "0101" else
              "0100000" when S = "0110" else
              "0001111" when S = "0111" else
              "0000000" when S = "1000" else
              "0001100" when S = "1001" else
              "0001000" when S = "1010" else
              "1100000" when S = "1011" else
              "1110010" when S = "1100" else
              "1000010" when S = "1101" else
              "0110000" when S = "1110" else
              "0111000" when S = "1111";
end;
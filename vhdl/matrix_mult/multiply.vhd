library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity multiply is
    port(
        in0    : in  unsigned(7 downto 0);
        in1    : in  unsigned(7 downto 0);
        output : out unsigned(15 downto 0)
    );
end multiply;
    
architecture structural of multiply is
begin
    
    output <= in0 * in1; 
    
end structural; 
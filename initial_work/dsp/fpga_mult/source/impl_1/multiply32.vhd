library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity multiply32 is
    port(
        in0    : in  unsigned(31 downto 0);
        in1    : in  unsigned(31 downto 0);
        output : out unsigned(63 downto 0)
    );
end multiply32;
    
architecture structural of multiply32 is
begin
    output <= in0 * in1; 
    
end structural; 
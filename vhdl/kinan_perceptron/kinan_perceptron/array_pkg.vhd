library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package array_pkg is
    type byte_array is array(0 to 15) of std_logic_vector(7 downto 0);
end array_pkg;

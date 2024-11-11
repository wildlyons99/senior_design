library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity activation is
    port(
        input_vector : in std_logic_vector(15 downto 0);
        prediction : out std_logic
    );
end activation;

architecture dataflow of activation is 
begin 
    output <= '1' when (signed(input_vector) > 0) else '0';

end dataflow;

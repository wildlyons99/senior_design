-- introductory testbench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity hello_world is
    -- empty 
end hello_world;

architecture behavioral of hello_world is
    begin
        process is
        begin
            report "hello world"; 
            wait;
        end process;
    end architecture; 
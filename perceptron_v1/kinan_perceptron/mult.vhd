
library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.numeric_std.ALL; 
use work.array_pkg.ALL;

entity mult is 
    port(
        clk : in std_logic;
        reset : in std_logic;
        input : in byte_array;
        output : out std_logic_vector(15 downto 0)
    );
end mult;

architecture behavioral of mult is 
    signal bias : signed(15 downto 0) := x"0800";
    signal weights : byte_array := (
        "00111010",
        "00011101",
        "00010000",
        "01010101",
        "01001001",
        "11101100",
        "00010111",
        "11010111",
        "10111101",
        "11101010",
        "11111010",
        "11000001",
        "00100010",
        "11001111",
        "11101000",
        "01001000"
    ); 
    signal temp_output : signed(15 downto 0) := (others => '0');
    signal count : integer := 0;

    begin 
        process(clk)
        begin
            if rising_edge(clk) then 
                if reset = '1' then 
                    -- Reset state
                    temp_output <= bias;
                    count <= 0;
                    output <= (others => '0');
                elsif count < 16 then 
                    -- Accumulate dot product
                    temp_output <= temp_output + signed(input(count)) * signed(weights(count));
                    output <= std_logic_vector(temp_output); 
                    count <= count + 1;
                else
                    -- End of calculation
                    output <= std_logic_vector(temp_output); 
                end if;
            end if;
        end process;
end behavioral;
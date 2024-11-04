library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned
use work.array_pkg.ALL;

entity rom is
port(
    image_address : std_logic_vector(3 downto 0);
    clk : in std_logic;
    output_array : out byte_array
);
end rom;

architecture behavioral of rom is
signal rom_bytes : byte_array;

begin
    process(clk) is
    begin 
        if rising_edge(clk) then 
            if(image_address = "0000") then 
                rom_bytes(0)  <= "00000000";  
                rom_bytes(1)  <= "00010010";  
                rom_bytes(2)  <= "00010001";  
                rom_bytes(3)  <= "00000000";  
                rom_bytes(4)  <= "00000000";  
                rom_bytes(5)  <= "00100011";  
                rom_bytes(6)  <= "00101000";  
                rom_bytes(7)  <= "00000000";  

                rom_bytes(8)  <= "00000000";  
                rom_bytes(9)  <= "00100000";  
                rom_bytes(10)  <= "00101010";  
                rom_bytes(11)  <= "00000000";  
                rom_bytes(12)  <= "00000000";  
                rom_bytes(13)  <= "00010011";  
                rom_bytes(14)  <= "00000000";  
                rom_bytes(15)  <= "00000000"; 
            else 
                for i in 0 to 15 loop
                    rom_bytes(i) <= "00000000";  
                end loop;
            end if;
            output_array <= rom_bytes;
        end if;
    end process;
end behavioral;





library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned
use work.array_pkg.ALL;

entity rom is
    port(
        clk : in std_logic;
        image_address : std_logic_vector(7 downto 0);
        output_array : out byte_array
    );
end rom;

architecture behavioral of rom is
signal rom_bytes : byte_array;

begin
    process(clk) is
    begin 
        if rising_edge(clk) then 
            -- Zero
            if(image_address(0) = '1') then 
                rom_bytes(0)   <= "00000000";  
                rom_bytes(1)   <= "00000100";  
                rom_bytes(2)   <= "00011101";  
                rom_bytes(3)   <= "00000000";  
                rom_bytes(4)   <= "00000000";  
                rom_bytes(5)   <= "00101100";  
                rom_bytes(6)   <= "00000000";  
                rom_bytes(7)   <= "00001011";  
                rom_bytes(8)   <= "00000111";  
                rom_bytes(9)   <= "00100111";  
                rom_bytes(10)  <= "00001000";  
                rom_bytes(11)  <= "00100010";  
                rom_bytes(12)  <= "00000000";  
                rom_bytes(13)  <= "00010000";  
                rom_bytes(14)  <= "00011001";  
                rom_bytes(15)  <= "00000000"; 
            
            -- One
            elsif(image_address(1) = '1') then 
                rom_bytes(0)   <= "00000000"; 
                rom_bytes(1)   <= "00000000"; 
                rom_bytes(2)   <= "00011000"; 
                rom_bytes(3)   <= "00000000"; 
                rom_bytes(4)   <= "00000000"; 
                rom_bytes(5)   <= "00000010"; 
                rom_bytes(6)   <= "00111110"; 
                rom_bytes(7)   <= "00000000"; 
                rom_bytes(8)   <= "00000000"; 
                rom_bytes(9)   <= "00110011"; 
                rom_bytes(10)  <= "00010001"; 
                rom_bytes(11)  <= "00000000"; 
                rom_bytes(12)  <= "00000000"; 
                rom_bytes(13)  <= "00100001"; 
                rom_bytes(14)  <= "00000000"; 
                rom_bytes(15)  <= "00000000";

            -- One
            elsif(image_address(2) = '1') then 
                rom_bytes(0)   <= "00000000"; 
                rom_bytes(1)   <= "00000100"; 
                rom_bytes(2)   <= "00000001"; 
                rom_bytes(3)   <= "00000000"; 
                rom_bytes(4)   <= "00000000"; 
                rom_bytes(5)   <= "00010010"; 
                rom_bytes(6)   <= "00010001"; 
                rom_bytes(7)   <= "00000000"; 
                rom_bytes(8)   <= "00000000"; 
                rom_bytes(9)   <= "00010001"; 
                rom_bytes(10)  <= "00001111"; 
                rom_bytes(11)  <= "00000000"; 
                rom_bytes(12)  <= "00000000"; 
                rom_bytes(13)  <= "00000100"; 
                rom_bytes(14)  <= "00001100"; 
                rom_bytes(15)  <= "00000000";

            -- One
            elsif(image_address(3) = '1') then 
                rom_bytes(0)   <= "00000000"; 
                rom_bytes(1)   <= "00000000"; 
                rom_bytes(2)   <= "00001101"; 
                rom_bytes(3)   <= "00000000"; 
                rom_bytes(4)   <= "00000000"; 
                rom_bytes(5)   <= "00010110"; 
                rom_bytes(6)   <= "01000011"; 
                rom_bytes(7)   <= "00000000"; 
                rom_bytes(8)   <= "00000000"; 
                rom_bytes(9)   <= "00100111"; 
                rom_bytes(10)  <= "00001100"; 
                rom_bytes(11)  <= "00000000"; 
                rom_bytes(12)  <= "00000000"; 
                rom_bytes(13)  <= "00011101"; 
                rom_bytes(14)  <= "00000000"; 
                rom_bytes(15)  <= "00000000";

            -- Zero
            elsif(image_address(4) = '1') then 
                rom_bytes(0)   <= "00000000"; 
                rom_bytes(1)   <= "00000000"; 
                rom_bytes(2)   <= "00100001"; 
                rom_bytes(3)   <= "00000000"; 
                rom_bytes(4)   <= "00000000"; 
                rom_bytes(5)   <= "00110000"; 
                rom_bytes(6)   <= "01011011"; 
                rom_bytes(7)   <= "00010010"; 
                rom_bytes(8)   <= "00001100"; 
                rom_bytes(9)   <= "00111010"; 
                rom_bytes(10)  <= "00101010"; 
                rom_bytes(11)  <= "00010001"; 
                rom_bytes(12)  <= "00000001"; 
                rom_bytes(13)  <= "00101110"; 
                rom_bytes(14)  <= "00010111"; 
                rom_bytes(15)  <= "00000000";


            -- One
            elsif(image_address(5) = '1') then 
                rom_bytes(0)   <= "00000000"; 
                rom_bytes(1)   <= "00010000"; 
                rom_bytes(2)   <= "00001010"; 
                rom_bytes(3)   <= "00000000"; 
                rom_bytes(4)   <= "00000000"; 
                rom_bytes(5)   <= "00110000"; 
                rom_bytes(6)   <= "00110000"; 
                rom_bytes(7)   <= "00000000"; 
                rom_bytes(8)   <= "00000000"; 
                rom_bytes(9)   <= "00110101"; 
                rom_bytes(10)  <= "00110100"; 
                rom_bytes(11)  <= "00000000"; 
                rom_bytes(12)  <= "00000000"; 
                rom_bytes(13)  <= "00001010"; 
                rom_bytes(14)  <= "00011001"; 
                rom_bytes(15)  <= "00000000";

            -- Zero
            elsif(image_address(6) = '1') then 
                rom_bytes(0)   <= "00000000"; 
                rom_bytes(1)   <= "00000000"; 
                rom_bytes(2)   <= "00000000"; 
                rom_bytes(3)   <= "00000000"; 
                rom_bytes(4)   <= "00000000"; 
                rom_bytes(5)   <= "01001000"; 
                rom_bytes(6)   <= "01001011"; 
                rom_bytes(7)   <= "00100001"; 
                rom_bytes(8)   <= "00101000"; 
                rom_bytes(9)   <= "00011001"; 
                rom_bytes(10)  <= "00101111"; 
                rom_bytes(11)  <= "00010100"; 
                rom_bytes(12)  <= "00000101"; 
                rom_bytes(13)  <= "00011101"; 
                rom_bytes(14)  <= "00000100"; 
                rom_bytes(15)  <= "00000000";


            -- Zero
            elsif(image_address(7) = '1') then 
                rom_bytes(0)   <= "00000000"; 
                rom_bytes(1)   <= "00000000"; 
                rom_bytes(2)   <= "00100010"; 
                rom_bytes(3)   <= "00000000"; 
                rom_bytes(4)   <= "00000000"; 
                rom_bytes(5)   <= "00011010"; 
                rom_bytes(6)   <= "01001000"; 
                rom_bytes(7)   <= "00001000"; 
                rom_bytes(8)   <= "00001001"; 
                rom_bytes(9)   <= "00110100"; 
                rom_bytes(10)  <= "01000001"; 
                rom_bytes(11)  <= "00000011"; 
                rom_bytes(12)  <= "00000101"; 
                rom_bytes(13)  <= "00101011"; 
                rom_bytes(14)  <= "00000111"; 
                rom_bytes(15)  <= "00000000";
            else 
                -- all zeros ROM 
				rom_bytes(0)   <= "00000000"; 
                rom_bytes(1)   <= "00000000"; 
                rom_bytes(2)   <= "00000000"; 
                rom_bytes(3)   <= "00000000"; 
                rom_bytes(4)   <= "00000000"; 
                rom_bytes(5)   <= "00000000"; 
                rom_bytes(6)   <= "00000000"; 
                rom_bytes(7)   <= "00000000"; 
                rom_bytes(8)   <= "00000000"; 
                rom_bytes(9)   <= "00000000"; 
                rom_bytes(10)  <= "00000000"; 
                rom_bytes(11)  <= "00000000"; 
                rom_bytes(12)  <= "00000000"; 
                rom_bytes(13)  <= "00000000"; 
                rom_bytes(14)  <= "00000000"; 
                rom_bytes(15)  <= "00000000";
            end if;
            output_array <= rom_bytes;
        end if;
    end process;
end behavioral;
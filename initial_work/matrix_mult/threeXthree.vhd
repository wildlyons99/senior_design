-- initial implementation of a synthesizable (we think) 3x3 matrix multiplication
-- 2 bit unsigned matrix multiplication
-- likely not the most efficient 
-- ToDO: on FPGA & measure usage. Figure out DSPs vs Multipliers

-- Authors: Tom and Cory

library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity threeXthree is
    port(
        clk        : in  std_logic; 
        rst        : in  std_logic; 
        -- 2 bit 3x3 vectors
        matrixA    : in  unsigned(17 downto 0);
        matrixB    : in  unsigned(17 downto 0);
        matrixC    : out unsigned(17 downto 0)
    );
end threeXthree;
    
architecture structural of threeXthree is
    -- general matrix type with 2-bit unsigned elements
    type matrix is array(natural range <>, natural range <>) of unsigned(1 downto 0);
    
    -- initialize 3x3 matrices (nested others for setting the inner dimension to "00")
    signal matA : matrix(0 to 2, 0 to 2) := (others => (others => "00"));
    signal matB : matrix(0 to 2, 0 to 2) := (others => (others => "00"));
    signal matC : matrix(0 to 2, 0 to 2) := (others => (others => "00"));

    -- initial states - using types to make more clear 
    type state_type is (init, do_mult, apply_outputs);
    signal state : state_type := init; -- initial state is init
    signal i,j,k : integer := 0;

begin
    state_machine : process (clk, rst)
    
    -- Temp variable to use within process block
    variable temp : unsigned(3 downto 0) := (others => '0');  -- 4 bits to handle the multiplication result
    begin
        if(rst = '1') then
            state <= init;
            matA <= (others => (others => "00"));
            matB <= (others => (others => "00"));
            matC <= (others => (others => "00"));
        elsif rising_edge(clk) then
            case state is
                when init =>    --the matrices which are in a 1-D array are converted to 2-D matrices first.
                    for i in 0 to 2 loop    --run through the rows
                        for j in 0 to 2 loop    --run through the columns
                            matA(i, j) <= matrixA((i * 3 + j + 1) * 2 - 1 downto (i * 3 + j) * 2); 
                            matB(i, j) <= matrixB((i * 3 + j + 1) * 2 - 1 downto (i * 3 + j) * 2);
                        end loop;
                    end loop;
                    state <= do_mult;
                when do_mult =>
                    temp := unsigned(matA(i,k)) * unsigned(matB(k,j)); 
                    matC(i,j) <= matC(i,j) + temp(1 downto 0); -- sum the result (take lower 2 bits)
                    if(k = 2) then
                        k <= 0;
                        if(j = 2) then
                            j <= 0;
                            if (i = 2) then
                                i <= 0;
                                state <= apply_outputs;
                            else
                                i <= i + 1;
                            end if;
                        else
                            j <= j + 1;
                        end if;        
                    else
                        k <= k + 1;
                    end if;     
                when apply_outputs =>   --convert 3x3 matrix into a 1-D matrix.
                    for i in 0 to 2 loop    --run through the rows
                        for j in 0 to 2 loop    --run through the columns
                            matrixC((i*3+j+1)*2-1 downto (i*3+j)*2) <= matC(i,j);
                        end loop;
                    end loop;
                    state <= init;  
            end case;
        end if;
    end process;
        
end structural;

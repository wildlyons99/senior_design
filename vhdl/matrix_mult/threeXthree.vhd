-- initial implementation of a synthesizable (we think) 3x3 matrix multiplication
-- 1 bit integer matrix multiplication
-- likely not the most efficent 
-- ToDO: on FPGA & measure usage. Figure out DSPs vs Multipliers

-- Authors: Tom and Cory

library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity threeXthree is
    -- generic(NUM_ELEMS : integer := 9);
    port(
        clk        : in  std_logic; 
        rst        : in  std_logic; 
        -- 1 bit 3x3 vectors
        matrixA    : in  unsigned(8 downto 0);
        matrixB    : in  unsigned(8 downto 0);
        
        -- 2 bit 3x3 vectors to handle multiplication
        -- matrixC    : out unsigned(17 downto 0)
        matrixC    : out unsigned(8 downto 0)
    );
end threeXthree;
    
architecture structural of threeXthree is
    -- general matrix type
    type matrix is array(natural range <>, natural range <>) of std_logic;
    
    -- initialize 3x3 matrices (nested others for setting the inner demension to 0)
    signal matA : matrix(0 to 2, 0 to 2) := (others => (others => '0'));
    signal matB : matrix(0 to 2, 0 to 2) := (others => (others => '0'));
    signal matC : matrix(0 to 2, 0 to 2) := (others => (others => '0'));

    -- initial states - using types to make more clear 
    type state_type is (init, do_mult, apply_outputs);
    signal state : state_type := init; -- initial state is init
    signal i,j,k : integer := 0;

begin -- begin the architecture 
    state_machine : process (clk, rst)
    
    -- Temp variable to use within process block
    -- Variable can be updated within process (doesn't take a clock cycle to update like signals)
    variable temp : unsigned(15 downto 0) := (others => '0');
    begin -- beginning of process
        if(rst = '1') then
            state <= init;
            -- i <= 0;
            -- j <= 0;
            -- k <= 0;
            matA <= (others => (others => '0'));
            matB <= (others => (others => '0'));
            matC <= (others => (others => '0'));
        elsif rising_edge(clk) then
            case state is
                when init =>    --the matrices which are in a 1-D array are converted to 2-D matrices first.
                    for i in 0 to 2 loop    --run through the rows
                        for j in 0 to 2 loop    --run through the columns
                            matA(i, j) <= matrixA((i * 3 + j + 1) * 8 - 1); -- change to downto for vector
                            matB(i, j) <= matrixB((i * 3 + j + 1) * 8 - 1);
                        end loop;
                    end loop;
                    state <= do_mult;
                when do_mult =>
                    temp := unsigned((matA(i,k))) * unsigned((matB(k,j))); -- make unsigned since std_logic instead of unsigned
                    matC(i,j) <= matC(i,j) + temp(1 downto 0);
                    if(k = 2) then
                        k <= 0;
                        if(j = 2) then
                            j <= 0;
                            if (i= 2) then
                                i <= 0;
                                state <= apply_outputs;
                            else
                                i <= i + 1;
                            end if;
                        else
                            j <= j+1;
                        end if;        
                    else
                        k <= k+1;
                    end if;     
                when apply_outputs =>   --convert 3 by 3 matrix into a 1-D matrix.
                --     for i in 0 to 2 loop    --run through the rows
                --         for j in 0 to 2 loop    --run through the columnss
                --             matrixC((i*3+j+1)*8-1 downto (i*3+j)*8) <= matC(i,j);
                --         end loop;
                --     end loop;
                    state <= init;  
            end case;
        end if;
    end process;
        
end structural; 
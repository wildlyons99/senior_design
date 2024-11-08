library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity perceptron is port(
        clk    : in std_logic; 
        enable : in std_logic; 
        binary_class : out std_logic 
    );
end perceptron;

architecture behavioral of perceptron is
    component image is port(
        clk       : in std_logic;
        totaladr  : in unsigned(3 downto 0);
        grayScale : out signed(7 downto 0)
        );
    end component;

    component WeightRom is port(
        clk : in std_logic;
        totaladr : unsigned(3 downto 0);
        weight : out signed(7 downto 0)
        );
    end component;

    type state_type is (INIT, MULT, ADD, BIAS, DONE);
    signal state       : state_type := INIT;
    
    -- signal ena       : std_logic := '0'; 
    signal index     : unsigned(3 downto 0) := 4b"0"; 
    signal pixel_val : signed(7 downto 0); 
    signal weight    : signed(7 downto 0); 

    -- intermediate results
    signal temp_result : signed(15 downto 0); 
    
    -- final sum
    signal sum         : signed(15 downto 0) := 16b"0";  

    -- signed
    signal bias_val : signed(15 downto 0) := 16b"0"; 

begin
    -- port mapping to ROM to get pixel values of 1 image
    -- (image 1)
    b: image port map(
        clk       => clk,
        totaladr  => index,
        grayScale => pixel_val
    );

    -- port mapping for the weights
    -- outputs one weight each time 
    a: WeightRom port map(
        clk       => clk,
        totaladr  => index,
        weight => weight
    );

    -- state machine
    sm: process (clk) 
        -- variable v_Count : integer range 0 to 5 := 0;
    begin
        if rising_edge(clk) then
            case state is
                when init =>
                    if enable = '1' then 
                        state <= mult;
                        bias_val <= b"0000000001100000";
                    end if; 
                when MULT =>
                    temp_result <= pixel_val * weight; 
                    state <= ADD; 
                when ADD =>
                    sum <= sum + temp_result; 
                    if index = 15 then
                        state <= BIAS; 
                    else 
                        index <= index + 1; 
                        state <= MULT; 
                    end if; 
                when BIAS =>
                    sum <= sum + bias_val; 
                    state <= DONE; 
                when DONE => 
                    if sum > 0 then
                        binary_class <= '1'; -- number is one
                    else 
                        binary_class <= '0'; -- number is zero
                    end if; 
                when others =>
                    state <= init;
                end case;
        end if;
    end process; 

end behavioral; 
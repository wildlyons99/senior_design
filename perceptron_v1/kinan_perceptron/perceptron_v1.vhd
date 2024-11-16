library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned
use work.array_pkg.ALL;

entity perceptron_v1 is
    port(
        clk : in std_logic;
        image_address : in std_logic_vector(3 downto 0);
        prediction : out std_logic
    );
end perceptron_v1;



architecture structural of perceptron_v1 is 

component rom is 
    port(
        clk : in std_logic;
        image_address : std_logic_vector(3 downto 0);
        output_array : out byte_array
    );
end component rom;

component mult is 
    port(
        clk : in std_logic;
        input : in byte_array;
        output : out std_logic_vector(15 downto 0)
    );
end component mult;

component activation is 
    port(
        input_vector : in std_logic_vector(15 downto 0);
        prediction : out std_logic
    );
end component activation;

signal image_data : byte_array;
signal perceptron_output : std_logic_vector(15 downto 0) := (others => '0');

begin 
    memory : rom port map(
        clk             => clk,
        image_address   => image_address,
        output_array    => image_data
    );

    perceptron : mult port map(
        clk             => clk,
        input           => image_data,
        output          => perceptron_output
    );

    activator : activation port map(
        input_vector    => perceptron_output,
        prediction      => prediction
    );

end structural;
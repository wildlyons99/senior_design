library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned
use work.array_pkg.ALL;

entity perceptron_v1 is
    port(
		clk_12MHz : in std_logic; 
        image_address : in std_logic_vector(2 downto 0);
		prediction : out std_logic_vector(6 downto 0); 
		prediction_bit : out std_logic
    );
end perceptron_v1;


architecture structural of perceptron_v1 is 

-- clk 
 component HSOSC is
	generic (
		CLKHF_DIV : String := "0b00"); -- Divide 48MHz clock by 2^N (0-3)
	port(
		CLKHFPU : in std_logic := 'X'; -- Set to 1 to power up
		CLKHFEN : in std_logic := 'X'; -- Set to 1 to enable output
		CLKHF : out std_logic := 'X'); -- Clock output
end component;

component sevenseg is
  port(
	  S : in std_logic_vector(3 downto 0);
	  segments : out std_logic_vector(6 downto 0)
  );
end component;

component rom is 
    port(
        clk : in std_logic;
        image_address : std_logic_vector(2 downto 0);
        output_array : out byte_array
    );
end component rom;

component mult is 
    port(
        clk : in std_logic;
        reset : in std_logic;
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
signal rst : std_logic := '0';
signal perceptron_output : std_logic_vector(15 downto 0) := (others => '0');

signal result_to_sevseg : std_logic_vector(3 downto 0); 

-- prediction output from activation
-- signal prediction_bit : std_logic;

-- clk 
signal clk : std_logic; 
signal clkcount : unsigned(6 downto 0);

signal prev_image_address : std_logic_vector(2 downto 0);

signal first_time : std_logic; 

begin 
	-- 48 mhz?? 
	-- _clock : HSOSC port map(CLKHFPU => '1', CLKHFEN => '1', CLKHF => clk_48mhz);
	
	 -- Generate 100KHz clock
	process(clk_12MHz)
	begin
		if rising_edge(clk_12MHz) then
			if clkCount = 7d"59" then 
				clkCount <= 7d"0"; 
				clk <= not clk;
			else 
                clkCount <= clkCount + 1;
			end if;
		end if;
	end process;
	
	process (clk) begin
		if rising_edge(clk) then 
			if not(prev_image_address = image_address) then
				rst <= '1';
			else
				rst <= '0';
			end if;
			prev_image_address <= image_address;
		end if; 
	end process; 
	
	seven_map : sevenseg port map ( 
		S => result_to_sevseg,
	    segments => prediction
	); 

    memory : rom port map(
        clk             => clk,
        image_address   => image_address,
        output_array    => image_data
    );

    perceptron : mult port map(
        clk             => clk,
        reset           => rst,
        input           => image_data,
        output          => perceptron_output
    );

    activator : activation port map(
        input_vector    => perceptron_output,
        prediction      => prediction_bit
    );
	
	result_to_sevseg <= "000" & prediction_bit;
	

end structural;
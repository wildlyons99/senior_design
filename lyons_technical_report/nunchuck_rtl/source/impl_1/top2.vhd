library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    port (
        clk_12MHz   : in  std_logic;
        sda         : inout std_logic;
        scl         : inout std_logic;
		busy        : out std_logic; 
		ena         : out std_logic;
		byte_counter: out unsigned(2 downto 0)
    );
end top;

architecture Behavioral of top is
    component i2c_master is
        generic( -- used for internal divider
            input_clk : INTEGER := 12_000_000;    -- input clock speed from user logic in Hz
            bus_clk   : INTEGER := 100_000        -- speed the i2c bus (scl) will run at in Hz
        );  
        port(
            clk       : IN     STD_LOGIC;                    -- system clock
            reset_n   : IN     STD_LOGIC;                    -- active low reset
            ena       : IN     STD_LOGIC;                    -- latch in command - tells controller to start new transaction
            addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); -- address of target slave
            rw        : IN     STD_LOGIC;                    -- '0' is write, '1' is read
            data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); -- data to write to slave
            busy      : OUT    STD_LOGIC;                    -- indicates transaction in progress
            data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); -- data read from slave
            ack_error : BUFFER STD_LOGIC;                    -- flag if improper acknowledge from slave
            sda       : INOUT  STD_LOGIC;                    -- serial data output of i2c bus
            scl       : INOUT  STD_LOGIC                     -- serial clock output of i2c bus
        );                  
    end component;
    
     --State Machine Enumerations
    -- type state_type is (RESET, HANDSHAKE, READ_DATA, STOP);
    -- signal state : state_type := RESET;
	
	signal clkCount : unsigned(6 downto 0);
	signal clk      : std_logic; -- 100kHz clk 

    -- I2C Related Signals
    signal I2C_ADDRESS : std_logic_vector(6 downto 0) := "1010010";  -- 0x52 (7-bit address)

    signal data_wr       : std_logic_vector(7 downto 0) := (others => '0');
    signal data_rd       : std_logic_vector(7 downto 0);
    --signal ena           : std_logic := '0';
    signal rw            : std_logic := '0';
    -- signal busy          : std_logic;
    signal ack_error     : std_logic;

     --First-time initialization signal
    signal first_time    : std_logic := '0';
	
	-- signal byte_counter : unsigned(2 downto 0) := "000"; 

begin
    -- I2C Master Instantiation
    i2c_master_portmap : i2c_master port map (
        clk       => clk_12MHz,
        reset_n   => '1',         -- active low reset
        ena       => ena,         -- latch in command
        addr      => I2C_ADDRESS, -- address of target slave
        rw        => rw,          -- '0' is write, '1' is read
        data_wr   => data_wr,     -- data to write to slave
        busy      => busy,        -- indicates transaction in progress
        data_rd   => data_rd,     -- data read from slave
        ack_error => ack_error,   -- flag if improper acknowledge from slave
        sda       => sda,         -- serial data output of i2c bus
        scl       => scl          -- serial clock output of i2c bus
    );
	
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
	
	 -- State machine for the nunchuck handshake
     -- writing the sequence 0xF0, x55, xFB, x00
     process (clk) begin
         if rising_edge(clk) then
              if first_time = '0' then
                -- Initialize signals
                --state            <= RESET;
				byte_counter <= "000"; 
                -- read_counter     <= 0;
                -- handshake_state  <= HS_START;
                -- read_state       <= READ_START;
                ena              <= '0';
                data_wr          <= (others => '0');
                rw               <= '0';
                I2C_ADDRESS      <= "1010010"; -- x52
                first_time       <= '1'; -- Set first_time to '1' after initialization
            else
			  if busy = '0' then  -- Wait until the I2C master is not busy
                 case byte_counter is
                     when "000" =>
                         data_wr <= x"F0"; 
                         ena <= '1';             -- Trigger I2C write
                         byte_counter <= "001";   -- Move to next byte
                     when "001" =>
						-- ena <= '0'; 
						 data_wr <= x"55";
                         ena <= '1';             -- Trigger I2C write
                         byte_counter <= "010";   -- Move to next byte
					 when "010" => 
                         data_wr <= x"FB";
                         ena <= '1';             -- Trigger I2C write
                         byte_counter <= "011";   -- Move to next byte
                     when "011" =>
                         data_wr <= x"00";
                         ena <= '1';             -- Trigger I2C write
                         byte_counter <= "000";   -- Repeat
                     when others => -- all other cases (shouldn't happen but ghdl is mad without it)
	 					byte_counter <= "000"; 
                 end case;
             else
                 ena <= '0';  -- Latch off when busy so doesn't send same data again
				 -- byte_counter <= byte_counter + 1; 
             end if;
			end if; 
         end if;
     end process;

end Behavioral;

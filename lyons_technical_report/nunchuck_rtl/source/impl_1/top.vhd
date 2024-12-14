library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    port (
        clk_12MHz   : in  std_logic;
		reset       : in  std_logic;   -- Active-low reset signal
        sda         : inout std_logic;
        scl         : inout std_logic;
        busy        : out std_logic; 
        ena         : out std_logic;
		-- joystick_x  : out std_logic_vector(7 downto 0);
		-- joystick_y  : out std_logic_vector(7 downto 0);
		-- accel_x     : out std_logic_vector(9 downto 0);
		-- accel_y     : out std_logic_vector(9 downto 0);
		-- accel_z     : out std_logic_vector(9 downto 0);
		c_button    : out std_logic;
		z_button    : out std_logic
    );
end top;

architecture Behavioral of top is
	signal joystick_x  : std_logic_vector(7 downto 0);
	signal joystick_y  : std_logic_vector(7 downto 0);
	signal accel_x     : std_logic_vector(9 downto 0);
	signal accel_y     : std_logic_vector(9 downto 0);
	signal accel_z     : std_logic_vector(9 downto 0);

    -- I2C Master Component
    component i2c_master is
        generic(
            input_clk : INTEGER := 12_000_000; -- input clock freq in Hz
            bus_clk   : INTEGER := 100_000     -- I2C bus speed in Hz
        );
        port(
            clk       : IN     STD_LOGIC;
            reset_n   : IN     STD_LOGIC;
            ena       : IN     STD_LOGIC;
            addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0);
            rw        : IN     STD_LOGIC;
            data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0);
            busy      : OUT    STD_LOGIC;
            data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0);
            ack_error : BUFFER STD_LOGIC;
            sda       : INOUT  STD_LOGIC;
            scl       : INOUT  STD_LOGIC
        );
    end component;
    
    -- States for our simple machine
    type state_type is (start, handshake, set_pointer, read_data, done_state);
    signal state          : state_type := start;

    -- Signals
    signal clkCount       : unsigned(6 downto 0) := (others => '0');
    signal first_time     : std_logic := '0';
    signal I2C_ADDRESS    : std_logic_vector(6 downto 0) := "1010010";  -- Wii Nunchuck Address: 0x52
    signal data_wr_sig    : std_logic_vector(7 downto 0) := (others => '0');
    signal data_rd_sig    : std_logic_vector(7 downto 0);
    signal rw_sig         : std_logic := '0';
    signal ack_error_sig  : std_logic;
    signal busy_prev      : std_logic := '0';
    
    signal i2c_ena        : std_logic := '0';
    signal i2c_addr       : std_logic_vector(6 downto 0) := (others => '0');
    signal i2c_rw         : std_logic := '0';
    signal i2c_data_wr    : std_logic_vector(7 downto 0) := (others => '0');
    signal i2c_data_rd    : std_logic_vector(7 downto 0);

	signal nunchuck_data : std_logic_vector(47 downto 0); -- 6 bytes * 8 bits = 48 bits
	
	signal reset_n : std_logic; 
begin
	reset_n <= reset; 
    -- Map outputs
    ena <= i2c_ena;

    -- I2C Master Instantiation
    i2c_master_portmap : i2c_master
        generic map(
            input_clk => 12_000_000,
            bus_clk   => 400_000
        )
        port map(
            clk       => clk_12MHz,
            reset_n   => reset_n,
            ena       => i2c_ena,
            addr      => i2c_addr,
            rw        => i2c_rw,
            data_wr   => i2c_data_wr,
            busy      => busy,
            data_rd   => i2c_data_rd,
            ack_error => ack_error_sig,
            sda       => sda,
            scl       => scl
        );
        

    -- State machine process
    -- Handshake sequence: Write 0xF0, 0x55, 0xFB, 0x00 to initiate communication
    process(clk_12MHz, reset_n)
	    variable busy_cnt     : integer range 0 to 10 := 0; -- counting busy transitions
    begin
        if reset_n = '0' then
            -- Asynchronous reset: set all signals to initial values
            first_time <= '0';
            i2c_ena <= '0';
            i2c_addr <= I2C_ADDRESS;
            i2c_rw <= '0';
            i2c_data_wr <= (others => '0');
            busy_cnt := 0;
            state <= start;
            busy_prev <= '0';
            nunchuck_data <= (others => '0');
        elsif rising_edge(clk_12MHz) then
            busy_prev <= busy; -- track previous busy state
            
            if first_time = '0' then
                -- Initialization
                i2c_ena      <= '0';
                i2c_addr     <= I2C_ADDRESS;
                i2c_rw       <= '0';
                i2c_data_wr  <= (others => '0');
                busy_cnt     := 0;
                first_time   <= '1';
                state        <= handshake;
            else
                case state is
                    when start =>
                        -- If you had a delay or other initialization, it would go here
                        state <= handshake;
						-- busy_cnt := 0; 
                    
                    when handshake =>
                        -- Similar to the example code:
                        -- On each new transaction, if i2c_busy goes from '0' to '1', increment busy_cnt
                        if (busy_prev = '0' and busy = '1') then
                            busy_cnt := busy_cnt + 1;
                        end if;
                        
                        case busy_cnt is
                            when 0 =>
                                -- Initiate transaction: write 0xF0
                                i2c_ena <= '1';
                                i2c_addr <= I2C_ADDRESS;
                                i2c_rw <= '0';
                                i2c_data_wr <= x"F0";
                            when 1 =>
                                -- Next command: write 0x55
                                i2c_data_wr <= x"55";
                            when 2 =>
                                -- Next command: write 0xFB
                                i2c_data_wr <= x"FB";
                            when 3 =>
                                -- Final command: write 0x00
                                i2c_data_wr <= x"00";
                            when 4 =>
                                -- Deassert enable to end this transaction
                                i2c_ena <= '0';
                                if (busy = '0') then
                                    -- Transaction complete
                                    busy_cnt := 0;
                                    state <= read_data; -- Move to reading data from Nunchuck
                                end if;
                            when others =>
                                null;
                        end case;

                     when set_pointer =>
                        -- Set the register pointer to 0x00 before reading data
                        if (busy_prev = '0' and busy = '1') then
                            busy_cnt := busy_cnt + 1;
                        end if;

                        case busy_cnt is
                            when 0 =>
                                -- Start write transaction to set pointer
                                i2c_ena <= '1';
                                i2c_addr <= I2C_ADDRESS;
                                i2c_rw <= '0';
                                i2c_data_wr <= x"00"; 
                            when 1 =>
                                -- Stop the transaction after pointer is set
                                i2c_ena <= '0';
                                if (busy = '0') then
                                    busy_cnt := 0;
                                    state <= read_data; -- Ready to read the 6 bytes
                                end if;
                            when others =>
                                null;
                        end case;

                    when read_data =>
                        -- Read all 6 bytes from the device
                        if (busy_prev = '0' and busy = '1') then
                            busy_cnt := busy_cnt + 1;
                        end if;

                        case busy_cnt is
                            when 0 =>
                                -- Initiate read (byte 0)
                                i2c_ena <= '1';
                                i2c_addr <= I2C_ADDRESS;
                                i2c_rw <= '1';
                            when 1 =>
                                -- After read latched, when busy=0 data is ready
                                if (busy = '0') then
                                    nunchuck_data(47 downto 40) <= i2c_data_rd; -- Byte0: Joystick X
                                    i2c_ena <= '1'; -- read next byte
                                end if;
                            when 2 =>
                                if (busy = '0') then
                                    nunchuck_data(39 downto 32) <= i2c_data_rd; -- Byte1: Joystick Y
                                    i2c_ena <= '1'; 
                                end if;
                            when 3 =>
                                if (busy = '0') then
                                    nunchuck_data(31 downto 24) <= i2c_data_rd; -- Byte2: Accel X
                                    i2c_ena <= '1';
                                end if;
                            when 4 =>
                                if (busy = '0') then
                                    nunchuck_data(23 downto 16) <= i2c_data_rd; -- Byte3: Accel Y
                                    i2c_ena <= '1';
                                end if;
                            when 5 =>
                                if (busy = '0') then
                                    nunchuck_data(15 downto 8) <= i2c_data_rd;  -- Byte4: Accel Z
                                    i2c_ena <= '1';
                                end if;
                            when 6 =>
                                if (busy = '0') then
                                    nunchuck_data(7 downto 0) <= i2c_data_rd;   -- Byte5: Buttons and lower bits
                                    i2c_ena <= '0';  -- Done reading, stop transaction
                                    if (busy = '0') then
                                        busy_cnt := 0;
                                        -- done <= '1';  -- Data is now ready
                                        state <= done_state;
                                    end if;
                                end if;
                            when others =>
                                null;
                        end case;

                    when done_state =>
                        joystick_x <= nunchuck_data(47 downto 40);
                        joystick_y <= nunchuck_data(39 downto 32);
                        accel_x <= nunchuck_data(31 downto 24) & nunchuck_data(3 downto 2);
                        accel_y <= nunchuck_data(23 downto 16) & nunchuck_data(5 downto 4);
                        accel_z <= nunchuck_data(15 downto 8)  & nunchuck_data(7 downto 6);
                        c_button <= nunchuck_data(1);
						z_button <= nunchuck_data(0);
						
						-- start reading data again 
						state <= set_pointer; 

                    when others =>
                        state <= start;
                        
                end case;
            end if;
        end if;
    end process;

end Behavioral;

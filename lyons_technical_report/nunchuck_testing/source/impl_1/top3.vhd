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

    component i2c_master is
        generic(
            input_clk : INTEGER := 12_000_000; -- input clock freq in Hz
            bus_clk   : INTEGER := 400_000     -- I2C bus speed in Hz
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

    type state_type is (
        INIT_F0, INIT_F0_WAIT_START, INIT_F0_WAIT_END,
        INIT_55, INIT_55_WAIT_START, INIT_55_WAIT_END,
        INIT_FB, INIT_FB_WAIT_START, INIT_FB_WAIT_END,
        INIT_00, INIT_00_WAIT_START, INIT_00_WAIT_END,
        SET_PTR, SET_PTR_WAIT_START, SET_PTR_WAIT_END,
        READ_0, READ_0_WAIT_START, READ_0_WAIT_END,
        READ_1, READ_1_WAIT_START, READ_1_WAIT_END,
        READ_2, READ_2_WAIT_START, READ_2_WAIT_END,
        READ_3, READ_3_WAIT_START, READ_3_WAIT_END,
        READ_4, READ_4_WAIT_START, READ_4_WAIT_END,
        READ_5, READ_5_WAIT_START, READ_5_WAIT_END,
        PROCESS_DATA
    );
    signal state : state_type := INIT_F0;

    signal I2C_ADDRESS    : std_logic_vector(6 downto 0) := "1010010";  -- 0x52
    signal i2c_ena        : std_logic := '0';
    signal i2c_addr       : std_logic_vector(6 downto 0) := (others => '0');
    signal i2c_rw         : std_logic := '0';
    signal i2c_data_wr    : std_logic_vector(7 downto 0) := (others => '0');
    signal i2c_data_rd    : std_logic_vector(7 downto 0);
    signal ack_error_sig  : std_logic;
    signal reset_n        : std_logic;

    signal nunchuck_data  : std_logic_vector(47 downto 0); -- 6 bytes

begin
    reset_n <= reset;
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

    process(clk_12MHz, reset_n)
    begin
        if reset_n = '0' then
            state <= INIT_F0;
            i2c_ena <= '0';
            i2c_addr <= I2C_ADDRESS;
            i2c_rw <= '0';
            i2c_data_wr <= (others => '0');
            nunchuck_data <= (others => '0');
        elsif rising_edge(clk_12MHz) then

            case state is
                -- Initialization sequence: Write F0, then 55, then FB, then 00
                when INIT_F0 =>
                    i2c_addr <= I2C_ADDRESS;
                    i2c_rw <= '0';
                    i2c_data_wr <= x"F0";
                    i2c_ena <= '1';
                    state <= INIT_F0_WAIT_START;

                when INIT_F0_WAIT_START =>
                    if busy = '1' then
                        state <= INIT_F0_WAIT_END;
                    end if;

                when INIT_F0_WAIT_END =>
                    if busy = '0' then
                        i2c_ena <= '0';
                        state <= INIT_55;
                    end if;

                when INIT_55 =>
                    i2c_addr <= I2C_ADDRESS;
                    i2c_rw <= '0';
                    i2c_data_wr <= x"55";
                    i2c_ena <= '1';
                    state <= INIT_55_WAIT_START;

                when INIT_55_WAIT_START =>
                    if busy = '1' then
                        state <= INIT_55_WAIT_END;
                    end if;

                when INIT_55_WAIT_END =>
                    if busy = '0' then
                        i2c_ena <= '0';
                        state <= INIT_FB;
                    end if;

                when INIT_FB =>
                    i2c_addr <= I2C_ADDRESS;
                    i2c_rw <= '0';
                    i2c_data_wr <= x"FB";
                    i2c_ena <= '1';
                    state <= INIT_FB_WAIT_START;

                when INIT_FB_WAIT_START =>
                    if busy = '1' then
                        state <= INIT_FB_WAIT_END;
                    end if;

                when INIT_FB_WAIT_END =>
                    if busy = '0' then
                        i2c_ena <= '0';
                        state <= INIT_00;
                    end if;

                when INIT_00 =>
                    i2c_addr <= I2C_ADDRESS;
                    i2c_rw <= '0';
                    i2c_data_wr <= x"00";
                    i2c_ena <= '1';
                    state <= INIT_00_WAIT_START;

                when INIT_00_WAIT_START =>
                    if busy = '1' then
                        state <= INIT_00_WAIT_END;
                    end if;

                when INIT_00_WAIT_END =>
                    if busy = '0' then
                        i2c_ena <= '0';
                        -- Initialization done, now set pointer for reading
                        state <= SET_PTR;
                    end if;

                -- Set pointer to 0x00 before reading data
                when SET_PTR =>
                    i2c_addr <= I2C_ADDRESS;
                    i2c_rw <= '0';
                    i2c_data_wr <= x"00";
                    i2c_ena <= '1';
                    state <= SET_PTR_WAIT_START;

                when SET_PTR_WAIT_START =>
                    if busy = '1' then
                        state <= SET_PTR_WAIT_END;
                    end if;

                when SET_PTR_WAIT_END =>
                    if busy = '0' then
                        i2c_ena <= '0';
                        state <= READ_0;  -- Start reading 6 bytes
                    end if;

                -- Read byte 0
                when READ_0 =>
                    i2c_addr <= I2C_ADDRESS;
                    i2c_rw <= '1';
                    i2c_ena <= '1';
                    state <= READ_0_WAIT_START;

                when READ_0_WAIT_START =>
                    if busy = '1' then
                        state <= READ_0_WAIT_END;
                    end if;

                when READ_0_WAIT_END =>
                    if busy = '0' then
                        i2c_ena <= '0';
                        nunchuck_data(47 downto 40) <= i2c_data_rd;
                        state <= READ_1;
                    end if;

                -- Read byte 1
                when READ_1 =>
                    i2c_addr <= I2C_ADDRESS;
                    i2c_rw <= '1';
                    i2c_ena <= '1';
                    state <= READ_1_WAIT_START;

                when READ_1_WAIT_START =>
                    if busy = '1' then
                        state <= READ_1_WAIT_END;
                    end if;

                when READ_1_WAIT_END =>
                    if busy = '0' then
                        i2c_ena <= '0';
                        nunchuck_data(39 downto 32) <= i2c_data_rd;
                        state <= READ_2;
                    end if;

                -- Read byte 2
                when READ_2 =>
                    i2c_addr <= I2C_ADDRESS;
                    i2c_rw <= '1';
                    i2c_ena <= '1';
                    state <= READ_2_WAIT_START;

                when READ_2_WAIT_START =>
                    if busy = '1' then
                        state <= READ_2_WAIT_END;
                    end if;

                when READ_2_WAIT_END =>
                    if busy = '0' then
                        i2c_ena <= '0';
                        nunchuck_data(31 downto 24) <= i2c_data_rd;
                        state <= READ_3;
                    end if;

                -- Read byte 3
                when READ_3 =>
                    i2c_addr <= I2C_ADDRESS;
                    i2c_rw <= '1';
                    i2c_ena <= '1';
                    state <= READ_3_WAIT_START;

                when READ_3_WAIT_START =>
                    if busy = '1' then
                        state <= READ_3_WAIT_END;
                    end if;

                when READ_3_WAIT_END =>
                    if busy = '0' then
                        i2c_ena <= '0';
                        nunchuck_data(23 downto 16) <= i2c_data_rd;
                        state <= READ_4;
                    end if;

                -- Read byte 4
                when READ_4 =>
                    i2c_addr <= I2C_ADDRESS;
                    i2c_rw <= '1';
                    i2c_ena <= '1';
                    state <= READ_4_WAIT_START;

                when READ_4_WAIT_START =>
                    if busy = '1' then
                        state <= READ_4_WAIT_END;
                    end if;

                when READ_4_WAIT_END =>
                    if busy = '0' then
                        i2c_ena <= '0';
                        nunchuck_data(15 downto 8) <= i2c_data_rd;
                        state <= READ_5;
                    end if;

                -- Read byte 5
                when READ_5 =>
                    i2c_addr <= I2C_ADDRESS;
                    i2c_rw <= '1';
                    i2c_ena <= '1';
                    state <= READ_5_WAIT_START;

                when READ_5_WAIT_START =>
                    if busy = '1' then
                        state <= READ_5_WAIT_END;
                    end if;

                when READ_5_WAIT_END =>
                    if busy = '0' then
                        i2c_ena <= '0';
                        nunchuck_data(7 downto 0) <= i2c_data_rd;
                        state <= PROCESS_DATA;
                    end if;

                -- Process the data and go back to read again
                when PROCESS_DATA =>
                    joystick_x <= nunchuck_data(47 downto 40);
                    joystick_y <= nunchuck_data(39 downto 32);
                    accel_x <= nunchuck_data(31 downto 24) & nunchuck_data(3 downto 2);
                    accel_y <= nunchuck_data(23 downto 16) & nunchuck_data(5 downto 4);
                    accel_z <= nunchuck_data(15 downto 8)  & nunchuck_data(7 downto 6);
                    c_button <= nunchuck_data(1);
                    z_button <= nunchuck_data(0);

                    -- After processing, set the pointer again and read continuously
                    state <= SET_PTR;

                when others =>
                    state <= INIT_F0; -- default safe state
            end case;
        end if;
    end process;

end Behavioral;

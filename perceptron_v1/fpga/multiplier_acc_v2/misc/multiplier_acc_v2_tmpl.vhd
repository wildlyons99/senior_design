component multiplier_acc_v2 is
    port(
        clk_i: in std_logic;
        clk_en_i: in std_logic;
        rst_i: in std_logic;
        data_a_i: in std_logic_vector(17 downto 0);
        data_b_i: in std_logic_vector(17 downto 0);
        result_o: out std_logic_vector(36 downto 0)
    );
end component;

__: multiplier_acc_v2 port map(
    clk_i=>,
    clk_en_i=>,
    rst_i=>,
    data_a_i=>,
    data_b_i=>,
    result_o=>
);

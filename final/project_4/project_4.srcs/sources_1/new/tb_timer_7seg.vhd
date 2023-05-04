library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_timer_7seg is
end entity tb_timer_7seg;

architecture behavioral of tb_timer_7seg is
    component timer_7seg is
        port (
            clk : in std_logic;
            rst : in std_logic;
            en : in std_logic;
            seg1 : out std_logic_vector(6 downto 0);
            seg2 : out std_logic_vector(6 downto 0);
            seg3 : out std_logic_vector(6 downto 0);
            sig_g_NUM_CYCLES: natural;
            sig_g_CNT1_INIT: natural;
            sig_g_CNT2_INIT: natural
        );
    end component timer_7seg;

    signal clk_sig: std_logic := '0';
    signal rst_sig: std_logic := '1';
    signal en_sig: std_logic := '0';
    signal seg1_sig: std_logic_vector(6 downto 0);
    signal seg2_sig: std_logic_vector(6 downto 0);
    signal seg3_sig: std_logic_vector(6 downto 0);
    signal sig_cnt1: std_logic_vector(9  downto 0);
    signal sig_cnt2: std_logic_vector(9  downto 0);
    


    constant CLK_PERIOD: time := 10 ns;

begin
    inst_timer_7seg: timer_7seg
        port map (
            clk => clk_sig,
            rst => rst_sig,
            en => en_sig,
            seg1 => seg1_sig,
            seg2 => seg2_sig,
            seg3 => seg3_sig,
            sig_g_NUM_CYCLES => 3, 
            sig_g_CNT1_INIT => 20,
            sig_g_CNT2_INIT => 10
        );

        
    p_clk_gen: process is
    begin
        while true loop
            clk_sig <= not clk_sig;
            wait for CLK_PERIOD / 2;
        end loop;
    end process p_clk_gen;

    p_stimulus: process is
    begin
        wait for CLK_PERIOD * 5;
        rst_sig <= '0';
        wait for CLK_PERIOD * 5;
        en_sig <= '1';
        wait for CLK_PERIOD * 100;
        en_sig <= '0';
        wait for CLK_PERIOD * 5;
        rst_sig <= '1';
        wait for CLK_PERIOD * 5;
        rst_sig <= '0';
        wait for CLK_PERIOD * 5;
        en_sig <= '1';
        wait for CLK_PERIOD * 100;
        en_sig <= '0';
        wait;
    end process p_stimulus;

end architecture behavioral;
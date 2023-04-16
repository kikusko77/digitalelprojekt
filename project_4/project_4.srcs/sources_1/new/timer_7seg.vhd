library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer_7seg is
    port (
        clk : in std_logic;
        rst : in std_logic;
        en : in std_logic;
        seg1 : out std_logic_vector(6 downto 0);
        seg2 : out std_logic_vector(6 downto 0);
        seg3 : out std_logic_vector(6 downto 0)
    );
end entity timer_7seg;

architecture behavioral of timer_7seg is
    component timer is
        generic (
            g_CNT_WIDTH : natural := 9;
            g_NUM_CYCLES: natural := 3;
            g_CNT1_INIT: natural := 20;
            g_CNT2_INIT: natural := 10
        );
        port (
            clk : in std_logic;
            rst : in std_logic;
            en : in std_logic;
            cnt1 : out std_logic_vector(g_CNT_WIDTH  downto 0);
            cnt2 : out std_logic_vector(g_CNT_WIDTH  downto 0)
        );
    end component timer;

    component hex_7seg is
        port (
            blank : in std_logic;
            hex : in std_logic_vector(9 downto 0);
            seg1 : out std_logic_vector(6 downto 0);
            seg2 : out std_logic_vector(6 downto 0);
            seg3 : out std_logic_vector(6 downto 0)
        );
    end component hex_7seg;

    signal cnt1_sig: std_logic_vector(9 downto 0);
    signal hex_sig: std_logic_vector(9 downto 0);

begin
    inst_timer: timer
        port map (
            clk => clk,
            rst => rst,
            en => en,
            cnt1 => cnt1_sig,
            cnt2 => open
        );

    hex_sig <= cnt1_sig;

    inst_hex_7seg: hex_7seg
        port map (
            blank => '0',
            hex => hex_sig,
            seg1 => seg1,
            seg2 => seg2,
            seg3 => seg3
        );
end architecture behavioral;
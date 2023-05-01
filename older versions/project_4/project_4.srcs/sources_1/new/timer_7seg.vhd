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
        seg3 : out std_logic_vector(6 downto 0);
        seg : out std_logic_vector(6 downto 0);
        seg1_p : out std_logic_vector(6 downto 0);
        seg2_p : out std_logic_vector(6 downto 0)
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
            cnt2 : out std_logic_vector(g_CNT_WIDTH  downto 0);
            cycle_count: out std_logic_vector(1 downto 0)
            
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

    component hex_7seg_k is
            port (
                blank : in std_logic;
                hex : in std_logic_vector(1 downto 0);
                seg : out std_logic_vector(6 downto 0)
            );
        end component hex_7seg_k;
     
     component hex_7seg_p is
            port (
                blank : in std_logic;
                hex : in std_logic_vector(9 downto 0);
                seg1_p : out std_logic_vector(6 downto 0);
                seg2_p : out std_logic_vector(6 downto 0)
            );
        end component hex_7seg_p;   
        

    signal cnt1_sig: std_logic_vector(9 downto 0);
    signal hex_sig: std_logic_vector(9 downto 0);
    signal cycle1_count: std_logic_vector(1 downto 0);
    signal hex_sig_k: std_logic_vector(1 downto 0);
    signal hex_sig_p: std_logic_vector(9 downto 0);
    signal cnt2_sig: std_logic_vector(9 downto 0);

begin
    inst_timer: timer
        port map (
            clk => clk,
            rst => rst,
            en => en,
            cnt1 => cnt1_sig,
            cnt2 => cnt2_sig,
            cycle_count => cycle1_count
        );

    hex_sig <= cnt1_sig;
    hex_sig_p <= cnt2_sig;
    hex_sig_k <= cycle1_count;

    inst_hex_7seg: hex_7seg
        port map (
            blank => '0',
            hex => hex_sig,
            seg1 => seg1,
            seg2 => seg2,
            seg3 => seg3
        );
        
    inst_hex_7seg_k: hex_7seg_k
        port map (
            blank => '0',
            hex => hex_sig_k,
            seg => seg
        );
        
      inst_hex_7seg_p: hex_7seg_p
        port map (
            blank => '0',
            hex => hex_sig_p,
            seg1_p => seg1_p,
            seg2_p => seg2_p
        );  
        
        
end architecture behavioral;
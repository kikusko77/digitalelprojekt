library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port (
        clk: in std_logic;
        rst: in std_logic;
        en: in std_logic;
        seg1: buffer std_logic_vector(6 downto 0);
        seg2: buffer std_logic_vector(6 downto 0);
        seg3: buffer std_logic_vector(6 downto 0);
        seg: out std_logic_vector(6 downto 0);
        AN: out std_logic_vector(7 downto 0);
        CA: out std_logic;
        CB: out std_logic;
        CC: out std_logic;
        CD: out std_logic;
        CE: out std_logic;
        CF: out std_logic;
        CG: out std_logic
    );
end entity top;

architecture behavioral of top is
    component timer_7seg is
        port (
            clk: in std_logic;
            rst: in std_logic;
            en: in std_logic;
            seg1: out std_logic_vector(6 downto 0);
            seg2: out std_logic_vector(6 downto 0);
            seg3: out std_logic_vector(6 downto 0);
            seg: out std_logic_vector(6 downto 0);
            seg1_p: out std_logic_vector(6 downto 0);
            seg2_p: out std_logic_vector(6 downto 0)
        );
    end component timer_7seg;

begin

    -- Map output signals from timer_7seg to seven-segment display input ports
    AN <= "11111110"; -- Select first seven-segment display
    CA <= not seg1(6);
    CB <= not seg1(5);
    CC <= not seg1(4);
    CD <= not seg1(3);
    CE <= not seg1(2);
    CF <= not seg1(1);
    CG <= not seg1(0);

    AN <= "11111101"; -- Select second seven-segment display
    CA <= not seg2(6);
    CB <= not seg2(5);
    CC <= not seg2(4);
    CD <= not seg2(3);
    CE <= not seg2(2);
    CF <= not seg2(1);
    CG <= not seg2(0);

    AN <= "11111011"; -- Select third seven-segment display
    CA <= not seg3(6);
    CB <= not seg3(5);
    CC <= not seg3(4);
    CD <= not seg3(3);
    CE <= not seg3(2);
    CF <= not seg3(1);
    CG <= not seg3(0);

    AN <= "11110111"; -- Select fourth seven-segment display (display nothing)
    AN <= "11101111"; -- Select fifth seven-segment display (display nothing)
    AN <= "11011111"; -- Select sixth seven-segment display (display nothing)
    AN <= "10111111"; -- Select seventh seven-segment display (display nothing)
    AN <= "01111111"; -- Select seventh seven-segment display (display nothing)
    
    
    -- Instantiate timer_7seg entity
timer_7seg_inst: entity work.timer_7seg
port map (
    clk => clk,
    rst => rst,
    en => en,
    seg1 => seg1,
    seg2 => seg2,
    seg3 => seg3,
    seg => open,
    seg1_p => open,
    seg2_p => open
);

end architecture behavioral;
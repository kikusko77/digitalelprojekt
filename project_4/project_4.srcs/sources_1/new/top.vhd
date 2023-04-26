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
            seg1_p: out std_logic_vector(6 downto 0);
            seg2_p: out std_logic_vector(6 downto 0)
        );
    end component timer_7seg;

    -- Signals
    signal count: integer range 0 to 1000000 := 0;
    signal digit_sel: integer range 1 to 3 := 1;

begin

    -- Instantiate timer_7seg entity
    timer_7seg_inst: entity work.timer_7seg
    port map (
        clk => clk,
        rst => rst,
        en => en,
        seg1 => seg1,
        seg2 => seg2,
        seg3 => seg3,
        seg1_p => open,
        seg2_p => open
    );

    -- Multiplexing process
    mux_proc: process (clk)
    begin
        if rising_edge(clk) then
            if count = 1000000 then
                count <= 0;

                case digit_sel is
                    when 1 =>
                        AN <= "11111110"; -- Select first seven-segment display
                        CA <= not seg1(6);
                        CB <= not seg1(5);
                        CC <= not seg1(4);
                        CD <= not seg1(3);
                        CE <= not seg1(2);
                        CF <= not seg1(1);
                        CG <= not seg1(0);

                        digit_sel <= digit_sel + 1;

                    when 2 =>
                        AN <= "11111101"; -- Select second seven-segment display
                        CA <= not seg2(6);
                        CB <= not seg2(5);
                        CC <= not seg2(4);
                        CD <= not seg2(3);
                        CE <= not seg2(2);
                        CF <= not seg2(1);
                        CG <= not seg2(0);

                        digit_sel <= digit_sel + 1;

                    when others =>
                        AN <= "11111011"; -- Select third seven-segment display
                        CA <= not seg3(6);
                        CB <= not seg3(5);
                        CC <= not seg3(4);
                        CD <= not seg3(3);
                        CE <= not seg3(2);
                        CF <= not seg3(1);
                        CG <= not seg3(0);

                        digit_sel <= 1;

                end case;
            else
                count <= count + 1;
            end if;
        end if;
    end process mux_proc;

end architecture behavioral;
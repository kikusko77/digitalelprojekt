library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port (
        CLK100MHZ: in std_logic;
        SW: in std_logic_vector (15 downto 0);
        AN: out std_logic_vector(7 downto 0);
        CA: out std_logic;
        CB: out std_logic;
        CC: out std_logic;
        CD: out std_logic;
        CE: out std_logic;
        CF: out std_logic;
        CG: out std_logic;
        BTNC: in std_logic
    );
end entity top;

architecture behavioral of top is

   signal sig_seg1:  std_logic_vector(6 downto 0);
   signal sig_seg2:  std_logic_vector(6 downto 0);
   signal sig_seg3:  std_logic_vector(6 downto 0);
   signal sig_seg1_p:  std_logic_vector(6 downto 0);
   signal sig_seg2_p:  std_logic_vector(6 downto 0);
   signal sig_seg:  std_logic_vector(6 downto 0);
      
      
    component timer_7seg is
        port (
            CLK100MHZ: in std_logic;
            rst: in std_logic;
            en: in std_logic;
            seg1: out std_logic_vector(6 downto 0);
            seg2: out std_logic_vector(6 downto 0);
            seg3: out std_logic_vector(6 downto 0);
            seg1_p: out std_logic_vector(6 downto 0);
            seg2_p: out std_logic_vector(6 downto 0);
            seg: out std_logic_vector(6 downto 0);
            sig_g_NUM_CYCLES: natural;
            sig_g_CNT1_INIT: natural;
            sig_g_CNT2_INIT: natural            
            
        );
    end component timer_7seg;

    -- Signals
    signal count: integer range 0 to 1000000 := 0;
    signal digit_sel: integer range 1 to 5 := 1;
    
    signal SW_NUM_CYCLES : natural;
    signal SW_CNT1_INIT : natural;
    signal SW_CNT2_INIT : natural;

   
    
begin

    -- Instantiate timer_7seg entity
    timer_7seg_inst: entity work.timer_7seg
    port map (
        clk => CLK100MHZ,
        rst => BTNC,
        en => SW(15),
        seg1 => sig_seg1,
        seg2 => sig_seg2,
        seg3 => sig_seg3,
        seg1_p => sig_seg1_p,
        seg2_p => sig_seg2_p,
        seg  => sig_seg,
        sig_g_NUM_CYCLES => SW_NUM_CYCLES,
        sig_g_CNT1_INIT => SW_CNT1_INIT,
        sig_g_CNT2_INIT => SW_CNT2_INIT
        
    );
    
    
    p_set_values : process(SW)
    begin
        if SW(1) = '1' then
            SW_NUM_CYCLES <= 7;
        elsif SW(0) = '1' then
            SW_NUM_CYCLES <= 5;    
        else
            SW_NUM_CYCLES <= 3; -- default value
        end if;
        
        if SW(4) = '1' then
            SW_CNT1_INIT <= 240;
        elsif SW(3) = '1' then
            SW_CNT1_INIT <= 180;
        elsif SW(2) = '1' then
            SW_CNT1_INIT <= 90;    
        else
            SW_CNT1_INIT <= 30; -- default value
        end if;
        
        if SW(6) = '1' then
            SW_CNT2_INIT <= 90;
        elsif SW(5) = '1' then
            SW_CNT2_INIT <= 60;   
        else
            SW_CNT2_INIT <= 20; -- default value
        end if;
        
    end process p_set_values;
    
    
    
    -- Multiplexing process
    mux_proc: process (CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            if count = 300000 then
                count <= 0;

                case digit_sel is
                    when 1 =>
                        AN <= "11111110"; -- Select first seven-segment display
                        CA <=  sig_seg1(6);
                        CB <=   sig_seg1(5);
                        CC <=   sig_seg1(4);
                        CD <=   sig_seg1(3);
                        CE <=   sig_seg1(2);
                        CF <=   sig_seg1(1);
                        CG <=   sig_seg1(0);

                        digit_sel <= digit_sel + 1;

                    when 2 =>
                        AN <= "11111101"; -- Select second seven-segment display
                        CA <=   sig_seg2(6);
                        CB <=   sig_seg2(5);
                        CC <=   sig_seg2(4);
                        CD <=   sig_seg2(3);
                        CE <=   sig_seg2(2);
                        CF <=   sig_seg2(1);
                        CG <=   sig_seg2(0);
                        digit_sel <= digit_sel + 1;

                    when 3 =>
                        AN <= "11111011"; -- Select third seven-segment display
                        CA <=   sig_seg3(6);
                        CB <=   sig_seg3(5);
                        CC <=   sig_seg3(4);
                        CD <=   sig_seg3(3);
                        CE <=   sig_seg3(2);
                        CF <=   sig_seg3(1);
                        CG <=   sig_seg3(0);
                        digit_sel <= digit_sel + 1;

                     when 4 =>
                        AN <= "11101111"; 
                        CA <=   sig_seg1_p(6);
                        CB <=   sig_seg1_p(5);
                        CC <=   sig_seg1_p(4);
                        CD <=   sig_seg1_p(3);
                        CE <=   sig_seg1_p(2);
                        CF <=   sig_seg1_p(1);
                        CG <=   sig_seg1_p(0);
                        digit_sel <= digit_sel + 1;
                        

                     when 5 =>
                        AN <= "11011111"; 
                        CA <=   sig_seg2_p(6);
                        CB <=   sig_seg2_p(5);
                        CC <=   sig_seg2_p(4);
                        CD <=   sig_seg2_p(3);
                        CE <=   sig_seg2_p(2);
                        CF <=   sig_seg2_p(1);
                        CG <=   sig_seg2_p(0);
                        digit_sel <= digit_sel + 1;
    
                        
                       when others =>
                        AN <= "01111111"; 
                        CA <=   sig_seg(6);
                        CB <=   sig_seg(5);
                        CC <=   sig_seg(4);
                        CD <=   sig_seg(3);
                        CE <=   sig_seg(2);
                        CF <=   sig_seg(1);
                        CG <=   sig_seg(0);
                        digit_sel <= 1;

                end case;
            else
                count <= count + 1;
            end if;
        end if;
    end process mux_proc;

end architecture behavioral;
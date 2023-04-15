library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
  generic (
    g_CNT_WIDTH : natural := 7; --! Default number of counter bits
    g_NUM_CYCLES: natural := 3; --! Default number of cycles
    g_CNT1_INIT: natural := 20; --! Default initial value for first counter
    g_CNT2_INIT: natural := 10 --! Default initial value for second counter
  );
  port (
    clk    : in    std_logic;                                 --! Main clock
    rst    : in    std_logic;                                 --! Synchronous reset
    en     : in    std_logic;                                 --! Enable input
    cnt1   : out   std_logic_vector(g_CNT_WIDTH - 1 downto 0); --! First counter value
    cnt2   : out   std_logic_vector(g_CNT_WIDTH - 1 downto 0) --! Second counter value
  );
end entity timer;

architecture behavioral of timer is

  signal sig_cnt1 : unsigned(g_CNT_WIDTH - 1 downto 0) := to_unsigned(g_CNT1_INIT, g_CNT_WIDTH); --! Local first counter with initial value of g_CNT1_INIT
  signal sig_cnt2 : unsigned(g_CNT_WIDTH - 1 downto 0) := to_unsigned(g_CNT2_INIT, g_CNT_WIDTH); --! Local second counter with initial value of g_CNT2_INIT
  signal cycle_count: natural range 0 to g_NUM_CYCLES := 0; --! Cycle count

begin

 p_timer: process(clk)
 
 begin
  
    if (rising_edge(clk)) then
      if (rst = '1') then           -- Synchronous reset
        sig_cnt1 <= (others => '0'); -- Clear all bits of first counter
        sig_cnt2 <= (others => '0'); -- Clear all bits of second counter
        cycle_count <= 0;           -- Reset cycle count
      elsif (en = '1' and cycle_count < g_NUM_CYCLES) then         -- Test if counter is enabled and cycle count is less than g_NUM_CYCLES
        if sig_cnt1 = 0 then                                       -- Test if first counter has reached zero
          if sig_cnt2 = 0 then                                     -- Test if second counter has reached zero
            sig_cnt1 <= to_unsigned(g_CNT1_INIT, g_CNT_WIDTH);     -- Reset first counter to initial value of g_CNT1_INIT
            sig_cnt2 <= to_unsigned(g_CNT2_INIT, g_CNT_WIDTH);     -- Reset second counter to initial value of g_CNT2_INIT
            cycle_count <= cycle_count + 1;                        -- Increment cycle count
          else                                                     -- Second counter has not reached zero yet
            sig_cnt2 <= sig_cnt2 - 1;                              -- Decrement second counter
          end if;
        else                                                       -- First counter has not reached zero yet
          sig_cnt1 <= sig_cnt1 - 1;                                -- Decrement first counter
        end if;
      end if;
    end if;
  end process p_timer;

  cnt1 <= std_logic_vector(sig_cnt1);
  cnt2 <= std_logic_vector(sig_cnt2);
  
end architecture behavioral;
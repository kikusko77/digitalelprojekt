library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
  generic (
    g_CNT_WIDTH : natural := 9; --! Default number of counter bits
    g_NUM_CYCLES: natural := 3; --! Default number of cycles
    g_CNT1_INIT: natural := 20; --! Default initial value for first counter
    g_CNT2_INIT: natural := 10 --! Default initial value for second counter
  );
  port (
    clk    : in    std_logic;                                 --! Main clock
    rst    : in    std_logic;                                 --! Synchronous reset
    en     : in    std_logic;                                 --! Enable input
    cnt1   : out   std_logic_vector(g_CNT_WIDTH  downto 0);   --! First counter value
    cnt2   : out   std_logic_vector(g_CNT_WIDTH  downto 0);    --! Second counter value
    cycle_count: out   std_logic_vector(1  downto 0)
  );
end entity timer;

architecture behavioral of timer is

  signal sig_cnt1 : unsigned(g_CNT_WIDTH downto 0) := to_unsigned(g_CNT1_INIT, 10); --! Local first counter with initial value of g_CNT1_INIT
  signal sig_cnt2 : unsigned(g_CNT_WIDTH downto 0) := to_unsigned(g_CNT2_INIT, 10); --! Local second counter with initial value of g_CNT2_INIT
  signal sig_cycle_count: unsigned(1 downto 0) := to_unsigned(3, 2);                         --! Cycle count
  signal sig_en : std_logic;  


begin

 clk_en0 : entity work.clock_enable
    generic map (
      -- FOR SIMULATION, KEEP THIS VALUE TO 1
      -- FOR IMPLEMENTATION, CALCULATE VALUE: 250 ms / (1/100 MHz)
      -- 1   @ 10 ns
      -- ??? @ 250 ms
      g_MAX => 100000000
    )
    port map (
      clk => clk,
      rst => rst,
      ce  => sig_en
    );



 p_timer: process(clk)
 
 begin
  
    if (rising_edge(clk)) then
      if (rst = '1') then           -- Synchronous reset
        sig_cnt1 <= (others => '0'); -- Clear all bits of first counter
        sig_cnt2 <= (others => '0'); -- Clear all bits of second counter
        sig_cycle_count <= (others => '0');          -- Reset cycle count
      elsif (en = '1' and sig_cycle_count < g_NUM_CYCLES and sig_en = '1') then     -- Test if counter is enabled and cycle count is less than g_NUM_CYCLES
        if sig_cnt1 = 0 then                                       -- Test if first counter has reached zero
          if sig_cnt2 = 0 then                                     -- Test if second counter has reached zero
            sig_cnt1 <= to_unsigned(g_CNT1_INIT, 10);              -- Reset first counter to initial value of g_CNT1_INIT
            sig_cnt2 <= to_unsigned(g_CNT2_INIT, 10);              -- Reset second counter to initial value of g_CNT2_INIT
            sig_cycle_count <= sig_cycle_count + 1;                        -- Increment cycle count
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
  cycle_count <= std_logic_vector(sig_cycle_count);
  
end architecture behavioral;

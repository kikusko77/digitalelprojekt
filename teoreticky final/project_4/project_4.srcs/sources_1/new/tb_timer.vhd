library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_timer is
end entity tb_timer;

architecture testbench of tb_timer is

  constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

  -- Local signals
  signal sig_clk_100mhz : std_logic;
  signal sig_rst        : std_logic;
  signal sig_en         : std_logic;
  signal sig_cnt1       : std_logic_vector(9  downto 0);
  signal sig_cnt2       : std_logic_vector(9  downto 0);

begin

  uut_cnt : entity work.timer
    port map (
      clk    => sig_clk_100mhz,
      rst    => sig_rst,
      en     => sig_en,
      cnt1   => sig_cnt1,
      cnt2   => sig_cnt2,
      g_NUM_CYCLES => 3,
      g_CNT1_INIT => 20,
      g_CNT2_INIT => 10
    );

  p_clk_gen : process is
  begin

    while now < 2000 ns loop             -- 100 periods of 100MHz clock

      sig_clk_100mhz <= '0';
      wait for c_CLK_100MHZ_PERIOD / 2;
      sig_clk_100mhz <= '1';
      wait for c_CLK_100MHZ_PERIOD / 2;

    end loop;
    wait;                               -- Process is suspended forever

  end process p_clk_gen;

  p_reset_gen : process is
  begin

    sig_rst <= '0';

    wait;

  end process p_reset_gen;

  p_stimulus : process is
  begin

    report "Stimulus process started";
    
    sig_en <= '1';

    report "Stimulus process finished";
    wait;

  end process p_stimulus;

end architecture testbench;
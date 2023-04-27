-- Testbench code for the Tabata counter
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cnt is
end tb_cnt;

architecture Behavioral of tb_cnt is
    signal s_clock     : std_logic := '0';  -- clock signal
    signal s_reset     : std_logic := '0';  -- reset signal
    signal s_start     : std_logic := '0';  -- start signal
    signal s_rounds    : integer := 8;     -- number of rounds
    signal s_minutes   : integer := 20;    -- number of minutes
    signal s_pause     : integer := 10;    -- pause time
    
begin
    -- Instantiate the Tabata counter module
    uut: entity work.cnt_up_down
        port map (
            clock   => clock,
            reset   => reset,
            start   => start,
            rounds  => rounds,
            minutes => minutes,
            pause   => pause
           
        );

    -- Clock generation process
    process
    begin
        clock <= '0';
        wait for 500 ns;
        clock <= '1';
        wait for 500 ns;
    end process;

    -- Stimulus process
    process
    begin
        -- Reset the Tabata counter
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;

        -- Start the Tabata counter
        start <= '1';
        wait for 100 ns;

        -- Stop the Tabata counter
        start <= '0';
        wait;
    end process;
end Behavioral;

------------------------------------------------------------------------
--
-- One-minute stopwatch.
-- Nexys A7-50T, Vivado v2020.1.1, EDA Playground
--
-- Copyright (c) 2020 Tomas Fryza
-- Dept. of Radio Electronics, Brno University of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Entity declaration for stopwatch counter
------------------------------------------------------------------------
entity clock is
    port(
         clk_in: in std_logic;
        rst: in std_logic;
        button_rounds_inc: in std_logic;
        button_rounds_dec: in std_logic;
        button_rounds_conf: in std_logic;
        button_time_round_inc: in std_logic;
        button_time_round_dec: in std_logic;
        button_time_round_conf: in std_logic;
        button_time_pause_inc: in std_logic;
        button_time_pause_dec: in std_logic;
        button_time_pause_conf: in std_logic;
        clk_out: out std_logic
    );
     signal internal_clk_out : std_logic := '0';
end entity clock;

------------------------------------------------------------------------
-- Architecture declaration for stopwatch counter
------------------------------------------------------------------------
architecture Behavioral of clock is

    signal counter_rounds : integer range 0 to 10 := 0;
    signal counter_time_round : integer range 0 to 20 := 0;
    signal counter_time_pause : integer range 0 to 20 := 0;
    signal counter : integer range 0 to 100 := 0;
    signal state : integer range 0 to 3 := 0;
    signal is_running : boolean := false;
begin
    -- Synchronous process to increment/decrement rounds
    process(clk_in, rst)
    begin
        if rst = '1' then
            counter_rounds <= 0;
        else
            if button_rounds_inc = '1' and state = 0 then
                if counter_rounds < 10 then
                    counter_rounds <= counter_rounds + 1;
                end if;
            elsif button_rounds_dec = '1' and state = 0 then
                if counter_rounds > 0 then
                    counter_rounds <= counter_rounds - 1;
                
                end if;
            end if;
        end if;
    end process;
    -- Synchronous process to increment/decrement time per round
    process(clk_in, rst)
    begin
        if rst = '1' then
            counter_time_round <= 0;
        else
            if button_time_round_inc = '1' and state = 1 then
                if counter_time_round < 20 then
                    counter_time_round <= counter_time_round + 10;
                end if;
            elsif button_time_round_dec = '1' and state = 1 then
                if counter_time_round > 0 then
                    counter_time_round <= counter_time_round - 10;
                end if;
            end if;
        end if;
    end process;
    -- Synchronous process to increment/decrement pause time
    process(clk_in, rst)
    begin
        if rst = '1' then
            counter_time_pause <= 0;
        else
            if button_time_pause_inc = '1' and state = 2 then
                if counter_time_pause < 20 then
                    counter_time_pause <= counter_time_pause + 10;
                end if;
            elsif button_time_pause_dec = '1' and state = 2 then
                if counter_time_pause > 0 then
                    counter_time_pause <= counter_time_pause - 10;
                end if;
            end if;
        end if;
    end process;
     -- Asynchronous reset to default values
    process(rst)
    begin
        if rst = '1' then
            counter_rounds <= 0;
            counter_time_round <= 0;
            counter_time_pause <= 0;
            state <= 0;
            is_running <= false;
        end if;
    end process;
    process(clk_in)
begin
    if is_running = true then
        if counter = 0 then
            if state = 1 then
                counter <= counter_time_pause;
                state <= 2;
            elsif state = 2 then
                if counter_rounds > 0 then
                    counter_rounds <= counter_rounds - 1;
                    counter <= counter_time_round;
                    state <= 1;
                else
                    is_running <= false;
                end if;
            end if;
        else
            counter <= counter - 1;
        end if;
    end if;
end process;
-- Output the clock signal

    process(clk_in, internal_clk_out)
    begin
        if clk_in'event and clk_in = '1' then
            internal_clk_out <= not internal_clk_out;
        end if;
    end process;

    clk_out <= internal_clk_out; -- Assign internal signal to clk_out port


end architecture Behavioral;

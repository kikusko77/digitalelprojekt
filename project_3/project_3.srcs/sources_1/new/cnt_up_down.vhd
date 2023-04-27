-- Define the inputs and outputs of the module
entity cnt_up_down is
    port (
        clock   : in  std_logic;     -- clock input
        reset   : in  std_logic;     -- reset input
        start   : in  std_logic;     -- start input
        rounds  : in  integer range 0 to 255;   -- number of rounds input
        minutes : in  integer range 0 to 255;   -- number of minutes input
        pause   : in  integer range 0 to 255;   -- pause time input
      
    );
end cnt_up_down;

-- Implement the logic for the Tabata counter
architecture Behavioral of cnt_up_down is
    signal round_cnt   : integer range 0 to 255 := 0;  -- round counter
    signal minute_cnt  : integer range 0 to 255 := 0;  -- minute counter
    signal pause_cnt   : integer range 0 to 255 := 0;  -- pause counter
    signal state       : integer range 0 to 3   := 0  -- state machine state
begin
    -- State machine for counting rounds, minutes, and pause time
    process (clock, reset)
    begin
        if reset = '1' then
            -- Reset all counters and state machine state
            round_cnt   <= 0;
            minute_cnt  <= 0;
            pause_cnt   <= 0;
            state       <= 0;
        elsif rising_edge(clock) then
            -- Increment counters based on state machine state
            case state is
                when 0 =>   -- round countdown
                    if start = '1' then
                        if round_cnt < rounds - 1 then
                            round_cnt <= round_cnt + 1;
                        else
                            state <= 1;
                            round_cnt <= 0;
                        end if;
                    end if;
                when 1 =>   -- pause countdown
                    if pause_cnt < pause - 1 then
                        pause_cnt <= pause_cnt + 1;
                    else
                        state <= 2;
                        pause_cnt <= 0;
                    end if;
                when 2 =>   -- work countdown
                    if start = '1' then
                        if minute_cnt < minutes - 1 then
                            minute_cnt <= minute_cnt + 1;
                        else
                            state <= 3;
                            minute_cnt <= 0;
                        end if;
                    end if;
                when 3 =>   -- pause countdown
                    if pause_cnt < pause - 1 then
                        pause_cnt <= pause_cnt + 1;
                    else
                        state <= 0;
                        pause_cnt <= 0;
                    end if;
            end case;
        end if;
    end process;
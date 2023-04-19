library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all; -- Package for arithmetic operations

-- Define the inputs and outputs of the module
entity Tabata_Counter is
    port (
        clock   : in  std_logic;     -- clock input
        reset   : in  std_logic;     -- reset input
        start   : in  std_logic;     -- start input
        rounds  : in  integer range 0 to 255;   -- number of rounds input
        minutes : in  integer range 0 to 255;   -- number of minutes input
        pause   : in  integer range 0 to 255;   -- pause time input
        buzzer  : out std_logic      -- buzzer output
    );
end Tabata_Counter;

-- Implement the logic for the Tabata counter
architecture Behavioral of Tabata_Counter is
    signal cnt         : integer range 0 to 255 := 0;  -- counter
    signal state       : integer range 0 to 2   := 0;  -- state machine state
begin
    -- State machine for counting rounds and pause time
    process (clock, reset)
    begin
        if reset = '1' then
            -- Reset the counter and state machine state
            cnt   <= 0;
            state <= 0;
        elsif rising_edge(clock) then
            -- Increment the counter based on state machine state
            case state is
                when 0 =>   -- run
                    if start = '1' then
                        if cnt < rounds - 1 then
                            cnt <= cnt + 1;
                        else
                            state <= 1;
                            cnt <= 0;
                        end if;
                    end if;
                when 1 =>   -- pause
                    if cnt < pause - 1 then
                        cnt <= cnt + 1;
                    else
                        state <= 0;
                        cnt <= 0;
                    end if;
            end case;
        end if;
    end process;

    -- Activate the buzzer when in the pause state
    buzzer <= '1' when state = 1 else '0';
end Behavioral;

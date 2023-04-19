library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Tabata_Counter_TB is
end Tabata_Counter_TB;

architecture Behavioral of Tabata_Counter_TB is
    component Tabata_Counter is
        port (
            clock   : in  std_logic;
            reset   : in  std_logic;
            start   : in  std_logic;
            rounds  : in  integer range 0 to 255;
            minutes : in  integer range 0 to 255;
            pause   : in  integer range 0 to 255;
            buzzer  : out std_logic
        );
    end component;

    signal clock      : std_logic := '0';
    signal reset      : std_logic := '0';
    signal start      : std_logic := '0';
    signal rounds     : integer range 0 to 255 := 4;
    signal minutes    : integer range 0 to 255 := 1;
    signal pause      : integer range 0 to 255 := 2;
    signal buzzer_out : std_logic;

begin
    uut : Tabata_Counter
        port map (
            clock   => clock,
            reset   => reset,
            start   => start,
            rounds  => rounds,
            minutes => minutes,
            pause   => pause,
            buzzer  => buzzer_out
        );

    process
    begin
        -- Initialize inputs
        reset <= '1';
        rounds <= 8;
        minutes <= 1;
        pause <= 2;
        wait for 10 ns;
        reset <= '0';

        -- Wait for one minute
        wait for 60_000_000 ns;

        -- Start the counter
        start <= '1';

        -- Wait for four rounds (run for 20s, pause for 10s)
        wait for 30_000_000 ns;
        wait for 30_000_000 ns;
        wait for 30_000_000 ns;
        wait for 30_000_000 ns;

        -- Stop the counter
        start <= '0';

        -- Wait for the buzzer to stop
        wait for 2_000_000 ns;

        -- Check the output
        assert buzzer_out = '0' report "Buzzer did not stop after the counter finished" severity error;

        wait;
    end process;
end Behavioral;

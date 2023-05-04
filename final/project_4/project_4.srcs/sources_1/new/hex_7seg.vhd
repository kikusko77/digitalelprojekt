library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hex_7seg is
    port (
        blank : in std_logic;
        hex : in std_logic_vector(9 downto 0);
        seg1 : out std_logic_vector(6 downto 0);
        seg2 : out std_logic_vector(6 downto 0);
        seg3 : out std_logic_vector(6 downto 0)
    );
end entity hex_7seg;

architecture behavioral of hex_7seg is
    signal hex_int : integer range 0 to 300;
    signal hundreds : integer range 0 to 3;
    signal tens : integer range 0 to 9;
    signal ones : integer range 0 to 9;
begin
    hex_int <= to_integer(unsigned(hex));

    hundreds <= hex_int / 100;
    tens <= (hex_int / 10) mod 10;
    ones <= hex_int mod 10;

    p_7seg_decoder : process (blank, hundreds, tens, ones) is
    begin
        if (blank = '1') then
            seg1 <= "1111111";
            seg2 <= "1111111";
            seg3 <= "1111111";
        else
            case hundreds is
                when 1 => seg3 <= "1001111";
                when 2 => seg3 <= "0010010";
                when 3 => seg3 <= "0000110";
                when others => seg3 <= "1111111";
            end case;

            case tens is
                when 0 => seg2 <= "0000001";
                when 1 => seg2 <= "1001111";
                when 2 => seg2 <= "0010010";
                when 3 => seg2 <= "0000110";
                when 4 => seg2 <= "1001100";
                when 5 => seg2 <= "0100100";
                when 6 => seg2 <= "0100000";
                when 7 => seg2 <= "0001111";
                when 8 => seg2 <= "0000000";
                when 9 => seg2 <= "0000100";
                when others => null;
            end case;

            case ones is
                when 0 => seg1 <= "0000001";
                when 1 => seg1 <= "1001111";
                when 2 => seg1 <= "0010010";
                when 3 => seg1 <= "0000110";
                when 4 => seg1 <= "1001100";
                when 5 => seg1 <= "0100100";
                when 6 => seg1 <= "0100000";
                when 7 => seg1 <= "0001111";
                when 8 => seg1 <= "0000000";
                when 9 => seg1 <= "0000100";
                when others => null;
            end case;
        end if;
    end process p_7seg_decoder;
end architecture behavioral;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hex_7seg_p is
    port (
        blank : in std_logic;
        hex : in std_logic_vector(9 downto 0);
        seg1_p : out std_logic_vector(6 downto 0);
        seg2_p : out std_logic_vector(6 downto 0)
    );
end entity hex_7seg_p;

architecture behavioral of hex_7seg_p is
    signal hex_int : integer range 0 to 20;
    signal tens : integer range 0 to 2;
    signal ones : integer range 0 to 9;
begin
    hex_int <= to_integer(unsigned(hex));

    tens <= (hex_int / 10) mod 10;
    ones <= hex_int mod 10;

    p_7seg_decoder : process (blank, tens, ones) is
    begin
        if (blank = '1') then
            seg1_p <= "1111111";
            seg2_p <= "1111111";

        else
            
            case tens is
                when 0 => seg2_p <= "0000001";
                when 1 => seg2_p <= "1001111";
                when 2 => seg2_p <= "0010010";
                when others => null;
            end case;

            case ones is
                when 0 => seg1_p <= "0000001";
                when 1 => seg1_p <= "1001111";
                when 2 => seg1_p <= "0010010";
                when 3 => seg1_p <= "0000110";
                when 4 => seg1_p <= "1001100";
                when 5 => seg1_p <= "0100100";
                when 6 => seg1_p <= "0100000";
                when 7 => seg1_p <= "0001111";
                when 8 => seg1_p <= "0000000";
                when 9 => seg1_p <= "0000100";
                when others => null;
            end case;
        end if;
    end process p_7seg_decoder;
end architecture behavioral;
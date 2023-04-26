

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;



entity hex_7seg_k is
  port (
    blank : in    std_logic;                    --! Display is clear if blank = 1
    hex   : in    std_logic_vector(1 downto 0); --! Binary representation of one hexadecimal symbol
    seg   : out   std_logic_vector(6 downto 0)  --! Seven active-low segments in the order: a, b, ..., g
  );
end entity hex_7seg_k;

----------------------------------------------------------
-- Architecture body for seven-segment display decoder
----------------------------------------------------------

architecture behavioral of hex_7seg_k is
 signal ones : integer range 0 to 9;
 signal hex_int : integer range 0 to 20;
begin

hex_int <= to_integer(unsigned(hex));

   
    ones <= hex_int mod 10;

   p_7seg_decoder : process (blank,ones) is
    begin
        if (blank = '1') then
            seg <= "1111111";
            
        else
            
            

            case ones is
                when 0 => seg <= "0000001";
                when 1 => seg <= "1001111";
                when 2 => seg <= "0010010";
                when 3 => seg <= "0000110";
                when 4 => seg <= "1001100";
                when 5 => seg <= "0100100";
                when 6 => seg <= "0100000";
                when 7 => seg <= "0001111";
                when 8 => seg <= "0000000";
                when 9 => seg <= "0000100";
                when others => null;
            end case;
         end if;
  end process p_7seg_decoder;

end architecture behavioral;
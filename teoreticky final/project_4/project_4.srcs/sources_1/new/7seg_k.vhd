

library ieee;
  use ieee.std_logic_1164.all;



entity hex_7seg_k is
  port (
    blank : in    std_logic;                    --! Display is clear if blank = 1
    hex   : in    std_logic_vector(2 downto 0); --! Binary representation of one hexadecimal symbol
    seg   : out   std_logic_vector(6 downto 0)  --! Seven active-low segments in the order: a, b, ..., g
  );
end entity hex_7seg_k;

----------------------------------------------------------
-- Architecture body for seven-segment display decoder
----------------------------------------------------------

architecture behavioral of hex_7seg_k is

begin

  p_7seg_decoder : process (blank, hex) is

  begin

    if (blank = '1') then
      seg <= "1111111";     -- Blanking display
    else

      case hex is

        when "000" =>
          seg <= "0000001"; -- 0

        when "001" =>
          seg <= "1001111"; -- 1

        -- WRITE YOUR CODE HERE
        -- 2, 3, 4, 5, 6, 7

        when "010" =>
          seg <= "0010010"; -- 2

        when "011" =>
          seg <= "0000110"; -- 3

        when "100" =>
          seg <= "1001100"; -- 4

        when "101" =>
          seg <= "0100100"; -- 5

        when "110" =>
          seg <= "0100000"; -- 6

        when "111" =>
          seg <= "0001111"; -- 7

        when others =>
          seg <= "1111111"; -- F

      end case;

    end if;

  end process p_7seg_decoder;

end architecture behavioral;
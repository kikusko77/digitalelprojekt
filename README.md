# VHDL project

## Časovač na intervalový (kruhový) trénink s možností nastavit počet kol, dobu kola a pauzy mezi nimi za běhu aplikace.

### Team members

* Filip Frey
* Christian Kuric
* Jakub Raimr





## Theoretical description and explanation

Mezi důležité oblasti tohoto projektu patří: 

- funkce pro odečet času kola a pauzy
- funkce pro přičítání počtu kol
- správné zobrazení všech údajů na displeji
- správná funkce reset
- správná funkce enable
- nastavování údajů pomocí přepínačů

### Funkce pro odečet času kola a pauzy
Po přepnutí patnáctého přepínače začne odečet kola. Po odečtení kola začne odečet pauzy.

### Funkce pro přičítání počtu kol
Jakmile skončí odečtení pauzy, přičte se počet kol a odčítání kola opět začíná.

### Správné zobrazení všech údajů na displeji
Pro správné zobrazení hodnot času kola a pauzy posíláme daná čísla do hex7_seg a 7seg_p, kde jsou čísla konvertována pomocí dalších funkcí na jednotlivé cifry. Tyto cifry jsou následně v jejich 7mi segmentových hodnotách posílány na 7mi segmentový displej.
Takže například v kódu pro zobrazení pauzy jsme definovali, že se bude zobrazovat na dvou 7mi segmentových displejích a každý displej bude ukazovat hodnoty 0 až 9.

### Správná funkce resetu
Pro tuto funkci jsme si zvolili tlačítko BTNC nad 7mi segmentovými displeji. Při zmáčknutí tlačítka BTNC se odpočet zastaví a displej se vynuluje.

### Správná funkce enable
Pro tuto funkci jsme si zvolili patnáctý přepínač. Při jeho sepnutí začne odpočet časovače podle zvoleného nastavení. Pokud jsme ponechali výchozí nastavení, tak se začnou odčítat 3 kola po 30 sekundách s 20 sekundovou pauzou.

### Nastavování údajů pomocí přepínačů
Pro každou veličinu jsme si určili n-bitové číslo, konkrétně pro čas kola 10ti bitové číslo, pro čas pauzy 10ti bitové číslo a pro zobrazení kol 3 bitové číslo. Nejvyšší zobrazitelný čas kola je 300 sekund, nejvyšší možný čas pauzy je 99 sekund a nejvyšší počet kol je 7. 
U každé veličiny budeme nastavovat číslo natural za pomocí přepínačů. První 2 přepínače zprava (SW(0), SW(1)) slouží k nastavení počtu kol. První přepínač zprava má nejměnší přírůst čísla natural a druhý přepínač zprava má nejvyšší přírůst čísla natural. Podobným způsobem funguje nastavení času kola následujícími třemi přepínači v pořadí (SW(2), SW(3), SW(4)) a úplně stejně to má i délka pauzy, která se nastavuje dalšími dvěmi přepínači (SW(5), SW(6)).
Pomocí design souborů hex_7seg, 7seg_p a 7seg_k zvolenou hodnotu natural dekódujeme na jednotlivé cifry, které jsou následně zobrazeny na displeji.

## Hardware description of demo application

Pro realizaci našeho časovače jsme použili desku Nexys A7 Artix-7 50T, což je dostupná, ale zároveň výkonná vývojářská deska. Jelikož byla deska navržena v rámci Xilinx Artix®-7 FPGA family, tak je tato deska výbornou platformou pro seznamení studentů s vývojem digitálních obvodů a jejich následnou aplikací. Nexys A7 Artix-7 50T je podporovaná softwarem Xilinx Vivado Design Suite, který byl použit pro vytvoření tohoto projektu. 

Deska obsahuje mnoho užitečných nástrojů pro využití v projektech, jako například mikrofon, LED diody, reproduktor a další. Pro používání těchto komponentů deska obsahuje rozhraní 10/100 Ethernet, USB, VGA a jiné. Pro naše účely bude dostatečné rozhraní USB s použitím 7mi segmentových displejů, přepínačů a tlačítek.

![Digilent_Nexys_A7-100T](https://user-images.githubusercontent.com/95495159/235364753-0c22832e-0b96-4617-91d1-f8c308c7bfe5.jpg)



## Software description

Put flowchats/state diagrams of your algorithm(s) and direct links to source/testbench files in `src` and `sim` folders.

7seg_k - nevím - source, který slouží k počítání kol na displeji

https://github.com/kikusko77/digitalelprojekt/blob/3943aa9c5cb736bb78a51a3be46713379b49007a/teoreticky%20final/project_4/project_4.srcs/sources_1/new/7seg_k.vhd

```vhdl


library ieee;
  use ieee.std_logic_1164.all;



entity 7seg_k is
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
```



7seg_p - nevím - source, který slouží k počítání času pauzy

https://github.com/kikusko77/digitalelprojekt/blob/3943aa9c5cb736bb78a51a3be46713379b49007a/teoreticky%20final/project_4/project_4.srcs/sources_1/new/7seg_p.vhd

```vhdl
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
    signal hex_int : integer range 0 to 99;
    signal tens : integer range 0 to 9;
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
                when 3 => seg2_p <= "0000110";
                when 4 => seg2_p <= "1001100";
                when 5 => seg2_p <= "0100100";
                when 6 => seg2_p <= "0100000";
                when 7 => seg2_p <= "0001111";
                when 8 => seg2_p <= "0000000";
                when 9 => seg2_p <= "0000100";
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
```



clock_enable - nevím - source se spouštěním odpočtu

https://github.com/kikusko77/digitalelprojekt/blob/3943aa9c5cb736bb78a51a3be46713379b49007a/teoreticky%20final/project_4/project_4.srcs/sources_1/new/clock_enable.vhd

```vhdl
----------------------------------------------------------
--
--! @title Clock enable
--! @author Tomas Fryza
--! Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
--!
--! @copyright (c) 2019 Tomas Fryza
--! This work is licensed under the terms of the MIT license
--!
--! Generates clock enable signal according to the number
--! of clock pulses `g_MAX`.
--
-- Hardware: Nexys A7-50T, xc7a50ticsg324-1L
-- Software: TerosHDL, Vivado 2020.2, EDA Playground
--
----------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all; -- Package for arithmetic operations

----------------------------------------------------------
-- Entity declaration for clock enable
----------------------------------------------------------

entity clock_enable is
  generic (
    g_MAX : natural := 5 --! Number of clk pulses to generate one enable signal period
  );                       -- Note that there IS a semicolon between generic and port sections
  port (
    clk : in    std_logic; --! Main clock
    rst : in    std_logic; --! High-active synchronous reset
    ce  : out   std_logic  --! Clock enable pulse signal
  );
end entity clock_enable;

------------------------------------------------------------
-- Architecture body for clock enable
------------------------------------------------------------

architecture behavioral of clock_enable is

  -- Local counter
  signal sig_cnt : natural;

begin

  --------------------------------------------------------
  -- p_clk_enable:
  -- Generate clock enable signal. By default, enable signal
  -- is low and generated pulse is always one clock long.
  --------------------------------------------------------
  p_clk_enable : process (clk) is
  begin

    if (rising_edge(clk)) then            -- Synchronous process
      if (rst = '1') then                 -- High-active reset
        sig_cnt <= 0;                     -- Clear local counter
        ce      <= '0';                   -- Set output to low

      -- Test number of clock periods
      elsif (sig_cnt >= (g_MAX - 1)) then
        sig_cnt <= 0;                     -- Clear local counter
        ce      <= '1';                   -- Generate clock enable pulse
      else
        sig_cnt <= sig_cnt + 1;
        ce      <= '0';
      end if;
    end if;

  end process p_clk_enable;

end architecture behavioral;
```



hex_7seg - nevím - source se zobrazením času kola

https://github.com/kikusko77/digitalelprojekt/blob/3943aa9c5cb736bb78a51a3be46713379b49007a/teoreticky%20final/project_4/project_4.srcs/sources_1/new/hex_7seg.vhd

```vhdl
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
```



timer - nevím - source, který obsahuje funkce odpočtu časovače

https://github.com/kikusko77/digitalelprojekt/blob/3943aa9c5cb736bb78a51a3be46713379b49007a/teoreticky%20final/project_4/project_4.srcs/sources_1/new/timer.vhd

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
  port (
    clk    : in    std_logic;                                 --! Main clock
    rst    : in    std_logic;                                 --! Synchronous reset
    en     : in    std_logic;                                 --! Enable input
    cnt1   : out   std_logic_vector(9  downto 0);   --! First counter value
    cnt2   : out   std_logic_vector(9  downto 0);    --! Second counter value
    cycle_count: out   std_logic_vector(2  downto 0);
    g_NUM_CYCLES: in natural; --! Default number of cycles
    g_CNT1_INIT: in natural; --! Default initial value for first counter
    g_CNT2_INIT: in natural   --! Default initial value for second counter
    
  );
end entity timer;

architecture behavioral of timer is

  signal sig_cnt1 : unsigned(9 downto 0) := to_unsigned(g_CNT1_INIT, 10); --! Local first counter with initial value of g_CNT1_INIT
  signal sig_cnt2 : unsigned(9 downto 0) := to_unsigned(g_CNT2_INIT, 10); --! Local second counter with initial value of g_CNT2_INIT
  signal sig_cycle_count: unsigned(2 downto 0) := to_unsigned(g_NUM_CYCLES, 3);                         --! Cycle count
  signal sig_en : std_logic;  


begin

 clk_en0 : entity work.clock_enable
    generic map (
      g_MAX => 100000000
    )
    port map (
      clk => clk,
      rst => rst,
      ce  => sig_en
    );



 p_timer: process(clk)
 
 begin
  
    if (rising_edge(clk)) then
      if (rst = '1') then           -- Synchronous reset
        sig_cnt1 <= (others => '0'); -- Clear all bits of first counter
        sig_cnt2 <= (others => '0'); -- Clear all bits of second counter
        sig_cycle_count <= (others => '0');          -- Reset cycle count
      elsif (en = '1' and sig_cycle_count <= g_NUM_CYCLES and sig_en = '1') then     -- Test if counter is enabled and cycle count is less than g_NUM_CYCLES
        if sig_cnt1 = 0 then                                       -- Test if first counter has reached zero
          if sig_cnt2 = 0 then                                     -- Test if second counter has reached zero
            sig_cnt1 <= to_unsigned(g_CNT1_INIT, 10);              -- Reset first counter to initial value of g_CNT1_INIT
            sig_cnt2 <= to_unsigned(g_CNT2_INIT, 10);              -- Reset second counter to initial value of g_CNT2_INIT
            sig_cycle_count <= sig_cycle_count + 1;                        -- Increment cycle count
          else                                                     -- Second counter has not reached zero yet
            sig_cnt2 <= sig_cnt2 - 1;                              -- Decrement second counter
          end if;
        else                                                       -- First counter has not reached zero yet
          sig_cnt1 <= sig_cnt1 - 1;                                -- Decrement first counter
        end if;
      end if;
    end if;
  end process p_timer;

  cnt1 <= std_logic_vector(sig_cnt1);
  cnt2 <= std_logic_vector(sig_cnt2);
  cycle_count <= std_logic_vector(sig_cycle_count);
  
end architecture behavioral;
```



timer_7seg - nevím - source, který zobrazuje funkce na displeji

https://github.com/kikusko77/digitalelprojekt/blob/3943aa9c5cb736bb78a51a3be46713379b49007a/teoreticky%20final/project_4/project_4.srcs/sources_1/new/timer_7seg.vhd

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer_7seg is
    port (
        clk : in std_logic;
        rst : in std_logic;
        en : in std_logic;
        seg1 : out std_logic_vector(6 downto 0);
        seg2 : out std_logic_vector(6 downto 0);
        seg3 : out std_logic_vector(6 downto 0);
        seg : out std_logic_vector(6 downto 0);
        seg1_p : out std_logic_vector(6 downto 0);
        seg2_p : out std_logic_vector(6 downto 0);
        sig_g_NUM_CYCLES: natural;
        sig_g_CNT1_INIT: natural;
        sig_g_CNT2_INIT: natural
    );
end entity timer_7seg;

architecture behavioral of timer_7seg is
    component timer is
        port (
            clk : in std_logic;
            rst : in std_logic;
            en : in std_logic;
            cnt1 : out std_logic_vector(9  downto 0);
            cnt2 : out std_logic_vector(9  downto 0);
            cycle_count: out std_logic_vector(2 downto 0);
            g_NUM_CYCLES: in natural;
            g_CNT1_INIT:  in natural;
            g_CNT2_INIT:  in natural
            
        );
    end component timer;

    component hex_7seg is
        port (
            blank : in std_logic;
            hex : in std_logic_vector(9 downto 0);
            seg1 : out std_logic_vector(6 downto 0);
            seg2 : out std_logic_vector(6 downto 0);
            seg3 : out std_logic_vector(6 downto 0)
        );
    end component hex_7seg;

    component hex_7seg_k is
            port (
                blank : in std_logic;
                hex : in std_logic_vector(2 downto 0);
                seg : out std_logic_vector(6 downto 0)
            );
        end component hex_7seg_k;
     
     component hex_7seg_p is
            port (
                blank : in std_logic;
                hex : in std_logic_vector(9 downto 0);
                seg1_p : out std_logic_vector(6 downto 0);
                seg2_p : out std_logic_vector(6 downto 0)
            );
        end component hex_7seg_p;   
        

    signal cnt1_sig: std_logic_vector(9 downto 0);
    signal hex_sig: std_logic_vector(9 downto 0);
    signal cycle1_count: std_logic_vector(2 downto 0);
    signal hex_sig_k: std_logic_vector(2 downto 0);
    signal hex_sig_p: std_logic_vector(9 downto 0);
    signal cnt2_sig: std_logic_vector(9 downto 0);

begin
    inst_timer: timer
        port map (
            clk => clk,
            rst => rst,
            en => en,
            cnt1 => cnt1_sig,
            cnt2 => cnt2_sig,
            cycle_count => cycle1_count,
            g_NUM_CYCLES => sig_g_NUM_CYCLES,
            g_CNT1_INIT => sig_g_CNT1_INIT,
            g_CNT2_INIT => sig_g_CNT2_INIT
        );


    hex_sig <= cnt1_sig;
    hex_sig_p <= cnt2_sig;
    hex_sig_k <= cycle1_count;


    inst_hex_7seg: hex_7seg
        port map (
            blank => '0',
            hex => hex_sig,
            seg1 => seg1,
            seg2 => seg2,
            seg3 => seg3
        );
        
    inst_hex_7seg_k: hex_7seg_k
        port map (
            blank => '0',
            hex => hex_sig_k,
            seg => seg
        );
        
      inst_hex_7seg_p: hex_7seg_p
        port map (
            blank => '0',
            hex => hex_sig_p,
            seg1_p => seg1_p,
            seg2_p => seg2_p
        );  
        
        
end architecture behavioral;
```



top - nevím - propojení všech funkcí k následnému použití na desce

https://github.com/kikusko77/digitalelprojekt/blob/3943aa9c5cb736bb78a51a3be46713379b49007a/teoreticky%20final/project_4/project_4.srcs/sources_1/new/top.vhd

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port (
        CLK100MHZ: in std_logic;
        SW: in std_logic_vector (15 downto 0);
        AN: out std_logic_vector(7 downto 0);
        CA: out std_logic;
        CB: out std_logic;
        CC: out std_logic;
        CD: out std_logic;
        CE: out std_logic;
        CF: out std_logic;
        CG: out std_logic;
        BTNC: in std_logic
    );
end entity top;

architecture behavioral of top is

   signal sig_seg1:  std_logic_vector(6 downto 0);
   signal sig_seg2:  std_logic_vector(6 downto 0);
   signal sig_seg3:  std_logic_vector(6 downto 0);
   signal sig_seg1_p:  std_logic_vector(6 downto 0);
   signal sig_seg2_p:  std_logic_vector(6 downto 0);
   signal sig_seg:  std_logic_vector(6 downto 0);
      
      
    component timer_7seg is
        port (
            CLK100MHZ: in std_logic;
            rst: in std_logic;
            en: in std_logic;
            seg1: out std_logic_vector(6 downto 0);
            seg2: out std_logic_vector(6 downto 0);
            seg3: out std_logic_vector(6 downto 0);
            seg1_p: out std_logic_vector(6 downto 0);
            seg2_p: out std_logic_vector(6 downto 0);
            seg: out std_logic_vector(6 downto 0);
            sig_g_NUM_CYCLES: natural;
            sig_g_CNT1_INIT: natural;
            sig_g_CNT2_INIT: natural            
            
        );
    end component timer_7seg;

    -- Signals
    signal count: integer range 0 to 1000000 := 0;
    signal digit_sel: integer range 1 to 5 := 1;
    
    signal SW_NUM_CYCLES : natural;
    signal SW_CNT1_INIT : natural;
    signal SW_CNT2_INIT : natural;

   
    
begin

    -- Instantiate timer_7seg entity
    timer_7seg_inst: entity work.timer_7seg
    port map (
        clk => CLK100MHZ,
        rst => BTNC,
        en => SW(15),
        seg1 => sig_seg1,
        seg2 => sig_seg2,
        seg3 => sig_seg3,
        seg1_p => sig_seg1_p,
        seg2_p => sig_seg2_p,
        seg  => sig_seg,
        sig_g_NUM_CYCLES => SW_NUM_CYCLES,
        sig_g_CNT1_INIT => SW_CNT1_INIT,
        sig_g_CNT2_INIT => SW_CNT2_INIT
        
    );
    
    
    p_set_values : process(SW)
    begin
        if SW(1) = '1' then
            SW_NUM_CYCLES <= 7;
        elsif SW(0) = '1' then
            SW_NUM_CYCLES <= 5;    
        else
            SW_NUM_CYCLES <= 3; -- default value
        end if;
        
        if SW(4) = '1' then
            SW_CNT1_INIT <= 240;
        elsif SW(3) = '1' then
            SW_CNT1_INIT <= 180;
        elsif SW(2) = '1' then
            SW_CNT1_INIT <= 90;    
        else
            SW_CNT1_INIT <= 30; -- default value
        end if;
        
        if SW(6) = '1' then
            SW_CNT2_INIT <= 90;
        elsif SW(5) = '1' then
            SW_CNT2_INIT <= 60;   
        else
            SW_CNT2_INIT <= 20; -- default value
        end if;
        
    end process p_set_values;
    
    
    
    -- Multiplexing process
    mux_proc: process (CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            if count = 1000000 then
                count <= 0;

                case digit_sel is
                    when 1 =>
                        AN <= "11111110"; -- Select first seven-segment display
                        CA <=  sig_seg1(6);
                        CB <=   sig_seg1(5);
                        CC <=   sig_seg1(4);
                        CD <=   sig_seg1(3);
                        CE <=   sig_seg1(2);
                        CF <=   sig_seg1(1);
                        CG <=   sig_seg1(0);

                        digit_sel <= digit_sel + 1;

                    when 2 =>
                        AN <= "11111101"; -- Select second seven-segment display
                        CA <=   sig_seg2(6);
                        CB <=   sig_seg2(5);
                        CC <=   sig_seg2(4);
                        CD <=   sig_seg2(3);
                        CE <=   sig_seg2(2);
                        CF <=   sig_seg2(1);
                        CG <=   sig_seg2(0);
                        digit_sel <= digit_sel + 1;

                    when 3 =>
                        AN <= "11111011"; -- Select third seven-segment display
                        CA <=   sig_seg3(6);
                        CB <=   sig_seg3(5);
                        CC <=   sig_seg3(4);
                        CD <=   sig_seg3(3);
                        CE <=   sig_seg3(2);
                        CF <=   sig_seg3(1);
                        CG <=   sig_seg3(0);
                        digit_sel <= digit_sel + 1;

                     when 4 =>
                        AN <= "11101111"; 
                        CA <=   sig_seg1_p(6);
                        CB <=   sig_seg1_p(5);
                        CC <=   sig_seg1_p(4);
                        CD <=   sig_seg1_p(3);
                        CE <=   sig_seg1_p(2);
                        CF <=   sig_seg1_p(1);
                        CG <=   sig_seg1_p(0);
                        digit_sel <= digit_sel + 1;
                        

                     when 5 =>
                        AN <= "11011111"; 
                        CA <=   sig_seg2_p(6);
                        CB <=   sig_seg2_p(5);
                        CC <=   sig_seg2_p(4);
                        CD <=   sig_seg2_p(3);
                        CE <=   sig_seg2_p(2);
                        CF <=   sig_seg2_p(1);
                        CG <=   sig_seg2_p(0);
                        digit_sel <= digit_sel + 1;
    
                        
                       when others =>
                        AN <= "01111111"; 
                        CA <=   sig_seg(6);
                        CB <=   sig_seg(5);
                        CC <=   sig_seg(4);
                        CD <=   sig_seg(3);
                        CE <=   sig_seg(2);
                        CF <=   sig_seg(1);
                        CG <=   sig_seg(0);
                        digit_sel <= 1;

                end case;
            else
                count <= count + 1;
            end if;
        end if;
    end process mux_proc;

end architecture behavioral;
```



tb_timer - nevím - testbench pro vytvořený časovač

https://github.com/kikusko77/digitalelprojekt/blob/3943aa9c5cb736bb78a51a3be46713379b49007a/teoreticky%20final/project_4/project_4.srcs/sources_1/new/tb_timer.vhd

```vhdl
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
```



tb_timer_7seg - nevím - testbench pro 7mi segmentový displej

https://github.com/kikusko77/digitalelprojekt/blob/3943aa9c5cb736bb78a51a3be46713379b49007a/teoreticky%20final/project_4/project_4.srcs/sources_1/new/tb_timer_7seg.vhd

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_timer_7seg is
end entity tb_timer_7seg;

architecture behavioral of tb_timer_7seg is
    component timer_7seg is
        port (
            clk : in std_logic;
            rst : in std_logic;
            en : in std_logic;
            seg1 : out std_logic_vector(6 downto 0);
            seg2 : out std_logic_vector(6 downto 0);
            seg3 : out std_logic_vector(6 downto 0);
            sig_g_NUM_CYCLES: natural;
            sig_g_CNT1_INIT: natural;
            sig_g_CNT2_INIT: natural
        );
    end component timer_7seg;

    signal clk_sig: std_logic := '0';
    signal rst_sig: std_logic := '1';
    signal en_sig: std_logic := '0';
    signal seg1_sig: std_logic_vector(6 downto 0);
    signal seg2_sig: std_logic_vector(6 downto 0);
    signal seg3_sig: std_logic_vector(6 downto 0);
    signal sig_cnt1: std_logic_vector(9  downto 0);
    signal sig_cnt2: std_logic_vector(9  downto 0);
    


    constant CLK_PERIOD: time := 10 ns;

begin
    inst_timer_7seg: timer_7seg
        port map (
            clk => clk_sig,
            rst => rst_sig,
            en => en_sig,
            seg1 => seg1_sig,
            seg2 => seg2_sig,
            seg3 => seg3_sig,
            sig_g_NUM_CYCLES => 3, 
            sig_g_CNT1_INIT => 20,
            sig_g_CNT2_INIT => 10
        );

        
    p_clk_gen: process is
    begin
        while true loop
            clk_sig <= not clk_sig;
            wait for CLK_PERIOD / 2;
        end loop;
    end process p_clk_gen;

    p_stimulus: process is
    begin
        wait for CLK_PERIOD * 5;
        rst_sig <= '0';
        wait for CLK_PERIOD * 5;
        en_sig <= '1';
        wait for CLK_PERIOD * 100;
        en_sig <= '0';
        wait for CLK_PERIOD * 5;
        rst_sig <= '1';
        wait for CLK_PERIOD * 5;
        rst_sig <= '0';
        wait for CLK_PERIOD * 5;
        en_sig <= '1';
        wait for CLK_PERIOD * 100;
        en_sig <= '0';
        wait;
    end process p_stimulus;

end architecture behavioral;
```



Constraint file - přiřazení switchů, tlačítek a displejů 

https://github.com/kikusko77/digitalelprojekt/blob/3943aa9c5cb736bb78a51a3be46713379b49007a/teoreticky%20final/project_4/project_4.srcs/constrs_1/imports/new/nexys-a7-50t.xdc

```vhdl 
## Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { CLK100MHZ }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
#create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {CLK100MHZ}];


##Switches
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { SW[0] }]; #IO_L24N_T3_RS0_15 Sch=sw[0]
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { SW[1] }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=sw[1]
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { SW[2] }]; #IO_L6N_T0_D08_VREF_14 Sch=sw[2]
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { SW[3] }]; #IO_L13N_T2_MRCC_14 Sch=sw[3]
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { SW[4] }]; #IO_L12N_T1_MRCC_14 Sch=sw[4]
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { SW[5] }]; #IO_L7N_T1_D10_14 Sch=sw[5]
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { SW[6] }]; #IO_L17N_T2_A13_D29_14 Sch=sw[6]
#set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { SW[7] }]; #IO_L5N_T0_D07_14 Sch=sw[7]
#set_property -dict { PACKAGE_PIN T8    IOSTANDARD LVCMOS18 } [get_ports { SW[8] }]; #IO_L24N_T3_34 Sch=sw[8]
#set_property -dict { PACKAGE_PIN U8    IOSTANDARD LVCMOS18 } [get_ports { SW[9] }]; #IO_25_34 Sch=sw[9]
#set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { SW[10] }]; #IO_L15P_T2_DQS_RDWR_B_14 Sch=sw[10]
#set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { SW[11] }]; #IO_L23P_T3_A03_D19_14 Sch=sw[11]
#set_property -dict { PACKAGE_PIN H6    IOSTANDARD LVCMOS33 } [get_ports { SW[12] }]; #IO_L24P_T3_35 Sch=sw[12]
#set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { SW[13] }]; #IO_L20P_T3_A08_D24_14 Sch=sw[13]
#set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { SW[14] }]; #IO_L19N_T3_A09_D25_VREF_14 Sch=sw[14]
set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { SW[15] }]; #IO_L21P_T3_DQS_14 Sch=sw[15]
## LEDs
#set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { LED[0] }]; #IO_L18P_T2_A24_15 Sch=led[0]
#set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { LED[1] }]; #IO_L24P_T3_RS1_15 Sch=led[1]
#set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { LED[2] }]; #IO_L17N_T2_A25_15 Sch=led[2]
#set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { LED[3] }]; #IO_L8P_T1_D11_14 Sch=led[3]
#set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { LED[4] }]; #IO_L7P_T1_D09_14 Sch=led[4]
#set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { LED[5] }]; #IO_L18N_T2_A11_D27_14 Sch=led[5]
#set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { LED[6] }]; #IO_L17P_T2_A14_D30_14 Sch=led[6]
#set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { LED[7] }]; #IO_L18P_T2_A12_D28_14 Sch=led[7]
#set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { LED[8] }]; #IO_L16N_T2_A15_D31_14 Sch=led[8]
#set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33 } [get_ports { LED[9] }]; #IO_L14N_T2_SRCC_14 Sch=led[9]
#set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { LED[10] }]; #IO_L22P_T3_A05_D21_14 Sch=led[10]
#set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS33 } [get_ports { LED[11] }]; #IO_L15N_T2_DQS_DOUT_CSO_B_14 Sch=led[11]
#set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { LED[12] }]; #IO_L16P_T2_CSI_B_14 Sch=led[12]
#set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { LED[13] }]; #IO_L22N_T3_A04_D20_14 Sch=led[13]
#set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { LED[14] }]; #IO_L20N_T3_A07_D23_14 Sch=led[14]
#set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports { LED[15] }]; #IO_L21N_T3_DQS_A06_D22_14 Sch=led[15]

## RGB LEDs
#set_property -dict { PACKAGE_PIN R12   IOSTANDARD LVCMOS33 } [get_ports { LED16_B }]; #IO_L5P_T0_D06_14 Sch=led16_b
#set_property -dict { PACKAGE_PIN M16   IOSTANDARD LVCMOS33 } [get_ports { LED16_G }]; #IO_L10P_T1_D14_14 Sch=led16_g
#set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports { LED16_R }]; #IO_L11P_T1_SRCC_14 Sch=led16_r
#set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { LED17_B }]; #IO_L15N_T2_DQS_ADV_B_15 Sch=led17_b
#set_property -dict { PACKAGE_PIN R11   IOSTANDARD LVCMOS33 } [get_ports { LED17_G }]; #IO_0_14 Sch=led17_g
#set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { LED17_R }]; #IO_L11N_T1_SRCC_14 Sch=led17_r

##7 segment display
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { CA }]; #IO_L24N_T3_A00_D16_14 Sch=ca
set_property -dict { PACKAGE_PIN R10   IOSTANDARD LVCMOS33 } [get_ports { CB }]; #IO_25_14 Sch=cb
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { CC }]; #IO_25_15 Sch=cc
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { CD }]; #IO_L17P_T2_A26_15 Sch=cd
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { CE }]; #IO_L13P_T2_MRCC_14 Sch=ce
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { CF }]; #IO_L19P_T3_A10_D26_14 Sch=cf
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports { CG }]; #IO_L4P_T0_D04_14 Sch=cg
#set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { DP }]; #IO_L19N_T3_A21_VREF_15 Sch=dp
set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports { AN[0] }]; #IO_L23P_T3_FOE_B_15 Sch=an[0]
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { AN[1] }]; #IO_L23N_T3_FWE_B_15 Sch=an[1]
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { AN[2] }]; #IO_L24P_T3_A01_D17_14 Sch=an[2]
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { AN[3] }]; #IO_L19P_T3_A22_15 Sch=an[3]
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { AN[4] }]; #IO_L8N_T1_D12_14 Sch=an[4]
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { AN[5] }]; #IO_L14P_T2_SRCC_14 Sch=an[5]
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports { AN[6] }]; #IO_L23P_T3_35 Sch=an[6]
set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { AN[7] }]; #IO_L23N_T3_A02_D18_14 Sch=an[7]
```
 


### Component(s) simulation

Na snímcích obrazovky níže můžeme pozorovat, jak funguje náš časovač. Při aktivaci tlačítka enable začne postupný odpočet kola. Jakmile kolo skončí, začne se odčítávat pauza. Po skončení pauzy se přičte počet kol a celý proces se opakuje.

* simulace entity `timer` (ověření správného odečítání kola, pauzy a následného opakování)

![Capture](https://github.com/kikusko77/digitalelprojekt/blob/main/simulation%20images/timer_1.PNG)

![Capture](https://github.com/kikusko77/digitalelprojekt/blob/main/simulation%20images/timer_2.PNG)



* simulace entity `timer_7seg` (ověření správného zobrazování, resp. posílání správné číslice na sedmi segmentové displeje)

![Capture](https://github.com/kikusko77/digitalelprojekt/blob/main/simulation%20images/nuber_decoding_to_7seg.PNG)

![Capture](https://github.com/kikusko77/digitalelprojekt/blob/main/simulation%20images/nuber_decoding_to_7seg_2.PNG)

![Capture](https://user-images.githubusercontent.com/95495159/235148465-c7c22338-cda8-4edf-b740-eeb164a91847.png)


### Obvod projektu

<img width="514" alt="Snímek obrazovky 2023-05-02 192727" src="https://user-images.githubusercontent.com/95495159/235740612-9bda64a2-402b-48ab-81d0-30cc92efd261.png">

<img width="857" alt="Snímek obrazovky 2023-05-02 192749" src="https://user-images.githubusercontent.com/95495159/235740636-1d943ed9-49d2-49bf-81eb-6a2af3c13f93.png">

<img width="159" alt="Snímek obrazovky 2023-05-02 192811" src="https://user-images.githubusercontent.com/95495159/235740645-ab834112-de43-4e33-817e-258aea02b5c2.png">



## Instructions

Časovač se zobrazuje v plné šíři osmi 7mi-segmentových číslic, v prvních 3 číslicích vpravo lze pozorovat délku kola, uprostřed se zobrazuje odpočítávání pauzy a úplně vlevo se zobrazuje pořadí kola. Časovač má předem nastavené 3 kola s délkou 30 sekund a pevně nastavenou pauzu 20 sekund. Počet kol, délku kola a délku pauzy lze nastavit pomocí přepínačů zprava doleva.
První 2 přepínače slouží k nastavení počtu kol, následující 3 přepínače slouží k nastavení délky kola a další 2 přepínače slouží k nastavení délky pauzy. Přepnutím přepínače do vrchní polohy přidáváme čas či počet kol. V každé sekci (počet kol, délka kola, délka pauzy) se vpravo nachází nejmenší možný přídavek kola / času a vlevo se nachází nejvyšší možný přídavek kol / času. Pro zvýšení požadovaného parametru musíme přepínač přepnout do vrchní polohy, naopak pro snížení musí přepínač zůstat ve spodní poloze.
Jakmile jsme nastavili požadované údaje, odpočet lze spustit 15. přepínačem. Pokud jsme nechtěně nastavili špatný čas kola či počet kol, odpočet lze resetovat prostředním tlačítkem BTNC. Časovač se může hodit pro cvičení v sériích, nebo může posloužit jako "minutka" při vaření v kuchyni.


[I'm an inline-style link with title](https://vutbr-my.sharepoint.com/:v:/g/personal/240856_vutbr_cz/EYHoxPQC865AsCj_t32AXCMBwtA-zDfYdiQmJR3evQSV4w?e=rZJxAk)

## References

1. https://digilent.com/shop/nexys-a7-fpga-trainer-board-recommended-for-ece-curriculum/

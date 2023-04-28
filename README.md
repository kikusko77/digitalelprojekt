# VHDL project

## Časovač na intervalový (kruhový) trénink s možností nastavit počet kol, dobu kola a pauzy mezi nimi za běhu aplikace.

### Team members

* Filip Frey (zodpovědný za správné fungování odpočtu časovače)
* Christian Kuric (zodpovědný za zobrazení odpočtu na displeji)
* Jakub Raimr (zodpovědný za dokumantaci k projektu)

+ všichni se podíleli na tvoření kódu, implementace na desku a na dalších úkolech během hodin cvičení na počítači

## Theoretical description and explanation

Mezi důležité oblasti tohoto projektu patří: 

- funkce pro odečet času kola a pauzy
- funkce pro přičítání počtu kol
- správné zobrazení všech údajů na displeji
- správná funkce resetu a enablu pomocí tlačítek
- nastavování údajů pomocí switchů

### Funkce pro odečet času kola a pauzy
Po zmáčknutí tlačítka enable začne odečet kola. Po odečtení kola začne odečet pauzy.

### Funkce pro přičítání počtu kol
Jakmile skončí odečtení pauzy, přičte se počet kol a odčítání kola opět začíná.

### Správné zobrazení všech údajů na displeji
Pro správné zobrazení všech hodnot (počet kol, čas kola a čas pauzy) jsme vytvořili samostatné design sourcy a v každém sourcu bylo definováno zobrazení na sedmibitovém displeji, počet cifer na displeji a počet čísel, který každá cifra bude ukazovat. Takže například v kódu pro zobrazení pauzy jsme definovali, že se bude zobrazovat na dvou 7mi segmentových displejích a každý displej bude ukazovat hodnoty 0 až 9.

### Správná funkce resetu a enablu pomocí tlačítek
Pro tyto funkce jsme si zvolili tlačítka nad 7mi segmentovými displeji. Prostřední tlačítko BTNC slouží k resetu časovače a levé tlačítko BTNL slouží ke spuštění odpočtu. Jakmile jsme si jistí, že jsme nastavili požadované hodnoty na displeji, tak zmáčkeme tlačítko BTNL a na displeji se zahájí odpočet. Naopak při zmáčknutí tlačítka BTNC se odpočet zastaví a přepne se na hodnoty, které jsme nastavili na začátku odpočtu. 

### Nastavování údajů pomocí switchů
Pro nastavování údajů jsme si pro každý údaj, kromě času pauzy, určili 4-bitové číslo, které budeme nastavovat pomocí switchů. První 4 switche zprava slouží k nastavení délky kola. První switch zprava má hodnotu nejméně významného bitu a čtvrtý switch zprava má hodnotu nejvíce významného bitu. Podobným způsobem funguje nastavení počtu kol následujícími switchi v pořadí.

## Hardware description of demo application

Insert descriptive text and schematic(s) of your implementation.

## Software description

Put flowchats/state diagrams of your algorithm(s) and direct links to source/testbench files in `src` and `sim` folders.

#7seg_k - source, který slouží k zobrazení kol na displeji
```vhdl
prozatím prázdný, protože je v hex_7seg
```



7seg_p - source, který zobrazuje čas pauzy na displeji
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
```



clock_enable - design s funkcí odpočtu časovače
```vhdl

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all; -- Package for arithmetic operations

----------------------------------------------------------
-- Entity declaration for clock enable
----------------------------------------------------------

entity clock_enable is
  generic (
    g_MAX : natural := 50000 --! Number of clk pulses to generate one enable signal period
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



hex_7seg - design se zobrazením času kola
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
                when others => null;
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



timer - design, který obsahuje funkce odpočtu časovače, enable a reset
```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
  generic (
    g_CNT_WIDTH : natural := 9; --! Default number of counter bits
    g_NUM_CYCLES: natural := 3; --! Default number of cycles
    g_CNT1_INIT: natural := 20; --! Default initial value for first counter
    g_CNT2_INIT: natural := 10 --! Default initial value for second counter
  );
  port (
    clk    : in    std_logic;                                 --! Main clock
    rst    : in    std_logic;                                 --! Synchronous reset
    en     : in    std_logic;                                 --! Enable input
    cnt1   : out   std_logic_vector(g_CNT_WIDTH  downto 0);   --! First counter value
    cnt2   : out   std_logic_vector(g_CNT_WIDTH  downto 0);    --! Second counter value
    cycle_count: out   std_logic_vector(1  downto 0)
  );
end entity timer;

architecture behavioral of timer is

  signal sig_cnt1 : unsigned(g_CNT_WIDTH downto 0) := to_unsigned(g_CNT1_INIT, 10); --! Local first counter with initial value of g_CNT1_INIT
  signal sig_cnt2 : unsigned(g_CNT_WIDTH downto 0) := to_unsigned(g_CNT2_INIT, 10); --! Local second counter with initial value of g_CNT2_INIT
  signal sig_cycle_count: unsigned(1 downto 0) := to_unsigned(3, 2);                         --! Cycle count
  signal sig_en : std_logic;  


begin

 clk_en0 : entity work.clock_enable
    generic map (
      -- FOR SIMULATION, KEEP THIS VALUE TO 1
      -- FOR IMPLEMENTATION, CALCULATE VALUE: 250 ms / (1/100 MHz)
      -- 1   @ 10 ns
      -- ??? @ 250 ms
      g_MAX => 500000000
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
      elsif (en = '1' and sig_cycle_count < g_NUM_CYCLES and sig_en = '1') then     -- Test if counter is enabled and cycle count is less than g_NUM_CYCLES
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


timer_7seg - design, který spojuje všechny desginy popsané výše kromě clock_enable
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
        seg2_p : out std_logic_vector(6 downto 0)
    );
end entity timer_7seg;

architecture behavioral of timer_7seg is
    component timer is
        generic (
            g_CNT_WIDTH : natural := 9;
            g_NUM_CYCLES: natural := 3;
            g_CNT1_INIT: natural := 20;
            g_CNT2_INIT: natural := 10
        );
        port (
            clk : in std_logic;
            rst : in std_logic;
            en : in std_logic;
            cnt1 : out std_logic_vector(g_CNT_WIDTH  downto 0);
            cnt2 : out std_logic_vector(g_CNT_WIDTH  downto 0);
            cycle_count: out std_logic_vector(1 downto 0)
            
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
                hex : in std_logic_vector(1 downto 0);
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
    signal cycle1_count: std_logic_vector(1 downto 0);
    signal hex_sig_k: std_logic_vector(1 downto 0);
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
            cycle_count => cycle1_count
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



top - propojení všech funkcí (včetně reset a enable) k následnému použití na desce
```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port (
        CLK100MHZ: in std_logic;
        SW: in std_logic_vector (1 downto 0);
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
            seg: out std_logic_vector(6 downto 0)            
            
        );
    end component timer_7seg;

    -- Signals
    signal count: integer range 0 to 1000000 := 0;
    signal digit_sel: integer range 1 to 3 := 1;

begin

    -- Instantiate timer_7seg entity
    timer_7seg_inst: entity work.timer_7seg
    port map (
        clk => CLK100MHZ,
        rst => BTNC,
        en => SW(0),
        seg1 => sig_seg1,
        seg2 => sig_seg2,
        seg3 => sig_seg3,
        seg1_p => sig_seg1_p,
        seg2_p => sig_seg2_p,
        seg  => sig_seg
    );

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



                     when 5 =>
                        AN <= "11101111"; -- Select third seven-segment display
                        CA <=   sig_seg1_p(6);
                        CB <=   sig_seg1_p(5);
                        CC <=   sig_seg1_p(4);
                        CD <=   sig_seg1_p(3);
                        CE <=   sig_seg1_p(2);
                        CF <=   sig_seg1_p(1);
                        CG <=   sig_seg1_p(0);
                        digit_sel <= digit_sel + 1;
                        

                         when 6 =>
                        AN <= "11011111"; -- Select third seven-segment display
                        CA <=   sig_seg2_p(6);
                        CB <=   sig_seg2_p(5);
                        CC <=   sig_seg2_p(4);
                        CD <=   sig_seg2_p(3);
                        CE <=   sig_seg2_p(2);
                        CF <=   sig_seg2_p(1);
                        CG <=   sig_seg2_p(0);
                        digit_sel <= digit_sel + 1;
    
                        
                       when others =>
                        AN <= "01111111"; -- Select third seven-segment display
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


tb_timer - testbench pro vytvořený časovač
```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_timer is
  -- Entity of testbench is always empty
end entity tb_timer;

architecture testbench of tb_timer is

  -- Number of bits for testbench counter
  constant c_CNT_WIDTH         : natural := 9; --! Number of counter bits
  constant c_NUM_CYCLES        : natural := 3; --! Number of cycles
  constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

  -- Local signals
  signal sig_clk_100mhz : std_logic;
  signal sig_rst        : std_logic;
  signal sig_en         : std_logic;
  signal sig_cnt1       : std_logic_vector(c_CNT_WIDTH - 1 downto 0);
  signal sig_cnt2       : std_logic_vector(c_CNT_WIDTH - 1 downto 0);

begin

  uut_cnt : entity work.timer
    generic map (
      g_CNT_WIDTH => c_CNT_WIDTH,
      g_NUM_CYCLES => c_NUM_CYCLES
    )
    port map (
      clk    => sig_clk_100mhz,
      rst    => sig_rst,
      en     => sig_en,
      cnt1    => sig_cnt1,
      cnt2   => sig_cnt2
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



tb_timer_7seg - testbench pro 7mi segmentový displej
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
            seg3 : out std_logic_vector(6 downto 0)
        );
    end component timer_7seg;

    signal clk_sig: std_logic := '0';
    signal rst_sig: std_logic := '1';
    signal en_sig: std_logic := '0';
    signal seg1_sig: std_logic_vector(6 downto 0);
    signal seg2_sig: std_logic_vector(6 downto 0);
    signal seg3_sig: std_logic_vector(6 downto 0);

    constant CLK_PERIOD: time := 10 ns;

begin
    inst_timer_7seg: timer_7seg
        port map (
            clk => clk_sig,
            rst => rst_sig,
            en => en_sig,
            seg1 => seg1_sig,
            seg2 => seg2_sig,
            seg3 => seg3_sig
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
```vhdl
## This file is a general .xdc for the Nexys A7-50T
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { CLK100MHZ }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
#create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {CLK100MHZ}];


##Switches
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { SW[0] }]; #IO_L24N_T3_RS0_15 Sch=sw[0]
#set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { SW[1] }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=sw[1]
#set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { SW[2] }]; #IO_L6N_T0_D08_VREF_14 Sch=sw[2]
#set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { SW[3] }]; #IO_L13N_T2_MRCC_14 Sch=sw[3]
#set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { SW[4] }]; #IO_L12N_T1_MRCC_14 Sch=sw[4]
#set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { SW[5] }]; #IO_L7N_T1_D10_14 Sch=sw[5]
#set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { SW[6] }]; #IO_L17N_T2_A13_D29_14 Sch=sw[6]
#set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { SW[7] }]; #IO_L5N_T0_D07_14 Sch=sw[7]
#set_property -dict { PACKAGE_PIN T8    IOSTANDARD LVCMOS18 } [get_ports { SW[8] }]; #IO_L24N_T3_34 Sch=sw[8]
#set_property -dict { PACKAGE_PIN U8    IOSTANDARD LVCMOS18 } [get_ports { SW[9] }]; #IO_25_34 Sch=sw[9]
#set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { SW[10] }]; #IO_L15P_T2_DQS_RDWR_B_14 Sch=sw[10]
#set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { SW[11] }]; #IO_L23P_T3_A03_D19_14 Sch=sw[11]
#set_property -dict { PACKAGE_PIN H6    IOSTANDARD LVCMOS33 } [get_ports { SW[12] }]; #IO_L24P_T3_35 Sch=sw[12]
#set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { SW[13] }]; #IO_L20P_T3_A08_D24_14 Sch=sw[13]
#set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { SW[14] }]; #IO_L19N_T3_A09_D25_VREF_14 Sch=sw[14]
#set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { SW[15] }]; #IO_L21P_T3_DQS_14 Sch=sw[15]
```
 

### Component(s) simulation

Na snímku obrazovky níže můžeme pozorovat, jak funguje funkce našeho časovače. Při aktivaci tlačítka enable začne postupný odpočet kola. Jakmile kolo skončí, začne se odčítávat pauza. Po skončení pauzy se přičte počet kol a celý proces se opakuje.

![Capture](https://user-images.githubusercontent.com/95495159/235148465-c7c22338-cda8-4edf-b740-eeb164a91847.png)

## Instructions

Časovač se zobrazuje v plné šíři osmi 7mi-segmentových číslic, v prvních 2 číslicích vlevo lze pozorovat počet kol, uprostřed se zobrazuje odpočítávání pauzy a úplně vpravo se zobrazuje odpočet kola. Časovač má předem nastavené 3 kola s délkou 20 sekund a pevně nastavenou pauzu 10 sekund. Počet kol a délku kola lze nastavit pomocí switchů zprava doleva. První 4 switche slouží k nastavení délky kola a následující 4 switche slouží k nastavení počtu kol. Přepnutím switche do vrchní polohy přidáváme čas či počet kol. V každé sekci (pro počet kol a čas kola) vpravo se nachází nejmenší možný přídavek kola / času a vlevo se nachází nejvyšší možný přídavek kol / času. Pro zvýšení požadovaného parametru musíme switch přepnout do vrchní polohy, naopak pro snížení musí switch zůstat ve spodní poloze. Jakmile jsme nastavili požadovaný počet kol a čas kola, odpočet lze spustit tlačítkem BTNL (tlačítko vlevo od středu). Pokud jsme nechtěně nastavili špatný čas kola či počet kol, odpočet lze resetovat prostředním tlačítkem BTNC. Časovač se může hodit pro cvičení v sériích, nebo může posloužit jako "minutka" při vaření v kuchyni.

## References

1. Put here the literature references you used.
2. ...

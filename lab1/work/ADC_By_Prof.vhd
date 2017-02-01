library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ADC_interface2 is
  port(
    START :in std_logic;
    CLK,reset   :in std_logic; --reset
    SCLK  :out std_logic;
    SDATA :in std_logic;
    par_out:out std_logic_vector(11 downto 0);
    cs    :out std_logic
      
  );
end entity ADC_interface2;

architecture behav2 of ADC_interface2 is
  
  signal counter_clr : std_logic;
  signal q_out: std_logic_vector( 4 downto 0 );
  signal Paraller_load,sdata_active : std_logic;
  signal SHIFT_REG , SHIFT_NEXT , PARBUF_REG:std_logic_vector (11 downto 0);
  signal r_reg, r_next : unsigned(4 downto 0);  
  
  type state_type is( state_start, state_read, state_store );
  signal state_reg, next_state  :state_type;
  
  
  begin


 SCLK <= not CLK;
------------------------- counter and clock process --------------------------
process (CLK,counter_clr )
    BEGIN 
      if (reset = '1') then 
        r_reg <= (others=>'0');
      elsif (clk' event and clk='1') then
        if (counter_clr = '1') then
          r_reg <= (others=>'0');
        else 
          r_reg<=r_next ; 
        end if ;
      end if; 
    end process ; 
    r_next <= r_reg + 1 ; 
    q_out <= std_logic_vector (r_reg);
    
-------------------------serial to paraller----------------------------------
  
------------------------ shift register ------------------------------------- 
      process (CLK,reset)
      begin
        if reset ='1' then 
           SHIFT_REG <= ( others => '0') ;--after 10 ns;
        elsif(CLK' event and CLK = '1')then
        if (sdata_active='1' ) then
           SHIFT_REG <= SHIFT_NEXT ;--after 10 ns;
          end if;
        end if;
      end process ;
     SHIFT_NEXT <= SDATA & SHIFT_REG (11 downto 1);
------------------------------------ parallel buffer register ---------------------------------
     process (CLK)
       begin
        if reset ='1' then
          PARBUF_REG <= ( others => '0') ;--after 10 ns;
        elsif (CLK ' event and CLK = '1' ) then
        if Paraller_load = '1' then
           --PARBUF_REG <= SHIFT_REG ;--after 10 ns;
           
           PARBUF_REG(0)<= SHIFT_REG(11) ; 
           PARBUF_REG(1)<= SHIFT_REG(10) ; 
           PARBUF_REG(2)<= SHIFT_REG(9) ; 
           PARBUF_REG(3)<= SHIFT_REG(8) ; 
           PARBUF_REG(4)<= SHIFT_REG(7) ; 
           PARBUF_REG(5)<= SHIFT_REG(6) ; 
           PARBUF_REG(6)<= SHIFT_REG(5) ; 
           PARBUF_REG(7)<= SHIFT_REG(4) ; 
           PARBUF_REG(8)<= SHIFT_REG(3) ; 
           PARBUF_REG(9)<= SHIFT_REG(2) ; 
           PARBUF_REG(10)<= SHIFT_REG(1) ; 
           PARBUF_REG(11)<= SHIFT_REG(0) ; 
       end if;
       end if;
     end process ;
     par_out <= PARBUF_REG ; 
  
----------------------------------------symbolic states type-------------------------------------
---------------------- state register------------------------------------------------------------
s_reg:process (CLK,reset)
    begin
      if(reset='1')then
        state_reg<=state_start;
      elsif( CLK' event and CLK='1') then
        state_reg <= next_state;
      end if;
end process s_reg;

-------------------------combination logic (output and next state)--------------------------------
--------------------------sensitivity list now include input start_switch-------------------------

combin: process (clk,state_reg,start)
begin

--default values: remain instate;
 next_state <= state_reg;

case state_reg is
-----------------------------------------state_start-------------------------------------- 
when state_start =>
  cs <= '1';
  paraller_load<='0';
  counter_clr <= '1';
  sdata_active <= '0';
  if(START='1')then
     next_state<=state_read;
  else
     next_state<=state_start;
  end if;
------------------------------------------state_read------------------------------------------
when state_read =>
  
  cs<='0';
  paraller_load<='0';
  counter_clr <= '0';
  sdata_active<='1';
  if (r_reg>14)then
   next_state<=state_store;
  end if;
------------------------------------------state_store-----------------------------------------
when state_store =>
  
  cs<='1';
  paraller_load<='1';
  counter_clr <= '0';
  sdata_active<='0';
  if (r_reg>16) then
   next_state<=state_start;
  end if;
--------------------------------------------------------------------------------------------------
end case;
end process combin;
end architecture behav2;    
  



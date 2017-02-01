library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

 
entity CLK_DIV is
  	port ( CLK, N_RES: in  bit;    -- 100 MHz; asynch, active low reset
          SCLK      : out bit);		-- 3.125 MHz clk out		 
end CLK_DIV;


architecture BEHAVIOUR of CLK_DIV is

signal CLK_CNT : std_logic_vector(4 downto 0);

begin

-- clock divider
CLK_DIV : process(N_RES,CLK)
  begin
     if N_RES ='0'  then
	       CLK_CNT <= (others =>'0');
     elsif CLK  = '1' and CLK'event then
           CLK_CNT <= CLK_CNT + '1'  ;
     end if;
end process CLK_DIV;

SCLK <= to_bit(CLK_CNT(4)) ; 


end BEHAVIOUR ;	
	
	


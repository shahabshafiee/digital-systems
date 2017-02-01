library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

 
entity SR_GEN is
  	port ( CLK, N_RES : in bit; -- 100MHz; asynch, active low reset
          START_TE   : out bit);	
end SR_GEN;


architecture BEHAVIOUR of SR_GEN is

signal SCNT : std_logic_vector(11 downto 0);

begin

SR_GEN:process(N_RES,CLK)
  begin
     if N_RES ='0'  then
	       SCNT <= (others=>'0');
     elsif CLK  = '1' and CLK'event then
         if SCNT = "100000100010" then -- 100MHz/48kHz=2083.33
                                       -- range 0...2082
             SCNT <= "000000000000";
         else
	          SCNT <= SCNT + '1'  ;
	      end if;
		end if;
  end process SR_GEN;
  START_TE <= '1' after 5 ns when SCNT < "000000100000" else '0' after 5 ns;
end BEHAVIOUR ;	
	
	


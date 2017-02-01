library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity AUDIO_VOL is
  	port ( CLK, N_RES : in bit; 
               START  : in bit;		 
	       SW_PLUS  :  in bit;
               SW_MINUS  :  in bit;
               AUDIO_IN   :  in signed(11 downto 0);
               VOL_LEVEL  :  out unsigned(3 downto 0);
               AUDIO_OUT  : out signed(11 downto 0));		 
end AUDIO_VOL ;


architecture BEHAVIOUR of AUDIO_VOL is

type    State_AV is (S_SET,S_WAIT);
signal  STATE        : State_AV;
signal  NEXTSTATE    : State_AV;
signal VOL_LEVEL0: unsigned(3 downto 0);
signal VOL_LEVEL0_NEXT: unsigned(3 downto 0);
signal temp:signed(24 downto 0);

begin

FSM_seq : process(CLK , N_RES)
   begin
     if N_RES ='0'  then
        STATE <= S_SET after 5 ns ;
		 VOL_LEVEL0 <= "1010" after 5 ns;
     elsif CLK  = '1' and CLK 'event then
        STATE <= NEXTSTATE after 5 ns ;
		VOL_LEVEL0 <= VOL_LEVEL0_NEXT after 5 ns;
     end if ;
end process ;

FSM_com: process(CLK , N_RES)
  
  
  begin
  
  NEXTSTATE <= STATE after 5 ns ; 
  VOL_LEVEL <= VOL_LEVEL0 after 5 ns;
  AUDIO_OUT <= (others => '0') after 5 ns;
  VOL_LEVEL0_NEXT <= VOL_LEVEL0 after 5 ns;
  case STATE is
     when S_SET =>     temp <= to_signed(( to_integer(AUDIO_IN)*to_integer(VOL_LEVEL0)*409),25) after 5 ns;
                       AUDIO_OUT <= temp(23 downto 12); 
                       VOL_LEVEL <= VOL_LEVEL0 after 5 ns;
                     
                       
                       if START='1' then
                         if SW_PLUS='1' then
                           if VOL_LEVEL0<"1010" then
                             VOL_LEVEL0_NEXT <= VOL_LEVEL0+1 after 5 ns;
                             NEXTSTATE <= S_WAIT after 5 ns ;
                            
                           else
                             NEXTSTATE <= S_WAIT after 5 ns ;
                            end if;
                            
                           elsif SW_MINUS='1' then 
                             if VOL_LEVEL0>"0001" then
                               VOL_LEVEL0_NEXT <= VOL_LEVEL0-1 after 5 ns;
                               NEXTSTATE <= S_WAIT after 5 ns ;
                             else
                               NEXTSTATE <= S_WAIT after 5 ns ;
                           
                            end if;
                          end if;
                       
                       end if;       
                     


                     
     when S_WAIT =>   temp <= to_signed(( to_integer(AUDIO_IN)*to_integer(VOL_LEVEL0)*409),25) after 5 ns;
                      AUDIO_OUT <= temp(23 downto 12);
                      VOL_LEVEL <= VOL_LEVEL0 after 5 ns;
     
     
                        
                        if SW_PLUS='0' and SW_MINUS='0' then
                           NEXTSTATE <= S_SET after 5 ns ;
                        end if;

     end case;
end process ;



end BEHAVIOUR;

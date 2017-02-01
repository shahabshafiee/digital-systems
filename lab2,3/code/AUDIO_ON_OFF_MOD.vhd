-----------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 

entity AUDIO_ON_OFF_MOD is
  	port ( CLK, N_RES : in bit;
               SW_AUDIO_ON   :  in bit;   
               LED_IN   : in bit_vector(9 downto 0);		 
	       AUDIO_IN   :  in signed(11 downto 0);
               LED_out   : out bit_vector(9 downto 0);
               REQUEST  : out bit;
               AUDIO_OUT  : out signed(11 downto 0));		 
end AUDIO_ON_OFF_MOD ;

architecture BEHAVIOUR of AUDIO_ON_OFF_MOD is

type    State_AM is (S_AUDIO_OFF,S_AUDIO_ON);
signal  STATE        : State_AM;
signal  NEXTSTATE    : State_AM;


begin

FSM_seq : process(CLK , N_RES)
   begin
     if N_RES ='0'  then
        STATE <= S_AUDIO_OFF after 5 ns ;
     elsif CLK  = '1' and CLK 'event then
        STATE <= NEXTSTATE after 5 ns ;
     end if ;
end process ;

FSM_com: process(CLK , N_RES)
  begin
  
  NEXTSTATE <= STATE after 5 ns ;
  LED_out <= (others => '0') after 5 ns ;
  REQUEST <= '0' after 5 ns ;  
  AUDIO_OUT <= (others => '0') after 5 ns ;

  case STATE is
     when S_AUDIO_OFF => if SW_AUDIO_ON='1' then
                           NEXTSTATE <= S_AUDIO_ON after 5 ns ;
                         end if;
     when S_AUDIO_ON => REQUEST <= '1' after 5 ns ;
                        AUDIO_OUT <= AUDIO_IN after 5 ns ;
                        LED_out <= LED_IN after 5 ns ;
                        if SW_AUDIO_ON='0' then
                           NEXTSTATE <= S_AUDIO_OFF after 5 ns ;
                        end if;

     end case;
end process ;



end BEHAVIOUR;
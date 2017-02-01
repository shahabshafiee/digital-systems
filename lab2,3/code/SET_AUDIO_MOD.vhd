-----------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 

entity SET_AUDIO_MOD is
  	port ( CLK, N_RES : in bit;
               SW_MODE_VOL_nQNT  :  in bit;   
               START  : in bit;		 
	       VOL_LEVEL  : in unsigned (3 downto 0);
               QNT_RES  :  in unsigned (3 downto 0);
               REQ_VOL : out bit;
               REQ_QNT : out bit;
               LED_out  : out bit_vector(9 downto 0));		 
end SET_AUDIO_MOD ;

architecture BEHAVIOUR of SET_AUDIO_MOD is

type    State_SM is (S_SET_VOL,S_SET_QNT);
signal  STATE        : State_SM;
signal  NEXTSTATE    : State_SM;


begin

FSM_seq : process(CLK , N_RES)
   begin
     if N_RES ='0'  then
        STATE <= S_SET_VOL after 5 ns ;
     elsif CLK  = '1' and CLK 'event then
        STATE <= NEXTSTATE after 5 ns ;
     end if ;
end process ;

FSM_com: process(CLK , N_RES)
  begin
  
  NEXTSTATE <= STATE after 5 ns ;
  LED_out <= (others => '0') after 5 ns ;
  REQ_VOL <= '0' after 5 ns ;  
  REQ_QNT <= '0' after 5 ns ;

  case STATE is
     when S_SET_VOL => LED_out <= "1111111111" srl to_integer(10 - VOL_LEVEL)  after 5 ns ;
                       REQ_VOL <= '1' after 5 ns ;
                       
                       if START='1' and SW_MODE_VOL_nQNT='0' then
                         NEXTSTATE <= S_SET_QNT after 5 ns ;
                        end if; 
     when S_SET_QNT => LED_out <= "1111111111" srl to_integer(10 - QNT_RES) after 5 ns ;
                       REQ_QNT <= '1' after 5 ns ;
                        
                        if START='0' or SW_MODE_VOL_nQNT='1' then
                           NEXTSTATE <= S_SET_VOL after 5 ns ;
                        end if;

     end case;
end process ;



end BEHAVIOUR;

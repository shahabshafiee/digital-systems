library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity AUDIO_QNT is
  	port ( CLK, N_RES : in bit; 
               START  : in bit;		 
	       SW_PLUS  :  in bit;
               SW_MINUS  :  in bit;
               AUDIO_IN   :  in signed(11 downto 0);
               QNT_RES  :  out unsigned(3 downto 0);
               AUDIO_OUT  : out signed(11 downto 0));		 
end AUDIO_QNT ;


architecture BEHAVIOUR of AUDIO_QNT is

type    State_AQ is (S_SET,S_WAIT);
signal  STATE        : State_AQ;
signal  NEXTSTATE    : State_AQ;
signal QNT_RES0: unsigned(3 downto 0);
signal QNT_RES0_NEXT: unsigned(3 downto 0);
signal temp : signed(11 downto 0);

 
begin

FSM_seq : process(CLK , N_RES)
   begin
     if N_RES ='0'  then
        STATE <= S_SET after 5 ns ;
		QNT_RES0 <= "1010" after 5 ns ;
     elsif CLK  = '1' and CLK 'event then
        STATE <= NEXTSTATE after 5 ns ;
		QNT_RES0 <= QNT_RES0_NEXT after 5 ns ;
     end if ;
end process ;

FSM_com: process(CLK , N_RES)
  
 
  
  begin
  
  NEXTSTATE <= STATE after 5 ns ;
  QNT_RES <= QNT_RES0 after 5 ns;
  temp <= (others => '0') after 5 ns;
  AUDIO_OUT <= temp after 5 ns;
  QNT_RES0_NEXT <= QNT_RES0 after 5 ns ;

  case STATE is
     when S_SET =>  temp <=  (AUDIO_IN srl (12-to_integer(QNT_RES0))) sll (12-to_integer(QNT_RES0)) after 5 ns ;
	                 AUDIO_OUT <= temp after 5 ns;
                    QNT_RES <= QNT_RES0 after 5 ns;
                       
                       if START='1' then
                         if SW_PLUS='1' then
                           if QNT_RES0<10 then
                             QNT_RES0_NEXT <= QNT_RES0+1 after 5 ns;
                             QNT_RES <= QNT_RES0 after 5 ns;
                             NEXTSTATE <= S_WAIT after 5 ns ;
                            
                           else
                             NEXTSTATE <= S_WAIT after 5 ns ;
                            end if;
                            
                           elsif SW_MINUS='1' then 
                             if QNT_RES0>1 then
                               QNT_RES0_NEXT <= QNT_RES0-1 after 5 ns;
                               QNT_RES <= QNT_RES0 after 5 ns;
                               NEXTSTATE <= S_WAIT after 5 ns ;
                             else
                               NEXTSTATE <= S_WAIT after 5 ns ;
                           
                            end if;
                          end if;
 
                            end if;       
                     


                     
     when S_WAIT => temp <=  (AUDIO_IN srl (12-to_integer(QNT_RES0))) sll (12-to_integer(QNT_RES0)) after 5 ns ;
	                 AUDIO_OUT <= temp after 5 ns;
                    QNT_RES <= QNT_RES0 after 5 ns;
                        
                        if SW_PLUS='0' and SW_MINUS='0' then
                           NEXTSTATE <= S_SET after 5 ns ;
                        end if;

     end case;
end process ;



end BEHAVIOUR;

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 

entity AUDIO_PROC_MOD is
  	port ( CLK, N_RES : in bit;
               SW_PLUS   :  in bit;
               SW_MINUS   :  in bit;   
               SW_AUDIO_ON   : in bit;		 
	       SW_MODE_VOL_nQNT  :  in bit;
	       AUDIO_IN   :  in bit_vector(15 downto 0);
               LED_out   : out bit_vector(9 downto 0);
               AUDIO_OUT  : out bit_vector(15 downto 0));		 
end AUDIO_PROC_MOD ;

architecture BEHAVIOUR of AUDIO_PROC_MOD is

 

component SET_AUDIO_MOD is
  	port ( CLK, N_RES : in bit;
               SW_MODE_VOL_nQNT  :  in bit;   
               START  : in bit;		 
	       VOL_LEVEL  :  in bit_vector(9 downto 0);
               QNT_RES  :  in bit_vector(9 downto 0);
               REQ_VOL : out bit;
               REQ_QNT : out bit;
               LED_out  : out bit_vector(9 downto 0));		 
end component SET_AUDIO_MOD ;


component AUDIO_ON_OFF_MOD is
  	port ( CLK, N_RES : in bit;
               SW_AUDIO_ON   :  in bit;   
               LED_IN   : in bit_vector(9 downto 0);		 
	       AUDIO_IN   :  in bit_vector(15 downto 0);
               LED_out   : out bit_vector(9 downto 0);
               REQUEST  : out bit;
               AUDIO_OUT  : out bit_vector(15 downto 0));		 
end component AUDIO_ON_OFF_MOD ;

signal CLK0 :  bit;
signal  N_RES0 :  bit;          
signal SW_PLUS0   :   bit;
signal SW_MINUS0   :   bit;   
signal SW_AUDIO_ON0   :  bit;		  
signal SW_MODE_VOL_nQNT0  :   bit;
signal AUDIO_IN0   :   bit_vector(15 downto 0);
signal LED_out0   :  bit_vector(9 downto 0);
signal AUDIO_OUT0 :  bit_vector(15 downto 0);	
signal req_st: bit;
signal LED: bit_vector(9 downto 0);





begin 

CLK0 <= CLK;
SW_PLUS0 <= SW_PLUS;
SW_MINUS0 <= SW_MINUS;
SW_AUDIO_ON0 <= SW_AUDIO_ON;
SW_MODE_VOL_nQNT0<= SW_MODE_VOL_nQNT;
AUDIO_IN0 <= AUDIO_IN; 
LED_out <= LED_out0;
AUDIO_OUT <= AUDIO_OUT0;


SET_AUDIO_MOD0 : SET_AUDIO_MOD
  	      port map ( CLK0, N_RES0, SW_MODE_VOL_nQNT0, req_st,"0011111111","0001111111", open, open);	
 
AUDIO_ON_OFF_MOD0 : AUDIO_ON_OFF_MOD
  	      port map ( CLK0, N_RES0, SW_AUDIO_ON0, LED,AUDIO_IN0,LED_out0, req_st, AUDIO_OUT0);	

end BEHAVIOUR;

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 

entity AUDIO_PROC_MOD is
  	port ( CLK, N_RES : in bit;
               SW_PLUS   :  in bit;
               SW_MINUS   :  in bit;   
               SW_AUDIO_ON   : in bit;		 
	       SW_MODE_VOL_nQNT  :  in bit;
	       AUDIO_IN   :  in signed(11 downto 0);
               LED_out   : out bit_vector(9 downto 0);
               AUDIO_OUT  : out signed(11 downto 0));		 
end AUDIO_PROC_MOD ;

architecture BEHAVIOUR of AUDIO_PROC_MOD is

 

component SET_AUDIO_MOD is
  	port ( CLK, N_RES : in bit;
               SW_MODE_VOL_nQNT  :  in bit;   
               START  : in bit;		 
	       VOL_LEVEL  : in unsigned(3 downto 0);
               QNT_RES  : in unsigned(3 downto 0);
               REQ_VOL : out bit;
               REQ_QNT : out bit;
               LED_out  : out bit_vector(9 downto 0));		 
end component SET_AUDIO_MOD ;


component AUDIO_ON_OFF_MOD is
  	port ( CLK, N_RES : in bit;
               SW_AUDIO_ON   :  in bit;   
               LED_IN   : in bit_vector(9 downto 0);		 
	       AUDIO_IN   :  in signed(11 downto 0);
               LED_out   : out bit_vector(9 downto 0);
               REQUEST  : out bit;
               AUDIO_OUT  : out signed(11 downto 0));		 
end component AUDIO_ON_OFF_MOD ;


component AUDIO_VOL is
  	port ( CLK, N_RES : in bit; 
               START  : in bit;		 
	       SW_PLUS  :  in bit;
               SW_MINUS  :  in bit;
               AUDIO_IN   :  in signed(11 downto 0);
               VOL_LEVEL  :  out unsigned(3 downto 0);
               AUDIO_OUT  : out signed(11 downto 0));		 
end component AUDIO_VOL ;


component AUDIO_QNT is
  	port ( CLK, N_RES : in bit; 
               START  : in bit;		 
	       SW_PLUS  :  in bit;
               SW_MINUS  :  in bit;
               AUDIO_IN   :  in signed(11 downto 0);
               QNT_RES  :  out unsigned(3 downto 0);
               AUDIO_OUT  : out signed(11 downto 0));		 
end component AUDIO_QNT ;
	
	
--internal signals	

signal req_st: bit;
signal LED: bit_vector(9 downto 0);
signal vol_st: bit;
signal qnt_st: bit;
signal  QNT_RES  : unsigned(3 downto 0);
signal VOL_LEVEL  : unsigned(3 downto 0);
signal AUDIO1 : signed(11 downto 0);
signal AUDIO2 : signed(11 downto 0);


begin 


SET_AUDIO_MOD0 : SET_AUDIO_MOD
  	      port map ( CLK, N_RES, SW_MODE_VOL_nQNT, req_st, VOL_LEVEL, QNT_RES, vol_st, qnt_st, LED);	
 
AUDIO_ON_OFF_MOD0 : AUDIO_ON_OFF_MOD
  	      port map ( CLK, N_RES, SW_AUDIO_ON, LED, AUDIO2, LED_out, req_st, AUDIO_OUT);	
  	      
AUDIO_VOL0 : AUDIO_VOL
              port map(CLK, N_RES, vol_st, SW_PLUS, SW_MINUS, AUDIO_IN, VOL_LEVEL, AUDIO1);
              
AUDIO_QNT0 : AUDIO_QNT
              port map(CLK, N_RES, qnt_st, SW_PLUS, SW_MINUS, AUDIO1, QNT_RES, AUDIO2);              	      

end BEHAVIOUR;

library IEEE;

use IEEE.std_logic_1164.ALL;

use ieee.numeric_std.all;

use IEEE.std_logic_unsigned.all;

 
entity ADC_AUDIO_DAC is
  	port ( CLK, N_RES: in bit; -- 100 MHz; asynch, active low reset
		    SW_PLUS   :  in bit;
          SW_MINUS   :  in bit;   
          SW_AUDIO_ON   : in bit;		 
	       SW_MODE_VOL_nQNT  :  in bit;
-- Signals to DAC0			  
		    DA_SD0    : out bit ;
          DA_CLK0   : out bit ;
          DA_CS0    : out bit ;  
---ADC_SIGNALS
	       AD_SD    : in bit ;
          AD_CS    : out bit ;
			 LED_STATUS: out bit_vector(9 downto 0);
          AD_CLK   : out bit	
			 );		-- ist DAC-Wert Ausgabe		 
end ADC_AUDIO_DAC;


architecture BEHAVIOUR of ADC_AUDIO_DAC is

component DAC_001 is
  	port ( SCLK, N_RES : in bit;
		    DA_IN    : in bit_vector(11 downto 0);	
		    START    :  in bit; --Startsignal
		    RDY_DA   :  out bit ; --Ready-Flag
---DAC0_SIGNALS
	 	    DA_SD0   : out bit ;
      	 DA_CS0   : out bit ;
       	 DA_CLK0  : out bit) ;
 end component ;

component ADC_001 is
  	port ( SCLK, N_RES : in bit;
          AD_OUT   : out bit_vector(11 downto 0);
		    START    :  in bit; --Startsignal
		    RDY_AD   :  out bit ; --Ready-Flag			 
---ADC_SIGNALS
	       AD_SD   : in bit ;
          AD_CS   : out bit ;
          AD_CLK : out bit );		 
end component ;

component SR_GEN is
  	port ( CLK, N_RES : in bit; -- 100MHz; asynch, active low reset
          START_TE   : out bit);	
end component SR_GEN;

component CLK_DIV is
  	port ( CLK, N_RES: in  bit;    -- 100 MHz; asynch, active low reset
          SCLK      : out bit);		-- 3.125 MHz clk out		 
end component CLK_DIV;


component CODE_CONV_AD is

generic (D_WIDTH : positive := 12);

port ( ADCODE : in bit_vector(D_WIDTH-1 downto 0);

SIGNCODE: out std_logic_vector(D_WIDTH-1 downto 0));

end component CODE_CONV_AD;



component CODE_CONV_DA is
generic (D_WIDTH : positive := 12);
port ( DACODE : out bit_vector(D_WIDTH-1 downto 0);
SIGNCODE: in signed(D_WIDTH-1 downto 0)
);
end component CODE_CONV_DA;

component AUDIO_PROC_MOD is
  	port ( CLK, N_RES : in bit;
               SW_PLUS   :  in bit;
               SW_MINUS   :  in bit;   
               SW_AUDIO_ON   : in bit;		 
	       SW_MODE_VOL_nQNT  :  in bit;
	       AUDIO_IN   :  in signed(11 downto 0);
               LED_out   : out bit_vector(9 downto 0);
               AUDIO_OUT  : out signed(11 downto 0));		 
end component AUDIO_PROC_MOD ;



signal  START_TE  : bit ; 
--ADC-Signals
signal DA_IN_INT0: bit_vector(11 downto 0);
--DAC-Signals
signal DA_INT_SD0 , DA_INT_CS0, DA_INT_CLK0 : bit ;

--signal  DIN_TE0   : bit_vector(11 downto 0)  ; 

--ADC-Signals

signal AD_INT_SD0 , AD_INT_CS0, AD_INT_CLK0 : bit ;

signal  AD_OUT_INT0   :  bit_vector(11 downto 0);	

--proc signals

signal AUDIO_OUT0  : signed(11 downto 0);

--CODE_CONV_AD signals

signal CONV_AD_OUT : std_logic_vector(11 downto 0)  ; 

--CODE_CONV_DA signals

signal CONV_DA_OUT : bit_vector(11 downto 0)  ; 

signal AD_OUT0 : bit_vector(11 downto 0)  ; 


--clock divider signals:

signal SCLK0 : bit;





begin


DAC_0 :  DAC_001
         port map ( SCLK0, N_RES, CONV_DA_OUT, START_TE, open, DA_SD0, DA_CS0, DA_CLK0 ) ;
 
 

ADC_0 :  ADC_001
         port map ( SCLK0, N_RES ,AD_OUT0 , START_TE, open, AD_SD, AD_CS, AD_CLK ) ; 
 
SR_GEN0 : SR_GEN
  	      port map ( CLK, N_RES, START_TE);	

CLK_DIV0: CLK_DIV
  	      port map (CLK, N_RES,SCLK0);	 
  	      
  	      
CODE_CONV_AD0: CODE_CONV_AD
	      port map (AD_OUT0,CONV_AD_OUT);
	      
	      
CODE_CONV_DA0: CODE_CONV_DA
	      port map (CONV_DA_OUT, AUDIO_OUT0);

AUDIO_PROC_MOD0: AUDIO_PROC_MOD
         port map ( CLK, N_RES, SW_PLUS, SW_MINUS, SW_AUDIO_ON, SW_MODE_VOL_nQNT, signed(CONV_AD_OUT), LED_STATUS, AUDIO_OUT0);
			
			
end BEHAVIOUR ;	
---------------------------------------------------------------------------
	
	

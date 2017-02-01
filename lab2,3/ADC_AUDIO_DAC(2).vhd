library IEEE;

use IEEE.std_logic_1164.ALL;

use ieee.numeric_std.all;

use IEEE.std_logic_unsigned.all;

 
entity ADC_AUDIO_DAC is
  	port ( CLK, N_RES: in bit; -- 100 MHz; asynch, active low reset
			
-- Signals to DAC0			  
		    DA_SD0    : out bit ;
          DA_CLK0   : out bit ;
          DA_CS0    : out bit ;  
---ADC_SIGNALS
	       AD_SD0    : in bit ;
          AD_CS0    : out bit ;
          AD_CLK0   : out bit;	
--				
          AD_OUT    : out bit_vector(11 downto 0)
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



signal  START_TE  : bit ; 
--ADC-Signals
signal DA_IN_INT0: bit_vector(11 downto 0);
--DAC-Signals
signal DA_INT_SD0 , DA_INT_CS0, DA_INT_CLK0 : bit ;

--signal  DIN_TE0   : bit_vector(11 downto 0)  ; 

--ADC-Signals

signal AD_INT_SD0 , AD_INT_CS0, AD_INT_CLK0 : bit ;


signal  AD_OUT_INT0   :  bit_vector(11 downto 0);	


--Takt, Taktteiler, Bitzaehler
signal SCLK : bit; -- interner Takt

--CODE_CONV_AD signals

signal CONV_AD_OUT : std_logic_vector(11 downto 0)  ; 

--CODE_CONV_DA signals

signal CONV_DA_OUT : bit_vector(11 downto 0)  ; 

begin

AD_OUT <= AD_OUT_INT0 ;
DA_SD0  <= DA_INT_SD0 ;
DA_CS0  <= DA_INT_CS0 ;
DA_CLK0 <= DA_INT_CLK0 ;



DAC_0 :  DAC_001
         port map ( SCLK, N_RES, CONV_DA_OUT, START_TE, open, DA_INT_SD0, DA_INT_CS0, DA_INT_CLK0 ) ;
 
 
AD_INT_SD0  <=  AD_SD0 ;
AD_CS0  <= AD_INT_CS0 ;
AD_CLK0 <= AD_INT_CLK0 ;

ADC_0 :  ADC_001
         port map ( SCLK, N_RES , AD_OUT_INT0, START_TE, open, AD_INT_SD0, AD_INT_CS0, AD_INT_CLK0 ) ; 
 
SR_GEN0 : SR_GEN
  	      port map ( CLK, N_RES, START_TE);	

CLK_DIV0: CLK_DIV
  	      port map (CLK, N_RES,SCLK);	 
  	      
  	      
CODE_CONV_AD0: CODE_CONV_AD
	      port map (AD_OUT_INT0,CONV_AD_OUT);
	      
	      
CODE_CONV_DA0: CODE_CONV_DA
	      port map (CONV_DA_OUT,signed(CONV_AD_OUT));
end BEHAVIOUR ;	
---------------------------------------------------------------------------
	
	

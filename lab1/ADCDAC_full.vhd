-----------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

 
entity ADCDAC_full is
  	port ( CLK, N_RES: in bit; -- 100 MHz; asynch, active low reset
          DA_IN     : in bit_vector(11 downto 0) ;
			 M_ODE     : in bit; -- '1' for loop back test
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
end ADCDAC_full ;


architecture BEHAVIOUR of ADCDAC_full is

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

begin

AD_OUT <= AD_OUT_INT0 ;



-- multiplexer for internal loop or individual test of ADC/DAC
with M_ODE select DA_IN_INT0 <= AD_OUT_INT0 when '1',
						DA_IN when others;
						

--DIN_TE0 <= DA_IN ;
DA_SD0  <= DA_INT_SD0 ;
DA_CS0  <= DA_INT_CS0 ;
DA_CLK0 <= DA_INT_CLK0 ;

DAC_0 :  DAC_001
         port map ( SCLK, N_RES, DA_IN_INT0, START_TE, open, DA_INT_SD0, DA_INT_CS0, DA_INT_CLK0 ) ;
 
 
AD_INT_SD0  <=  AD_SD0 ;
AD_CS0  <= AD_INT_CS0 ;
AD_CLK0 <= AD_INT_CLK0 ;

ADC_0 :  ADC_001
         port map ( SCLK, N_RES , AD_OUT_INT0, START_TE, open, AD_INT_SD0, AD_INT_CS0, AD_INT_CLK0 ) ; 
 
SR_GEN0 : SR_GEN
  	      port map ( CLK, N_RES, START_TE);	

CLK_DIV0: CLK_DIV
  	      port map (CLK, N_RES,SCLK);	 

end BEHAVIOUR ;	
---------------------------------------------------------------------------
	
	

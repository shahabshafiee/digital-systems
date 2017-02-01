library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

 
entity ADCDAC_TOP is
  	port ( CLK, N_RES: in bit; -- 100MHz; asynch, active low reset
          DA_IN     : in bit_vector(11 downto 0) ;
		--	 M_ODE 	  : in bit;
-- Signals to DAC0			  
		    DA_SD0    : out bit ;
          DA_CLK0   : out bit ;
          DA_CS0    : out bit );  
 	
end ADCDAC_TOP;


architecture BEHAVIOUR of ADCDAC_TOP is

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

component SR_GEN is
  	port ( CLK, N_RES : in bit; -- 100MHz; asynch, active low reset
          START_TE   : out bit);	
end component SR_GEN;

component CLK_DIV is
  	port ( CLK, N_RES: in  bit;    -- 100 MHz; asynch, active low reset
          SCLK      : out bit);		-- 3.125 MHz clk out		 
end component CLK_DIV;

signal  START_TE  : bit ; 


--DAC-Signals
signal DA_INT_SD0 , DA_INT_CS0, DA_INT_CLK0 : bit ;

signal  DIN_TE0   : bit_vector(11 downto 0)  ; 


--Takt, Taktteiler, Bitzaehler
signal SCLK : bit; -- interner Takt

begin

DIN_TE0 <= DA_IN ;
DA_SD0  <= DA_INT_SD0 ;
DA_CS0  <= DA_INT_CS0 ;
DA_CLK0 <= DA_INT_CLK0 ;

DAC_0 :  DAC_001
         port map ( SCLK, N_RES , DIN_TE0 , START_TE, open, DA_INT_SD0, DA_INT_CS0, DA_INT_CLK0 ) ;
 
 
SR_GEN0 : SR_GEN
  	      port map ( CLK, N_RES, START_TE);	

CLK_DIV0: CLK_DIV
  	      port map (CLK, N_RES,SCLK);	 

end BEHAVIOUR ;	
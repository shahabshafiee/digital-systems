-----------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity ADC_001 is
  	port ( SCLK, N_RES : in bit;
          AD_OUT   : out bit_vector(11 downto 0);
		    START    :  in bit;   -- start signal
		    RDY_AD   : out bit ; -- ready flag			 
	       AD_SD    :  in bit ;
          AD_CS    : out bit ;
          AD_CLK   : out bit );		 
end ADC_001 ;

architecture BEHAVIOUR of ADC_001 is
-- bit counter
signal  B_NR    : unsigned(3 downto 0):= "0000" ;
signal  B_CLR   : bit  ;

--Control Signals ADC
signal  SR_CLR  : bit;   -- clear shift reg
signal  EN_SR   : bit;   -- enable shift reg
signal  EN_SAVE : bit;   -- store 

-- registers for ADC data
signal  AD_SRG0 : bit_vector(15 downto 0):= (others => '0')  ;  -- shift reg
signal  AD_DAT0 : bit_vector(11 downto 0):= (others => '0')  ;  -- save reg

type    State_Type_AD is (IDLE_AD,SHIFT_AD,SAVE_AD);
-- states of ADC communication module
signal  AD_STATE        : State_Type_AD;
signal  AD_NEXTSTATE    : State_Type_AD;

begin

AD_OUT <= AD_DAT0;
 
-- clock to ADC
AD_CLK <=  not SCLK;

-- counter for serial bits -------------------------------
BIT_CNT: process(SCLK)
   begin
     if SCLK = '1' and SCLK'event then
          if B_CLR = '1' then
              B_NR <= "0000" after 5 ns ;
         else 
              B_NR <= B_NR + 1 after 5 ns ;
         end if ;
     end if ;
end process BIT_CNT;

---------ADC0 - shift / save regs -----------------------------
AD0_SR: process(SCLK, N_RES)
   begin
     if N_RES ='0'  then
	     AD_SRG0 <= (others=>'0')  after 5 ns ;
	  elsif SCLK = '1' and SCLK'event then
	        if SR_CLR = '1' then
                AD_SRG0 <= (others=>'0')  after 5 ns ;
            elsif EN_SR = '1' then
                AD_SRG0 <= AD_SRG0(14 downto 0) & AD_SD after 5 ns ;
            end if;
     end if ;
end process AD0_SR;

AD0_REG: process(SCLK, N_RES)
   begin
     if N_RES ='0'  then
	     AD_DAT0 <= (others=>'0')  after 5 ns ;
	  elsif SCLK = '1' and SCLK'event then
            if EN_SAVE = '1' then
                AD_DAT0  <=  AD_SRG0(15 downto 4) after 5 ns ;
        end if;
     end if ;
end process AD0_REG;

-- FSM_ADC comm module -----------------------------------------
FSM_AD_REG : process(SCLK , N_RES)
   begin
     if N_RES ='0'  then
        AD_STATE <= IDLE_AD after 5 ns ;
     elsif SCLK  = '1' and SCLK 'event then
        AD_STATE <= AD_NEXTSTATE after 5 ns ;
     end if ;
end process ;

FSM_AD_SN : process(AD_STATE,B_NR,START)
   begin
        AD_NEXTSTATE <= AD_STATE after 5 ns ;
        AD_CS   <= '1' after 5 ns ;
        EN_SR <= '0' after 5 ns ;
        SR_CLR <= '0' after 5 ns ;
        EN_SAVE <= '0' after 5 ns ;
		  RDY_AD <= '0' after 5 ns ;
		  B_CLR  <= '1' after 5 ns ;
    case AD_STATE is
        when IDLE_AD => SR_CLR <= '1' after 5 ns ;
		                  RDY_AD <= '1' after 5 ns ;
		                  if START = '1' then
		                    AD_NEXTSTATE <= SHIFT_AD after 5 ns ;
                        end if ; 
        when SHIFT_AD => AD_CS   <= '0' after 5 ns ; -- 15 states
		                EN_SR <= '1' after 5 ns ;
		                B_CLR <= '0' after 5 ns ;
                      if B_NR = "1111" then   
                        B_CLR <= '1' after 5 ns ;
					         AD_NEXTSTATE <= SAVE_AD after 5 ns ;
					       end if;
        when SAVE_AD => EN_SAVE <= '1' after 5 ns ;
								if START = '0' then
                            AD_NEXTSTATE <= IDLE_AD after 5 ns ;
								end if;
    end case;
end process;

end BEHAVIOUR ;	
	
	
	
	


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DAC_001 is
  port(SCLK, N_RES : in bit;
      START  :  in bit;   -- start signal
      DA_IN  :  in bit_vector(11 downto 0) ;
      RDY_DA :  out bit;

      DA_SD0 :  out bit ;
      DA_CS0 : out bit ;
      DA_CLK0 : out bit );
end DAC_001 ;

architecture BEHAVIOUR of DAC_001 is
-- bit counter
signal  B_NR    : unsigned(3 downto 0):= "0000" ;
signal  B_CLR   : bit  ;

--Control Signals DAC
signal  DA_LD  : bit;   --if load '1'means start shifting else load in DA_IN


signal DA_DATA0 : bit_vector (15 downto 0) :=(others=> '0');  --  save all the shifted bits to DA_DAT0 and then from DA_DAT0 send always MSB to the DA_SD0

--states of the DAC communication module  
type State_Type_DA is (IDLE_DA, LOAD_DA);
signal   DA_STATE       :  State_Type_DA;
signal DA_NEXTSTATE     :  State_Type_DA;

begin

-- clock to DAC
DA_CLK0 <=  not SCLK;  

-- counter for serial bits -------------------------------
BIT_CNT: process(SCLK)  
   begin
     if SCLK = '1' and SCLK'event then
          if B_CLR = '1' then         -- B_CLR is clearing the counter 
              B_NR <= "0000" after 5 ns ;
         else 
              B_NR <= B_NR + 1 after 5 ns ; -- its output og bit counter  
         end if ;
     end if ;
end process BIT_CNT;

SR_DAC0 :process (SCLK, N_RES)   
  begin 
         if N_RES ='0' then
              DA_DATA0 <=(others=>'0') after 5 ns;
              elsif SCLK = '1' and SCLK'event then
               if DA_LD = '1' then 
               		DA_DATA0 <= "00"&DA_IN&"00" ;   
               elsif DA_LD = '0' then 
               		DA_DATA0 <= DA_DATA0(14 downto 0) & '0' ;    
               end if; 
      end if; 
end process SR_DAC0; 

DA_SD0 <= DA_DATA0(15); 
-- we have to create one(upper) FSM for whatever is related to clock  and other FSM should contain all combinational logics 
FSM_DA_REG : process(SCLK , N_RES)
begin 
      if N_RES ='0' then
      DA_STATE <= IDLE_DA after 5 ns ; 
      elsif SCLK = '1' and SCLK 'event then
      DA_STATE <= DA_NEXTSTATE after 5 ns ; 
end if ; 
end process ; 

FSM_DA_SN : process(DA_STATE,B_NR,START)  -- why dont we combine both FSMs
   begin           
        DA_NEXTSTATE <= DA_STATE after 5 ns ;-- idle state is our next state
        DA_CS0   <= '1' after 5 ns ;  -- CS is HIGH ( see Timing Diagram ) in IDLE STATE
        DA_LD <= '0' after 5 ns ; 
        RDY_DA <= '0' after 5 ns ; 
        B_CLR <= '1' after 5 ns ;
        
case DA_STATE is 
    when IDLE_DA => 
                RDY_DA <= '1' after 5 ns ; 
 		DA_CS0   <= '1' after 5 ns ;
                B_CLR <= '1' after 5 ns ;

                DA_LD <='1' after 5 ns;
                    
		if START = '1' then 
                DA_NEXTSTATE <= LOAD_DA after 5 ns ; 
end if ; 
when  LOAD_DA =>  
                DA_CS0 <= '0' after 5 ns;
                B_CLR <='0' after 5 ns;-- we dont clear untill the shifting is in process
                DA_LD <='0' after 5 ns;
                    if B_NR ="1111" then
                        B_CLR <='1' after 5 ns;
                DA_NEXTSTATE<= IDLE_DA after 5 ns ;
end if ;


end case; 
end process; 
end BEHAVIOUR ; 

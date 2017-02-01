
library IEEE;

use IEEE.std_logic_1164.ALL;

use ieee.numeric_std.all;

use IEEE.std_logic_unsigned.all;

entity CODE_CONV_AD is

generic (D_WIDTH : positive := 12);

port ( ADCODE : in bit_vector(D_WIDTH-1 downto 0);

SIGNCODE: out std_logic_vector(D_WIDTH-1 downto 0));

end CODE_CONV_AD;

architecture Behavioral of CODE_CONV_AD is

constant value : std_logic_vector := x"7FF";

constant value1 : std_logic_vector := x"FFF";

constant value2 : std_logic_vector := x"800"; 

begin


convert: process(ADCODE)

begin


if ADCODE(11)='0' then

SIGNCODE <= to_stdlogicvector(ADCODE)-value;

else

SIGNCODE <= (to_stdlogicvector(ADCODE) and (not value2))- value1;

end if;

end process;

end Behavioral;
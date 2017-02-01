library IEEE;

use IEEE.std_logic_1164.ALL;

use ieee.numeric_std.all;

use IEEE.std_logic_unsigned.all;

entity CODE_CONV_DA is
generic (D_WIDTH : positive := 12);
port ( DACODE : out bit_vector(D_WIDTH-1 downto 0);
SIGNCODE: in signed(D_WIDTH-1 downto 0)
);
end entity CODE_CONV_DA;

architecture Behavioral of CODE_CONV_DA is

constant value : std_logic_vector := x"7FF";

constant value1 : std_logic_vector := x"FFF";

constant value2 : std_logic_vector := x"800";

begin

convert: process(SIGNCODE)

begin

if SIGNCODE(11)='0' then

DACODE <= to_bitvector(value - std_logic_vector(SIGNCODE));

else

DACODE <= to_bitvector(value1 - (std_logic_vector(SIGNCODE) and (not value2)));

end if;

end process;


end Behavioral;
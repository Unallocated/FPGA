library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity iotest is
    Port ( 
           porta : inout  STD_LOGIC_VECTOR(1 downto 0);
           leds : out  STD_LOGIC_VECTOR (7 downto 0));
end iotest;

architecture Behavioral of iotest is

	--signal en : std_logic;

begin
	porta(0) <= 'Z';
	porta(1) <= 'H';
--	porta <= porta_buf when en = '1' else 'Z';
	
	leds <= (others => porta(0));

end Behavioral;


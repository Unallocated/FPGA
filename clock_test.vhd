library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_test is
end clock_test;

architecture Behavioral of clock_test is

	signal clk : std_logic := '0';
	signal cpu_clock : std_logic := '0';
	signal enable : std_logic := '0';
	
begin

	clocking : process
	begin
		wait for 1ns;
		clk <= not clk;
	end process;
	
	
--	clock_divider : process(clk)
--		variable counter : integer := 0;
--	begin
--		if(rising_edge(clk)) then
--			if(counter = 100) then
--				cpu_clock <= not cpu_clock;
--				enable <= '1';
--				counter := 0;
--			else
--				enable <= '0';
--				counter := counter + 1;
--			end if;
--		end if;
--	end process;

	clock_divider : process(clk)
		variable counter : integer := 0;
	begin
		if(rising_edge(clk)) then
			if(counter = 100) then
				cpu_clock <= not cpu_clock;
				enable <= '1';
				counter := 0;
			else
				enable <= '0';
				counter := counter + 1;
			end if;
			
			
		end if;
	end process;

end Behavioral;


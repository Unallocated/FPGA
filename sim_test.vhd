library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sim_test is
end sim_test;

architecture Behavioral of sim_test is
	signal clk : std_logic := '0';
	signal slow_clk : std_logic := '0';
begin

	my_divider : process(clk)
		variable clk_divider : integer := 0;
	begin
		if(rising_edge(clk)) then
			if(clk_divider = 2) then
				slow_clk <= not slow_clk;
				clk_divider := 0;
			else
				clk_divider := clk_divider + 1;
			end if;
		end if;
	end process;

	clk_gen : process
	begin
		wait for 1 ns;
		clk <= not clk;
	end process;

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity divider_test is
end divider_test;

architecture Behavioral of divider_test is

	component divider
		port (
		clk: in std_logic;
		ce: in std_logic;
		rfd: out std_logic;
		dividend: in std_logic_vector(7 downto 0);
		divisor: in std_logic_vector(7 downto 0);
		quotient: out std_logic_vector(7 downto 0);
		fractional: out std_logic_vector(7 downto 0));
	end component;
	
	signal clk : std_logic := '0';
	
	signal en, rfd : std_logic := '0';
	signal dividend, divisor, quotient, fractional : std_logic_vector(7 downto 0);
begin

	your_instance_name : divider
		port map (
			clk => clk,
			ce => en,
			rfd => rfd,
			dividend => dividend,
			divisor => divisor,
			quotient => quotient,
			fractional => fractional);

	process
	begin
		wait for 1 ns;
		clk <= '0';
		wait for 1 ns;
		clk <= '1';
	end process;


	process
	begin
		en <= '0';
		dividend <= (others => '0');
		divisor <= (others => '0');
		
		wait for 100ns;
		
		wait until clk'event and clk = '1';
		dividend <= "10000000";
		divisor <= "00000010";
		wait until clk'event and clk = '1';
		en <= '1';
		wait for 100ns;
	end process;
		

end Behavioral;


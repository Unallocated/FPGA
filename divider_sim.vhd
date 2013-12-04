library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity divider_sim is
end divider_sim;

architecture Behavioral of divider_sim is

	component div2
		port (
		clk: in std_logic;
		rfd: out std_logic;
		dividend: in std_logic_vector(7 downto 0);
		divisor: in std_logic_vector(7 downto 0);
		quotient: out std_logic_vector(7 downto 0);
		fractional: out std_logic_vector(7 downto 0));
	end component;
	
	signal clk : std_logic := '0';
	signal rfd : std_logic;
	signal dividend : std_logic_vector(7 downto 0);
	signal divisor : std_logic_vector(7 downto 0);
	signal quotient : std_logic_vector(7 downto 0);
	signal fractional : std_logic_vector(7 downto 0);
	
	signal done : std_logic := '0';
	
begin
	
	clk_gen : process
	begin
		wait for 0.5 ns;
		clk <= not clk;
	end process;
	
	test : process
	begin
		done <= '0';
--		wait for 1 ns;
		wait until clk'event and clk='1';
		dividend <= "10000000";
		divisor <= "00000010";
		wait for 18 ns;
		done <= '1';
		wait until clk'event and clk='1';
	end process;

	divider : div2
		port map (
			clk => clk,
			rfd => rfd,
			dividend => dividend,
			divisor => divisor,
			quotient => quotient,
			fractional => fractional);


end Behavioral;


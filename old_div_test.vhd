
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity old_did_test is
end old_did_test;

architecture Behavioral of old_did_test is

	component asdf
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
	signal en : std_logic := '0';
	signal rfd : std_logic := '0';
	signal dividend : std_logic_vector(7 downto 0);
	signal divisor : std_logic_vector(7 downto 0);
	signal quotient : std_logic_vector(7 downto 0);
	signal fractional : std_logic_vector(7 downto 0);

begin
	your_instance_name : asdf
		port map (
			clk => clk,
			ce => en,
			rfd => rfd,
			dividend => dividend,
			divisor => divisor,
			quotient => quotient,
			fractional => fractional);
	
	test_proc : process
	begin
--		en <= '0';
		dividend <= "00000000";
		divisor <= "00000000";
		
		wait for 2 ns;
		dividend <= "01000000";
		divisor <= "00000010";
		en <= '1';
		wait for 18 ns;
		en <= '0';
		wait for 2 ns;
		dividend <= "01000000";
		divisor <= "00000100";
		en <= '1';
		wait for 36 ns;
		en <= '0';
	end process;
	
	clk_gen : process
	begin
		wait for 1 ns;
		clk <= not clk;
	end process;
	
	

end Behavioral;


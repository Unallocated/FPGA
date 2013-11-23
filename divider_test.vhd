library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity divider_test is
end divider_test;

architecture Behavioral of divider_test is

	COMPONENT divider
	  PORT (
	    aclk : IN STD_LOGIC;
	    aclken : IN STD_LOGIC;
	    s_axis_divisor_tvalid : IN STD_LOGIC;
	    s_axis_divisor_tready : OUT STD_LOGIC;
	    s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	    s_axis_dividend_tvalid : IN STD_LOGIC;
	    s_axis_dividend_tready : OUT STD_LOGIC;
	    s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	    m_axis_dout_tvalid : OUT STD_LOGIC;
	    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	  );
	END COMPONENT;
	
	signal clk : std_logic := '0';
	
	signal en : std_logic := '0';
	signal divisor_valid : std_logic := '0';
	signal divisor_ready : std_logic;
	signal divisor_data : std_logic_vector(7 downto 0) := (others => '0');
	signal dividend_valid : std_logic := '0';
	signal dividend_ready : std_logic;
	signal dividend_data : std_logic_vector(7 downto 0) := (others => '0');
	
	signal data_valid : std_logic := '0';
	signal data_out : std_logic_vector(15 downto 0);

begin

	your_instance_name : divider
	  PORT MAP (
		 aclk => clk,
		 aclken => en,
		 s_axis_divisor_tvalid => divisor_valid,
		 s_axis_divisor_tready => divisor_ready,
		 s_axis_divisor_tdata => divisor_data,
		 s_axis_dividend_tvalid => dividend_valid,
		 s_axis_dividend_tready => dividend_ready,
		 s_axis_dividend_tdata => dividend_data,
		 m_axis_dout_tvalid => data_valid,
		 m_axis_dout_tdata => data_out
	  );

	process
	begin
		wait for 1 ns;
		clk <= not clk;
	end process;

	process
	begin
		wait for 2 ns;
		en <= '1';
		wait for 2 ns;
		dividend_data <= "00001000";
		divisor_data <= "00000010";
		wait for 2 ns;
		divisor_valid <= '1';
		dividend_valid <= '1';
		wait for 2 ns;
		en <= '0';
	
	end process;

end Behavioral;


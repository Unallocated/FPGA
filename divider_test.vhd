library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

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

	signal state : integer := 0;

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

--	process(clk)
		
--	begin
--		if(rising_edge(clk)) then
--			case state is
--				when 0 =>
--					en <= '0';
--					divisor_data <= (others => '0');
--					dividend_data <= (others => '0');
--					divisor_valid <= '0';
--					dividend_valid <= '0';
--					state <= 1;
--				when 1 =>
--					en <= '1';
--					state <= 2;
--				when 2 => 
--					divisor_valid <= '1';
--					dividend_valid <= '1';
--					divisor_data <= "00000010";
--					dividend_data <= "00001000";
--					state <= 3;
--				when 3 =>
--
--					state <= 4;
--				when 4 =>
--					dividend_valid <= '1';
--					divisor_valid <= '1';
--					state <= 5;
--				when 5 =>
--					state <= 6;
--				when others =>
--					en <= '0';
--					divisor_data <= (others => '0');
--					dividend_data <= (others => '0');
--					divisor_valid <= '0';
--					dividend_valid <= '0';
--					state <= 0;
--			end case;
--		end if;
--	end process;

	process
	begin
--		en <= '1';
--		divisor_valid <= '1';
--		dividend_valid <= '1';
--		wait for 30 ns;
--		en <= '0';
--		divisor_valid <= '0';
--		dividend_valid <= '0';
--		wait for 4 ns;
		en <= '0';
		dividend_valid <= '0';
		dividend_data <= "00000000";
		divisor_data <= "00000000";
		divisor_valid <= '0';
		wait for 2 ns;
		dividend_data <= "01000000";
		divisor_data <= "00000010";
		divisor_valid <= '1';
		dividend_valid <= '1';
		wait for 2 ns;
		en <= '1';
		wait for 40 ns;
		
		wait for 4 ns;
		
		
		en <= '0';
		dividend_valid <= '0';
		dividend_data <= "00000000";
		divisor_data <= "00000000";
		divisor_valid <= '0';
		wait for 2 ns;
		dividend_data <= "01000000";
		divisor_data <= "00000100";
		divisor_valid <= '1';
		dividend_valid <= '1';
		wait for 2 ns;
		en <= '1';
		wait for 40 ns;
		wait for 4 ns;
		
		
		
		en <= '0';
		dividend_valid <= '0';
		dividend_data <= "00000000";
		divisor_data <= "00000000";
		divisor_valid <= '0';
		wait for 2 ns;
		dividend_data <= "01000000";
		divisor_data <= "00001000";
		divisor_valid <= '1';
		dividend_valid <= '1';
		wait for 2 ns;
		en <= '1';
		wait for 40 ns;
		wait for 4 ns;
		
		en <= '0';
		dividend_valid <= '0';
		dividend_data <= "00000000";
		divisor_data <= "00000000";
		divisor_valid <= '0';
		wait for 2 ns;
		dividend_data <= "01000000";
		divisor_data <= "00010000";
		divisor_valid <= '1';
		dividend_valid <= '1';
		wait for 2 ns;
		en <= '1';
		wait for 40 ns;
		wait for 4 ns;
	end process;

end Behavioral;


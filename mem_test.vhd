library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mem_test is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           leds : out  STD_LOGIC_VECTOR (7 downto 0));
end mem_test;

architecture Behavioral of mem_test is

	COMPONENT memory
	  PORT (
		 clka : IN STD_LOGIC;
		 wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		 addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;
	
	signal mem_we : std_logic_vector(0 downto 0);
	signal mem_addr : std_logic_vector(15 downto 0);
	signal mem_data_in : std_logic_vector(7 downto 0);
	signal mem_data_out : std_logic_vector(7 downto 0);
	
	signal slow_clk : std_logic := '0';
begin

	leds <= mem_data_out;

	process(slow_clk, rst)
		variable clk_counter : integer := 0;
	begin
		if(rst = '1') then
			clk_counter := 0;
		elsif(rising_edge(slow_clk)) then
			case(clk_counter) is
				when 0 =>
					mem_we <= "1";
					mem_addr <= "0000000000000001";
					mem_data_in <= "11111111";
				when 1 =>
					mem_we <= "0";
				when 2 =>
					mem_addr <= (others => '0');
					mem_data_in <= "10101010";
					mem_we <= "1";
--				when 3 =>
--					mem_we <= "0";
				when 3 =>
					mem_we <= "0";
					mem_addr <= "0000000000000001";
				when 4 =>
					mem_addr <= (others => '0');
				when others => 
					null;
			end case;
			clk_counter := clk_counter + 1;
		end if;
	end process;

	process (clk, rst)
		variable counter : integer range 0 to 100000000/8 := 0;
	begin
		if(rst = '1') then
			counter := 0;
		elsif(rising_edge(clk)) then
			if(counter = 0) then
				slow_clk <= not slow_clk;
			end if;
			counter := counter + 1;
		end if;
	end process;
	
	
	cpu_memory : memory
	  PORT MAP (
		 clka => slow_clk,
		 wea => mem_we,
		 addra => mem_addr,
		 dina => mem_data_in,
		 douta => mem_data_out
	  );

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sram_wrapper is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           cs_n : out  STD_LOGIC;
           so : out  STD_LOGIC;
           sck : out  STD_LOGIC;
           si : in  STD_LOGIC);
end sram_wrapper;

architecture Behavioral of sram_wrapper is

	COMPONENT sram
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		si : IN std_logic;
		data_in : IN std_logic_vector(7 downto 0);
		start : IN std_logic;
		we : IN std_logic;
		addr : IN std_logic_vector(23 downto 0);          
		data_out : OUT std_logic_vector(7 downto 0);
		so : OUT std_logic;
		done : OUT std_logic;
		sck : OUT std_logic;
		cs_n : OUT std_logic
		);
	END COMPONENT;

	signal data_in : std_logic_vector(7 downto 0) := (others => '0');
	signal start : std_logic := '0';
	signal we : std_logic := '0';
	signal data_out : std_logic_vector(7 downto 0) := (others => '0');
	signal done : std_logic := '0';
	signal addr : std_logic_vector(23 downto 0) := (others => '0');
	
	signal slow_clk : std_logic := '0';
begin

	process(clk, rst)
		variable counter : integer := 0;
	begin
		if(rst = '1') then
			counter := 0;
		elsif(rising_edge(clk)) then
			if(counter = 5000000) then -- that's 5 million
				counter := 0;
				slow_clk <= not slow_clk;
			else
				counter := counter + 1;
			end if;
		end if;
	end process;

	Inst_sram: sram PORT MAP(
		clk => slow_clk,
		rst => not rst,
		si => si,
		data_in => data_in,
		start => start,
		we => we,
		addr => addr,
		data_out => data_out,
		so => so,
		done => done,
		sck => sck,
		cs_n => cs_n
	);

end Behavioral;


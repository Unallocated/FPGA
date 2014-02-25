library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sram_wrapper is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           cs_n : out  STD_LOGIC;
           so : out  STD_LOGIC;
           sck : out  STD_LOGIC;
           si : in  STD_LOGIC;
			  leds : out STD_LOGIC_VECTOR(7 downto 0));
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
		addr : IN std_logic_vector(16 downto 0);          
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
	signal addr : std_logic_vector(16 downto 0) := (others => '0');
	
	signal slow_clk : std_logic := '0';
	
	type state_t is (WRT, WRT_DONE, WRT_DEL, WRT_PAUSE, RD, RD_DONE, RD_DEL, RD_PAUSE);
	signal state : state_t := WRT;
begin

	leds <= data_out;

	process(slow_clk, rst)
	begin
		if(rst = '1') then
			start <= '0';
			addr <= (others => '0');
			data_in <= (others => '0');
			we <= '0';
			
			state <= WRT;
		elsif(rising_edge(slow_clk)) then
			case state is
				when WRT =>
					addr <= "00000000000000001";
					data_in <= x"55";
					we <= '1';
					
					state <= WRT_PAUSE;
				when WRT_PAUSE =>
					start <= '1';
					state <= WRT_DEL;
				when WRT_DEL =>
					state <= WRT_DONE;
				when WRT_DONE =>
					start <= '0';
					if(done = '1') then
						state <= RD;
					end if;
				
				when RD =>
					we <= '0';
					state <= RD_PAUSE;
				when RD_PAUSE =>
					start <= '1';
					state <= RD_DEL;
				when RD_DEL =>
					state <= RD_DONE;
				when RD_DONE =>
					start <= '0';
					if(done = '1') then
						state <= RD;
					end if;
			end case;
		end if;
	end process;

	process(clk, rst)
		variable counter : integer := 0;
	begin
		if(rst = '1') then
			counter := 0;
		elsif(rising_edge(clk)) then
			if(counter = 5) then -- that's 5 million
				counter := 0;
				slow_clk <= not slow_clk;
			else
				counter := counter + 1;
			end if;
		end if;
	end process;

	Inst_sram: sram PORT MAP(
		clk => slow_clk,
		rst => rst,
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


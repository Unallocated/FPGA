library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memory_wrapper is
    Port ( clk : in  STD_LOGIC;
    	   rst : in STD_LOGIC;
           start : in  STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR(7 downto 0);
           data_out : out STD_LOGIC_VECTOR(7 downto 0);
           addr : in  STD_LOGIC_VECTOR (15 downto 0);
           we : in  STD_LOGIC;
           done : out  STD_LOGIC);
end memory_wrapper;

architecture Behavioral of memory_wrapper is
	
	COMPONENT memory
	  PORT (
		 clka : IN STD_LOGIC;
		 wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		 addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;

	signal ram_clk : std_logic := '0';
	signal done_buffer : std_logic := '0';
	signal en : std_logic := '0';

	signal d_in_latch : std_logic_vector(7 downto 0) := (others => '0');
	signal addr_latch : std_logic_vector(15 downto 0) := (others => '0');
	signal we_latch : std_logic := '0';
	signal last_start : std_logic := '0';
	signal ram_we : std_logic_vector(0 downto 0) := (others => '0');
	
	constant cycles_per_operation : integer := 3;
begin
	done <= done_buffer;
	ram_clk <= clk and en;
	
	--ram_we <= (others => '1') when we = '1' else (others => '0');

	process(clk, rst)
		variable delay : integer range 0 to cycles_per_operation := 0;
	begin
		if(rst = '1') then
			delay := 0;
			en <= '0';
			done_buffer <= '0';
		elsif(rising_edge(clk)) then
			if(start = '1' and last_start = '0') then
				addr_latch <= addr;
				if(we = '1') then
					d_in_latch <= data_in;
					ram_we <= (others => '1');
				else
					ram_we <= (others => '0');
				end if;
				en <= '1';
				done_buffer <= '0';
				delay := cycles_per_operation;
			elsif(delay /= 0) then
				delay := delay - 1;
			elsif(delay = 0) then
				done_buffer <= '1';
				en <= '0';
			end if;
			
			last_start <= start;
		end if;
	end process;
	
	cpu_memory : memory
	  PORT MAP (
		 clka => ram_clk,
		 wea => ram_we,
		 addra => addr_latch,
		 dina => d_in_latch,
		 douta => data_out
	  );

end Behavioral;

